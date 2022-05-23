package hppsProject

import freechips.rocketchip.tile._
import hppsProject._
import chisel3._
import chisel3.util._
import chisel3.util.HasBlackBoxResource
import chisel3.experimental.IntParam
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.rocket._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.util.InOrderArbiter


class PECommand extends Bundle{
    //control signals
    val load = Bool()
    val store = Bool()
    val doAllToAll = Bool()

//communiction between PE and controller
    val rs1 = Bits(64.W)
    val rs2 = Bits(64.W)
}

class PEResponse extends Bundle{

    //communiction between PE and controller
    val data = Bits(64.W)
    val write_enable = Bool()
}


class OutputPE(val indexWidth: Int) extends Bundle{
  val data = Bits(64.W)
  val x_0 = Bits(indexWidth.W)
  val y_0 = Bits(indexWidth.W)
  val x_dest = Bits(indexWidth.W)
  val y_dest = Bits(indexWidth.W)
}


class InputOutputPEdata(indexWidth: Int) extends Bundle{
    val out = Decoupled(new OutputPE(indexWidth))
    val in = Flipped(Decoupled(new OutputPE(indexWidth)))
}

class AllToAllPEIO(indexWidth: Int) extends Bundle{

    //when busy = true -> computation of PE not terminated yet
    val busy = Output(Bool())
    val end_AllToAll = Input(Bool())
    
    val cmd = Flipped(Decoupled(new PECommand))
    val resp = Decoupled(new PEResponse)
    val left = new InputOutputPEdata(indexWidth)
    val right = new InputOutputPEdata(indexWidth)
    val up = new InputOutputPEdata(indexWidth)
    val bottom = new InputOutputPEdata(indexWidth)
}




class AllToAllPE(n : Int, cacheSize: Int, queueSize: Int, x : Int, y : Int) extends Module{

  
  val io = IO(new AllToAllPEIO(log2Up(n)))

  //memory
  val memPE = Mem(cacheSize, UInt(64.W)) 

  //It represents the number of the PE -> at most 2^16 PE -> n of mesh max 2^8 = 256
  val x_coord = RegInit(UInt(log2Up(n).W),x.U)
  val y_coord = RegInit(UInt(log2Up(n).W),y.U)
  val offset = RegInit((n*n).U)
  val index_write_this_PE = RegInit((x + y*n + n*n).U)
  
  //store rs1 and rs2 values and keep for all the cycle
  val rs1 = Reg(Bits(64.W))
  val rs2 = Reg(Bits(64.W))

  rs1 := io.cmd.bits.rs1
  rs2 := io.cmd.bits.rs2

  val read_index = Module(new IndexCalculator(n,log2Up(n)))
  val read_value = RegInit(Bits(64.W),0.U)
  val read_x = Reg(Bits(log2Up(n).W))
  val read_y = Reg(Bits(log2Up(n).W))
  val is_this_PE_generation = (read_x === x_coord) && (read_y === y_coord)

  def compute_x_coord(i: UInt): UInt = (i % n.U)
  //def compute_y_coord(i: UInt): UInt = ((n-1).U - (i / n.U))
  def compute_y_coord(i: UInt): UInt = (i / n.U)
    
  //notify when the response is ready
  val w_en = RegInit(Bool(),false.B)

  //states
  val idle :: action :: wait_action_resp :: action_resp :: do_load :: do_store :: store_resp :: stall_state :: Nil = Enum(8)

  val state = RegInit(idle) 
  val resp_value = RegInit(Bits(64.W),0.U)
  
  val x_value = rs2(15,0)
  val y_value = rs2(31,16)
  val memIndex = rs2(63,32)
  
  /*
    transitions values
  */

  //IF CONTROLLER STALLS WAITING FOR THE RESP.READY OF PROCESSOR -> IO.CMD.VALID = FALSE -> FOR SURE NO NEW CMD

  val is_this_PE = (x_value === x_coord) && (y_value === y_coord)
  val load_signal = io.cmd.valid && io.cmd.bits.load 
  val store_signal = io.cmd.valid && io.cmd.bits.store 
  val allToAll_signal = io.cmd.valid && io.cmd.bits.doAllToAll 
  //need to respond but cannot
  val stall_resp = !io.resp.ready && io.resp.valid
  val start_AllToAll = state === action

  val leftBusy = Wire(Bool())
  val rightBusy = Wire(Bool())
  val upBusy = Wire(Bool())
  val bottomBusy = Wire(Bool())

  leftBusy := false.B
  rightBusy := false.B
  rightBusy := false.B
  upBusy := false.B
  bottomBusy := false.B

  when(state === idle){
    io.busy := false.B
    io.cmd.ready := true.B
    io.resp.valid := false.B
    io.resp.bits.data := 0.U

    io.resp.bits.write_enable := false.B
    w_en := false.B

    read_index.io.enable := true.B
    read_index.io.reset := true.B

    when(load_signal){
      state := do_load
    }.elsewhen(store_signal){
      state := do_store
    }.elsewhen(allToAll_signal){
      state := action
    }.otherwise{
      state := idle
    }

  }.elsewhen(state === do_load){
    io.busy := stall_resp
    io.cmd.ready := !stall_resp
    io.resp.valid := true.B
    io.resp.bits.data := 32.U
    resp_value := 32.U

    read_index.io.enable := true.B
    read_index.io.reset := true.B

    when(is_this_PE){
      memPE(memIndex) := rs1
      io.resp.bits.write_enable := true.B
      w_en := true.B
    }.otherwise{
      io.resp.bits.write_enable := false.B
      w_en := false.B
    }
   
    when(load_signal && !stall_resp){
      state := do_load
    }.elsewhen(store_signal && !stall_resp){
      state := do_store
    }.elsewhen(allToAll_signal && !stall_resp){
      state := action
    }.elsewhen(stall_resp){
      state := stall_state
    }.otherwise{
      state := idle
    }

  }.elsewhen(state === do_store){

    io.busy := true.B
    io.cmd.ready := false.B
    io.resp.valid := false.B
    io.resp.bits.data := 33.U
    
    when(is_this_PE){
      resp_value := memPE(memIndex)
      w_en := true.B
    }.otherwise{
      w_en := false.B
    }

    io.resp.bits.write_enable := false.B

    read_index.io.enable := false.B

    state := store_resp

  }.elsewhen(state === store_resp){

    io.busy := stall_resp
    io.cmd.ready := !stall_resp
    io.resp.valid := true.B
    io.resp.bits.data := resp_value
    io.resp.bits.write_enable := w_en

    read_index.io.enable := true.B
    read_index.io.reset := true.B
    
    when(load_signal && !stall_resp){
      state := do_load
    }.elsewhen(store_signal && !stall_resp){
      state := do_store
    }.elsewhen(allToAll_signal && !stall_resp){
      state := action
    }.elsewhen(stall_resp){
      state := stall_state
    }.otherwise{
      state := idle
    }
    
  }.elsewhen(state === stall_state){
    
    io.busy := true.B
    io.cmd.ready := false.B
    io.resp.valid := true.B
    io.resp.bits.data := resp_value

    io.resp.bits.write_enable := w_en

    read_index.io.enable := false.B
    
    when(stall_resp){
      state := stall_state
    }.otherwise{
      state := idle
    }
    
  }.elsewhen(state === action){
    io.busy := true.B
    io.cmd.ready := false.B
    io.resp.valid := false.B
    io.resp.bits.data := resp_value

    w_en := false.B
    io.resp.bits.write_enable := false.B

    //manage values to be pushed in the queues
    read_index.io.enable := true.B
    read_value := memPE(read_index.io.index)
    read_x := compute_x_coord(read_index.io.index)
    read_y := compute_x_coord(read_index.io.index)
    
    state := action_resp

  }.elsewhen(state === wait_action_resp){
    //busy iff at least one edge is busy
    io.busy := leftBusy || rightBusy || upBusy || bottomBusy
    io.cmd.ready := false.B
    io.resp.valid := false.B
    io.resp.bits.data := resp_value
    io.resp.bits.write_enable := false.B
    
    //enable input queues
    io.left.in.ready := true.B
    io.right.in.ready := true.B
    io.up.in.ready := true.B
    io.bottom.in.ready := true.B
    
    when (io.end_AllToAll){
      state := action_resp
    }.otherwise{
      state := wait_action_resp
    }

  }.elsewhen(state === action_resp){
    io.busy := false.B
    io.cmd.ready := false.B
    io.resp.valid := true.B
    io.resp.bits.data := 0.U
    io.resp.bits.write_enable := false.B
    read_index.io.enable := false.B

    state := idle

  }.otherwise{
    
    io.busy := false.B
    io.cmd.ready := false.B
    io.resp.valid := false.B
    io.resp.bits.data := "b10101010101010101010101010101010".U(64.W)
    io.resp.bits.write_enable := true.B
    read_index.io.enable := false.B
  }


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //FSM for managing of AllToAll


  val stateAction = RegInit(idle) 



  when(stateAction === idle){

    when(start_AllToAll){
      stateAction := action
    }.otherwise{
      stateAction := idle
    }
  }.elsewhen(stateAction === action){//cycle to push data into queues

    when(/*codainoutputaccettareadvalue*/true.B || is_this_PE_generation){
      read_x := compute_x_coord(read_index.io.index)
      read_y := compute_x_coord(read_index.io.index)
      read_value := memPE(read_index.io.index)
      read_index.io.enable := true.B
    }.otherwise{
      read_index.io.enable := false.B
    }

    when(is_this_PE_generation){
      //read_index.io.index has as current value the value at which data were read + 1 
      // -> index at which data were read = read_indez.io.index - 1
      memPE(index_write_this_PE) := read_value
    }

    when(read_index.io.last_index){
      stateAction := idle
    }.otherwise{
      stateAction := action
    }

  }.otherwise{

    //error
  }

  
 
  //temporary initialization of values since no actual logic is implemented yet
/*
  io.left.out.bits.data := 0.U(64.W)
  io.left.out.bits.x_0 := 0.U
  io.left.out.bits.y_0 := 0.U
  io.left.out.bits.x_dest := 0.U
  io.left.out.bits.y_dest := 0.U
  io.left.out.valid := false.B
  io.left.in.ready := false.B

  io.right.out.bits.data := 0.U(64.W)
  io.right.out.bits.x_0 := 0.U
  io.right.out.bits.y_0 := 0.U
  io.right.out.bits.x_dest := 0.U
  io.right.out.bits.y_dest := 0.U
  io.right.out.valid := false.B
  io.right.in.ready := false.B

  io.up.out.bits.data := 0.U(64.W)
  io.up.out.bits.x_0 := 0.U
  io.up.out.bits.y_0 := 0.U
  io.up.out.bits.x_dest := 0.U
  io.up.out.bits.y_dest := 0.U
  io.up.out.valid := false.B
  io.up.in.ready := false.B 
  
  io.bottom.out.bits.data := 0.U(64.W)
  io.bottom.out.bits.x_0 := 0.U
  io.bottom.out.bits.y_0 := 0.U
  io.bottom.out.bits.x_dest := 0.U
  io.bottom.out.bits.y_dest := 0.U
  io.bottom.out.valid := false.B
  io.bottom.in.ready := false.B 
*/  

  //input queues
  val left_in = Queue(io.left.in, queueSize)
  val right_in = Queue(io.right.in, queueSize)
  val up_in = Queue(io.up.in, queueSize)
  val bottom_in = Queue(io.bottom.in, queueSize)

  

  /* facendo Queue(io.left.in) ho gia collegato la flipped decoupled che entra nel pE con quella della coda, non serve mettere cose a mano
  io.left.in.ready := left_in.ready
  io.right.in.ready := right_in.ready
  io.up.in.read := up_in.ready
  io.bottom.in.ready := bottom_in.ready
  */
  //DEVO SETTARE IL READY, CHE è IL READY DELL'ARBITER


  //dispatchers -> given value of input queue says where to forward the message
  val left_dispatcher = Module(new Dispatcher(log2Up(n)))
  val right_dispatcher = Module(new Dispatcher(log2Up(n)))
  val up_dispatcher = Module(new Dispatcher(log2Up(n)))
  val bottom_dispatcher = Module(new Dispatcher(log2Up(n)))

  //given the data read from memory says where to forward the message
  val generation_dispatcher = Module(new GenerationDispatcher(log2Up(n)))

  //connect dispatchers input to the input queues
  left_dispatcher.io.x_0 := left_in.bits.x_0
  left_dispatcher.io.y_0 := left_in.bits.y_0
  left_dispatcher.io.x_dest := left_in.bits.x_dest
  left_dispatcher.io.y_dest := left_in.bits.y_dest
  left_dispatcher.io.x_PE := x_coord
  left_dispatcher.io.y_PE := y_coord

  right_dispatcher.io.x_0 := right_in.bits.x_0
  right_dispatcher.io.y_0 := right_in.bits.y_0
  right_dispatcher.io.x_dest := right_in.bits.x_dest
  right_dispatcher.io.y_dest := right_in.bits.y_dest
  right_dispatcher.io.x_PE := x_coord
  right_dispatcher.io.y_PE := y_coord

  up_dispatcher.io.x_0 := up_in.bits.x_0
  up_dispatcher.io.y_0 := up_in.bits.y_0
  up_dispatcher.io.x_dest := up_in.bits.x_dest
  up_dispatcher.io.y_dest := up_in.bits.y_dest
  up_dispatcher.io.x_PE := x_coord
  up_dispatcher.io.y_PE := y_coord

  bottom_dispatcher.io.x_0 := bottom_in.bits.x_0
  bottom_dispatcher.io.y_0 := bottom_in.bits.y_0
  bottom_dispatcher.io.x_dest := bottom_in.bits.x_dest
  bottom_dispatcher.io.y_dest := bottom_in.bits.y_dest
  bottom_dispatcher.io.x_PE := x_coord
  bottom_dispatcher.io.y_PE := y_coord

  generation_dispatcher.io.x_PE := x_coord
  generation_dispatcher.io.y_PE := y_coord
  generation_dispatcher.io.x_dest := read_x
  generation_dispatcher.io.y_dest := read_y

  val write_index = 

  //write into mem at index + n
  when(left_dispatcher.io.this_PE){
    memPE(left_in.bits.x_0 + left_in.bits.y_0 * n.U + offset) := left_in.bits.data
  }

  when(right_dispatcher.io.this_PE){
    memPE(right_in.bits.x_0 + right_in.bits.y_0 * n.U + offset) := right_in.bits.data
  }

  when(up_dispatcher.io.this_PE){
    memPE(up_in.bits.x_0 + up_in.bits.y_0 * n.U + offset) := up_in.bits.data
  }

  when(bottom_dispatcher.io.this_PE){
    memPE(bottom_in.bits.x_0 + bottom_in.bits.y_0 * n.U + offset) := bottom_in.bits.data
  }




  //round robin arbiters for output queues inputs
  //4 input ports because the 4th is the port used by the PE to write data from its own memory, the other 3 are the potrs used by the input queues
  val left_out_arbiter = Module(new RRArbiter(OutputPE(log2Up(n)),4))
  val right_out_arbiter = Module(new RRArbiter(OutputPE(log2Up(n)),4))
  val up_out_arbiter = Module(new RRArbiter(OutputPE(log2Up(n)),4))
  val bottom_out_arbiter =Module(new RRArbiter(OutputPE(log2Up(n)),4))

  //output queues
  val left_out = Queue(left_out_arbiter.io.out, queueSize)
  val right_out = Queue(right_out_arbiter.io.out, queueSize)
  val up_out = Queue(up_out_arbiter.io.out, queueSize)
  val bottom_out = Queue(bottom_out_arbiter.io.out, queueSize)


  //connect output queues to the uptput of the PE
  io.left.out <> left_out
  io.right.out <> right_out
  io.up.out <> up_out
  io.bottom.out <> bottom_out

  //connect input of the arbiter with output of the dispatcher
  //overrwrite the valid bit -> SI PUO FARE???
  //arbiter.io.in(0) il connected with the data generated by the PE
  left_out_arbiter.io.in(0).valid := generation_dispatcher.io.left
  left_out_arbiter.io.in(0).bits.data := read_value
  left_out_arbiter.io.in(0).bits.x_0 := x_coord
  left_out_arbiter.io.in(0).bits.y_0 := y_coord
  left_out_arbiter.io.in(0).bits.x_dest := read_x
  left_out_arbiter.io.in(0).bits.y_dest := read_y
  left_out_arbiter.io.in(1) <> right_in
  left_out_arbiter.io.in(1).valid := right_dispatcher.io.left
  left_out_arbiter.io.in(2) <> up_in
  left_out_arbiter.io.in(2).valid := up_dispatcher.io.left
  left_out_arbiter.io.in(3) <> bottom_in
  left_out_arbiter.io.in(3).valid := bottom_dispatcher.io.left

  right_out_arbiter.io.in(0).valid := generation_dispatcher.io.right
  right_out_arbiter.io.in(0).bits.data := read_value
  right_out_arbiter.io.in(0).bits.x_0 := x_coord
  right_out_arbiter.io.in(0).bits.y_0 := y_coord
  right_out_arbiter.io.in(0).bits.x_dest := read_x
  right_out_arbiter.io.in(0).bits.y_dest := read_y 
  right_out_arbiter.io.in(1) <> left_in
  right_out_arbiter.io.in(1).valid := left_dispatcher.io.right
  right_out_arbiter.io.in(2) <> up_in
  right_out_arbiter.io.in(2).valid := up_dispatcher.io.right
  right_out_arbiter.io.in(3) <> bottom_in
  right_out_arbiter.io.in(3).valid := bottom_dispatcher.io.right

  up_out_arbiter.io.in(0).valid := generation_dispatcher.io.up
  up_out_arbiter.io.in(0).bits.data := read_value
  up_out_arbiter.io.in(0).bits.x_0 := x_coord
  up_out_arbiter.io.in(0).bits.y_0 := y_coord
  up_out_arbiter.io.in(0).bits.x_dest := read_x
  up_out_arbiter.io.in(0).bits.y_dest := read_y
  up_out_arbiter.io.in(1) <> left_in
  up_out_arbiter.io.in(1).valid := left_dispatcher.io.up
  up_out_arbiter.io.in(2) <> right_in
  up_out_arbiter.io.in(2).valid := right_dispatcher.io.up
  up_out_arbiter.io.in(3) <> bottom_in
  up_out_arbiter.io.in(3).valid := bottom_dispatcher.io.up

  bottom_out_arbiter.io.in(0).valid := generation_dispatcher.io.bottom
  bottom_out_arbiter.io.in(0).bits.data := read_value
  bottom_out_arbiter.io.in(0).bits.x_0 := x_coord
  bottom_out_arbiter.io.in(0).bits.y_0 := y_coord
  bottom_out_arbiter.io.in(0).bits.x_dest := read_x
  bottom_out_arbiter.io.in(0).bits.y_dest := read_y
  bottom_out_arbiter.io.in(1) <> left_in
  bottom_out_arbiter.io.in(1).valid := left_dispatcher.io.bottom
  bottom_out_arbiter.io.in(2) <> right_in
  bottom_out_arbiter.io.in(2).valid := right_dispatcher.io.bottom
  bottom_out_arbiter.io.in(3) <> up_in
  bottom_out_arbiter.io.in(3).valid := bottom_dispatcher.io.bottom

 

  
}

/*
class AllTOAllPEcorner(n : Int, cacheSize: Int, id : Int) extends AllToAllPE{
  override val io = IO(new AllToAllPEIOcorner)
  io.side1.out := 0.U(64.W)
  io.side2.out := 0.U(64.W)
 
  io.data := 0.U(64.W)

}

class AllTOAllPEedge(n : Int, cacheSize: Int, id : Int) extends AllToAllPE{
  override val io = IO(new AllToAllPEIOedge)
  io.side1.out := 0.U(64.W)
  io.side2.out := 0.U(64.W)
  io.side3.out := 0.U(64.W)
 
  io.data := 0.U(64.W)
  
}

class AllTOAllPEmiddle(n : Int, cacheSize: Int, id : Int) extends AllToAllPE{
  override val io = IO(new AllToAllPEIOmiddle)
  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  io.down.out := 0.U(64.W)
  io.data := 0.U(64.W)
  
}
*/
class AllToAllPEupLeftCorner(n : Int, cacheSize: Int, queueSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,queueSize,x,y){
  /*
  //io.left.in :=  0.U(64.W)
  io.left.out :=  0.U(64.W)
  //io.up.in :=  0.U(64.W)
  io.up.out :=  0.U(64.W)

  io.right.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 */
}

class AllToAllPEupRightCorner(n : Int, cacheSize: Int, queueSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,queueSize,x,y){
 /* 
  //io.right.in :=  0.U(64.W)
  io.right.out :=  0.U(64.W)
  //io.up.in :=  0.U(64.W)
  io.up.out :=  0.U(64.W)

  io.left.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
*/
}

class AllToAllPEbottomLeftCorner(n : Int, cacheSize: Int, queueSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,queueSize,x,y){
 /* 
  //io.left.in :=  0.U(64.W)
  io.left.out :=  0.U(64.W)
  //io.bottom.in :=  0.U(64.W)
  io.bottom.out :=  0.U(64.W)


  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
 
*/
}
class AllToAllPEbottomRightCorner(n : Int, cacheSize: Int, queueSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,queueSize,x,y){
 /* 
  //io.right.in :=  0.U(64.W)
  io.right.out :=  0.U(64.W)
  //io.bottom.in :=  0.U(64.W)
  io.bottom.out :=  0.U(64.W)

  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  
*/
}
class AllToAllPEup(n : Int, cacheSize: Int, queueSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,queueSize,x,y){
 /*
  //io.up.in :=  0.U(64.W)
  io.up.out :=  0.U(64.W)

  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 */
}
class AllToAllPEbottom(n : Int, cacheSize: Int, queueSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,queueSize,x,y){
 /* 
  //io.bottom.in :=  0.U(64.W)
  io.bottom.out :=  0.U(64.W)

  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
*/ 

}
class AllToAllPEleft(n : Int, cacheSize: Int, queueSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,queueSize,x,y){
 /* 
  
  //io.left.in :=  0.U(64.W)
  io.left.out :=  0.U(64.W)

  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
*/

}
class AllToAllPEright(n : Int, cacheSize: Int, queueSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,queueSize,x,y){
/*
  //io.right.in :=  0.U(64.W)
  io.right.out :=  0.U(64.W)

  io.left.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 
*/
}
class AllToAllPEmiddle(n : Int, cacheSize: Int, queueSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,queueSize,x,y){
 /*
  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 */
}


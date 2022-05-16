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
  
  //store rs1 and rs2 values and keep for all the cycle
  val rs1 = Reg(Bits(64.W))
  val rs2 = Reg(Bits(64.W))

  
  rs1 := io.cmd.bits.rs1
  rs2 := io.cmd.bits.rs2
  

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

    state := store_resp

  }.elsewhen(state === store_resp){

    io.busy := stall_resp
    io.cmd.ready := !stall_resp
    io.resp.valid := true.B
    io.resp.bits.data := resp_value
    io.resp.bits.write_enable := w_en
    
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

    state := action_resp

  }.elsewhen(state === wait_action_resp){
    //busy iff at least one edge is busy
    io.busy := leftBusy || rightBusy || upBusy || bottomBusy
    io.cmd.ready := false.B
    io.resp.valid := false.B
    io.resp.bits.data := resp_value
    io.resp.bits.write_enable := false.B
    
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

    state := idle

  }.otherwise{
    
    io.busy := false.B
    io.cmd.ready := false.B
    io.resp.valid := false.B
    io.resp.bits.data := "b10101010101010101010101010101010".U(64.W)
    io.resp.bits.write_enable := true.B
  }




  //FSM for managing of AllToAll


  val stateAction = RegInit(idle) 



  when(stateAction === idle){

    when(start_AllToAll){
      stateAction := action
    }.otherwise{
      stateAction := idle
    }
  }.elsewhen(stateAction === action){

    //here enable all queues to read input and write to output
    when(io.end_AllToAll){//end_AllToAll is true only when all PEs have finished
      stateAction := idle
    }.otherwise{
      stateAction := action
    }
  }.otherwise{
    //error
  }

  //temporary initialization of values since no actual logic is implemented yet

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
  
  //output queues
  //val left_out = Queue(io.left.out, queueSize)
  //val right_out = Queue(io.right.out, queueSize)
  //val up_out = Queue(io.up.out, queueSize)
  //val bottom_out = Queue(io.bottom.out, queueSize)

  //left_out.valid := io.left.out.valid
  //right_out.valid := io.right.out.valid
  //up_out.valid := io.up.out.valid
  //bottom_out.valid := io.bottom.out.valid

  //input queues
  val left_in = Queue(io.left.in, queueSize)
  val right_in = Queue(io.right.in, queueSize)
  val up_in = Queue(io.up.in, queueSize)
  val bottom_in = Queue(io.bottom.in, queueSize)

  left_in.ready := io.left.in.ready
  right_in.ready := io.right.in.ready
  up_in.ready := io.up.in.ready
  bottom_in.ready := io.bottom.in.ready


  //round robin arbiters for output queues inputs
  //5 input ports because the 5th is the port used by the PE to write data from its own memory
  //val left_out_arbiter = Module(new RRArbiter(InputOutputPEdata(log2Up(n),5)))
  //val right_out_arbiter = Module(new RRArbiter(InputOutputPEdata(log2Up(n),5)))
  //val up_out_arbiter = Module(new RRArbiter(InputOutputPEdata(log2Up(n),5)))
  //val bottom_out_arbiter = Module(new RRArbiter(InputOutputPEdata(log2Up(n),5)))
  


def functU(i: SInt): SInt = {
  //if(i>0.S)
  //  1.S
  //else
    0.S
}

def functI(i: SInt): SInt = {
  //if(i>0)
  //  1.S
  //else
    -1.S
}

// x = x_0 and y != y_0
def neighborSameX1x(x_0 : SInt, y_0 : SInt): SInt = {
  val x = x_coord.zext - x_0 
  val y = y_coord.zext - y_0
  x + (y - y_0 + functU(functI(y - y_0)))%2.S
}

def neighborSameX1y(y_0 : SInt): SInt = {
  val y = y_coord.zext - y_0
  y + functI(y - y_0) * (y - y_0 + 1.S - functU(functI(y - y_0)))%2.S
}

def neighborSameX2x(x_0 : SInt, y_0 : SInt): SInt = {
  val x = x_coord.zext - x_0
  val y = y_coord.zext - y_0 
  x - (y - y_0 + functU(-functI(y - y_0)))%2.S
}

def neighborSameX2y(y_0 : SInt): SInt = {
  val y = y_coord.zext - y_0 
  y + functI(y - y_0) * (y - y_0 + 1.S - functU(-functI(y - y_0)))%2.S
}

// x != x_0 and y = y_0

def neighborSameY1x(x_0 : SInt): SInt = {
  val x = x_coord.zext - x_0 
  x + functI(x - x_0) * (x - x_0 + functU(functI(x - x_0)))%2.S
}

def neighborSameY1y(x_0 : SInt, y_0 : SInt): SInt = {
  val x = x_coord.zext - x_0
  val y = y_coord.zext - y_0
  y + (x - x_0 + 1.S - functU(functI(x - x_0)))%2.S
}

def neighborSameY2x(x_0 : SInt): SInt = {
  val x = x_coord.zext - x_0
  x + functI(x - x_0) * (x - x_0 + functU(-functI(x - x_0)))%2.S
}

def neighborSameY2y(x_0 : SInt, y_0 : SInt): SInt = {
  val x = x_coord.zext - x_0
  val y = y_coord.zext - y_0
  y - (x - x_0 + 1.S - functU(-functI(x - x_0)))%2.S
}


// x != x_0 and y != y_0

def neighbor3x(x_0 : SInt, y_0 : SInt): SInt = {
  val x = x_coord.zext - x_0
  val y = y_coord.zext - y_0
  x + functI(x - x_0) * ((x-x_0) + (y-y_0) + functU(functI(x-x_0)*functI(y-y_0)))%2.S
}

def neighbor3y(x_0 : SInt, y_0 : SInt): SInt = {
  val x = x_coord.zext - x_0
  val y = y_coord.zext - y_0 
  y + functI(y - y_0) * ((x-x_0) + (y-y_0) + 1.S - functU(functI(x-x_0)*functI(y-y_0)))%2.S

}







  
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


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

class AllToAllPEIO extends Bundle{

    //when busy = true -> computation of PE not terminated yet
    val busy = Output(Bool())
    
    /*
    //communiction between PE and controller
    val load = Input(Bool())
    val store = Input(Bool())
    val doAllToAll = Input(Bool())
    val rs1 = Input(Bits(64.W))
    val rs2 = Input(Bits(64.W))
    val data = Output(Bits(64.W))
    */

    val cmd = Flipped(Decoupled(new PECommand))
    val resp = Decoupled(new PEResponse)
    val left = new InputOutputPEdata
    val right = new InputOutputPEdata
    val up = new InputOutputPEdata
    val bottom = new InputOutputPEdata
}


/*
class AllToAllPEIOcorner extends AllToAllPEIO{
    val side1 = new InputOutputPEdata
    val side2 = new InputOutputPEdata
}
class AllToAllPEIOedge extends AllToAllPEIO{
    val side1 = new InputOutputPEdata
    val side2 = new InputOutputPEdata
    val side3 = new InputOutputPEdata
}
class AllToAllPEIOmiddle extends AllToAllPEIO{
    val left = new InputOutputPEdata
    val right = new InputOutputPEdata
    val up = new InputOutputPEdata
    val down = new InputOutputPEdata
}
*/

/*
class AllToAllPEIOupRightCorner extends AllToAllPEIO{
    val left = new InputOutputPEdata
    val bottom = new InputOutputPEdata
}
class AllToAllPEIOupLeftCorner extends AllToAllPEIO{
    val right = new InputOutputPEdata
    val bottom = new InputOutputPEdata
}
class AllToAllPEIObottomRightCorner extends AllToAllPEIO{
    val left = new InputOutputPEdata
    val up = new InputOutputPEdata
}
class AllToAllPEIObottomLeftCorner extends AllToAllPEIO{
    val right = new InputOutputPEdata
    val up = new InputOutputPEdata
}
class AllToAllPEIOright extends AllToAllPEIO{
    val left = new InputOutputPEdata
    val up = new InputOutputPEdata
    val bottom = new InputOutputPEdata
}
class AllToAllPEIOleft extends AllToAllPEIO{
    val right = new InputOutputPEdata
    val up = new InputOutputPEdata
    val bottom = new InputOutputPEdata
}
class AllToAllPEIOup extends AllToAllPEIO{
    val left = new InputOutputPEdata
    val right = new InputOutputPEdata
    val bottom = new InputOutputPEdata
}
class AllToAllPEIObottom extends AllToAllPEIO{
    val left = new InputOutputPEdata
    val right = new InputOutputPEdata
    val up = new InputOutputPEdata
}
class AllToAllPEIOmiddle extends AllToAllPEIO{
    val left = new InputOutputPEdata
    val right = new InputOutputPEdata
    val up = new InputOutputPEdata
    val bottom = new InputOutputPEdata
}
*/



class InputOutputPEdata extends Bundle{
    val out = Decoupled(new OutputPE)
    val in = Flipped(Decoupled(new OutputPE))
}

class OutputPE extends Bundle{
  val data = Bits(64.W)
  val x_0 = Bits(16.W)
  val y_0 = Bits(16.W)
  val x_dest = Bits(16.W)
  val y_dest = Bits(16.W)
}

class AllToAllPE(n : Int, cacheSize: Int, x : Int, y : Int) extends Module{

  val io = IO(new AllToAllPEIO())

  //memory
  val memPE = Mem(cacheSize, UInt(64.W)) 

  //It represents the number of the PE -> at most 2^16 PE -> n of mesh max 2^8 = 256
  val x_coord = RegInit(UInt(16.W),x.U)
  val y_coord = RegInit(UInt(16.W),y.U)
  
  //store rs1 and rs2 values and keep for all the cycle
  val rs1 = Reg(Bits(64.W))
  val rs2 = Reg(Bits(64.W))

  rs1 := io.cmd.bits.rs1
  rs2 := io.cmd.bits.rs2

  //notify when the response is ready
  val w_en = Reg(Bool())
  io.resp.bits.write_enable := w_en

  //states
  val idle :: action :: action_resp :: do_load :: do_store :: stall_state :: Nil = Enum(6)

  val state = RegInit(idle) 
  val resp_signal = RegInit(Bool(),false.B)
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
  val stall_resp = !io.resp.ready && resp_signal

  when(state === idle){
    io.busy := false.B
    io.cmd.ready := true.B
    io.resp.valid := resp_signal
    io.resp.bits.data := resp_value
    resp_value := 0.U
    resp_signal := false.B
    w_en := false.B

    when(load_signal){
      state := do_load
    }.elsewhen(store_signal){
      state := do_store
    }.elsewhen(allToAll_signal){
      state := action
    }.elsewhen(stall_resp){
      state := stall_state
    }.otherwise{
      state := idle
    }

  }.elsewhen(state === do_load){
    io.busy := false.B
    io.cmd.ready := true.B
    io.resp.valid := resp_signal
    io.resp.bits.data := resp_value
    resp_signal := true.B

    when(is_this_PE){
      memPE(memIndex) := rs1
      w_en := true.B
    }.otherwise{
      w_en := false.B
    }
    resp_value := 32.U(64.W)

    when(load_signal){
      state := do_load
    }.elsewhen(store_signal){
      state := do_store
    }.elsewhen(allToAll_signal){
      state := action
    }.elsewhen(stall_resp){
      state := stall_state
    }.otherwise{
      state := idle
    }

  }.elsewhen(state === do_store){

    io.busy := false.B
    io.cmd.ready := true.B
    io.resp.valid := resp_signal
    io.resp.bits.data := resp_value
    resp_signal := true.B

    when(is_this_PE){
      resp_value := memPE(memIndex)
      w_en := true.B
    }.otherwise{
      w_en := false.B
    }

    when(load_signal){
      state := do_load
    }.elsewhen(store_signal){
      state := do_store
    }.elsewhen(allToAll_signal){
      state := action
    }.elsewhen(stall_resp){
      state := stall_state
    }.otherwise{
      state := idle
    }

  }.elsewhen(state === stall_state){
    
    io.busy := true.B
    io.cmd.ready := false.B
    io.resp.valid := resp_signal
    io.resp.bits.data := resp_value
    
    when(stall_resp){
      //still stalling response
      resp_signal := true.B
      state := stall_state
      
    }.otherwise{
      //response already given, no need to respond at next clock cycle
      resp_signal := false.B
      state := idle
    }
    
  }.elsewhen(state === action){
    io.busy := true.B
    io.cmd.ready := false.B
    io.resp.valid := resp_signal
    io.resp.bits.data := resp_value

    //funziona sse aggiorna il reg dopo aver letto il valore
    resp_signal := false.B
    //during action PEs don't need to write resp.data
    w_en := false.B

    state := action_resp
  }.elsewhen(state === action_resp){
    io.busy := true.B
    io.cmd.ready := false.B
    io.resp.valid := true.B
    io.resp.bits.data := resp_value
    //funziona sse aggiorna il reg dopo aver letto il valore
    resp_signal := false.B

    state := idle
  }.otherwise{
    io.busy := false.B
    io.cmd.ready := false.B
    io.resp.valid := false.B
    io.resp.bits.data := "b10101010101010101010101010101010".U(64.W)
  }

  //temporary initialization of values since no actual logic is implemented yet

  io.left.out.bits.data := 0.U(64.W)
  io.left.out.bits.x_0 := 0.U(16.W)
  io.left.out.bits.y_0 := 0.U(16.W)
  io.left.out.bits.x_dest := 0.U(16.W)
  io.left.out.bits.y_dest := 0.U(16.W)
  io.left.out.valid := false.B
  io.left.in.ready := false.B

  io.right.out.bits.data := 0.U(64.W)
  io.right.out.bits.x_0 := 0.U(16.W)
  io.right.out.bits.y_0 := 0.U(16.W)
  io.right.out.bits.x_dest := 0.U(16.W)
  io.right.out.bits.y_dest := 0.U(16.W)
  io.right.out.valid := false.B
  io.right.in.ready := false.B

  io.up.out.bits.data := 0.U(64.W)
  io.up.out.bits.x_0 := 0.U(16.W)
  io.up.out.bits.y_0 := 0.U(16.W)
  io.up.out.bits.x_dest := 0.U(16.W)
  io.up.out.bits.y_dest := 0.U(16.W)
  io.up.out.valid := false.B
  io.up.in.ready := false.B 
  
  io.bottom.out.bits.data := 0.U(64.W)
  io.bottom.out.bits.x_0 := 0.U(16.W)
  io.bottom.out.bits.y_0 := 0.U(16.W)
  io.bottom.out.bits.x_dest := 0.U(16.W)
  io.bottom.out.bits.y_dest := 0.U(16.W)
  io.bottom.out.valid := false.B
  io.bottom.in.ready := false.B 
  
/*
  val left_out = Queue(io.left.out)
  val right_out = Queue(io.right.out)
  val up_out = Queue(io.up.out)
  val bottom_out = Queue(io.bottom.out)
*/
/*

  val left_in = Queue(io.left.in)
  val right_in = Queue(io.right.in)
  val up_in = Queue(io.up.in)
  val bottom_in = Queue(io.bottom.in)

  left_in.ready := false.B
  left_in.ready := false.B
  left_in.ready := false.B
  left_in.ready := false.B
  */
  /*
  left_in.deq := false.B
  right_in.deq := false.B
  up_in.deq := false.B
  bottom_in.deq := false.B
 */
  
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
class AllToAllPEupLeftCorner(n : Int, cacheSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,x,y){
  /*
  //io.left.in :=  0.U(64.W)
  io.left.out :=  0.U(64.W)
  //io.up.in :=  0.U(64.W)
  io.up.out :=  0.U(64.W)

  io.right.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 */
}

class AllToAllPEupRightCorner(n : Int, cacheSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,x,y){
 /* 
  //io.right.in :=  0.U(64.W)
  io.right.out :=  0.U(64.W)
  //io.up.in :=  0.U(64.W)
  io.up.out :=  0.U(64.W)

  io.left.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
*/
}

class AllToAllPEbottomLeftCorner(n : Int, cacheSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,x,y){
 /* 
  //io.left.in :=  0.U(64.W)
  io.left.out :=  0.U(64.W)
  //io.bottom.in :=  0.U(64.W)
  io.bottom.out :=  0.U(64.W)


  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
 
*/
}
class AllToAllPEbottomRightCorner(n : Int, cacheSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,x,y){
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
class AllToAllPEup(n : Int, cacheSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,x,y){
 /*
  //io.up.in :=  0.U(64.W)
  io.up.out :=  0.U(64.W)

  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 */
}
class AllToAllPEbottom(n : Int, cacheSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,x,y){
 /* 
  //io.bottom.in :=  0.U(64.W)
  io.bottom.out :=  0.U(64.W)

  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
*/ 

}
class AllToAllPEleft(n : Int, cacheSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,x,y){
 /* 
  
  //io.left.in :=  0.U(64.W)
  io.left.out :=  0.U(64.W)

  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
*/

}
class AllToAllPEright(n : Int, cacheSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,x,y){
/*
  //io.right.in :=  0.U(64.W)
  io.right.out :=  0.U(64.W)

  io.left.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 
*/
}
class AllToAllPEmiddle(n : Int, cacheSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,x,y){
 /*
  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 */
}

/*

class AllToAllPEupLeftCorner(n : Int, cacheSize: Int, id : Int) extends AllToAllPE(n,cacheSize,id){
  override val io = IO(new AllToAllPEIOupLeftCorner)
  io.right.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 
  io.data := 0.U(64.W)

}

class AllToAllPEupRightCorner(n : Int, cacheSize: Int, id : Int) extends AllToAllPE(n,cacheSize,id){
  override val io = IO(new AllToAllPEIOupRightCorner)
  io.left.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 
  io.data := 0.U(64.W)

}

class AllToAllPEbottomLeftCorner(n : Int, cacheSize: Int, id : Int) extends AllToAllPE(n,cacheSize,id){
  override val io = IO(new AllToAllPEIObottomLeftCorner)
  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
 
  io.data := 0.U(64.W)

}
class AllToAllPEbottomRightCorner(n : Int, cacheSize: Int, id : Int) extends AllToAllPE(n,cacheSize,id){
  override val io = IO(new AllToAllPEIObottomRightCorner)
  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  
  io.data := 0.U(64.W)

}
class AllToAllPEup(n : Int, cacheSize: Int, id : Int) extends AllToAllPE(n,cacheSize,id){
  override val io = IO(new AllToAllPEIOup)
  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 
  io.data := 0.U(64.W)

}
class AllToAllPEbottom(n : Int, cacheSize: Int, id : Int) extends AllToAllPE(n,cacheSize,id){
  override val io = IO(new AllToAllPEIObottom)
  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
 
  io.data := 0.U(64.W)

}
class AllToAllPEleft(n : Int, cacheSize: Int, id : Int) extends AllToAllPE(n,cacheSize,id){
  override val io = IO(new AllToAllPEIOleft)
  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)

  io.data := 0.U(64.W)

}
class AllToAllPEright(n : Int, cacheSize: Int, id : Int) extends AllToAllPE(n,cacheSize,id){
  override val io = IO(new AllToAllPEIOright)
  io.left.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 
  io.data := 0.U(64.W)

}
class AllToAllPEmiddle(n : Int, cacheSize: Int, id : Int) extends AllToAllPE(n,cacheSize,id){
  override val io = IO(new AllToAllPEIOmiddle)
  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 
  io.data := 0.U(64.W)

}
*/



/*

//Single Processing ELement 
class AllToAllPE(n : Int, cacheSize: Int, id : Int) extends Module{
  
  val io = IO(new AllToAllPEIO())

  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  io.down.out := 0.U(64.W)
  io.data := 0.U(64.W)

  //It represents the number of the PE -> at most 2^32 PE -> n of mesh max 2^16
  val number_PE = Reg(UInt(32.W))
  number_PE := id.U(32.W)
  /*
  def setNumberPE(number: Int) : Unit = {
    number_PE := number.U(32.W)
  }
  */

  //val cacheRegister = Reg(Vec(cacheSize, UInt(64.W)))

  val memPE = Mem(cacheSize, UInt(64.W)) 

  /*def 
  //to load -> write data in rs2 in memory at address rs1
  val wen = false.B //eg depending on opcode understand that it is a store
  val writeAddr = io.rs1
  val dataIn = io.rs2
  when (wen) { 
    memPE(writeAddr) := dataIn 
  } 
  */

  when(io.load){
     for(i<-0 to (n*n)-1){
      memPE(i.U) := computeLoadValue(i)
     }
  }

  
  def computeLoadValue(i : Int) : UInt = {
    val msb32 = i.U(32.W)
    val memLine = Cat(msb32,number_PE)
    memLine
  }
}
*/
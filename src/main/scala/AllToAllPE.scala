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

class AllToAllPEIO extends Bundle{

    //when busy = true -> computation of PE not terminated yet
    val busy = Output(Bool())
    
    //communiction between PE and controller
    val load = Input(Bool())
    val store = Input(Bool())
    val doAllToAll = Input(Bool())
    val rs1 = Input(Bits(64.W))
    val rs2 = Input(Bits(64.W))
    val data = Output(Bits(64.W))
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
    val out = Output(Bits(64.W))
    val in = Input(Bits(64.W))
}

class AllToAllPE(n : Int, cacheSize: Int, id : Int) extends Module{
  val io = IO(new AllToAllPEIO())
  val memPE = Mem(cacheSize, UInt(64.W)) 

  //It represents the number of the PE -> at most 2^16 PE -> n of mesh max 2^8 = 256
  assert(n<=256)
  val number_PE = Reg(UInt(16.W))
  number_PE := id.U(16.W)

  io.busy := false.B

  when(io.load){
     for(i<-0 to (n*n)-1){
      memPE(i.U) := computeLoadValue(i)
     }
  }

  
  def computeLoadValue(i : Int) : UInt = {
    val msb32 = i.U(48.W)
    val memLine = Cat(msb32,number_PE)
    memLine
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
class AllToAllPEupLeftCorner(n : Int, cacheSize: Int, id : Int) extends AllToAllPE(n,cacheSize,id){
  
  //io.left.in :=  0.U(64.W)
  io.left.out :=  0.U(64.W)
  //io.up.in :=  0.U(64.W)
  io.up.out :=  0.U(64.W)

  io.right.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 
  io.data := 0.U(64.W)

}

class AllToAllPEupRightCorner(n : Int, cacheSize: Int, id : Int) extends AllToAllPE(n,cacheSize,id){
  
  //io.right.in :=  0.U(64.W)
  io.right.out :=  0.U(64.W)
  //io.up.in :=  0.U(64.W)
  io.up.out :=  0.U(64.W)

  io.left.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 
  io.data := 0.U(64.W)

}

class AllToAllPEbottomLeftCorner(n : Int, cacheSize: Int, id : Int) extends AllToAllPE(n,cacheSize,id){
  
  //io.left.in :=  0.U(64.W)
  io.left.out :=  0.U(64.W)
  //io.bottom.in :=  0.U(64.W)
  io.bottom.out :=  0.U(64.W)


  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
 
  io.data := 0.U(64.W)

}
class AllToAllPEbottomRightCorner(n : Int, cacheSize: Int, id : Int) extends AllToAllPE(n,cacheSize,id){
  
  //io.right.in :=  0.U(64.W)
  io.right.out :=  0.U(64.W)
  //io.bottom.in :=  0.U(64.W)
  io.bottom.out :=  0.U(64.W)

  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  
  io.data := 0.U(64.W)

}
class AllToAllPEup(n : Int, cacheSize: Int, id : Int) extends AllToAllPE(n,cacheSize,id){
 
  //io.up.in :=  0.U(64.W)
  io.up.out :=  0.U(64.W)

  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 
  io.data := 0.U(64.W)

}
class AllToAllPEbottom(n : Int, cacheSize: Int, id : Int) extends AllToAllPE(n,cacheSize,id){
  
  //io.bottom.in :=  0.U(64.W)
  io.bottom.out :=  0.U(64.W)

  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
 
  io.data := 0.U(64.W)

}
class AllToAllPEleft(n : Int, cacheSize: Int, id : Int) extends AllToAllPE(n,cacheSize,id){
  
  
  //io.left.in :=  0.U(64.W)
  io.left.out :=  0.U(64.W)

  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)

  io.data := 0.U(64.W)

}
class AllToAllPEright(n : Int, cacheSize: Int, id : Int) extends AllToAllPE(n,cacheSize,id){

  //io.right.in :=  0.U(64.W)
  io.right.out :=  0.U(64.W)

  io.left.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 
  io.data := 0.U(64.W)

}
class AllToAllPEmiddle(n : Int, cacheSize: Int, id : Int) extends AllToAllPE(n,cacheSize,id){
 
  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 
  io.data := 0.U(64.W)

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
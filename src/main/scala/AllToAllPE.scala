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

    //val busy = Output(Bool())

    //communication between PEs
    val left = new InputOutputPEdata
    val right = new InputOutputPEdata
    val up = new InputOutputPEdata
    val down = new InputOutputPEdata
    
    //communiction between PE and controller
    val rs1 = Input(Bits(64.W))
    val rs2 = Input(Bits(64.W))
    val data = Output(Bits(64.W))
}

class InputOutputPEdata extends Bundle{
    val out = Output(Bits(64.W))
    val in = Input(Bits(64.W))
}

//Single Processing ELement 
class AllToAllPE(cacheSize: Int) extends Module{
  
  val io = IO(new AllToAllPEIO())

  val cacheRegister = Reg(Vec(cacheSize, UInt(64.W)))

  val memPE = Mem(128, UInt(32.W)) 

  //to load -> write data in rs2 in memory at address rs1
  val wen = false.B //eg depending on opcode understand that it is a store
  val writeAddr = io.rs1
  val dataIn = io.rs2
  when (wen) { 
    memPE(writeAddr) := dataIn 
  } 

}
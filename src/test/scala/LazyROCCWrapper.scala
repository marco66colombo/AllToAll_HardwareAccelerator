package hppsProject

import chisel3._
import chisel3.iotesters._
import chisel3.util._ 
import org.scalatest._
import hppsProject._


//simulating RoccInterface
class RoCCInstructionWrapper extends Bundle {
  val funct = Bits(7.W)
  val rs2 = Bits(5.W)
  val rs1 = Bits(5.W)
  val xd = Bool()
  val xs1 = Bool()
  val xs2 = Bool()
  val rd = Bits(5.W)
  val opcode = Bits(7.W)
}

class RoCCCommandWrapper extends Bundle {
  val inst = new RoCCInstructionWrapper
  val rs1 = Bits(64.W)
  val rs2 = Bits(64.W)
}

class RoCCResponseWrapper extends Bundle {
  val rd = Bits(5.W)
  val data = Bits(64.W)
}

class RoCCCoreIOWrapper extends Bundle {
  val cmd = Flipped(Decoupled(new RoCCCommandWrapper))
  val resp = Decoupled(new RoCCResponseWrapper)
  val busy = Output(Bool())
  val interrupt = Output(Bool())
  val exception = Input(Bool())
}

class RoCCIOWrapper() extends RoCCCoreIOWrapper {
  //val ptw = Vec(nPTWPorts, new TLBPTWIO)
  //val fpu_req = Decoupled(new FPInput)
  //val fpu_resp = Flipped(Decoupled(new FPResult))
}

class LazyRoCCModuleImpWrapper() extends Module {
  val io = IO(new RoCCIOWrapper)
}




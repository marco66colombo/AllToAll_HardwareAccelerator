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

//IO interface of custom module

class Instruction extends Bundle {
  val funct = Bits(7.W)
  val rs2 = Bits(5.W)
  val rs1 = Bits(5.W)
  val xd = Bool()
  val xs1 = Bool()
  val xs2 = Bool()
  val rd = Bits(5.W)
  val opcode = Bits(7.W)
}

//xLen put as 64.W
class Command extends Bundle {
  val inst = new Instruction
  val rs1 = Bits(64.W)
  val rs2 = Bits(64.W)
  //val status = new MStatus
}
class Response extends Bundle {
  val rd = Bits(5.W)
  val data = Bits(64.W)
}
class AcceleratorModuleIO extends Bundle {
  val cmd = Flipped(Decoupled(new Command))
  val resp = Decoupled(new Response)
  //val mem = new HellaCacheIO
  val busy = Output(Bool())
  val interrupt = Output(Bool())
  val exception = Input(Bool())

}
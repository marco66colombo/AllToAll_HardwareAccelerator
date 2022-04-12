
package hppsProject

import chisel3._
import chisel3.util._
import chisel3.util.HasBlackBoxResource
import chisel3.experimental.IntParam
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.rocket._
import freechips.rocketchip.tilelink._
import freechips.rocketchip.util.InOrderArbiter


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
  val status = new MStatus
}

class RoCCResponseWrapper extends Bundle {
  val rd = Bits(5.W)
  val data = Bits(64.W)
}

class RoCCCoreIOWrapper extends Bundle {
  val cmd = Flipped(Decoupled(new RoCCCommandWrapper))
  val resp = Decoupled(new RoCCResponseWrapper)
  val mem = new HellaCacheIO
  val busy = Output(Bool())
  val interrupt = Output(Bool())
  val exception = Input(Bool())
}

class RoCCIOWrapper(/*val nPTWPorts: Int*/) extends RoCCCoreIOWrapper {
  val ptw = Vec(nPTWPorts, new TLBPTWIO)
  val fpu_req = Decoupled(new FPInput)
  val fpu_resp = Flipped(Decoupled(new FPResult))
}

class LazyRoCCModuleImpWrapper() extends module {
  val io = IO(new RoCCIOWrapper)
}

class TestModule() extends LazyRoCCModuleImpWrapper{
  val customModule = new CustomModule

  //command input
  customModule.io.cmd.valid := io.cmd.valid
  customModule.io.cmd.ready := io.cmd.ready
  customModule.io.cmd.bits.inst.funct := io.cmd.bits.inst.funct
  customModule.io.cmd.bits.inst.rs2 := io.cmd.bits.inst.rs2
  customModule.io.cmd.bits.inst.rs1 := io.cmd.bits.inst.rs1
  customModule.io.cmd.bits.inst.xd := io.cmd.bits.inst.xd
  customModule.io.cmd.bits.inst.xs1 := io.cmd.bits.inst.xs1
  customModule.io.cmd.bits.inst.xs2 := io.cmd.bits.inst.xs2
  customModule.io.cmd.bits.inst.rd := io.cmd.bits.inst.rd
  customModule.io.cmd.bits.inst.opcode := io.cmd.bits.inst.opcode
  customModule.io.cmd.bits.rs1 := io.cmd.bits.rs1
  customModule.io.cmd.bits.rs2 := io.cmd.bits.rs2
  //customModule.io.cmd.bits.status := io.cmd.bits.status


  //response output
  io.resp.valid := customModule.io.resp.valid
  io.resp.ready := customModule.io.resp.ready
  io.resp.bits.rd := customModule.io.resp.bits.rd
  io.resp.bits.data := customModule.io.resp.bits.data
  io.busy := customModule.io.busy

  //interrupt output
  io.interrupt := customModule.io.interrupt

  //exception input
  customModule.io.exception := io.exception

  TODO 
  //null value
  /*
  io.cmd.bits.status := null
  io.ptw := null
  io.fpu_req := null
  io.fpu_resp := null
  io.mem := null
  */
}

/*
/** Base classes for Diplomatic TL2 RoCC units **/
abstract class LazyRoCCWrapper(
      val opcodes: OpcodeSet,
      val nPTWPorts: Int = 0,
      val usesFPU: Boolean = false
    )/*(implicit p: Parameters) extends LazyModule */extends module{
  val module: LazyRoCCModuleImp
  val atlNode: TLNode = TLIdentityNode()
  val tlNode: TLNode = TLIdentityNode()
}
*/


class CustomModuleTester(c: TestModule) extends PeekPokeTester(c) {

  poke(c.io.cmd.bits.rs1, 1.U)
  poke(c.io.cmd.bits.rs2, 3.U)
  poke(c.io.cmd.bits.inst.rd, 1.U)
  poke(c.io.cmd.valid, true.B) 
  
  step(1)

  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.resp.bits.data, 2.U)
  expect(c.io.interrupt, false.B)
  expect(c.io.busy, false.B) 
  
}

class CustomTest extends ChiselFlatSpec {

  val testerArgs = Array("")

  behavior of "DoAddTests"
  it should "add" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new TestModule()) {
      c => new CustomModuleTester(c)
    } should be (true)
  }

}



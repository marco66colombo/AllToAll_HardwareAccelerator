
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
/*

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
  val rs1 = Bits(xLen.W)
  val rs2 = Bits(xLen.W)
  val status = new MStatus
}

class RoCCResponseWrapper extends Bundle {
  val rd = Bits(5.W)
  val data = Bits(xLen.W)
}

class RoCCCoreIOWrapper extends Bundle {
  val cmd = Flipped(Decoupled(new RoCCCommandWrapper))
  val resp = Decoupled(new RoCCResponseWrapper)
  // val mem = new HellaCacheIO
  val busy = Output(Bool())
  val interrupt = Output(Bool())
  val exception = Input(Bool())
}

class RoCCIOWrapper(/*val nPTWPorts: Int*/) extends RoCCCoreIOWrapper {
  //val ptw = Vec(nPTWPorts, new TLBPTWIO)
  val fpu_req = Decoupled(new FPInput)
  val fpu_resp = Flipped(Decoupled(new FPResult))
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

class LazyRoCCModuleImpWrapper(/*outer: LazyRoCCWrapper*/) extends module {
  val io = IO(new RoCCIOWrapper/*(outer.nPTWPorts)*/)
}

/*
  nella classe dell'acceleratore ho il mio module che ha l'interfaccia definita da me
  e questo module è istanziato nell'acceleratore con la vera interfaccia rocc (perchè comunque deve funzionare veramente)
  e collego l'interfaccia rocc a quella definita da me

  nel test, non uso l'interfaccia rocc vera perchè ha gli implicit ma istanzio il mio module e faccio parlare 
  il componente con l'interrfaccia definita da me
  nel test devo creare lo scaffol che simula il processore e che quindi parla con la rocc interface

*/


*/

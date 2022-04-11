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


//interface of custom module

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
  val status = new MStatus
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



//custom accelerator def

class CustomAccelerator(opcodes: OpcodeSet) (implicit p: Parameters) extends LazyRoCC(opcodes) {
  override lazy val module = new CustomAcceleratorModule(this)
}


class CustomAcceleratorModule(outer: CustomAccelerator) extends LazyRoCCModuleImp(outer) {
  //val cmd = Queue(io.cmd)
  val customModule = new CustomModule
  
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
  customModule.io.cmd.bits.status := io.cmd.bits.status
  customModule.io.resp.valid := io.resp.valid
  customModule.io.resp.ready := io.resp.ready
  customModule.io.resp.bits.rd := io.resp.bits.rd
  customModule.io.resp.bits.data := io.resp.bits.data
  //mem
  customModule.io.busy := io.busy
  customModule.io.interrupt := io.interrupt
  customModule.io.exception := io.exception

}


//module with custom IO interface
class CustomModule extends Module{
  val io = IO(new AcceleratorModuleIO())
  val cmd = Queue(io.cmd)
  //devo salvare il valore del registro in scrittura nel processore (quando l'acceleratoere risponde) 
  //perchè quando testo è possibile che si resetti a zero al clock successivo
  io.cmd.ready := true.B
  io.resp.valid := true.B 
  io.resp.bits.rd := 3.U
  io.resp.bits.data := cmd.bits.rs1 + 1.U 

}

/*

  // The parts of the command are as follows
  // inst - the parts of the instruction itself
  //   opcode
  //   rd - destination register number
  //   rs1 - first source register number
  //   rs2 - second source register number
  //   funct
  //   xd - is the destination register being used?
  //   xs1 - is the first source register being used?
  //   xs2 - is the second source register being used?
  // rs1 - the value of source register 1
  // rs2 - the value of source register 2

  cmd.ready := true.B
  io.resp.valid := true.B 
  io.resp.bits.rd := 3.U
  io.resp.bits.data := cmd.bits.rs1 + 1.U 
  */

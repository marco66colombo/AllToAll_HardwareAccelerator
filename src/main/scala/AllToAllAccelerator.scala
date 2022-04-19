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




//custom accelerator def

class AllToAllAccelerator(opcodes: OpcodeSet) (implicit p: Parameters) extends LazyRoCC(opcodes) {
  override lazy val module = new AllToAllAcceleratorModule(this)
}


class AllToAllAcceleratorModule(outer: AllToAllAccelerator) extends LazyRoCCModuleImp(outer) {
  
  val aTaModule = Module(new AllToAllModule)
  
  //connection of RoccInterface with AcceleratorModuleIO

  //cmd input
  aTaModule.io.cmd.valid := io.cmd.valid
  aTaModule.io.cmd.bits.inst.funct := io.cmd.bits.inst.funct
  aTaModule.io.cmd.bits.inst.rs2 := io.cmd.bits.inst.rs2
  aTaModule.io.cmd.bits.inst.rs1 := io.cmd.bits.inst.rs1
  aTaModule.io.cmd.bits.inst.xd := io.cmd.bits.inst.xd
  aTaModule.io.cmd.bits.inst.xs1 := io.cmd.bits.inst.xs1
  aTaModule.io.cmd.bits.inst.xs2 := io.cmd.bits.inst.xs2
  aTaModule.io.cmd.bits.inst.rd := io.cmd.bits.inst.rd
  aTaModule.io.cmd.bits.inst.opcode := io.cmd.bits.inst.opcode
  aTaModule.io.cmd.bits.rs1 := io.cmd.bits.rs1
  aTaModule.io.cmd.bits.rs2 := io.cmd.bits.rs2
  aTaModule.io.resp.ready := io.resp.ready
  //customModule.io.cmd.bits.status := io.cmd.bits.status

  //resp output
  io.cmd.ready := aTaModule.io.cmd.ready
  io.resp.valid := aTaModule.io.resp.valid 
  io.resp.bits.rd := aTaModule.io.resp.bits.rd 
  io.resp.bits.data := aTaModule.io.resp.bits.data

  
  //output
  io.busy := aTaModule.io.busy
  //io.interrupt := aTaModule.io.interrupt
  io.interrupt := false.B

  //input
  //aTaModule.io.exception := io.exception
  aTaModule.io.exception := false.B

}




//module with custom IO interface
class AllToAllModule extends Module{
  val io = IO(new AcceleratorModuleIO())
  val cmd = io.cmd
  val aTaPE = Module(new AllToAllPE())
  val controller = Module(new AllToAllController())

  io <> controller.io

 
  // FSM 
  // if state is idle, it means there is no op waiting to do anything, otherwise 
  //this value has to be stored till the next one will be required to be stored(next idle state)
  io.resp.bits.rd := Mux( state === idle, io.cmd.bits.inst.rd, rd_address)
  io.cmd.ready := (state === idle)

  //io.rocc.resp.bits.data := io.resp.data
  //io.rocc.resp.valid := state === give_result

   //TODO
  //devo salvare il valore del registro in scrittura nel processore (quando l'acceleratoere risponde) 
  //perchè quando testo è possibile che si resetti a zero al clock successivo
  val rd_address = Reg(Bits(5.W))
  rd_address := io.cmd.bits.inst.rd
    
  val idle :: exchange :: done_exchange :: Nil = Enum(3)

  val state = Reg(Bits(2.W))
  val goto_excange = !(io.busy) && io.cmd.ready && io.cmd.valid
  
  state := idle

    when(state === idle){
    io.cmd.busy := false.B 
    io.cmd.ready := true.B 
    io.resp.valid := false.B
    io.busy := false.B 
    when(goto_excange){
      state := exchange
    }.otherwise{
      state := idle
    }
  }.elsewhen(state === exchange){
    io.busy := true.B 
    rocc.busy := true.B
    rocc.cmd.ready := false.B 
    rocc.resp.valid := false.B
    when(done){
        state := give_result
    }.otherwise{
        state := exec
    }
    
  }.elsewhen(state === give_result){
    io.ready := false.B 
    rocc.busy := true.B
    rocc.cmd.ready := false.B 
    rocc.resp.valid := true.B
    state := idle
  }.otherwise{ // shouldn't happen
  io.ready := false.B 
  rocc.busy := false.B
  rocc.cmd.ready := false.B 
  rocc.resp.valid := false.B 
  state := idle
  }


  //resp output
  io.cmd.ready := true.B
  io.resp.valid := true.B
  io.resp.bits.rd := 1.U
  io.resp.bits.data := cmd.bits.rs1 + 1.U

  //output
  io.busy := false.B
  io.interrupt := false.B
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

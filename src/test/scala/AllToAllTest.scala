package hppsProject

import chisel3._
import chisel3.iotesters._
import chisel3.util._ 
import org.scalatest._
import hppsProject._



class AllToAll() extends LazyRoCCModuleImpWrapper{
  val aTaModule = Module(new AllToAllModule(2,4))

  //command input
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

  //interrupt output
  io.interrupt := aTaModule.io.interrupt
  io.busy := aTaModule.io.busy

  //exception input
  aTaModule.io.exception := io.exception

  
  /*
  io.cmd.bits.status := null
  io.ptw := null
  io.fpu_req := null
  io.fpu_resp := null
  io.mem := null
  */
}


class AllToAllModuleTester(c: AllToAll) extends PeekPokeTester(c) {

  poke(c.io.cmd.bits.rs1, 1.U)
  poke(c.io.cmd.bits.rs2, 3.U)
  poke(c.io.cmd.bits.inst.rd, 1.U)
  poke(c.io.cmd.valid, false.B) 

  step(1)

  //idle
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.resp.bits.data, 0.U)
  expect(c.io.interrupt, false.B)
  expect(c.io.busy, false.B) 

  step(1)
  
  
  poke(c.io.cmd.bits.rs1, 1.U)
  poke(c.io.cmd.bits.rs2, 3.U)
  poke(c.io.cmd.bits.inst.rd, 1.U)
  poke(c.io.cmd.valid, true.B) 
  
  step(1)

  //exchange
  expect(c.io.cmd.ready, false.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.resp.bits.data, 0.U)
  expect(c.io.interrupt, false.B)
  expect(c.io.busy, true.B) 

  step(1)

  //done_exchange
  expect(c.io.busy, true.B) 

  step(1)
 
  //back to idle
  expect(c.io.busy, false.B)
   
}

class AllToAllTest extends ChiselFlatSpec {

  val testerArgs = Array("")

  behavior of "controllerFSMTest"
  it should "changeState" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAll()) {
      c => new AllToAllModuleTester(c)
    } should be (true)
  }

}
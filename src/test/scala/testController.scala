package hppsProject

import chisel3._
import chisel3.iotesters._
import chisel3.util._ 
import org.scalatest._
import hppsProject._




//idle -> load -> no cmd -> no cmd
class AllToAllControllerTester(c: AllToAllController) extends PeekPokeTester(c) {
   val processor = c.io.processor
   val mesh = c.io.mesh
   /*
   poke(processor.resp.ready, true.B)

   step(1)

   expect(processor.busy, false.B)
   expect(processor.cmd.ready, true.B)
   expect(mesh.cmd.valid, false.B)
   expect(mesh.cmd.bits.load, false.B)
   expect(mesh.cmd.bits.store, false.B)
   expect(mesh.cmd.bits.doAllToAll, false.B)

   step(1)
   //still idle
   expect(processor.busy, false.B)
   expect(processor.cmd.ready, true.B)
   expect(mesh.cmd.valid, false.B)
   expect(mesh.cmd.bits.load, false.B)
   expect(mesh.cmd.bits.store, false.B)
   expect(mesh.cmd.bits.doAllToAll, false.B)
   expect(mesh.resp.ready, false.B)

   poke(processor.cmd.valid, true.B)
   poke(processor.cmd.bits.inst.rd, 5.U)
   poke(processor.cmd.bits.inst.funct, "b0000001".U)
   poke(processor.cmd.bits.inst.opcode, "b0001011".U)
   poke(processor.cmd.bits.rs1, 24.U)
   poke(processor.cmd.bits.rs2, 27.U)
   
   step(1)
   //mem_cmd_state without response since it is the first one
   expect(processor.busy, false.B)
   expect(processor.cmd.ready, true.B)
   expect(mesh.cmd.valid, true.B)
   expect(mesh.cmd.bits.load, true.B)
   expect(mesh.cmd.bits.store, false.B)
   expect(mesh.cmd.bits.doAllToAll, false.B)
   expect(mesh.resp.ready, false.B)
   expect(mesh.cmd.bits.rs1, 24.U)
   expect(mesh.cmd.bits.rs2, 27.U)

   poke(processor.cmd.valid, false.B)
   poke(processor.cmd.bits.inst.rd, 5.U)
   poke(processor.cmd.bits.inst.funct, "b0000001".U)
   poke(processor.cmd.bits.inst.opcode, "b0001011".U)
   poke(processor.cmd.bits.rs1, 24.U)
   poke(processor.cmd.bits.rs2, 27.U)

   step(1)

   //idle + response
   expect(processor.busy, false.B)
   expect(processor.cmd.ready, true.B)
   expect(mesh.cmd.valid, false.B)
   expect(mesh.cmd.bits.load, false.B)
   expect(mesh.cmd.bits.store, false.B)
   expect(mesh.cmd.bits.doAllToAll, false.B)
   expect(mesh.resp.ready, true.B)
 */
}

//idle -> load -> no cmd -> no cmd
class test2loads(c: AllToAllController) extends PeekPokeTester(c) {
   val processor = c.io.processor
   val mesh = c.io.mesh
/*
   poke(processor.resp.ready, true.B)

   step(1)
   
   //still idle
   expect(processor.busy, false.B)
   expect(processor.cmd.ready, true.B)
   expect(mesh.cmd.valid, false.B)
   expect(mesh.cmd.bits.load, false.B)
   expect(mesh.cmd.bits.store, false.B)
   expect(mesh.cmd.bits.doAllToAll, false.B)
   expect(mesh.resp.ready, false.B)

   poke(processor.cmd.valid, true.B)
   poke(processor.cmd.bits.inst.rd, 5.U)
   poke(processor.cmd.bits.inst.funct, "b0000001".U)
   poke(processor.cmd.bits.inst.opcode, "b0001011".U)
   poke(processor.cmd.bits.rs1, 24.U)
   poke(processor.cmd.bits.rs2, 27.U)
   
   step(1)
   //mem_cmd_state without response since it is the first one
   expect(processor.busy, false.B)
   expect(processor.cmd.ready, true.B)
   expect(mesh.cmd.valid, true.B)
   expect(mesh.cmd.bits.load, true.B)
   expect(mesh.cmd.bits.store, false.B)
   expect(mesh.cmd.bits.doAllToAll, false.B)
   expect(mesh.resp.ready, false.B)
   expect(mesh.cmd.bits.rs1, 24.U)
   expect(mesh.cmd.bits.rs2, 27.U)

   poke(processor.cmd.valid, true.B)
   poke(processor.cmd.bits.inst.rd, 5.U)
   poke(processor.cmd.bits.inst.funct, "b0000010".U)
   poke(processor.cmd.bits.inst.opcode, "b0001011".U)
   poke(processor.cmd.bits.rs1, 25.U)
   poke(processor.cmd.bits.rs2, 28.U)

   step(1)

   //mem_cmd_stat (store) + response
   expect(processor.busy, false.B)
   expect(processor.cmd.ready, true.B)
   expect(mesh.cmd.valid, true.B)
   expect(mesh.cmd.bits.load, false.B)
   expect(mesh.cmd.bits.store, true.B)
   expect(mesh.cmd.bits.doAllToAll, false.B)
   expect(mesh.resp.ready, true.B)
   expect(mesh.cmd.bits.rs1, 25.U)
   expect(mesh.cmd.bits.rs2, 28.U)

   poke(processor.cmd.valid, false.B)
   poke(processor.cmd.bits.inst.rd, 5.U)
   poke(processor.cmd.bits.inst.funct, "b0000010".U)
   poke(processor.cmd.bits.inst.opcode, "b0001011".U)
   poke(processor.cmd.bits.rs1, 25.U)
   poke(processor.cmd.bits.rs2, 28.U)

   step(1)

   expect(processor.busy, false.B)
   expect(processor.cmd.ready, true.B)
   expect(mesh.cmd.valid, false.B)
   expect(mesh.cmd.bits.load, false.B)
   expect(mesh.cmd.bits.store, false.B)
   expect(mesh.cmd.bits.doAllToAll, false.B)
   expect(mesh.resp.ready, true.B)
 
*/
 
}



class AllToAllControllerTest extends ChiselFlatSpec {

  val testerArgs = Array("")

  behavior of "controllerFSMtest"
  it should "changeState" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllController()) {
      c => new AllToAllControllerTester(c)
    } should be (true)
  }

  behavior of "controllerFSMtestmultipleCmd"
  it should "changeState" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllController()) {
      c => new test2loads(c)
    } should be (true)
  }




}
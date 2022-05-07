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
  
  val aTaModule = Module(new AllToAllModule(2,8))
  
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
class AllToAllModule(n: Int, cacheSize: Int) extends Module{

  val io = IO(new AcceleratorModuleIO())

  val controller = Module(new AllToAllController())
  val mesh = Module(new AllToAllMesh(n, cacheSize))

  //aTaPE is temporary, it will be replaced by the actual mesh
  //val aTaPE = Module(new AllToAllPE())
  
  //connect part of interface of controller (dedicated to communicate with processor) with actual processor
  io <> controller.io.processor
  
  //connect part of interface of controller (dedicated to communicate with AllToAllMesh) with mesh interface
  
  //controller -> mesh
  mesh.io.cmd.valid := controller.io.mesh.cmd.valid
  mesh.io.cmd.bits.load := controller.io.mesh.cmd.bits.load
  mesh.io.cmd.bits.store := controller.io.mesh.cmd.bits.store
  mesh.io.cmd.bits.doAllToAll := controller.io.mesh.cmd.bits.doAllToAll
  mesh.io.cmd.bits.rs1 := controller.io.mesh.cmd.bits.rs1
  mesh.io.cmd.bits.rs2 := controller.io.mesh.cmd.bits.rs2
  mesh.io.resp.ready := controller.io.mesh.resp.ready
  
  //mesh -> controller
  controller.io.mesh.cmd.ready := mesh.io.cmd.ready
  controller.io.mesh.resp.valid := mesh.io.resp.valid
  controller.io.mesh.resp.bits.data := mesh.io.resp.bits.data
  controller.io.mesh.busy := mesh.io.busy


 

/*
  //resp output
  io.cmd.ready := true.B
  io.resp.valid := true.B
  io.resp.bits.rd := 1.U
  io.resp.bits.data := cmd.bits.rs1 + 1.U

  //output
  io.busy := false.B
  io.interrupt := false.B

  */
}

/*
object OpcodeSet {
  def custom0 = new OpcodeSet(Seq("b0001011".U)) //load 
  def custom1 = new OpcodeSet(Seq("b0101011".U)) //alltoall
  def custom2 = new OpcodeSet(Seq("b1011011".U)) 
  def custom3 = new OpcodeSet(Seq("b1111011".U))
  def all = custom0 | custom1 | custom2 | custom3
}
*/

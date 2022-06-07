package hppsProject

import chisel3._
import chisel3.iotesters._
import chisel3.util._ 
import org.scalatest._
import hppsProject._



class AllToAllMeshTester(c: AllToAllMesh) extends PeekPokeTester(c) {

    poke(c.io.resp.ready, true.B)

    step(1)

    expect(c.io.cmd.ready, true.B)
    expect(c.io.busy, false.B)
    expect(c.io.resp.valid, false.B)

    poke(c.io.cmd.valid, true.B)
    poke(c.io.cmd.bits.load, true.B)
    poke(c.io.cmd.bits.rs1, 24.U)
    poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000001_0000000000000001_0000000000000010".U)

    step(1)
    expect(c.io.cmd.ready, true.B)
    expect(c.io.busy, false.B)
    expect(c.io.resp.valid, true.B)
    expect(c.io.resp.bits.data, 32.U)

    poke(c.io.cmd.valid, false.B)

    step(1)
    expect(c.io.cmd.ready, true.B)
    expect(c.io.busy, false.B)
    expect(c.io.resp.valid, false.B)
    expect(c.io.resp.bits.data, 0.U)

    while(peek(c.io.resp.valid) != 0) {
      print("looping")
    }

}

//load and then store the same value
class testLoadStore(c: AllToAllMesh) extends PeekPokeTester(c) {

    poke(c.io.resp.ready, true.B)

    step(1)

    expect(c.io.cmd.ready, true.B)
    expect(c.io.busy, false.B)
    expect(c.io.resp.valid, false.B)

    poke(c.io.cmd.valid, true.B)
    poke(c.io.cmd.bits.load, true.B)
    poke(c.io.cmd.bits.rs1, 24.U)
    poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000001_0000000000000001_0000000000000010".U)

    step(1)
    expect(c.io.cmd.ready, true.B)
    expect(c.io.busy, false.B)
    expect(c.io.resp.valid, true.B)
    expect(c.io.resp.bits.data, 32.U)


    poke(c.io.cmd.valid, true.B)
    poke(c.io.cmd.bits.load, false.B)
    poke(c.io.cmd.bits.store, true.B)
    poke(c.io.cmd.bits.rs1, 22344.U)
    poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000001_0000000000000001_0000000000000010".U)

    step(1)
    expect(c.io.cmd.ready, false.B)
    expect(c.io.busy, true.B)
    expect(c.io.resp.valid, false.B)
    expect(c.io.resp.bits.data, 33.U)

    poke(c.io.cmd.valid, false.B)
    poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000101_0000000000000011_0000000000000010".U)

    step(1)

    expect(c.io.cmd.ready, true.B)
    expect(c.io.busy, false.B)
    expect(c.io.resp.valid, true.B)
    expect(c.io.resp.bits.data, 24.U)

}


class testLoadStoreDifferenPE(c: AllToAllMesh) extends PeekPokeTester(c) {
  
    poke(c.io.resp.ready, true.B)

    step(1)

    expect(c.io.cmd.ready, true.B)
    expect(c.io.busy, false.B)
    expect(c.io.resp.valid, false.B)

    poke(c.io.cmd.valid, true.B)
    poke(c.io.cmd.bits.load, true.B)
    poke(c.io.cmd.bits.store, false.B)
    poke(c.io.cmd.bits.doAllToAll, false.B)
    poke(c.io.cmd.bits.rs1, 24.U)
    poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000001_0000000000000001_0000000000000010".U)

    step(1)
    //do load no resp, store cmd
    expect(c.io.cmd.ready, true.B)
    expect(c.io.busy, false.B)
    expect(c.io.resp.valid, true.B)
    expect(c.io.resp.bits.data, 32.U)

    poke(c.io.cmd.valid, true.B)
    poke(c.io.cmd.bits.load, false.B)
    poke(c.io.cmd.bits.store, true.B)
    poke(c.io.cmd.bits.rs1, 22344.U)
    poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000001_0000000000000000_0000000000000010".U)

    step(1)
    expect(c.io.cmd.ready, false.B)
    expect(c.io.busy, true.B)
    expect(c.io.resp.valid, false.B)
    expect(c.io.resp.bits.data, 33.U)

    poke(c.io.cmd.valid, false.B)
    poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000001_0000000000000001_0000000000000010".U)

    step(1)
    //store response
    expect(c.io.cmd.ready, true.B)
    expect(c.io.busy, false.B)
    expect(c.io.resp.valid, true.B)
    //0 because it is accessing not written memory
    expect(c.io.resp.bits.data, 0.U)

}


class AllToAllMeshTest extends ChiselFlatSpec {

  val testerArgs = Array("")

  behavior of "meshFunctionality"
  it should "changeState" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllMesh(3,256, 81)) {
      c => new AllToAllMeshTester(c)
    } should be (true)
  }

  behavior of "meshLoadStore"
  it should "changeState" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllMesh(3,256,81)) {
      c => new testLoadStore(c)
    } should be (true)
  }

  behavior of "meshLoadStoreDifferentPE"
  it should "changeState" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllMesh(3,256,81)) {
      c => new testLoadStoreDifferenPE(c)
    } should be (true)
  }




}
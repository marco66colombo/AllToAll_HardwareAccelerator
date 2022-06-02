package hppsProject

import chisel3._
import chisel3.iotesters._
import chisel3.util._ 
import org.scalatest._
import hppsProject._


class UtilityTester(c: MyPriorityMux) extends PeekPokeTester(c) {

    step(1)

    poke(c.io.valid(0),false.B)
    poke(c.io.valid(1),false.B)
    poke(c.io.valid(2),false.B)
    poke(c.io.valid(3),false.B)

    poke(c.io.in_bits(0).data, 0.U)
    poke(c.io.in_bits(1).data, 0.U)
    poke(c.io.in_bits(2).data, 0.U)
    poke(c.io.in_bits(3).data, 0.U)

    expect(c.io.out_valid, false.B)
    expect(c.io.out_val.bits.data, 0.U)
    expect(c.io.out_val.selected, "b0000".U)
    

    step(1)

    poke(c.io.valid(0),false.B)
    poke(c.io.valid(1),true.B)
    poke(c.io.valid(2),false.B)
    poke(c.io.valid(3),false.B)

    poke(c.io.in_bits(0).data, 0.U)
    poke(c.io.in_bits(1).data, 24.U)
    poke(c.io.in_bits(2).data, 0.U)
    poke(c.io.in_bits(3).data, 0.U)

    expect(c.io.out_valid, true.B)
    expect(c.io.out_val.bits.data, 24.U)
    expect(c.io.out_val.selected, "b0010".U)

    step(1)

    poke(c.io.valid(0),true.B)
    poke(c.io.valid(1),false.B)
    poke(c.io.valid(2),false.B)
    poke(c.io.valid(3),false.B)

    poke(c.io.in_bits(0).data, 35.U)
    poke(c.io.in_bits(1).data, 0.U)
    poke(c.io.in_bits(2).data, 0.U)
    poke(c.io.in_bits(3).data, 0.U)

    expect(c.io.out_valid, true.B)
    expect(c.io.out_val.bits.data, 35.U)
    expect(c.io.out_val.selected, "b0001".U)

    step(1)

    poke(c.io.valid(0),false.B)
    poke(c.io.valid(1),false.B)
    poke(c.io.valid(2),true.B)
    poke(c.io.valid(3),true.B)

    poke(c.io.in_bits(0).data, 0.U)
    poke(c.io.in_bits(1).data, 0.U)
    poke(c.io.in_bits(2).data, 15.U)
    poke(c.io.in_bits(3).data, 0.U)

    expect(c.io.out_valid, true.B)
    expect(c.io.out_val.bits.data, 15.U)
    expect(c.io.out_val.selected, "b0100".U)

    step(1)

    poke(c.io.valid(0),true.B)
    poke(c.io.valid(1),true.B)
    poke(c.io.valid(2),true.B)
    poke(c.io.valid(3),true.B)

    poke(c.io.in_bits(0).data, 12.U)
    poke(c.io.in_bits(1).data, 0.U)
    poke(c.io.in_bits(2).data, 0.U)
    poke(c.io.in_bits(3).data, 0.U)

    expect(c.io.out_valid, true.B)
    expect(c.io.out_val.bits.data, 12.U)
    expect(c.io.out_val.selected, "b0001".U)
    
    step(1)

    poke(c.io.valid(0),false.B)
    poke(c.io.valid(1),false.B)
    poke(c.io.valid(2),false.B)
    poke(c.io.valid(3),true.B)

    poke(c.io.in_bits(0).data, 0.U)
    poke(c.io.in_bits(1).data, 0.U)
    poke(c.io.in_bits(2).data, 0.U)
    poke(c.io.in_bits(3).data, 12.U)

    expect(c.io.out_valid, true.B)
    expect(c.io.out_val.bits.data, 12.U)
    expect(c.io.out_val.selected, "b1000".U)


}





class UtilityTest extends ChiselFlatSpec {

  val testerArgs = Array("")

  behavior of "utility"
  it should "mux correctly" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new MyPriorityMux(3)) {
      c => new UtilityTester(c)
    } should be (true)
  }


}


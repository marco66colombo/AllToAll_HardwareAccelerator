package hppsProject

import chisel3._
import chisel3.iotesters._
import chisel3.util._ 
import org.scalatest._
import hppsProject._




//idle -> load -> no cmd -> no cmd
class IndexCalculatorTester(c: IndexCalculator) extends PeekPokeTester(c) {


    poke(c.io.reset, true.B)
    poke(c.io.enable, true.B)

    step(1)

    expect(c.io.index, 0.U)
    expect(c.io.last_index, false.B)

    poke(c.io.reset, false.B)
    poke(c.io.enable, false.B)
    
    step(1)
    step(1)

    expect(c.io.index, 0.U)
    expect(c.io.last_index, false.B)

    poke(c.io.reset, false.B)
    poke(c.io.enable, true.B)

    step(1)

    expect(c.io.index, 1.U)
    expect(c.io.last_index, false.B)
    
    step(1)

    expect(c.io.index, 2.U)
    expect(c.io.last_index, false.B)

    step(1)

    expect(c.io.index, 3.U)
    expect(c.io.last_index, true.B)

    poke(c.io.reset, true.B)

    step(1)

    expect(c.io.index, 0.U)
    expect(c.io.last_index, false.B)

}





class IndexCalculatorTest extends ChiselFlatSpec {

  val testerArgs = Array("")

  behavior of "indexCalculator"
  it should "resetAndCount" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new IndexCalculator(3,8)) {
      c => new IndexCalculatorTester(c)
    } should be (true)
  }


}
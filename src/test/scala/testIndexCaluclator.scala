package hppsProject

import chisel3._
import chisel3.iotesters._
import chisel3.util._ 
import org.scalatest._
import hppsProject._


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


class IndexCalculatorV1Tester(c: IndexCalculatorV1) extends PeekPokeTester(c) {


    poke(c.io.reset, true.B)
    poke(c.io.enable, true.B)
    poke(c.io.dim_N, 1.U)

    step(1)

    expect(c.io.index0, 0.U)
    expect(c.io.index1, 1.U)
    expect(c.io.index2, 2.U)
    expect(c.io.index3, 3.U)

    expect(c.io.valid0, true.B)
    expect(c.io.valid1, true.B)
    expect(c.io.valid2, true.B)
    expect(c.io.valid3, true.B)

    expect(c.io.x_dest_0, 0.U)
    expect(c.io.x_dest_1, 1.U)
    expect(c.io.x_dest_2, 2.U)
    expect(c.io.x_dest_3, 0.U)

    expect(c.io.y_dest_0, 0.U)
    expect(c.io.y_dest_1, 0.U)
    expect(c.io.y_dest_2, 0.U)
    expect(c.io.y_dest_3, 1.U)

    expect(c.io.pos_0, 0.U)
    expect(c.io.pos_1, 0.U)
    expect(c.io.pos_2, 0.U)
    expect(c.io.pos_3, 0.U)

    expect(c.io.last_iteration, false.B)

    poke(c.io.reset, false.B)
    poke(c.io.enable, true.B)

    step(1)

    expect(c.io.index0, 4.U)
    expect(c.io.index1, 5.U)
    expect(c.io.index2, 6.U)
    expect(c.io.index3, 7.U)

    expect(c.io.valid0, true.B)
    expect(c.io.valid1, true.B)
    expect(c.io.valid2, true.B)
    expect(c.io.valid3, true.B)

    expect(c.io.x_dest_0, 1.U)
    expect(c.io.x_dest_1, 2.U)
    expect(c.io.x_dest_2, 0.U)
    expect(c.io.x_dest_3, 1.U)

    expect(c.io.y_dest_0, 1.U)
    expect(c.io.y_dest_1, 1.U)
    expect(c.io.y_dest_2, 2.U)
    expect(c.io.y_dest_3, 2.U)

    expect(c.io.pos_0, 0.U)
    expect(c.io.pos_1, 0.U)
    expect(c.io.pos_2, 0.U)
    expect(c.io.pos_3, 0.U)

    expect(c.io.last_iteration, false.B)

    poke(c.io.reset, false.B)
    poke(c.io.enable, true.B)

    step(1)

    expect(c.io.index0, 8.U)
    expect(c.io.index1, 9.U)
    expect(c.io.index2, 10.U)
    expect(c.io.index3, 11.U)

    expect(c.io.valid0, true.B)
    expect(c.io.valid1, false.B)
    expect(c.io.valid2, false.B)
    expect(c.io.valid3, false.B)

    expect(c.io.x_dest_0, 2.U)
   
    expect(c.io.y_dest_0, 2.U)
    

    expect(c.io.pos_0, 0.U)
    expect(c.io.pos_1, 0.U)
    expect(c.io.pos_2, 0.U)
    expect(c.io.pos_3, 0.U)

    expect(c.io.last_iteration, false.B)

    poke(c.io.reset, false.B)
    poke(c.io.enable, true.B)

    step(1)

    expect(c.io.last_iteration, true.B)



}

class IndexCalculatorV1N2(c: IndexCalculatorV1) extends PeekPokeTester(c) {


    poke(c.io.reset, true.B)
    poke(c.io.enable, true.B)
    poke(c.io.dim_N, 2.U)

    step(1)

    expect(c.io.index0, 0.U)
    expect(c.io.index1, 2.U)
    expect(c.io.index2, 4.U)
    expect(c.io.index3, 6.U)

    expect(c.io.valid0, true.B)
    expect(c.io.valid1, true.B)
    expect(c.io.valid2, true.B)
    expect(c.io.valid3, true.B)

    expect(c.io.x_dest_0, 0.U)
    expect(c.io.x_dest_1, 1.U)
    expect(c.io.x_dest_2, 2.U)
    expect(c.io.x_dest_3, 0.U)

    expect(c.io.y_dest_0, 0.U)
    expect(c.io.y_dest_1, 0.U)
    expect(c.io.y_dest_2, 0.U)
    expect(c.io.y_dest_3, 1.U)

    expect(c.io.pos_0, 0.U)
    expect(c.io.pos_1, 0.U)
    expect(c.io.pos_2, 0.U)
    expect(c.io.pos_3, 0.U)

    expect(c.io.last_iteration, false.B)

    poke(c.io.reset, false.B)
    poke(c.io.enable, true.B)

    step(1)

    expect(c.io.index0, 8.U)
    expect(c.io.index1, 10.U)
    expect(c.io.index2, 12.U)
    expect(c.io.index3, 14.U)

    expect(c.io.valid0, true.B)
    expect(c.io.valid1, true.B)
    expect(c.io.valid2, true.B)
    expect(c.io.valid3, true.B)

    expect(c.io.x_dest_0, 1.U)
    expect(c.io.x_dest_1, 2.U)
    expect(c.io.x_dest_2, 0.U)
    expect(c.io.x_dest_3, 1.U)

    expect(c.io.y_dest_0, 1.U)
    expect(c.io.y_dest_1, 1.U)
    expect(c.io.y_dest_2, 2.U)
    expect(c.io.y_dest_3, 2.U)

    expect(c.io.pos_0, 0.U)
    expect(c.io.pos_1, 0.U)
    expect(c.io.pos_2, 0.U)
    expect(c.io.pos_3, 0.U)

    expect(c.io.last_iteration, false.B)

    poke(c.io.reset, false.B)
    poke(c.io.enable, true.B)

    step(1)

    expect(c.io.index0, 16.U)
    
    expect(c.io.valid0, true.B)
    expect(c.io.valid1, false.B)
    expect(c.io.valid2, false.B)
    expect(c.io.valid3, false.B)

    expect(c.io.x_dest_0, 2.U)
    
    expect(c.io.y_dest_0, 2.U)
    
    expect(c.io.pos_0, 0.U)

    expect(c.io.last_iteration, false.B)

    poke(c.io.reset, false.B)
    poke(c.io.enable, true.B)

    step(1)

    expect(c.io.index0, 1.U)
    expect(c.io.index1, 3.U)
    expect(c.io.index2, 5.U)
    expect(c.io.index3, 7.U)

    expect(c.io.valid0, true.B)
    expect(c.io.valid1, true.B)
    expect(c.io.valid2, true.B)
    expect(c.io.valid3, true.B)

    expect(c.io.x_dest_0, 0.U)
    expect(c.io.x_dest_1, 1.U)
    expect(c.io.x_dest_2, 2.U)
    expect(c.io.x_dest_3, 0.U)

    expect(c.io.y_dest_0, 0.U)
    expect(c.io.y_dest_1, 0.U)
    expect(c.io.y_dest_2, 0.U)
    expect(c.io.y_dest_3, 1.U)

    expect(c.io.pos_0, 1.U)
    expect(c.io.pos_1, 1.U)
    expect(c.io.pos_2, 1.U)
    expect(c.io.pos_3, 1.U)

    expect(c.io.last_iteration, false.B)

    step(1)

    expect(c.io.index0, 9.U)
    expect(c.io.index1, 11.U)
    expect(c.io.index2, 13.U)
    expect(c.io.index3, 15.U)

    expect(c.io.valid0, true.B)
    expect(c.io.valid1, true.B)
    expect(c.io.valid2, true.B)
    expect(c.io.valid3, true.B)

     expect(c.io.x_dest_0, 1.U)
    expect(c.io.x_dest_1, 2.U)
    expect(c.io.x_dest_2, 0.U)
    expect(c.io.x_dest_3, 1.U)

    expect(c.io.y_dest_0, 1.U)
    expect(c.io.y_dest_1, 1.U)
    expect(c.io.y_dest_2, 2.U)
    expect(c.io.y_dest_3, 2.U)

    expect(c.io.pos_0, 1.U)
    expect(c.io.pos_1, 1.U)
    expect(c.io.pos_2, 1.U)
    expect(c.io.pos_3, 1.U)

    expect(c.io.last_iteration, false.B)

    poke(c.io.reset, false.B)
    poke(c.io.enable, true.B)




    step(1)

    expect(c.io.index0, 17.U)

    expect(c.io.valid0, true.B)
    expect(c.io.valid1, false.B)
    expect(c.io.valid2, false.B)
    expect(c.io.valid3, false.B)

    expect(c.io.x_dest_0, 2.U)
   
    expect(c.io.y_dest_0, 2.U)
    

    expect(c.io.pos_0, 1.U)
    
    expect(c.io.last_iteration, false.B)

    poke(c.io.reset, false.B)
    poke(c.io.enable, true.B)

    step(1)

    expect(c.io.last_iteration, true.B)



}






class IndexCalculatorTest extends ChiselFlatSpec {

  val testerArgs = Array("")

  behavior of "indexCalculator"
  it should "resetAndCount" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new IndexCalculator(3,8)) {
      c => new IndexCalculatorTester(c)
    } should be (true)
  }


  behavior of "indexCalculatorV1"
  it should "resetAndCount" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new IndexCalculatorV1(3,9,3)) {
      c => new IndexCalculatorV1Tester(c)
    } should be (true)
  }

  behavior of "indexCalculatorV1_N2"
  it should "n2" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new IndexCalculatorV1(3,9,3)) {
      c => new IndexCalculatorV1N2(c)
    } should be (true)
  }


}
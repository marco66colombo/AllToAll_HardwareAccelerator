package hppsProject

import chisel3._
import chisel3.iotesters._
import chisel3.util._ 
import org.scalatest._
import hppsProject._


class DispatcherTesterQ1(c: Dispatcher) extends PeekPokeTester(c) {


        poke(c.io.x_PE, 5.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        poke(c.io.x_dest, 7.U)
        poke(c.io.y_dest, 7.U)

        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, true.B)
        expect(c.io.bottom, false.B)
        expect(c.io.this_PE, false.B)

        step(1)

        poke(c.io.x_PE, 5.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        poke(c.io.x_dest, 8.U)
        poke(c.io.y_dest, 6.U)

        expect(c.io.left, false.B)
        expect(c.io.right, true.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)
        expect(c.io.this_PE, false.B)

        step(1)

        poke(c.io.x_PE, 6.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        poke(c.io.x_dest, 8.U)
        poke(c.io.y_dest, 2.U)

        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, true.B)
        expect(c.io.this_PE, false.B)

        step(1)

        poke(c.io.x_PE, 6.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        poke(c.io.x_dest, 8.U)
        poke(c.io.y_dest, 3.U)

        expect(c.io.left, false.B)
        expect(c.io.right, true.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)
        expect(c.io.this_PE, false.B)


}


class DispatcherTesterQ2(c: Dispatcher) extends PeekPokeTester(c) {


        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 5.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        poke(c.io.x_dest, 1.U)
        poke(c.io.y_dest, 8.U)

        expect(c.io.left, true.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)
        expect(c.io.this_PE, false.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 5.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        poke(c.io.x_dest, 5.U)
        poke(c.io.y_dest, 8.U)

        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, true.B)
        expect(c.io.bottom, false.B)
        expect(c.io.this_PE, false.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 6.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        poke(c.io.x_dest, 3.U)
        poke(c.io.y_dest, 7.U)

        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, true.B)
        expect(c.io.bottom, false.B)
        expect(c.io.this_PE, false.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 6.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        poke(c.io.x_dest, 5.U)
        poke(c.io.y_dest, 6.U)

        expect(c.io.left, false.B)
        expect(c.io.right, true.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)
        expect(c.io.this_PE, false.B)


}

class DispatcherTesterQ3(c: Dispatcher) extends PeekPokeTester(c) {


        poke(c.io.x_PE, 3.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        poke(c.io.x_dest, 0.U)
        poke(c.io.y_dest, 0.U)

        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, true.B)
        expect(c.io.this_PE, false.B)

        step(1)

        poke(c.io.x_PE, 3.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        poke(c.io.x_dest, 0.U)
        poke(c.io.y_dest, 7.U)

        expect(c.io.left, true.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)
        expect(c.io.this_PE, false.B)

        step(1)

        poke(c.io.x_PE, 2.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        poke(c.io.x_dest, 0.U)
        poke(c.io.y_dest, 6.U)

        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, true.B)
        expect(c.io.bottom, false.B)
        expect(c.io.this_PE, false.B)

        step(1)

        poke(c.io.x_PE, 2.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        poke(c.io.x_dest, 0.U)
        poke(c.io.y_dest, 5.U)

        expect(c.io.left, true.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)
        expect(c.io.this_PE, false.B)


}


class DispatcherTesterQ4(c: Dispatcher) extends PeekPokeTester(c) {


        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 3.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        poke(c.io.x_dest, 7.U)
        poke(c.io.y_dest, 0.U)

        expect(c.io.left, false.B)
        expect(c.io.right, true.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)
        expect(c.io.this_PE, false.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 3.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        poke(c.io.x_dest, 3.U)
        poke(c.io.y_dest, 2.U)

        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, true.B)
        expect(c.io.this_PE, false.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 2.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        poke(c.io.x_dest, 2.U)
        poke(c.io.y_dest, 0.U)

        expect(c.io.left, true.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)
        expect(c.io.this_PE, false.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 2.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        poke(c.io.x_dest, 3.U)
        poke(c.io.y_dest, 0.U)

        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, true.B)
        expect(c.io.this_PE, false.B)


}

class DispatcherTesterThisPE(c: Dispatcher) extends PeekPokeTester(c) {


        poke(c.io.x_PE, 7.U)
        poke(c.io.y_PE, 7.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        poke(c.io.x_dest, 7.U)
        poke(c.io.y_dest, 7.U)

        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)
        expect(c.io.this_PE, true.B)

}

class DispatcherTesterNotOnAxis(c: Dispatcher) extends PeekPokeTester(c) {


        poke(c.io.x_PE, 5.U)
        poke(c.io.y_PE, 6.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        

        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, true.B)
        expect(c.io.bottom, false.B)
        expect(c.io.this_PE, false.B)

        step(1)

        poke(c.io.x_PE, 7.U)
        poke(c.io.y_PE, 7.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        

        expect(c.io.left, false.B)
        expect(c.io.right, true.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)
        expect(c.io.this_PE, false.B)

        step(1)

        poke(c.io.x_PE, 1.U)
        poke(c.io.y_PE, 5.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        

        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, true.B)
        expect(c.io.bottom, false.B)
        expect(c.io.this_PE, false.B)

        step(1)

        poke(c.io.x_PE, 2.U)
        poke(c.io.y_PE, 7.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        

        expect(c.io.left, true.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)
        expect(c.io.this_PE, false.B)

        step(1)

        poke(c.io.x_PE, 1.U)
        poke(c.io.y_PE, 3.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        

        expect(c.io.left, true.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)
        expect(c.io.this_PE, false.B)

        step(1)

        poke(c.io.x_PE, 3.U)
        poke(c.io.y_PE, 2.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        

        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, true.B)
        expect(c.io.this_PE, false.B)

        step(1)

        poke(c.io.x_PE, 5.U)
        poke(c.io.y_PE, 1.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        

        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, true.B)
        expect(c.io.this_PE, false.B)

        step(1)

        poke(c.io.x_PE, 6.U)
        poke(c.io.y_PE, 1.U)
        poke(c.io.x_0, 4.U)
        poke(c.io.y_0, 4.U)
        

        expect(c.io.left, false.B)
        expect(c.io.right, true.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)
        expect(c.io.this_PE, false.B)



}


class GenerationDispatcherTester(c: GenerationDispatcher) extends PeekPokeTester(c) {


        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_dest, 7.U)
        poke(c.io.y_dest, 7.U)
        
        expect(c.io.left, false.B)
        expect(c.io.right, true.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_dest, 5.U)
        poke(c.io.y_dest, 4.U)
        
        expect(c.io.left, false.B)
        expect(c.io.right, true.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_dest, 8.U)
        poke(c.io.y_dest, 1.U)
        
        expect(c.io.left, false.B)
        expect(c.io.right, true.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)

        step(1)
        
        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_dest, 8.U)
        poke(c.io.y_dest, 3.U)
        
        expect(c.io.left, false.B)
        expect(c.io.right, true.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_dest, 6.U)
        poke(c.io.y_dest, 7.U)
        
        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, true.B)
        expect(c.io.bottom, false.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_dest, 2.U)
        poke(c.io.y_dest, 6.U)
        
        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, true.B)
        expect(c.io.bottom, false.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_dest, 4.U)
        poke(c.io.y_dest, 8.U)
        
        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, true.B)
        expect(c.io.bottom, false.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_dest, 1.U)
        poke(c.io.y_dest, 6.U)
        
        expect(c.io.left, true.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_dest, 1.U)
        poke(c.io.y_dest, 1.U)
        
        expect(c.io.left, true.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_dest, 1.U)
        poke(c.io.y_dest, 3.U)
        
        expect(c.io.left, true.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_dest, 0.U)
        poke(c.io.y_dest, 4.U)
        
        expect(c.io.left, true.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_dest, 0.U)
        poke(c.io.y_dest, 0.U)
        
        expect(c.io.left, true.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, false.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_dest, 2.U)
        poke(c.io.y_dest, 0.U)
        
        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, true.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_dest, 3.U)
        poke(c.io.y_dest, 2.U)
        
        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, true.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_dest, 8.U)
        poke(c.io.y_dest, 0.U)
        
        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, true.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_dest, 4.U)
        poke(c.io.y_dest, 1.U)
        
        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, true.B)

        step(1)

        poke(c.io.x_PE, 4.U)
        poke(c.io.y_PE, 4.U)
        poke(c.io.x_dest, 5.U)
        poke(c.io.y_dest, 1.U)
        
        expect(c.io.left, false.B)
        expect(c.io.right, false.B)
        expect(c.io.up, false.B)
        expect(c.io.bottom, true.B)

}




class DispatcherTest extends ChiselFlatSpec {

  val testerArgs = Array("")

  behavior of "dispatcherQ1"
  it should "correctlyDispatch" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new Dispatcher(4)) {
      c => new DispatcherTesterQ1(c)
    } should be (true)
  }

  behavior of "dispatcherQ2"
  it should "correctlyDispatch" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new Dispatcher(4)) {
      c => new DispatcherTesterQ2(c)
    } should be (true)
  }

  behavior of "dispatcherQ3"
  it should "correctlyDispatch" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new Dispatcher(4)) {
      c => new DispatcherTesterQ3(c)
    } should be (true)
  }

  behavior of "dispatcherQ4"
  it should "correctlyDispatch" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new Dispatcher(4)) {
      c => new DispatcherTesterQ4(c)
    } should be (true)
  }

  behavior of "dispatcherThisPE"
  it should "correctlyDispatch" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new Dispatcher(4)) {
      c => new DispatcherTesterThisPE(c)
    } should be (true)
  }

  behavior of "dispatcherNotOnAxis"
  it should "correctlyDispatch" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new Dispatcher(4)) {
      c => new DispatcherTesterNotOnAxis(c)
    } should be (true)
  }
  

  behavior of "GenerationDispatcher"
  it should "correctlyDispatchGeneratedData" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new GenerationDispatcher(4)) {
      c => new GenerationDispatcherTester(c)
    } should be (true)
  }

}
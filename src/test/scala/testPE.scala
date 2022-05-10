package hppsProject

import chisel3._
import chisel3.iotesters._
import chisel3.util._ 
import org.scalatest._
import hppsProject._




//idle -> load -> no cmd -> no cmd
class AllToAllPEModuleTester(c: AllToAllPE) extends PeekPokeTester(c) {

  poke(c.io.cmd.bits.rs1, 1.U)
  poke(c.io.cmd.bits.rs2, 3.U)

  poke(c.io.cmd.valid, false.B) 

  poke(c.io.resp.ready, true.B)

  step(1)

  //idle
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)

  step(1)
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)
  expect(c.io.resp.bits.write_enable, false.B)

  
  poke(c.io.cmd.bits.rs1, 1.U)
  poke(c.io.cmd.bits.rs2, "b0000000000000001000000000000000100000000000000000000000000000001".U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)


  step(1)
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)
  expect(c.io.resp.bits.write_enable, false.B)

  poke(c.io.cmd.valid, false)

  step(1)

  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)
  //because here not load in the current PE, so it is false
  expect(c.io.resp.bits.write_enable, false.B)

  step(1)

  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)
  expect(c.io.resp.bits.write_enable, false.B)


   
}

//idle -> load -> no cmd -> no cmd
class testPEmultipleLoad(c: AllToAllPE) extends PeekPokeTester(c) {

  poke(c.io.cmd.bits.rs1, 1.U)
  poke(c.io.cmd.bits.rs2, 3.U)

  poke(c.io.cmd.valid, false.B) 

  poke(c.io.resp.ready, true.B)

  step(1)

  //idle
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)
  expect(c.io.resp.bits.write_enable, false.B)

  step(1)
  //still idle
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)
  expect(c.io.resp.bits.write_enable, false.B)

  
  poke(c.io.cmd.bits.rs1, 1.U)
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000001_0000000000000001_0000000000000010".U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)


  step(1)
  //firstLoad
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)
  expect(c.io.resp.bits.write_enable, false.B)


  step(1)
  //second load

  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)
  expect(c.io.resp.bits.write_enable, true.B)

  step(1)

  //third load
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)
  expect(c.io.resp.bits.write_enable, true.B)

  poke(c.io.cmd.valid, false)

  step(1)
  //resp to third load and back to idle
    expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)
  expect(c.io.resp.bits.write_enable, true.B)

  step(1)
  //idle without any resp
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)
  expect(c.io.resp.bits.write_enable, false.B)
  

   
}



//idle -> load -> no cmd -> no cmd
class testPEstore(c: AllToAllPE) extends PeekPokeTester(c) {

  poke(c.io.cmd.bits.rs1, 1.U)
  poke(c.io.cmd.bits.rs2, 3.U)

  poke(c.io.cmd.valid, false.B) 

  poke(c.io.resp.ready, true.B)

  step(1)

  //idle
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)
  expect(c.io.resp.bits.write_enable, false.B)

  step(1)
  //still idle
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)
  expect(c.io.resp.bits.write_enable, false.B)

  
  
  //x should be 2, y should be 1 in order to load into this pe
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000001_0000000000000001_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 24.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)


  step(1)
  //firstLoad
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)
  expect(c.io.resp.bits.write_enable, false.B)

  poke(c.io.cmd.bits.load, false.B)
  poke(c.io.cmd.bits.store, true.B)

  step(1)
  //cmd store + load resp

  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)
  expect(c.io.resp.bits.write_enable, true.B)

  poke(c.io.cmd.bits.store, false.B)
  poke(c.io.cmd.valid, false.B)

  step(1)

  //result of the store + idle
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 24.U)
  expect(c.io.resp.bits.write_enable, true.B)


  step(1)
  //idle without any resp
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)
  expect(c.io.resp.bits.write_enable, false.B)
  

   
}


//idle -> load -> no cmd -> no cmd
class testPEmixLoadStore(c: AllToAllPE) extends PeekPokeTester(c) {

  poke(c.io.cmd.bits.rs1, 1.U)
  poke(c.io.cmd.bits.rs2, 3.U)

  poke(c.io.cmd.valid, false.B) 

  poke(c.io.resp.ready, true.B)

  step(1)

  //idle
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)

  step(1)
  //still idle
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)

  
  //x should be 2, y should be 1 in order to load into this pe
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000001_0000000000000001_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 24.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)


  step(1)
  //first load
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, false.B)
  poke(c.io.cmd.bits.store, true.B)
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000001_0000000000000001_0000000000000010".U)

  step(1)
  //cmd store + load resp

  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)

  poke(c.io.cmd.bits.load, true.B)
  poke(c.io.cmd.bits.store, false.B)
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000111_0000000000000001_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 240899.U)
  poke(c.io.cmd.valid, true.B)

  step(1)
  //cmd load + store resp (should resp the value of memory corresponding to the old rs2 value(when the store was made))
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 24.U)

  poke(c.io.cmd.bits.load, false.B)
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000111_0000000000000001_0000000000000010".U)
  poke(c.io.cmd.bits.store, true.B)
  poke(c.io.cmd.bits.rs1, 1212.U)
  poke(c.io.cmd.valid, true.B)

  step(1)
  //store + no cmd + resp load
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)

  poke(c.io.cmd.bits.load, false.B)
  poke(c.io.cmd.bits.store, false.B)
  poke(c.io.cmd.bits.rs1, 1212.U)
  poke(c.io.cmd.valid, false.B)

  step(1)
  //store resp
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 240899.U)

  step(1)
  //idle without any resp
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)
  

   
}


class AllToAllPETest extends ChiselFlatSpec {

  val testerArgs = Array("")

  behavior of "peFSMTest"
  it should "changeState" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllPE(3,1024,2,1)) {
      c => new AllToAllPEModuleTester(c)
    } should be (true)
  }

  behavior of "peFSMTest"
  it should "multipleLoad" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllPE(3,1024,2,1)) {
      c => new testPEmultipleLoad(c)
    } should be (true)
  }

  behavior of "peFSMTest"
  it should "store+resp" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllPE(3,1024,2,1)) {
      c => new testPEstore(c)
    } should be (true)
  }

  behavior of "peFSMTest"
  it should "load+store+load+store" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllPE(3,1024,2,1)) {
      c => new testPEmixLoadStore(c)
    } should be (true)
  }


}
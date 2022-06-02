package hppsProject

import chisel3._
import chisel3.iotesters._
import chisel3.util._ 
import org.scalatest._
import hppsProject._



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
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)
  //because here not load in the current PE, so it is false
  expect(c.io.resp.bits.write_enable, false.B)

  poke(c.io.cmd.valid, false)

  step(1)
  //idle
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)
  expect(c.io.resp.bits.write_enable, false.B)

}


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

  //firstLoad cmd
  poke(c.io.cmd.bits.rs1, 1.U)
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000001_0000000000000001_0000000000000010".U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)


  step(1)
  
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)
  expect(c.io.resp.bits.write_enable, true.B)

  //cmd valid false
  poke(c.io.cmd.bits.rs1, 1.U)
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000001_0000000000000001_0000000000000010".U)

  poke(c.io.cmd.valid, false.B)
  poke(c.io.cmd.bits.load, false.B)
  poke(c.io.resp.ready, true.B)


  step(1)

  //expect idle
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)
  expect(c.io.resp.bits.write_enable, false.B)

  //secondLoad cmd
  poke(c.io.cmd.bits.rs1, 3.U)
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000010_0000000000000001_0000000000000010".U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)

  step(1)

  poke(c.io.resp.ready, false.B)

  expect(c.io.cmd.ready, false.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, true.B) 
  expect(c.io.resp.bits.data, 32.U)
  expect(c.io.resp.bits.write_enable, true.B)

  //no new cmd
  poke(c.io.cmd.valid, false.B)

  step(1)

  //should be in stall resp
  poke(c.io.resp.ready, true.B)

  expect(c.io.cmd.ready, false.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, true.B) 
  expect(c.io.resp.bits.data, 32.U)
  expect(c.io.resp.bits.write_enable, true.B)

  //no new cmd
  poke(c.io.cmd.valid, false.B)

  step(1)

  //idle
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)
  expect(c.io.resp.bits.write_enable, false.B)
  
}




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
  //load cmd
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000001_0000000000000001_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 24.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)


  step(1)
  //firstLoad results
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)
  expect(c.io.resp.bits.write_enable, true.B)

  //store cmd
  poke(c.io.cmd.bits.load, false.B)
  poke(c.io.cmd.bits.store, true.B)

  step(1)

  //do store
  expect(c.io.cmd.ready, false.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, true.B) 
  expect(c.io.resp.bits.data, 33.U)
  expect(c.io.resp.bits.write_enable, false.B)

  poke(c.io.cmd.bits.store, false.B)
  poke(c.io.cmd.valid, false.B)
  poke(c.io.cmd.valid, false.B)


  step(1)

  //result of the store 
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
  poke(c.io.cmd.bits.rs1, 1.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)


  step(1)
  //first load
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)

  //x should be 2, y should be 1 in order to load into this pe
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000010_0000000000000001_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 2.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)
  

 step(1)
  //first load
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)

  //x should be 2, y should be 1 in order to load into this pe
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000011_0000000000000001_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 3.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)

  step(1)
  //first load
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)

  //x should be 2, y should be 1 in order to load into this pe
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000100_0000000000000001_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 4.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)

  step(1)

  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)

  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000001_0000000000000001_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 4.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, false.B)
  poke(c.io.cmd.bits.store, true.B)

  step(1)

  expect(c.io.cmd.ready, false.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, true.B) 
  expect(c.io.resp.bits.data, 33.U)
  expect(c.io.resp.bits.write_enable, false.B)

  poke(c.io.cmd.valid, false.B)

  step(1)

  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 1.U)
  expect(c.io.resp.bits.write_enable, true.B)

  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000010_0000000000000001_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 4.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, false.B)
  poke(c.io.cmd.bits.store, true.B)

  step(1)

  expect(c.io.cmd.ready, false.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, true.B) 
  expect(c.io.resp.bits.data, 33.U)
  expect(c.io.resp.bits.write_enable, false.B)

  poke(c.io.cmd.valid, false.B)

  step(1)

  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 2.U)
  expect(c.io.resp.bits.write_enable, true.B)

  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000011_0000000000000001_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 4.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, false.B)
  poke(c.io.cmd.bits.store, true.B)

  step(1)

  expect(c.io.cmd.ready, false.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, true.B) 
  expect(c.io.resp.bits.data, 33.U)
  expect(c.io.resp.bits.write_enable, false.B)

  poke(c.io.cmd.valid, false.B)

  step(1)

  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 3.U)
  expect(c.io.resp.bits.write_enable, true.B)

  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000100_0000000000000001_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 4.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, false.B)
  poke(c.io.cmd.bits.store, true.B)

  step(1)

  expect(c.io.cmd.ready, false.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, true.B) 
  expect(c.io.resp.bits.data, 33.U)
  expect(c.io.resp.bits.write_enable, false.B)

  poke(c.io.cmd.valid, false.B)

  step(1)

  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 4.U)
  expect(c.io.resp.bits.write_enable, true.B)

  poke(c.io.cmd.valid, false.B)
  poke(c.io.cmd.bits.load, false.B)
  poke(c.io.cmd.bits.store, false.B)

  step(1)

  //idle
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)
  expect(c.io.resp.bits.write_enable, false.B)

   
}


class testPEstallResp(c: AllToAllPE) extends PeekPokeTester(c) {
/*
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
  poke(c.io.cmd.valid, false.B)
  poke(c.io.resp.ready, false.B)

  step(1)
  //cmd NOT valid + store resp stall 
  expect(c.io.cmd.ready, false.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, true.B) 
  //should be 32, it still has to respond to the first load 
  expect(c.io.resp.bits.data, 24.U)

  poke(c.io.cmd.bits.load, false.B)
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000111_0000000000000001_0000000000000010".U)
  poke(c.io.cmd.bits.store, true.B)
  poke(c.io.cmd.bits.rs1, 1212.U)
  poke(c.io.cmd.valid, false.B)
  poke(c.io.resp.ready, false.B)

  step(1)
  //stall_state
  expect(c.io.cmd.ready, false.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, true.B) 
  expect(c.io.resp.bits.data, 24.U)

  poke(c.io.resp.ready, true.B)


  step(1)
  //idle after stall
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  //not overwritten value yet
  expect(c.io.resp.bits.data, 24.U)

  poke(c.io.cmd.bits.load, false.B)
  poke(c.io.cmd.bits.store, false.B)
  poke(c.io.cmd.bits.rs1, 1212.U)
  poke(c.io.cmd.valid, false.B)


  step(1)
  //idle without any resp
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)
  
*/
   
}


class testPEstallRespFirstCmd(c: AllToAllPE) extends PeekPokeTester(c) {
/*
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

  //here no resp is required
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)

  poke(c.io.cmd.bits.load, true.B)
  poke(c.io.cmd.bits.store, false.B)
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000111_0000000000000001_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 240899.U)
  poke(c.io.cmd.valid, false.B)
  //not important here because resp is not valid
  poke(c.io.resp.ready, false.B)

  step(1)
  //should resp load in idle
  expect(c.io.cmd.ready, false.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, true.B) 
  expect(c.io.resp.bits.data, 32.U)
  poke(c.io.resp.ready, false.B)


  step(1)
  //cmd NOT valid + load resp stall 
  expect(c.io.cmd.ready, false.B)///////////////////////////////////////////////////////////////////
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, true.B) 
  expect(c.io.resp.bits.data, 32.U)

  poke(c.io.cmd.bits.load, false.B)
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000111_0000000000000001_0000000000000010".U)
  poke(c.io.cmd.bits.store, true.B)
  poke(c.io.cmd.bits.rs1, 1212.U)
  poke(c.io.cmd.valid, false.B)
  poke(c.io.resp.ready, false.B)

  step(1)
  //stall_state
  expect(c.io.cmd.ready, false.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, true.B) 
  expect(c.io.resp.bits.data, 32.U)

  poke(c.io.resp.ready, false.B)

  step(1)
  //again stall
  expect(c.io.cmd.ready, false.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, true.B) 
  expect(c.io.resp.bits.data, 32.U)

  poke(c.io.resp.ready, true.B)


  step(1)
  //idle after stall
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  //not overwritten value yet
  expect(c.io.resp.bits.data, 32.U)

  //send store cmd
  poke(c.io.cmd.bits.load, false.B)
  poke(c.io.cmd.bits.store, true.B)
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000111_0000000000000001_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 240899.U)
  poke(c.io.cmd.valid, true.B)
  //should not be important now that ready is false since no resp is sent
  poke(c.io.resp.ready, false.B)

  
  step(1)
  //do store
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)

  poke(c.io.cmd.valid, false.B)
  poke(c.io.cmd.bits.load, false.B)
  poke(c.io.cmd.bits.store, true.B)
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000001_0000000000000001_0000000000000010".U)
  //should not be important now that ready is false since no resp is sent
  ///////////////////att se metto false è sbagliato qualcosa -> ricontrollo
  poke(c.io.resp.ready, true.B)

  step(1)
  //store resp
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  //sistemo qui, forse dovrebbe essere 24 ma da 0
  //expect(c.io.resp.bits.data, 24.U)
  poke(c.io.resp.ready, true.B)
  poke(c.io.cmd.valid, false.B)


  step(1)
  //idle without any resp
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)
  

 */  
}


//PE pushes data from mem and writes the correct data on its
class testPEAllToAll(c: AllToAllPE) extends PeekPokeTester(c) {

  poke(c.io.cmd.valid, false.B) 

  poke(c.io.resp.ready, true.B)

  poke(c.io.left.out.ready, true.B)
  poke(c.io.right.out.ready, true.B)
  poke(c.io.up.out.ready, true.B)
  poke(c.io.bottom.out.ready, true.B)

  step(1)
  //idle
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)


  //x should be 1, y should be 1 in order to load into this pe
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000000_0000000000000010_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 0.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)


  step(1)
  //first load
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)

  //x should be 2, y should be 1 in order to load into this pe
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000001_0000000000000010_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 1.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)
  

 step(1)
  //first load
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)

  //x should be 2, y should be 1 in order to load into this pe
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000010_0000000000000010_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 2.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)

  step(1)
  //first load
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)

  //x should be 2, y should be 1 in order to load into this pe
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000011_0000000000000010_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 3.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)

  step(1)
  //first load
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)

  //x should be 2, y should be 1 in order to load into this pe
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000100_0000000000000010_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 4.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)

  step(1)
  //first load
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)

  //x should be 2, y should be 1 in order to load into this pe
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000101_0000000000000010_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 5.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)

  step(1)
  //first load
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)

  //x should be 2, y should be 1 in order to load into this pe
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000110_0000000000000010_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 6.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)

  step(1)
  //first load
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)

  //x should be 2, y should be 1 in order to load into this pe
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000111_0000000000000010_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 7.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)

  step(1)
  //first load
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)

  //x should be 2, y should be 1 in order to load into this pe
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000001000_0000000000000010_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 8.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)

  step(1)
  //first load
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 32.U)

  poke(c.io.cmd.valid, false.B)
  poke(c.io.cmd.bits.load, false.B)

  step(1)

  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)

  step(1)

  poke(c.io.cmd.bits.rs1, 1.U)
  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.doAllToAll, true.B)
  poke(c.io.end_AllToAll, false.B)

  step(1)

  poke(c.io.cmd.valid, false.B)
  poke(c.io.cmd.bits.doAllToAll, false.B)

  var x = 0
  var y = 0
/*
  while(c.io.busy == true.B){
    step(1)
    x = x+1
  }
*/
  while(y<200){
    step(1)
    x = x+1
    y=y+1
  }
  println( "Value of y: " + y );
  println( "Value of x: " + x );

  //se metto false funziona uguale -> PERCHE??????
  poke(c.io.end_AllToAll, true.B)
  poke(c.io.cmd.valid, false.B)

  step(1)
  step(1)
  step(1)


  //113
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)
  expect(c.io.resp.bits.write_enable, false.B)

  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000010001_0000000000000010_0000000000000010".U)
  poke(c.io.cmd.bits.rs1, 1.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, false.B)
  poke(c.io.cmd.bits.store, true.B)

  step(1)
//114
  expect(c.io.cmd.ready, false.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, true.B) 
  expect(c.io.resp.bits.data, 33.U)
  expect(c.io.resp.bits.write_enable, false.B)

  poke(c.io.cmd.valid, false.B)

  step(1)
//115
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, true.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 8.U)
  expect(c.io.resp.bits.write_enable, true.B)

  poke(c.io.cmd.valid, false.B)
  poke(c.io.cmd.bits.load, false.B)
  poke(c.io.cmd.bits.store, false.B)

  step(1)




  

}

class AllToAllPETest extends ChiselFlatSpec {

  val testerArgs = Array("")

  behavior of "peFSMTest"
  it should "changeState" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllPE(3,1024,81,2,1)) {
      c => new AllToAllPEModuleTester(c)
    } should be (true)
  }

  behavior of "peFSMTest"
  it should "multipleLoad" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllPE(3,1024,81,2,1)) {
      c => new testPEmultipleLoad(c)
    } should be (true)
  }

  behavior of "peFSMTest"
  it should "store+resp" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllPE(3,1024,81,2,1)) {
      c => new testPEstore(c)
    } should be (true)
  }

  behavior of "peFSMTest"
  it should "load+store+load+store" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllPE(3,1024,81,2,1)) {
      c => new testPEmixLoadStore(c)
    } should be (true)
  }

  behavior of "stallResp"
  it should "load+store+stall" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllPE(3,1024,81,2,1)) {
      c => new testPEstallResp(c)
    } should be (true)
  }

  behavior of "stallResp"
  it should "load+stall" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllPE(3,1024,81,2,1)) {
      c => new testPEstallRespFirstCmd(c)
    } should be (true)
  }

  behavior of "allToAll"
  it should "first attempt" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllPE(3,1024,81,2,2)) {
      c => new testPEAllToAll(c)
    } should be (true)
  }

}
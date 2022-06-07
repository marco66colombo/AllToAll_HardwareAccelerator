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


//PE pushes data from mem and writes the correct data on its
class testPEAllToAll(c: AllToAllPE) extends PeekPokeTester(c) {

  poke(c.io.cmd.valid, false.B) 

  poke(c.io.resp.ready, true.B)

  poke(c.io.left.out.ready, false.B)
  poke(c.io.right.out.ready, false.B)
  poke(c.io.up.out.ready, false.B)
  poke(c.io.bottom.out.ready, false.B)

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

  step(10)

  expect(c.io.left.out.valid, true.B)
  expect(c.io.left.out.bits.x_0, 2.U)
  expect(c.io.left.out.bits.y_0, 2.U)
  expect(c.io.left.out.bits.x_dest, 0.U)
  expect(c.io.left.out.bits.y_dest, 0.U)
  expect(c.io.left.out.bits.data, 0.U)

  expect(c.io.bottom.out.valid, true.B)
  expect(c.io.bottom.out.bits.x_0, 2.U)
  expect(c.io.bottom.out.bits.y_0, 2.U)
  expect(c.io.bottom.out.bits.x_dest, 1.U)
  expect(c.io.bottom.out.bits.y_dest, 0.U)
  expect(c.io.bottom.out.bits.data, 1.U)


  poke(c.io.bottom.out.ready, true.B)

  step(1)

  expect(c.io.bottom.out.valid, true.B)
  expect(c.io.bottom.out.bits.x_0, 2.U)
  expect(c.io.bottom.out.bits.y_0, 2.U)
  expect(c.io.bottom.out.bits.x_dest, 2.U)
  expect(c.io.bottom.out.bits.y_dest, 0.U)
  expect(c.io.bottom.out.bits.data, 2.U)

  poke(c.io.bottom.out.ready, false.B)

  step(1)

  poke(c.io.end_AllToAll, true.B)
  poke(c.io.cmd.valid, false.B)

  step(1)
  step(1)
  step(1)

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
  expect(c.io.resp.bits.data, 8.U)
  expect(c.io.resp.bits.write_enable, true.B)

  poke(c.io.cmd.valid, false.B)
  poke(c.io.cmd.bits.load, false.B)
  poke(c.io.cmd.bits.store, false.B)

  step(1)


}



//PE receives a message from a queue and dest is index of pe -> saves message
class testPEataGetAndSave(c: AllToAllPE) extends PeekPokeTester(c) {

  poke(c.io.cmd.valid, false.B) 

  poke(c.io.resp.ready, true.B)

  poke(c.io.left.out.ready, false.B)
  poke(c.io.right.out.ready, false.B)
  poke(c.io.up.out.ready, false.B)
  poke(c.io.bottom.out.ready, false.B)

  
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

  step(1)

  poke(c.io.left.in.valid, true.B)
  poke(c.io.left.in.bits.x_0, 0.U)
  poke(c.io.left.in.bits.y_0, 0.U)
  poke(c.io.left.in.bits.x_dest, 1.U)
  poke(c.io.left.in.bits.y_dest, 1.U)
  poke(c.io.left.in.bits.data, 59.U)

  step(1)

  poke(c.io.left.in.valid, false.B)

  step(10)
  
  poke(c.io.end_AllToAll, true.B)
  poke(c.io.cmd.valid, false.B)

  step(1)
  step(1)
  step(1)

  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)
  expect(c.io.resp.bits.write_enable, false.B)

  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000001001_0000000000000001_0000000000000001".U)
  poke(c.io.cmd.bits.rs1, 1.U)

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
  expect(c.io.resp.bits.data, 59.U)
  println( "non ci credo" );
  expect(c.io.resp.bits.write_enable, true.B)

  poke(c.io.cmd.valid, false.B)
  poke(c.io.cmd.bits.load, false.B)
  poke(c.io.cmd.bits.store, false.B)

  step(1)


}


//PE receives a message from a queue and forwards it
class testPEataGetAndForward(c: AllToAllPE) extends PeekPokeTester(c) {

  poke(c.io.cmd.valid, false.B) 

  poke(c.io.resp.ready, true.B)

  poke(c.io.left.out.ready, false.B)
  poke(c.io.right.out.ready, false.B)
  poke(c.io.up.out.ready, false.B)
  poke(c.io.bottom.out.ready, false.B)

  
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

  step(1)

  poke(c.io.left.in.valid, true.B)
  poke(c.io.left.in.bits.x_0, 1.U)
  poke(c.io.left.in.bits.y_0, 1.U)
  poke(c.io.left.in.bits.x_dest, 2.U)
  poke(c.io.left.in.bits.y_dest, 2.U)
  poke(c.io.left.in.bits.data, 58.U)

  step(1)

  poke(c.io.left.in.valid, false.B)

  step(20)

  expect(c.io.up.out.valid, true.B)
  expect(c.io.up.out.bits.x_0, 1.U)
  expect(c.io.up.out.bits.y_0, 1.U)
  expect(c.io.up.out.bits.x_dest, 2.U)
  expect(c.io.up.out.bits.y_dest, 2.U)
  expect(c.io.up.out.bits.data, 58.U)

  println("proviamo..");

  step(1)


}

//PE receives a message from a queue and forwards it
class testPEataGetAndForward2(c: AllToAllPE) extends PeekPokeTester(c) {

  poke(c.io.cmd.valid, false.B) 

  poke(c.io.resp.ready, true.B)

  poke(c.io.left.out.ready, false.B)
  poke(c.io.right.out.ready, false.B)
  poke(c.io.up.out.ready, false.B)
  poke(c.io.bottom.out.ready, false.B)

  
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


  step(1)

  poke(c.io.left.in.valid, false.B)

  step(20)

  //flush the output queues that are filled with data pushed from memory
  poke(c.io.left.out.ready, true.B)
  poke(c.io.right.out.ready, true.B)
  poke(c.io.up.out.ready, true.B)
  poke(c.io.bottom.out.ready, true.B)

  step(10)
  //stop flushing queues, hold results from now
  poke(c.io.left.out.ready, false.B)
  poke(c.io.right.out.ready, false.B)
  poke(c.io.up.out.ready, false.B)
  poke(c.io.bottom.out.ready, false.B)

  step(1)

  poke(c.io.left.in.valid, true.B)
  poke(c.io.left.in.bits.x_0, 0.U)
  poke(c.io.left.in.bits.y_0, 0.U)
  poke(c.io.left.in.bits.x_dest, 2.U)
  poke(c.io.left.in.bits.y_dest, 2.U)
  poke(c.io.left.in.bits.data, 58.U)

  step(1)

  poke(c.io.left.in.valid, true.B)
  poke(c.io.left.in.bits.x_0, 0.U)
  poke(c.io.left.in.bits.y_0, 0.U)
  poke(c.io.left.in.bits.x_dest, 2.U)
  poke(c.io.left.in.bits.y_dest, 0.U)
  poke(c.io.left.in.bits.data, 59.U)

  step(20)

  expect(c.io.up.out.valid, true.B)
  expect(c.io.up.out.bits.x_0, 0.U)
  expect(c.io.up.out.bits.y_0, 0.U)
  expect(c.io.up.out.bits.x_dest, 2.U)
  expect(c.io.up.out.bits.y_dest, 2.U)
  expect(c.io.up.out.bits.data, 58.U)

  expect(c.io.right.out.valid, true.B)
  expect(c.io.right.out.bits.x_0, 0.U)
  expect(c.io.right.out.bits.y_0, 0.U)
  expect(c.io.right.out.bits.x_dest, 2.U)
  expect(c.io.right.out.bits.y_dest, 0.U)
  expect(c.io.right.out.bits.data, 59.U)

  println("proviamo2..");

  step(1)


}



//PE receives a message from a queue and forwards it
class testPEataGetAndForward3(c: AllToAllPE) extends PeekPokeTester(c) {

  poke(c.io.cmd.valid, false.B) 

  poke(c.io.resp.ready, true.B)

  poke(c.io.left.out.ready, false.B)
  poke(c.io.right.out.ready, false.B)
  poke(c.io.up.out.ready, false.B)
  poke(c.io.bottom.out.ready, false.B)

  
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


  step(1)

  poke(c.io.left.in.valid, false.B)

  step(20)

  //flush the output queues that are filled with data pushed from memory
  poke(c.io.left.out.ready, true.B)
  poke(c.io.right.out.ready, true.B)
  poke(c.io.up.out.ready, true.B)
  poke(c.io.bottom.out.ready, true.B)

  step(10)
  //stop flushing queues, hold results from now
  poke(c.io.left.out.ready, false.B)
  poke(c.io.right.out.ready, false.B)
  poke(c.io.up.out.ready, false.B)
  poke(c.io.bottom.out.ready, false.B)

  step(1)

  poke(c.io.up.in.valid, true.B)
  poke(c.io.up.in.bits.x_0, 2.U)
  poke(c.io.up.in.bits.y_0, 2.U)
  poke(c.io.up.in.bits.x_dest, 2.U)
  poke(c.io.up.in.bits.y_dest, 0.U)
  poke(c.io.up.in.bits.data, 58.U)

  

  step(20)

  expect(c.io.bottom.out.valid, true.B)
  expect(c.io.bottom.out.bits.x_0, 2.U)
  expect(c.io.bottom.out.bits.y_0, 2.U)
  expect(c.io.bottom.out.bits.x_dest, 2.U)
  expect(c.io.bottom.out.bits.y_dest, 0.U)
  expect(c.io.bottom.out.bits.data, 58.U)

  

  println("proviamo 15..");

  step(1)


}

//PE pushes data from mem to output
class testPEataCreateAndForward(c: AllToAllPE) extends PeekPokeTester(c) {

  poke(c.io.cmd.valid, false.B) 

  poke(c.io.resp.ready, true.B)

  poke(c.io.left.out.ready, false.B)
  poke(c.io.right.out.ready, false.B)
  poke(c.io.up.out.ready, false.B)
  poke(c.io.bottom.out.ready, false.B)

  step(1)
  //idle
  expect(c.io.cmd.ready, true.B)
  expect(c.io.resp.valid, false.B)
  expect(c.io.busy, false.B) 
  expect(c.io.resp.bits.data, 0.U)


  //x should be 1, y should be 1 in order to load into this pe
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000000_0000000000000001_0000000000000001".U)
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
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000001_0000000000000001_0000000000000001".U)
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
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000101_0000000000000001_0000000000000001".U)
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
  poke(c.io.cmd.bits.rs2, "b00000000000000000000000000000110_0000000000000001_0000000000000001".U)
  poke(c.io.cmd.bits.rs1, 6.U)

  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.load, true.B)
  

  step(1)

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


  step(1)

  poke(c.io.left.in.valid, false.B)

  step(20)

  expect(c.io.left.out.valid, true.B)
  expect(c.io.left.out.bits.x_0, 1.U)
  expect(c.io.left.out.bits.y_0, 1.U)
  expect(c.io.left.out.bits.x_dest, 0.U)
  expect(c.io.left.out.bits.y_dest, 0.U)
  expect(c.io.left.out.bits.data, 0.U)

  expect(c.io.right.out.valid, true.B)
  expect(c.io.right.out.bits.x_0, 1.U)
  expect(c.io.right.out.bits.y_0, 1.U)
  expect(c.io.right.out.bits.x_dest, 2.U)
  expect(c.io.right.out.bits.y_dest, 1.U)
  expect(c.io.right.out.bits.data, 5.U)

  expect(c.io.up.out.valid, true.B)
  expect(c.io.up.out.bits.x_0, 1.U)
  expect(c.io.up.out.bits.y_0, 1.U)
  expect(c.io.up.out.bits.x_dest, 0.U)
  expect(c.io.up.out.bits.y_dest, 2.U)
  expect(c.io.up.out.bits.data, 6.U)

  expect(c.io.bottom.out.valid, true.B)
  expect(c.io.bottom.out.bits.x_0, 1.U)
  expect(c.io.bottom.out.bits.y_0, 1.U)
  expect(c.io.bottom.out.bits.x_dest, 1.U)
  expect(c.io.bottom.out.bits.y_dest, 0.U)
  expect(c.io.bottom.out.bits.data, 1.U)
  

  println("proviamo3..");

  step(1)


}


//PE pushes data from mem to output
class testPEataPushAll(c: AllToAllPE) extends PeekPokeTester(c) {

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

  step(1)

  poke(c.io.cmd.bits.rs1, 1.U)
  poke(c.io.cmd.valid, true.B)
  poke(c.io.cmd.bits.doAllToAll, true.B)
  poke(c.io.end_AllToAll, false.B)

  step(1)

  poke(c.io.cmd.valid, false.B)
  poke(c.io.cmd.bits.doAllToAll, false.B)

  var x = 0

  while(x<9){
    step(1)
    expect(c.io.busy, true.B)
    x+=1
  }
  println("Value of x: "+x)
  step(1)
  expect(c.io.busy, false.B)


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

  behavior of "allToAll1"
  it should "first attempt" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllPE(3,1024,81,2,2)) {
      c => new testPEAllToAll(c)
    } should be (true)
  }

  behavior of "allToAll_get_and_save"
  it should "get and save" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllPE(3,1024,81,1,1)) {
      c => new testPEataGetAndSave(c)
    } should be (true)
  }

  behavior of "allToAll_get_and_farward"
  it should "get and farward" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllPE(3,1024,81,2,1)) {
      c => new testPEataGetAndForward(c)
    } should be (true)
  }

  behavior of "allToAll_get_and_farward2"
  it should "get and farward" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllPE(3,1024,81,1,0)) {
      c => new testPEataGetAndForward2(c)
    } should be (true)
  }

  behavior of "allToAll_get_and_farward3"
  it should "get and farward" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllPE(3,1024,81,2,1)) {
      c => new testPEataGetAndForward3(c)
    } should be (true)
  }

  behavior of "allToAll_create_and_farward"
  it should "create and farward" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllPE(3,1024,81,1,1)) {
      c => new testPEataCreateAndForward(c)
    } should be (true)
  }

  behavior of "allToAll_push_all"
  it should "ata push all" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAllPE(3,1024,81,1,1)) {
      c => new testPEataPushAll(c)
    } should be (true)
  }


}
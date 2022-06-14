package hppsProject

import chisel3._
import chisel3.iotesters._
import chisel3.util._ 
import org.scalatest._
import hppsProject._



class AllToAll5() extends LazyRoCCModuleImpWrapper{
  
  val aTaModule = Module(new AllToAllModule(5,7000,128))

  //command input
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

  //interrupt output
  io.interrupt := aTaModule.io.interrupt
  io.busy := aTaModule.io.busy

  //exception input
  aTaModule.io.exception := io.exception


}



class testN5(c: AllToAll5) extends PeekPokeTester(c) {

  def x_coord(i: Int, n: Int): Int = (i%n)
  def y_coord(i: Int, n:Int): Int = (i/n)

  def doLoad(rs1 : Long, rs2: Long):Int = {

    poke(c.io.cmd.bits.rs1, rs1.U)
    poke(c.io.cmd.bits.rs2,  rs2.U)
    step(1) 
    0
  }

  def doStore(rs1 : Long, rs2: Long):Int = {
    poke(c.io.cmd.valid, true.B)
    poke(c.io.cmd.bits.rs2, rs2.U)
    step(1)
    poke(c.io.cmd.valid, false.B)
    step(1)
    expect(c.io.resp.bits.data, rs1.U)

    0
  }

  def testNumberCycles(n: Int, dim_N: Int):Int ={

      println("Start simulation\n");

      //var n = 3
      var p = n*n
      //var dim_N = 5
      var rs1, rs2, nPE, pos, index, indexMem,indexAfter, x_PE, y_PE : Long = 0
      var i,j,k : Long = 0
      
      poke(c.io.cmd.valid, false.B) 
      poke(c.io.resp.ready, true.B)
      step(1)

      poke(c.io.cmd.valid, true.B)
      poke(c.io.cmd.bits.inst.funct, "b0000001".U)
      poke(c.io.cmd.bits.inst.opcode, "b0001011".U)

      for(i<-0 until p){
          nPE = i
          for(j<-0 until p){
              for(k<-0 until dim_N){

                  pos = k
                  index = j*dim_N + k
                  rs1 = nPE << 48 | pos << 32 | index
                  x_PE = x_coord(i,n)
                  y_PE = y_coord(i,n)
                  indexMem = j*dim_N + k
                  rs2 = indexMem << 32 | y_PE << 16 | x_PE;
                  doLoad(rs1,rs2)
              }
          }
      }

      step(1)
      poke(c.io.cmd.bits.inst.funct, "b0000011".U)
      poke(c.io.cmd.bits.inst.opcode, "b0001011".U)
      poke(c.io.cmd.bits.rs1, dim_N.U)

      step(1)
      poke(c.io.cmd.valid, false.B)
      step(1)

      var x=1

      while(peek(c.io.resp.valid) == 0) {
        x = x+1
        step(1)
      }

      println("number of cycles for n = "+n+" dim_N = "+dim_N+"number of cycles = "+x)
      step(1)

      //idle
      expect(c.io.cmd.ready, true.B)
      expect(c.io.resp.valid, false.B)
      expect(c.io.resp.bits.data, 0.U)
      expect(c.io.interrupt, false.B)
      expect(c.io.busy, false.B) 
      step(1)
      println("before store")

      poke(c.io.cmd.bits.inst.funct, "b0000010".U)
      poke(c.io.cmd.bits.inst.opcode, "b0001011".U)
      
      for(i<-0 until p){
        for(j<-0 until p){
          for(k<-0 until dim_N){
            //populate rs2 with expected values after the AllToAll
            x_PE = x_coord(i,n);
            y_PE = y_coord(i,n);
            //result of AllToAll are stored p positions (N*N) -> different memory space between data before and after AllToAll
            indexMem = j*dim_N + k + p*dim_N;
            rs2 = indexMem << 32 | y_PE << 16 | x_PE;
      
            pos = k;
            index = j;
            indexAfter = i*dim_N + k;
            //load_value_rs1 = (uint64_t) mostSignificantWord << 32 | leastSignificantWord;
            rs1 = index << 48 | pos << 32 | indexAfter;
            
            doStore(rs1,rs2)
          }
        }
        
      }

      0
  }
 

  testNumberCycles(5,1)
  testNumberCycles(5,2)
  testNumberCycles(5,4)
  testNumberCycles(5,8)
  testNumberCycles(5,16)
  testNumberCycles(5,32)
  testNumberCycles(5,64)
  //testNumberCycles(5,128)

}






class AllToAllTest5 extends ChiselFlatSpec {

  val testerArgs = Array("")


  behavior of "test_n_5"
  it should "test_n_5" in {
    chisel3.iotesters.Driver.execute( testerArgs, () => new AllToAll5()) {
      c => new testN5(c)
    } should be (true)
  }



}
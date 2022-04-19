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


//IO interface for AllToAllController
class ControllerIO extends Bundle{

    //part of interface dedicated to communicate with processor
    val processor = new AcceleratorModuleIO
    
    //Flipped since all output of MeshIo here are input and vice versa
    //part of interface dedicated to communicate with AllToAllMesh
    val mesh = Flipped(new MeshIO)
}


//controller which manages interactions between AllTOAllModule and the AllToAllMesh instantiated in it
class AllToAllController extends Module{

  val io = IO(new ControllerIO())

  /*
    FSM 
    idle : controller ready to receive a request
    exchange: mesh of PE are exchanging data each other
    done_exchange: exchange between PE in mesh is terminated, notify the processor
  */

  val idle :: exchange :: done_exchange :: Nil = Enum(3)
  val state = RegInit(idle) 
  
  /*
    manage processor.resp.bits.rd (destination register)
    if idle just put in output the input value
    if not idle put in output the saved value
  */
  io.processor.resp.bits.rd := Mux( state === idle, io.processor.cmd.bits.inst.rd, rd_address)
  val rd_address = Reg(Bits(5.W))
  when(state === idle){
    rd_address := io.processor.cmd.bits.inst.rd
  }

  io.processor.cmd.ready := (state === idle)

  //io.rocc.resp.bits.data := io.resp.data
  //io.rocc.resp.valid := state === give_result


  val pcmd = io.processor.cmd
  val presp = io.processor.resp 

  val goto_excange = pcmd.valid
  //it should be set by the end of computation of the mesh
  val goto_done_exchange = true.B

  when(state === idle){
    //accelerator not busy -> free
    io.processor.busy := false.B 
    //ready to receive a command
    pcmd.ready := true.B 
    //response is not valid now
    presp.valid := false.B
    
    when(goto_excange){
      state := exchange
    }.otherwise{
      state := idle
    }
  }.elsewhen(state === exchange){
    //accelerator busy
    io.processor.busy := true.B 
    //not ready to receive a command
    pcmd.ready := false.B 
    //response is not valid now
    presp.valid := false.B

    when(goto_done_exchange){
        state := done_exchange
    }.otherwise{
        state := exchange
    }
  }.elsewhen(state === done_exchange){
    //accelerator busy
    io.processor.busy := true.B 
    //not ready to receive a command
    pcmd.ready := false.B
    //response is valid since computation has ended 
    presp.valid := true.B

    //always goto idle
    state := idle
  }.otherwise{ 
  //in this case there is an error
  // val error := true.B ?? makes sense?

    io.processor.busy := false.B 
    pcmd.ready := true.B 
    presp.valid := false.B 
    state := idle
  }

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

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
    val processor = new AcceleratorModuleIO()
    
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
  val idle :: action :: wait_action_resp :: action_resp :: load_state :: store_state :: store_resp :: stall_resp_state :: Nil = Enum(8)
  val state = RegInit(idle) 

  //reanaming signals names for simplicity
  val pcmd = io.processor.cmd
  val presp = io.processor.resp

  //save rd address when command is given
  val rd_address = Reg(Bits(5.W))

  //says whether the resp valid is true or not (if at the current cycle a response has to be sent)
  //val resp_signal = RegInit(Bool(),false.B)
  //true iff at that cycle accelerator have to respond and cannot (!presp.ready)
  val stall_resp = !presp.ready && io.mesh.resp.valid
  

  //interrupt always false up to this version
  io.processor.interrupt := false.B
  
  //set values of rs1,rs2 of mesh command
  io.mesh.cmd.bits.rs1 := pcmd.bits.rs1
  io.mesh.cmd.bits.rs2 := pcmd.bits.rs2

  //response data are given by the mesh
  presp.bits.data := io.mesh.resp.bits.data

 
  /*
    transitions values
  */
  //action opcode is "b0101011"
  //val action_signal = pcmd.valid && pcmd.ready && (pcmd.bits.inst.opcode === "b0101011".U)
  val action_signal = pcmd.valid && pcmd.ready && (pcmd.bits.inst.opcode === "b0001011".U) && (pcmd.bits.inst.funct === "b0000011".U)
  val done_action_signal = !(io.mesh.busy)

  //mem command opcode is "b0001011"
  val mem_cmd = pcmd.valid && pcmd.ready && (pcmd.bits.inst.opcode === "b0001011".U)
  //mem command is load when funct = "b0000001"
  val load_signal = pcmd.bits.inst.funct === "b0000001".U
  //mem command is store when funct = "b0000010"
  val store_signal = pcmd.bits.inst.funct === "b0000010".U

  //forward signals -> sync FSMs
  io.mesh.cmd.valid := pcmd.valid
  io.mesh.cmd.bits.load := mem_cmd && load_signal
  io.mesh.cmd.bits.store := mem_cmd && store_signal
  io.mesh.cmd.bits.doAllToAll := action_signal

  when(state === idle){

    io.processor.busy := false.B
    pcmd.ready := true.B
    io.mesh.cmd.valid := pcmd.valid
    presp.valid := false.B
    io.mesh.resp.ready := false.B
    io.processor.resp.bits.rd := pcmd.bits.inst.rd
    rd_address := pcmd.bits.inst.rd

    when(action_signal){
      state := action
    }.elsewhen(mem_cmd && load_signal){
      state := load_state
    }.elsewhen(mem_cmd && store_signal){
      state := store_state
    }.otherwise{
      state := idle
    }

  }.elsewhen(state === load_state){

    io.processor.busy := stall_resp
    pcmd.ready := !stall_resp
    io.mesh.cmd.valid := !stall_resp && pcmd.valid
    presp.valid := true.B
    io.mesh.resp.ready := presp.ready
    io.processor.resp.bits.rd := rd_address
  
    when(!stall_resp){
      rd_address := pcmd.bits.inst.rd
    }

    when (action_signal && !stall_resp){
      state := action
    }.elsewhen(mem_cmd && load_signal && !stall_resp){
      state := load_state
    }.elsewhen(mem_cmd && store_signal && !stall_resp){
      state := store_state
    }.elsewhen(stall_resp){
      state := stall_resp_state
    }.otherwise{
      state := idle
    }

  }.elsewhen(state === store_state){

    io.processor.busy := true.B
    pcmd.ready := false.B
    io.mesh.cmd.valid := false.B
    presp.valid := false.B
    io.mesh.resp.ready := false.B
    io.processor.resp.bits.rd := rd_address
    
    state := store_resp

  }.elsewhen(state === store_resp){

    io.processor.busy := stall_resp
    pcmd.ready := !stall_resp 
    io.mesh.cmd.valid := pcmd.valid && pcmd.valid
    presp.valid := true.B
    io.mesh.resp.ready := presp.ready
    io.processor.resp.bits.rd := rd_address

    when(!stall_resp){
      rd_address := pcmd.bits.inst.rd
    }

    when (action_signal && !stall_resp){
      state := action
    }.elsewhen(mem_cmd && load_signal && !stall_resp){
      state := load_state
    }.elsewhen(mem_cmd && store_signal && !stall_resp){
      state := store_state
    }.elsewhen(stall_resp){
      state := stall_resp_state
    }.otherwise{
      state := idle
    }

  }.elsewhen(state === stall_resp_state){

    io.processor.busy := true.B 
    pcmd.ready := false.B
    io.mesh.cmd.valid := false.B 
    presp.valid := true.B
    io.mesh.resp.ready := presp.ready
    io.processor.resp.bits.rd := rd_address

    when(stall_resp){
      state := stall_resp_state
    }.otherwise{
      state := idle
    }
    
  }.elsewhen(state === action){
    
    io.processor.busy := true.B 
    pcmd.ready := false.B 
    io.mesh.resp.ready := false.B
    presp.bits.rd := rd_address
    presp.valid := false.B

    state := wait_action_resp

  }.elsewhen(state === wait_action_resp){
    
    io.processor.busy := true.B 
    pcmd.ready := false.B 
    io.mesh.resp.ready := false.B
    io.processor.resp.bits.rd := rd_address
    presp.valid := false.B

    when (done_action_signal){
      state := action_resp
    }.otherwise{
      state := wait_action_resp
    }

  }.elsewhen(state === action_resp){

    io.processor.busy := true.B 
    pcmd.ready := false.B 
    io.mesh.resp.ready := true.B
    io.processor.resp.bits.rd := rd_address
    presp.valid := true.B

    when(!presp.ready){
      state := action_resp
    }.otherwise{
      state:= idle
    }

  }.otherwise{
    
    io.processor.busy := false.B 
    pcmd.ready := false.B 
    presp.valid := false.B
    io.mesh.resp.ready := false.B
    io.processor.resp.bits.rd := rd_address

    state := idle
    
  }
  
  

}



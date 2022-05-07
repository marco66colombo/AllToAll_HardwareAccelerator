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
  //val idle :: exchange :: load :: done_exchange :: Nil = Enum(4)

  val idle :: action :: action_resp :: first_mem_cmd :: mem_cmd_mem_resp :: mem_resp_only :: action_cmd_mem_resp :: wait_action_resp :: Nil = Enum(8)
  val state = RegInit(idle) 
  val rd_address = Reg(Bits(5.W))
  
  /*
    manage processor.resp.bits.rd (destination register)
    if idle just put in output the input value
    if not idle put in output the saved value
  */
  io.processor.resp.bits.rd := Mux( state === idle, io.processor.cmd.bits.inst.rd, rd_address)
  

  val pcmd = io.processor.cmd
  val presp = io.processor.resp 
  
  //pcm.ready := (state === idle)

  io.processor.interrupt := false.B
  
  io.mesh.cmd.valid := pcmd.valid
  io.mesh.cmd.bits.rs1 := pcmd.bits.rs1
  io.mesh.cmd.bits.rs2 := pcmd.bits.rs2

  presp.bits.data := io.mesh.resp.bits.data
  //responmse valid iff mesh.resp ready
  presp.valid := io.mesh.resp.ready


  

  /*
    transitions values
  */
  val goto_excange = pcmd.valid && (pcmd.bits.inst.opcode === "b0101011".U)
  //it should be set by the end of computation of the mesh
  //val goto_done_exchange = true.B
  val goto_done_exchange = !(io.mesh.busy)
  val loadSignal = pcmd.bits.inst.funct === "b0000001".U
  val storeSignal = pcmd.bits.inst.funct === "b0000010".U
  val mem_cmd = pcmd.valid && (pcmd.bits.inst.opcode === "b0001011".U)

  when(state === idle){
    //accelerator not busy -> free
    io.processor.busy := false.B 
    //ready to receive a command
    pcmd.ready := true.B 
    

    //signals to the mesh (reset state)
    io.mesh.cmd.bits.load := false.B
    io.mesh.cmd.bits.store := false.B
    io.mesh.cmd.bits.doAllToAll := false.B
    //not ready to receive resp from mesh
    io.mesh.resp.ready := false.B
    
    
    when(goto_excange){
      state := action
    }.elsewhen(mem_cmd){
      state := first_mem_cmd
    }.otherwise{
      state := idle
    }
  }.elsewhen(state === first_mem_cmd){

    //accelerator not busy -> free
    io.processor.busy := false.B 
    //ready to receive a command
    pcmd.ready := true.B 

    rd_address := pcmd.bits.inst.rd
    
    io.mesh.cmd.bits.doAllToAll := false.B
    io.mesh.resp.ready := false.B

    when(loadSignal){
      io.mesh.cmd.bits.load := true.B
      io.mesh.cmd.bits.store := false.B
    }.elsewhen(storeSignal){
      io.mesh.cmd.bits.load := false.B
      io.mesh.cmd.bits.store := true.B
    }.otherwise{
      io.mesh.cmd.bits.load := false.B
      io.mesh.cmd.bits.store := false.B
    }

    when(goto_excange){
      state := action_cmd_mem_resp
    }.elsewhen(mem_cmd){
      state := mem_cmd_mem_resp
    }.otherwise{
      state := mem_resp_only
    }

  }.elsewhen(state === mem_resp_only){
     //accelerator not busy -> free
    io.processor.busy := true.B 
    //ready to receive a command
    pcmd.ready := false.B 
    
    rd_address := pcmd.bits.inst.rd

    io.mesh.cmd.bits.load := false.B
    io.mesh.cmd.bits.store := false.B
    io.mesh.cmd.bits.doAllToAll := false.B
    io.mesh.resp.ready := true.B

    state := idle
    
  }.elsewhen(state === mem_cmd_mem_resp){
    //accelerator not busy -> free
    io.processor.busy := false.B 
    //ready to receive a command
    pcmd.ready := true.B 
   
    rd_address := pcmd.bits.inst.rd

    io.mesh.cmd.bits.doAllToAll := false.B
    io.mesh.resp.ready := true.B

    when(loadSignal){
      io.mesh.cmd.bits.load := true.B
      io.mesh.cmd.bits.store := false.B
    }.elsewhen(storeSignal){
      io.mesh.cmd.bits.load := false.B
      io.mesh.cmd.bits.store := true.B
    }.otherwise{
      io.mesh.cmd.bits.load := false.B
      io.mesh.cmd.bits.store := false.B
    }

    when(goto_excange){
      state := action_cmd_mem_resp
    }.elsewhen(mem_cmd){
      state := mem_cmd_mem_resp
    }.otherwise{
      state := mem_resp_only
    }

  }.elsewhen(state === action_cmd_mem_resp){
    //accelerator not busy -> free
    io.processor.busy := false.B 
    //ready to receive a command
    pcmd.ready := true.B 
    
    rd_address := pcmd.bits.inst.rd

    io.mesh.cmd.bits.load := false.B
    io.mesh.cmd.bits.store := false.B
    io.mesh.cmd.bits.doAllToAll := true.B
    io.mesh.resp.ready := true.B


    state := wait_action_resp
  }.elsewhen(state === action){
    //accelerator not busy -> free
    io.processor.busy := true.B 
    //ready to receive a command
    pcmd.ready := false.B 
    
    rd_address := pcmd.bits.inst.rd

    io.mesh.cmd.bits.load := false.B
    io.mesh.cmd.bits.store := false.B
    io.mesh.cmd.bits.doAllToAll := true.B
    io.mesh.resp.ready := false.B


    state := wait_action_resp
  }.elsewhen(state === wait_action_resp){
    //accelerator not busy -> free
    io.processor.busy := true.B 
    //ready to receive a command
    pcmd.ready := false.B 
    

    io.mesh.cmd.bits.load := false.B
    io.mesh.cmd.bits.store := false.B
    io.mesh.cmd.bits.doAllToAll := false.B
    io.mesh.resp.ready := false.B


    when(goto_done_exchange){
      state := action_resp
    }.otherwise{
      state := wait_action_resp
    }
  }.elsewhen(state === action_resp){
    io.processor.busy := true.B 
    //ready to receive a command
    pcmd.ready := false.B 
    

    io.mesh.cmd.bits.load := false.B
    io.mesh.cmd.bits.store := false.B
    io.mesh.cmd.bits.doAllToAll := false.B
    io.mesh.resp.ready := true.B

  }.otherwise{
    //accelerator not busy -> free
    io.processor.busy := false.B 
    //ready to receive a command
    pcmd.ready := false.B 
    

    //signals to the mesh (reset state)
    io.mesh.cmd.bits.load := false.B
    io.mesh.cmd.bits.store := false.B
    io.mesh.cmd.bits.doAllToAll := false.B
    //not ready to receive resp from mesh
    io.mesh.resp.ready := false.B
    
  }

    


}


/*def //IO interface for AllToAllController
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
  val idle :: exchange :: load :: done_exchange :: Nil = Enum(4)
  val state = RegInit(idle) 
  val rd_address = Reg(Bits(5.W))
  
  /*
    manage processor.resp.bits.rd (destination register)
    if idle just put in output the input value
    if not idle put in output the saved value
  */
  io.processor.resp.bits.rd := Mux( state === idle, io.processor.cmd.bits.inst.rd, rd_address)
  
  when(state === idle){
    rd_address := io.processor.cmd.bits.inst.rd
  }

  io.processor.cmd.ready := (state === idle)

  io.processor.interrupt := false.B
  io.processor.resp.bits.data := 0.U(64.W)


  val pcmd = io.processor.cmd
  val presp = io.processor.resp 

  /*
    transitions values
  */
  val goto_excange = pcmd.valid && (io.processor.cmd.bits.inst.opcode === "b0101011".U)
  //it should be set by the end of computation of the mesh
  //val goto_done_exchange = true.B
  val goto_done_exchange = !(io.mesh.busy)
  val loadSignal = pcmd.valid && (io.processor.cmd.bits.inst.opcode === "b0001011".U)

  when(state === idle){
    //accelerator not busy -> free
    io.processor.busy := false.B 
    //ready to receive a command
    pcmd.ready := true.B 
    //response is not valid now
    presp.valid := false.B

    //signals to the mesh (reset state)
    io.mesh.cmd.valid := false.B
    io.mesh.cmd.bits.load := false.B
    io.mesh.cmd.bits.store := false.B
    io.mesh.cmd.bits.doAllToAll := false.B
    io.mesh.cmd.bits.rs1 := 0.U(64.W)
    io.mesh.cmd.bits.rs2 := 0.U(64.W)
    //not ready to receive resp from mesh
    io.mesh.resp.ready := false.B
    
    when(goto_excange){
      state := exchange
    }.elsewhen(loadSignal){
      state := load
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

    //signals to the mesh
    io.mesh.cmd.load := false.B
    io.mesh.cmd.store := false.B
    //should be true
    io.mesh.cmd.doAllToAll := false.B
    io.mesh.cmd.rs1 := 0.U(64.W)
    io.mesh.cmd.rs2 := 0.U(64.W)

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

    io.mesh.cmd.load := false.B
    io.mesh.cmd.store := false.B
    io.mesh.cmd.doAllToAll := false.B
    io.mesh.cmd.rs1 := 0.U(64.W)
    io.mesh.cmd.rs2 := 0.U(64.W)

    //always goto idle
    state := idle
  }.elsewhen(state === load){
    //accelerator busy
    io.processor.busy := true.B 
    //not ready to receive a command
    pcmd.ready := false.B 
    //response is not valid now
    presp.valid := false.B

    //signals to the mesh
    //load true
    io.mesh.cmd.load := true.B
    io.mesh.cmd.store := false.B
    io.mesh.cmd.doAllToAll := false.B
    io.mesh.cmd.rs1 := 0.U(64.W)
    io.mesh.cmd.rs2 := 0.U(64.W)

    //always go to idle
    state := idle

  }.otherwise{ 
  //in this case there is an error
  // val error := true.B ?? makes sense?

    io.processor.busy := false.B 
    pcmd.ready := true.B 
    presp.valid := false.B 
    state := idle
    io.mesh.cmd.load := false.B
    io.mesh.cmd.store := false.B
    io.mesh.cmd.doAllToAll := false.B
    io.mesh.cmd.rs1 := 0.U(64.W)
    io.mesh.cmd.rs2 := 0.U(64.W)
  }


}
*/
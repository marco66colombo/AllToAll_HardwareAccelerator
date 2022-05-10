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

  val idle :: action :: action_resp :: mem_cmd_state :: wait_action_resp :: stall_state :: Nil = Enum(6)
  val state = RegInit(idle) 

  //reanaming signals names for simplicity
  val pcmd = io.processor.cmd
  val presp = io.processor.resp
/*
  //save rd address when command is given
  val rd_address_cmd = Reg(Bits(5.W))
  //save rd address when response is sent
  val rd_address_resp = Reg(Bits(5.W))
*/
  val rd_address_mem = ShiftRegister(pcmd.bits.inst.rd,2)
  val rd_address_mem_resp_stall = Reg(Bits(5.W))
  val rd_address_action = Reg(Bits(5.W))

  //manage processor.resp.bits.rd (destination register)
  //io.processor.resp.bits.rd := rd_address_resp

  //says whether the resp valid is true or not (if at the current cycle a response has to be sent)
  val resp_signal = RegInit(Bool(),false.B)
  //true iff at that cycle accelerator have to respond and cannot (!presp.ready)
  val stall_resp = !presp.ready && resp_signal
  
  
  //interrupt always false up to this version
  io.processor.interrupt := false.B
  
  //set values of rs1,rs2 of mesh command
  io.mesh.cmd.bits.rs1 := pcmd.bits.rs1
  io.mesh.cmd.bits.rs2 := pcmd.bits.rs2

  //response data are given by the mesh
  presp.bits.data := io.mesh.resp.bits.data

  //response valid iff mesh.resp ready
  presp.valid := resp_signal

  /*
    transitions values
  */

  //action opcode is "b0101011"
  val goto_excange = pcmd.valid && (pcmd.bits.inst.opcode === "b0101011".U)
  val goto_done_exchange = !(io.mesh.busy)

  //mem command opcode is "b0001011"
  val mem_cmd = pcmd.valid && (pcmd.bits.inst.opcode === "b0001011".U)
  //mem command is load when funct = "b0000001"
  val loadSignal = pcmd.bits.inst.funct === "b0000001".U
  //mem command is store when funct = "b0000010"
  val storeSignal = pcmd.bits.inst.funct === "b0000010".U

  //forward signals -> sync FSMs
  io.mesh.cmd.valid := pcmd.valid
  io.mesh.cmd.bits.load := mem_cmd && loadSignal
  io.mesh.cmd.bits.store := mem_cmd && storeSignal
  io.mesh.cmd.bits.doAllToAll := goto_excange
  
  

  when(state === idle){

    io.processor.busy := false.B || stall_resp //= stall resp
    pcmd.ready := true.B && !stall_resp //= !stall_resp

    io.mesh.cmd.valid := pcmd.valid && !stall_resp

    //reset response signal
    resp_signal := 0.U
  
    //signals to the mesh (reset state)
    io.mesh.resp.ready := resp_signal && presp.ready
    
    io.processor.resp.bits.rd := rd_address_mem
    rd_address_mem_resp_stall := rd_address_mem

    when(goto_excange && !stall_resp){
      state := action
    }.elsewhen(mem_cmd && !stall_resp){
      state := mem_cmd_state
    }.elsewhen(stall_resp){
      state := stall_state
    }.otherwise{
      state := idle
    }

  }.elsewhen(state === mem_cmd_state){

    io.processor.busy := false.B || stall_resp //= stall resp
    pcmd.ready := true.B && !stall_resp //= !stall_resp

    io.mesh.cmd.valid := pcmd.valid && !stall_resp

    //if here, it means that at next clocl cycle a response is sent
    //SE SCRIVO COSI RIMANE AL VALORE DI PRIMA FINCHE NON SCATTA IL PROSSIMO CICLO GIUSTO??
    resp_signal := true.B

    //signals to the mesh
    io.mesh.resp.ready := resp_signal && presp.ready

    io.processor.resp.bits.rd := rd_address_mem
    rd_address_mem_resp_stall := rd_address_mem

  
//QUESTI VALORI RIMANGONO E QUANDO SCATTA IL CICLO SE LA RESP.READY ERA TRUE ALLORA IL PROCESSORE SALVA LA RESP CORRETTAMENTE
//SE LA RESP.READY ERA FALSE ALLORA DEVO STALLARE -> HO GIA ACCETTATO IL COMANDO PERCHE' ERO CMD.READY QUINDI NON POSSO RINNEGARLO,
//LA COSA PIU SEMPLICE E' RIESEGUIRLO AL CICLO DOVE ESCO DALLO STALLO
//PROBLEMA -> DOPO LO STALLO AVRO' 2 RESPONSE DA DARE, QUELL STALLATA E QUELLA DEL CMD CHE HO ORMAI ACCETTATO, 
//E COMUNQUE LA STESSA COSA PUO SUCCEDERE NEI CICLI DOPO -> NON ACCETTO NUOVI COMANDI FINCHE ENTRAMBE LE RISPOSTE SONO STATE DATE
//OPPURE NEL CASO IN CUI ERO IN IDLE FINCHE L'UNICA RISPOSTA E' STATA DATA

    when(goto_excange && !stall_resp){
      state := action
    }.elsewhen(mem_cmd && !stall_resp){
      state := mem_cmd_state
    }.elsewhen(stall_resp){
      state := stall_state
    }.otherwise{
      state := idle
    }

  }.elsewhen(state === stall_state){

    //here resp_signal = true always -> stall_resp <=> !presp.ready

    io.processor.busy := true.B 
    pcmd.ready := false.B
    io.mesh.cmd.valid := false.B 
    
    //signals to the mesh
    io.mesh.resp.ready := presp.ready

    io.processor.resp.bits.rd := rd_address_mem_resp_stall

    when(stall_resp){
      //still stalling response
      resp_signal := true.B
      state := stall_state
      
    }.otherwise{
      //response already given, no need to respond at next clock cycle
      resp_signal := false.B
      state := idle
    }
    
  
  }.elsewhen(state === action){
    
    io.processor.busy := true.B 
    pcmd.ready := false.B 
    //assume action takes more that 1 clock cycle to respond
    resp_signal := false.B

    rd_address_action := pcmd.bits.inst.rd

    //signals to the mesh
    io.mesh.resp.ready := resp_signal

    io.processor.resp.bits.rd := rd_address_mem

    state := wait_action_resp

  }.elsewhen(state === wait_action_resp){
    
    io.processor.busy := true.B 
    pcmd.ready := false.B 

    //signals to the mesh
    io.mesh.resp.ready := false.B

    io.processor.resp.bits.rd := rd_address_action

    when(goto_done_exchange){
      state := action_resp
    }.otherwise{
      state := wait_action_resp
    }

  }.elsewhen(state === action_resp){

    io.processor.busy := true.B 
    pcmd.ready := false.B 
    
    //signals to the mesh
    //set true, response of the entire action
    io.mesh.resp.ready := true.B

    io.processor.resp.bits.rd := rd_address_action

    state := idle

  }.otherwise{
    
    io.processor.busy := false.B 
    pcmd.ready := false.B 
    
    //signals to the mesh (reset state)
    io.mesh.resp.ready := false.B

    io.processor.resp.bits.rd := rd_address_mem

    state := idle
    
  }


}



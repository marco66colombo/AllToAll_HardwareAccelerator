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



class ControllerIO extends Bundle{

    val processor = new AcceleratorModuleIO
    
    //Flipped since all output of MeshIo here are input and vice versa
    val mesh = Flipped(new MeshIO)
}

class MeshIO extends Bundle{
    val cmd = Flipped(Decoupled(new MeshCommand))
    val resp = Decoupled(new MeshResponse)
    val busy = Output(Bool())
}

class MeshCommand extends Bundle{

}

class MeshResponse extends Bundle{

}

//controller which manages interactions between AllTOAllModule and the AllToAllPE instantiated in it
class AllToAllController extends Module{
  io = IO(new AcceleratorModuleIO)

  // FSM 
  io.resp.bits.rd := Mux( state === idle, io.cmd.bits.inst.rd, rd_address)
  val rd_address = Reg(Bits(5.W))
  when(state === idle){
    rd_address := io.cmd.bits.inst.rd
  }
  io.cmd.ready := (state === idle)

  //io.rocc.resp.bits.data := io.resp.data
  //io.rocc.resp.valid := state === give_result

  /*
   //TODO
  //devo salvare il valore del registro in scrittura nel processore (quando l'acceleratoere risponde) 
  //perchè quando testo è possibile che si resetti a zero al clock successivo
  val rd_address = Reg(Bits(5.W))
  rd_address := io.cmd.bits.inst.rd
  */
    
  val idle :: exchange :: done_exchange :: Nil = Enum(3)

  val state = Reg(Bits(2.W))
  val goto_excange = !(io.busy) && io.cmd.ready && io.cmd.valid
  
  state := idle

    when(state === idle){
    io.cmd.busy := false.B 
    io.cmd.ready := true.B 
    io.resp.valid := false.B
    io.busy := false.B 
    when(goto_excange){
      state := exchange
    }.otherwise{
      state := idle
    }
  }.elsewhen(state === exchange){
    io.busy := true.B 
    rocc.busy := true.B
    rocc.cmd.ready := false.B 
    rocc.resp.valid := false.B
    when(done){
        state := give_result
    }.otherwise{
        state := exec
    }
    
  }.elsewhen(state === give_result){
    io.ready := false.B 
    rocc.busy := true.B
    rocc.cmd.ready := false.B 
    rocc.resp.valid := true.B
    state := idle
  }.otherwise{ // shouldn't happen
  io.ready := false.B 
  rocc.busy := false.B
  rocc.cmd.ready := false.B 
  rocc.resp.valid := false.B 
  state := idle
  }


  //resp output
  io.cmd.ready := true.B
  io.resp.valid := true.B
  io.resp.bits.rd := 1.U
  io.resp.bits.data := cmd.bits.rs1 + 1.U

  //output
  io.busy := false.B
  io.interrupt := false.B

}

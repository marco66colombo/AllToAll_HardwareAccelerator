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



class PECommand extends Bundle{
    //control signals
    val load = Bool()
    val store = Bool()
    val doAllToAll = Bool()

//communiction between PE and controller
    val rs1 = Bits(64.W)
    val rs2 = Bits(64.W)
}

class PEResponse extends Bundle{

    //communiction between PE and controller
    val data = Bits(64.W)
    val write_enable = Bool()
}


class OutputPE(val indexWidth: Int) extends Bundle{
  val data = Bits(64.W)
  val x_0 = Bits(indexWidth.W)
  val y_0 = Bits(indexWidth.W)
  val x_dest = Bits(indexWidth.W)
  val y_dest = Bits(indexWidth.W)
  val pos = Bits(16.W)
}


class InputOutputPEdata(indexWidth: Int) extends Bundle{
    val out = Decoupled(new OutputPE(indexWidth))
    val in = Flipped(Decoupled(new OutputPE(indexWidth)))
}

class AllToAllPEIO(indexWidth: Int) extends Bundle{

    //when busy = true -> computation of PE not terminated yet
    val busy = Output(Bool())
    val end_AllToAll = Input(Bool())
    
    val cmd = Flipped(Decoupled(new PECommand))
    val resp = Decoupled(new PEResponse)
    val left = new InputOutputPEdata(indexWidth)
    val right = new InputOutputPEdata(indexWidth)
    val up = new InputOutputPEdata(indexWidth)
    val bottom = new InputOutputPEdata(indexWidth)
}
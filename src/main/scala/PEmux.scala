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


class InputMux(val indexWidth : Int) extends Bundle{
    val data = Bits(64.W)
    val x_0 = UInt(indexWidth.W)
    val y_0 = UInt(indexWidth.W)
    val x_dest = UInt(indexWidth.W)
    val y_dest = UInt(indexWidth.W)
    val pos = UInt(16.W)
}

class OutputMux(val indexWidth : Int) extends Bundle{
    val bits = new InputMux(indexWidth)
    val selected = Bits(4.W)
}




class MyPriorityMux(val indexWidth : Int) extends Module{

    val io = IO(new Bundle(){

        val valid = Input(Vec(4, Bool()))
        val in_bits = Input(Vec(4, new InputMux(indexWidth)))
        val out_valid = Output(Bool())
        val out_val = Output(new OutputMux(indexWidth))

    })

  val first = Wire(new OutputMux(indexWidth))
  val second = Wire(new OutputMux(indexWidth))
  val third = Wire(new OutputMux(indexWidth))
  val fourth = Wire(new OutputMux(indexWidth))
  val no_valid_input = Wire(new OutputMux(indexWidth))

  first.bits <> io.in_bits(0)
  second.bits <> io.in_bits(1)
  third.bits <> io.in_bits(2)
  fourth.bits <> io.in_bits(3)

  no_valid_input.bits.data := 0.U
  no_valid_input.bits.x_0 := 0.U
  no_valid_input.bits.y_0 := 0.U
  no_valid_input.bits.x_dest := 0.U
  no_valid_input.bits.y_dest := 0.U
  no_valid_input.bits.pos := 0.U


  first.selected := "b0001".U
  second.selected := "b0010".U
  third.selected := "b0100".U
  fourth.selected := "b1000".U
  no_valid_input.selected := "b0000".U



  val myseq1 = Seq(io.valid(0),io.valid(1),io.valid(2),io.valid(3),true.B)
  val myseq2 = Seq(first, second, third, fourth, no_valid_input)

  val mux1 = PriorityMux(myseq1,myseq2)

  io.out_val := mux1

  val no_valid = !io.valid(0) && !io.valid(1) && !io.valid(2) && !io.valid(3)
  io.out_valid := Mux(no_valid, false.B, true.B)
  
}

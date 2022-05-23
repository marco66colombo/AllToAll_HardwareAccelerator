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


class IndexCalculator(numberPE: Int, val indexWidth: Int) extends Module{

    val io = IO(new Bundle{
        val reset = Input(Bool())
        val enable = Input(Bool())
        val last_index = Output(Bool())
        val index = Output(Bits((indexWidth*2 + 1).W))
    }) 
    
    //+1 because it counts from 0 to nPE, not from 0 to nPE-1
    val counter = Reg(UInt((indexWidth*2 + 1).W))
    
    when (io.enable) {

        counter := Mux(io.reset, 0.U, counter + 1.U)
    }

    io.index := counter

    //true when counter = nPE, PEs start from 0 to n-1, so if counter == n it means that all PEs have been read
    io.last_index := counter === numberPE.U

}
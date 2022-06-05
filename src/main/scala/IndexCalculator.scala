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
        val index = Output(Bits((indexWidth*2 + 2).W))
    }) 
    
    //+1 because it counts from 0 to nPE, not from 0 to nPE-1
    val counter = Reg(UInt((indexWidth*2 + 2).W))
    
    when (io.enable) {

        counter := Mux(io.reset, 0.U, counter + 1.U)
    }

    io.index := counter

    //true when counter = nPE, PEs start from 0 to n-1, so if counter == n it means that all PEs have been read
    io.last_index := counter === numberPE.U

}



class IndexCalculatorV1(n: Int, n_PE: Int, val indexWidth: Int) extends Module{

    val io = IO(new Bundle{

        val reset = Input(Bool())
        val enable = Input(Bool())

        //number or rows (of 64 bits) to be exchanged for each PE
        val dim_N = Input(Bits(16.W))

        val index0 = Output(Bits((indexWidth*2 + 2).W))
        val index1 = Output(Bits((indexWidth*2 + 2).W))
        val index2 = Output(Bits((indexWidth*2 + 2).W))
        val index3 = Output(Bits((indexWidth*2 + 2).W))

        //says whether the index_i is a valid index or not
        val valid0 = Output(Bool())
        val valid1 = Output(Bool())
        val valid2 = Output(Bool())
        val valid3 = Output(Bool())

        val x_dest_0 = Output(Bits(indexWidth.W))
        val x_dest_1 = Output(Bits(indexWidth.W))
        val x_dest_2 = Output(Bits(indexWidth.W))
        val x_dest_3 = Output(Bits(indexWidth.W))

        val y_dest_0 = Output(Bits(indexWidth.W))
        val y_dest_1 = Output(Bits(indexWidth.W))
        val y_dest_2 = Output(Bits(indexWidth.W))
        val y_dest_3 = Output(Bits(indexWidth.W))

        val pos_0 = Output(Bits(16.W))
        val pos_1 = Output(Bits(16.W))
        val pos_2 = Output(Bits(16.W))
        val pos_3 = Output(Bits(16.W))

        //says wheter all the indexes have been processed
        val last_iteration = Output(Bool())

    }) 

    
    val dim_N = Reg(Bits(16.W))

    //val counter_PE = Reg(UInt((indexWidth*2 + 1).W))
    val counter_PE = Reg(UInt((32).W))
    val counter_offset = Reg(UInt(16.W))

    //reset the state of the counter
    when(io.enable && io.reset){
        
        dim_N := io.dim_N
        counter_PE := 0.U
        counter_offset := 0.U
    }


    when(io.enable && !io.reset){

        when(counter_PE+3.U >= (n_PE-1).U){

            counter_PE := 0.U
            counter_offset := counter_offset + 1.U 

        }.otherwise{

            counter_PE := counter_PE + 4.U

        }
    }

    
    io.index0 := counter_PE * dim_N + counter_offset
    io.index1 := (counter_PE+1.U) * dim_N + counter_offset
    io.index2 := (counter_PE+2.U) * dim_N + counter_offset
    io.index3 := (counter_PE+3.U) * dim_N + counter_offset

    //useful when n is not a multiple of 4, so in the last iteration some output addresses are not valid
    /*
    io.valid0 := counter_PE * dim_N <= (n_PE-1).U
    io.valid1 := (counter_PE+1.U) * dim_N <= (n_PE-1).U
    io.valid2 := (counter_PE+2.U) * dim_N <= (n_PE-1).U
    io.valid3 := (counter_PE+3.U) * dim_N <= (n_PE-1).U
    */
    io.valid0 := counter_PE <= (n_PE-1).U
    io.valid1 := (counter_PE+1.U) <= (n_PE-1).U
    io.valid2 := (counter_PE+2.U) <= (n_PE-1).U
    io.valid3 := (counter_PE+3.U) <= (n_PE-1).U

    def compute_x_coord(i: UInt): UInt = (i % n.U)
    //def compute_y_coord(i: UInt): UInt = ((n-1).U - (i / n.U))
    def compute_y_coord(i: UInt): UInt = (i / n.U)
    

    io.x_dest_0 := compute_x_coord(counter_PE)
    io.x_dest_1 := compute_x_coord(counter_PE+1.U)
    io.x_dest_2 := compute_x_coord(counter_PE+2.U)
    io.x_dest_3 := compute_x_coord(counter_PE+3.U)

    io.y_dest_0 := compute_y_coord(counter_PE)
    io.y_dest_1 := compute_y_coord(counter_PE+1.U)
    io.y_dest_2 := compute_y_coord(counter_PE+2.U)
    io.y_dest_3 := compute_y_coord(counter_PE+3.U)

    //it indicates the offset of the packets for each PE
    io.pos_0 := counter_offset
    io.pos_1 := counter_offset
    io.pos_2 := counter_offset
    io.pos_3 := counter_offset


    //true when counter = nPE, PEs start from 0 to n-1, so if counter == n it means that all PEs have been read
    //io.last_iteration := counter_offset === (dim_N - 1.U) && counter_PE >= (n_PE - 4).U
    io.last_iteration := counter_offset === dim_N


}
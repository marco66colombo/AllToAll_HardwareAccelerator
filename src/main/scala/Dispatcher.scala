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

class Dispatcher(val indexWidth: Int) extends Module{

    val io = IO(new Bundle{
        
        val x_PE = Input(UInt(indexWidth.W))
        val y_PE = Input(UInt(indexWidth.W))
        val x_0 = Input(Bits(indexWidth.W))
        val y_0 = Input(Bits(indexWidth.W))
        val x_dest = Input(Bits(indexWidth.W))
        val y_dest = Input(Bits(indexWidth.W))

        val left = Output(Bool())
        val right = Output(Bool())
        val up = Output(Bool())
        val bottom = Output(Bool())
        val this_PE = Output(Bool())

    })

    val out_selector = Wire(Bits(4.W))

    io.left := out_selector === "b0001".U && !io.this_PE
    io.right := out_selector === "b0010".U && !io.this_PE
    io.up := out_selector === "b0100".U && !io.this_PE
    io.bottom := out_selector === "b1000".U && !io.this_PE

    
    
    //case end forwarding
    when(io.x_dest === io.x_PE && io.y_dest === io.y_PE){
        io.this_PE := true.B
        out_selector := "b0000".U
    }.otherwise{
        io.this_PE := false.B
        out_selector := "b0000".U
    }

    val x_PE_transl = io.x_PE.zext - io.x_0.zext
    val y_PE_transl = io.y_PE.zext - io.y_0.zext
    val x_PE_transl_odd = x_PE_transl(0) === 1.U
    val y_PE_transl_odd = y_PE_transl(0) === 1.U
    val x_dest_transl = io.x_dest.zext - io.x_0.zext
    val y_dest_transl = io.y_dest.zext - io.y_0.zext

    //case (x_PE,y_PE) on positive semiaxis x
    when(io.x_PE > io.x_0 && io.y_PE === io.y_0){
        //check odd
        when(x_PE_transl_odd){
            when(x_dest_transl <= y_dest_transl + x_PE_transl){
                //UP
                out_selector := "b0100".U
            }.otherwise{
                //RIGHT
                out_selector := "b0010".U
            }
        }.otherwise{
            when(x_dest_transl <= -y_dest_transl + x_PE_transl){
                //BOTTOM
                out_selector := "b1000".U
            }.otherwise{
                //RIGHT
                out_selector := "b0010".U
            }
        }
    }

    //case (x_PE,y_PE) on positive semiaxis y
    when(io.x_PE === io.x_0 && io.y_PE > io.y_0){
        //check odd
        when(y_PE_transl_odd){
            when(x_dest_transl <= -y_dest_transl + y_PE_transl){
                //LEFT
                out_selector := "b0001".U
            }.otherwise{
                //UP
                out_selector := "b0100".U
            }
        }.otherwise{
            when(x_dest_transl >= y_dest_transl - y_PE_transl){
                //RIGHT
                out_selector := "b0010".U
            }.otherwise{
                //UP
                out_selector := "b0100".U
            }
        }
    }

    //case (x_PE,y_PE) on negative semiaxis x
    when(io.x_PE < io.x_0 && io.y_PE === io.y_0){
        //check odd
        when(x_PE_transl_odd){
            when(x_dest_transl >= y_dest_transl + x_PE_transl){
                //BOTTOM
                out_selector := "b1000".U
            }.otherwise{
                //LEFT
                out_selector := "b0001".U
            }
        }.otherwise{
            when(x_dest_transl >= -y_dest_transl + x_PE_transl){
                //UP
                out_selector := "b0100".U
            }.otherwise{
                //LEFT
                out_selector := "b0001".U
            }
        }
    }

    //case (x_PE,y_PE) on negative semiaxis y
    when(io.x_PE === io.x_0 && io.y_PE < io.y_0){
        //check odd
        when(y_PE_transl_odd){
            when(x_dest_transl >= -y_dest_transl + y_PE_transl){
                //RIGHT
                out_selector := "b0010".U
            }.otherwise{
                //BOTTOM
                out_selector := "b1000".U
            }
        }.otherwise{
            when(x_dest_transl <= y_dest_transl - y_PE_transl){
                //LEFT
                out_selector := "b0001".U
            }.otherwise{
                //DOWN
                out_selector := "b1000".U
            }
        }
    }


    val sign_delta_x = x_PE_transl.head(1).asBool
    val sign_delta_y = y_PE_transl.head(1).asBool

    val uFactor_x = !(sign_delta_x ^ sign_delta_y)
    val oddResult_x = x_PE_transl_odd ^ y_PE_transl_odd ^ uFactor_x

    val uFactor_y = sign_delta_x ^ sign_delta_y
    val oddResult_y = x_PE_transl_odd ^ y_PE_transl_odd ^ uFactor_y

    //case (x_PE,y_PE) not on axis -> use standard forward rule
    when(io.x_PE != io.x_0 && io.y_PE != io.y_0){

        when(oddResult_x && !sign_delta_x){
            //RIGHT
            out_selector := "b0010".U

        }.elsewhen(oddResult_x && sign_delta_x){
            //LEFT
            out_selector := "b0001".U
        }

        when(oddResult_y && !sign_delta_y){
            //UP
            out_selector := "b0100".U

        }.elsewhen(oddResult_y && sign_delta_y){
            //BOTTOM
            out_selector := "b1000".U
        }

    }


}



class GenerationDispatcher(val indexWidth: Int) extends Module{

    val io = IO(new Bundle{
        
        val x_PE = Input(UInt(indexWidth.W))
        val y_PE = Input(UInt(indexWidth.W))
        val x_dest = Input(Bits(indexWidth.W))
        val y_dest = Input(Bits(indexWidth.W))

        val left = Output(Bool())
        val right = Output(Bool())
        val up = Output(Bool())
        val bottom = Output(Bool())

    })

    val out_selector = Wire(Bits(4.W))

    //if x_PE == x_dest && y_PE == y_dest -> out_selector == 0000  (0 < 0 false) -> all output false

    io.left := out_selector === "b0001".U 
    io.right := out_selector === "b0010".U 
    io.up := out_selector === "b0100".U
    io.bottom := out_selector === "b1000".U 

    val x_dest_transl = io.x_dest.zext - io.x_PE.zext
    val y_dest_transl = io.y_dest.zext - io.y_PE.zext

    when(x_dest_transl <= y_dest_transl && x_dest_transl < -y_dest_transl){
        //LEFT
        out_selector := "b0001".U

    }.elsewhen(x_dest_transl >= y_dest_transl && x_dest_transl > -y_dest_transl){
        //RIGHT
        out_selector := "b0010".U

    }.elsewhen(x_dest_transl < y_dest_transl && x_dest_transl >= -y_dest_transl){
        //UP
        out_selector := "b0100".U

    }.elsewhen(x_dest_transl > y_dest_transl && x_dest_transl <= -y_dest_transl){
        //BOTTOM
        out_selector := "b1000".U

    }.otherwise{
        //ERROR
        out_selector := "b0000".U
    }

    
}





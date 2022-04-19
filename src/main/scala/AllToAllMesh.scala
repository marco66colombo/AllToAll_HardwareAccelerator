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


class MeshIO extends Bundle{
    val cmd = Flipped(new MeshCommand)
    val resp = new MeshResponse
    //val busy = Output(Bool())
}

class MeshCommand extends Bundle{

//communiction between PE and controller
    val rs1 = Input(Bits(64.W))
    val rs2 = Input(Bits(64.W))
}

class MeshResponse extends Bundle{

    //communiction between PE and controller
    val data = Output(Bits(64.W))
}

/*
    AllToAllMesh respresents the mesh coposed of processing units
    n : is the dimension of the square matrix of PE
*/
class AllToAllMesh(n : Int, cacheSize : Int) extends Module{

    val io = IO(new MeshIO)

    val vector = Vec(n*n, Module(AllToAllPE(cacheSize)).io)

   
    def upLeftCorner(i: Int): Boolean = (i == 0)
    def upRightCorner(i: Int): Boolean = (i == (n-1))
    def bottomLeftCorner(i: Int): Boolean = (i == ((n*n)-n))
    def bottomRightCorner(i: Int): Boolean = (i == ((n*n)-1))

    def up(i: Int): Boolean = ( i > 0 && i < n-1)
    def bottom(i: Int): Boolean = (i > ((n*n)-n) && i < ((n*n)-1))
    def left(i: Int): Boolean = (!upLeftCorner(i) && !bottomLeftCorner(i) && (i%n == 0))
    def right(i: Int): Boolean = (!upRightCorner(i) && !bottomRightCorner(i) && (i%n == (n-1)))

    for(i<-0 to (n*n)){
        //input
        vector(i).rs1 := io.cmd.rs1
        vector(i).rs2 := io.cmd.rs2
        
        //output
        io.resp.data := vector(i).data

    }

    for(i<-0 to (n*n)){
        if(upLeftCorner(i)){
            vector(i).left.out := 0.U(64.W)
            vector(i).left.in := 0.U(64.W)
            vector(i).up.out := 0.U(64.W)
            vector(i).up.in := 0.U(64.W)

            //vector(i).right.out := 0.U(64.W)
            vector(i).right.in := vector(i+1).left.out
            //vector(i).down.out := 0.U(64.W)
            vector(i).down.in := vector(i+n).up.out


        }else if(upRighttCorner(i)){
            vector(i).right.out := 0.U(64.W)
            vector(i).right.in := 0.U(64.W)
            vector(i).up.out := 0.U(64.W)
            vector(i).up.in := 0.U(64.W)

            //vector(i).left.out := 0.U(64.W)
            vector(i).left.in := vector(i-1).right.out
            //vector(i).down.out := 0.U(64.W)
            vector(i).down.in := vector(i+n).up.out
            
        }else if(bottomLeftCorner(i)){
            vector(i).left.out := 0.U(64.W)
            vector(i).left.in := 0.U(64.W)
            vector(i).down.out := 0.U(64.W)
            vector(i).down.in := 0.U(64.W)

            //vector(i).right.out := 0.U(64.W)
            vector(i).right.in := vector(i+1).left.out
            //vector(i).up.out := 0.U(64.W)
            vector(i).up.in := vector(i-n).down.out
            
        }else if(bottomRightCorner(i)){
            vector(i).right.out := 0.U(64.W)
            vector(i).right.in := 0.U(64.W)
            vector(i).down.out := 0.U(64.W)
            vector(i).down.in := 0.U(64.W)

            //vector(i).left.out := 0.U(64.W)
            vector(i).left.in := vector(i-1).right.out
            //vector(i).up.out := 0.U(64.W)
            vector(i).up.in := vector(i-n).down.out
            
        }else if(up(i)){
            vector(i).up.out := 0.U(64.W)
            vector(i).up.in := 0.U(64.W)

            //vector(i).left.out := 0.U(64.W)
            vector(i).left.in := vector(i-1).right.out
            //vector(i).right.out := 0.U(64.W)
            vector(i).right.in := vector(i+1).left.out
            //vector(i).down.out := 0.U(64.W)
            vector(i).down.in := vector(i+n).up.out
            
        }else if(bottom(i)){
            vector(i).down.out := 0.U(64.W)
            vector(i).down.in := 0.U(64.W)

            //vector(i).left.out := 0.U(64.W)
            vector(i).left.in := vector(i-1).right.out
            //vector(i).right.out := 0.U(64.W)
            vector(i).right.in := vector(i+1).left.out
            //vector(i).up.out := 0.U(64.W)
            vector(i).up.in := vector(i-n).down.out
            
        }else if(left(i)){
            vector(i).left.out := 0.U(64.W)
            vector(i).left.in := 0.U(64.W)

            //vector(i).right.out := 0.U(64.W)
            vector(i).right.in := vector(i+1).left.out
            //vector(i).up.out := 0.U(64.W)
            vector(i).up.in := vector(i-n).down.out
            //vector(i).down.out := 0.U(64.W)
            vector(i).down.in := vector(i+n).up.out
            
        }else if(right(i)){
            vector(i).right.out := 0.U(64.W)
            vector(i).right.in := 0.U(64.W)

            //vector(i).left.out := 0.U(64.W)
            vector(i).left.in := vector(i-1).right.out
            //vector(i).up.out := 0.U(64.W)
            vector(i).up.in := vector(i-n).down.out
            //vector(i).down.out := 0.U(64.W)
            vector(i).down.in := vector(i+n).up.out
            
        }else{ //elements not on the borders

            //vector(i).left.out := 0.U(64.W)
            vector(i).left.in := vector(i-1).right.out
            //vector(i).right.out := 0.U(64.W)
            vector(i).right.in := vector(i+1).left.out
            //vector(i).up.out := 0.U(64.W)
            vector(i).up.in := vector(i-n).down.out
            //vector(i).down.out := 0.U(64.W)
            vector(i).down.in := vector(i+n).up.out

        }
    }

  


}
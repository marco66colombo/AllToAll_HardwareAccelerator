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
    val cmd = new MeshCommand
    val resp = new MeshResponse
    val busy = Output(Bool())
}

class MeshCommand extends Bundle{
    //control signals
    val load = Input(Bool())
    val store = Input(Bool())
    val doAllToAll = Input(Bool())

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

    //val vector = Vec(n*n, Module(AllToAllPE(cacheSize)).io)
    //val vector = Seq.fill(n*n)(Module(new AllToAllPE(n,cacheSize)))

    val zero64 =  0.U(64.W)

    var vector1 = Seq[AllToAllPE]()
    /*
    for(i<-0 to (n*n)-1){
        vector1 = vector1 :+  Module(new AllToAllPE(n,cacheSize,i))
    }*/
    /*
    for(i<-0 to (n*n)-1){
        if(upLeftCorner(i) || upRightCorner(i) || bottomLeftCorner(i) || bottomRightCorner(i)){
            vector1 = vector1 :+  Module(new AllToAllPEcorner(n,cacheSize,i))

        }else if(up(i) || bottom(i) || left(i)|| right(i)){
            vector1 = vector1 :+  Module(new AllToAllPEedge(n,cacheSize,i))
            
        }else{ //elements not on the borders
            vector1 = vector1 :+  Module(new AllToAllPEmiddle(n,cacheSize,i))

        }
    }
    */
    def upLeftCorner(i: Int): Boolean = (i == 0)
    def upRightCorner(i: Int): Boolean = (i == (n-1))
    def bottomLeftCorner(i: Int): Boolean = (i == ((n*n)-n))
    def bottomRightCorner(i: Int): Boolean = (i == ((n*n)-1))

    def up(i: Int): Boolean = ( i > 0 && i < n-1)
    def bottom(i: Int): Boolean = (i > ((n*n)-n) && i < ((n*n)-1))
    def left(i: Int): Boolean = (!upLeftCorner(i) && !bottomLeftCorner(i) && (i%n == 0))
    def right(i: Int): Boolean = (!upRightCorner(i) && !bottomRightCorner(i) && (i%n == (n-1)))

    for(i<-0 to (n*n)-1){
        if(upLeftCorner(i)){
            vector1 = vector1 :+  Module(new AllToAllPEupLeftCorner(n,cacheSize,i))

        }else if(upRightCorner(i)){
            vector1 = vector1 :+  Module(new AllToAllPEupRightCorner(n,cacheSize,i))
            
        }else if(bottomLeftCorner(i)){
            vector1 = vector1 :+  Module(new AllToAllPEbottomLeftCorner(n,cacheSize,i))
            
        }else if(bottomRightCorner(i)){
            vector1 = vector1 :+  Module(new AllToAllPEbottomRightCorner(n,cacheSize,i))
        }else if(up(i)){
            vector1 = vector1 :+  Module(new AllToAllPEup(n,cacheSize,i))
            
        }else if(bottom(i)){
            vector1 = vector1 :+  Module(new AllToAllPEbottom(n,cacheSize,i))
            
        }else if(left(i)){
            vector1 = vector1 :+  Module(new AllToAllPEleft(n,cacheSize,i))
            
        }else if(right(i)){
            vector1 = vector1 :+  Module(new AllToAllPEright(n,cacheSize,i))
            
        }else{ //elements not on the borders
            vector1 = vector1 :+  Module(new AllToAllPEmiddle(n,cacheSize,i))
        }
        
    }
    val vector = vector1


    //connect all PEs with the controller on a common bus
    for(i<-0 to (n*n)-1){

        //vector(i).setNumberPE(i)
        //vector(i).number_PE := i.U(32.W)

        //input
        vector(i).io.load := io.cmd.load
        vector(i).io.store := io.cmd.store
        vector(i).io.doAllToAll := io.cmd.doAllToAll

        vector(i).io.rs1 := io.cmd.rs1
        vector(i).io.rs2 := io.cmd.rs2

        //output
        io.resp.data := vector(i).io.data

    }

    //io.busy is the or of all busy signals of the PEs in the mesh
    io.busy := vector.map(_.io.busy).reduce(_ || _)

    //connect each PE with each other
    for(i<-0 to (n*n)-1){
        if(upLeftCorner(i)){
            
            //vector(i).io.left.out := 0.U(64.W)  
            vector(i).io.left.in := zero64
            //vector(i).io.up.out := 0.U(64.W)
            vector(i).io.up.in := zero64
            

            //vector(i).right.out := 0.U(64.W)
            vector(i).io.right.in := vector(i+1).io.left.out
            //vector(i).down.out := 0.U(64.W)
            vector(i).io.bottom.in := vector(i+n).io.up.out


        }else if(upRightCorner(i)){
            
            //vector(i).io.right.out := 0.U(64.W)
            vector(i).io.right.in := zero64
            //vector(i).io.up.out := 0.U(64.W)
            vector(i).io.up.in := zero64
            

            //vector(i).left.out := 0.U(64.W)
            vector(i).io.left.in := vector(i-1).io.right.out
            //vector(i).down.out := 0.U(64.W)
            vector(i).io.bottom.in := vector(i+n).io.up.out
            
        }else if(bottomLeftCorner(i)){
            
            //vector(i).io.left.out := 0.U(64.W)
            vector(i).io.left.in := zero64
            //vector(i).io.down.out := 0.U(64.W)
            vector(i).io.bottom.in := zero64
            

            //vector(i).right.out := 0.U(64.W)
            vector(i).io.right.in := vector(i+1).io.left.out
            //vector(i).up.out := 0.U(64.W)
            vector(i).io.up.in := vector(i-n).io.bottom.out
            
        }else if(bottomRightCorner(i)){
            
            //vector(i).io.right.out := 0.U(64.W)
            vector(i).io.right.in := zero64
            //vector(i).io.down.out := 0.U(64.W)
            vector(i).io.bottom.in := zero64
            

            //vector(i).left.out := 0.U(64.W)
            vector(i).io.left.in := vector(i-1).io.right.out
            //vector(i).up.out := 0.U(64.W)
            vector(i).io.up.in := vector(i-n).io.bottom.out
            
        }else if(up(i)){
            //vector(i).io.up.out := 0.U(64.W)
            vector(i).io.up.in := zero64

            //vector(i).left.out := 0.U(64.W)
            vector(i).io.left.in := vector(i-1).io.right.out
            //vector(i).right.out := 0.U(64.W)
            vector(i).io.right.in := vector(i+1).io.left.out
            //vector(i).down.out := 0.U(64.W)
            vector(i).io.bottom.in := vector(i+n).io.up.out
            
        }else if(bottom(i)){
            //vector(i).io.down.out := 0.U(64.W)
            vector(i).io.bottom.in := zero64

            //vector(i).left.out := 0.U(64.W)
            vector(i).io.left.in := vector(i-1).io.right.out
            //vector(i).right.out := 0.U(64.W)
            vector(i).io.right.in := vector(i+1).io.left.out
            //vector(i).up.out := 0.U(64.W)
            vector(i).io.up.in := vector(i-n).io.bottom.out
            
        }else if(left(i)){
            //vector(i).io.left.out := 0.U(64.W)
            vector(i).io.left.in := zero64

            //vector(i).right.out := 0.U(64.W)
            vector(i).io.right.in := vector(i+1).io.left.out
            //vector(i).up.out := 0.U(64.W)
            vector(i).io.up.in := vector(i-n).io.bottom.out
            //vector(i).down.out := 0.U(64.W)
            vector(i).io.bottom.in := vector(i+n).io.up.out
            
        }else if(right(i)){
            //vector(i).io.right.out := 0.U(64.W)
            vector(i).io.right.in := zero64

            //vector(i).left.out := 0.U(64.W)
            vector(i).io.left.in := vector(i-1).io.right.out
            //vector(i).up.out := 0.U(64.W)
            vector(i).io.up.in := vector(i-n).io.bottom.out
            //vector(i).down.out := 0.U(64.W)
            vector(i).io.bottom.in := vector(i+n).io.up.out
            
        }else{ //elements not on the borders

            //vector(i).left.out := 0.U(64.W)
            vector(i).io.left.in := vector(i-1).io.right.out
            //vector(i).right.out := 0.U(64.W)
            vector(i).io.right.in := vector(i+1).io.left.out
            //vector(i).up.out := 0.U(64.W)
            vector(i).io.up.in := vector(i-n).io.bottom.out
            //vector(i).down.out := 0.U(64.W)
            vector(i).io.bottom.in := vector(i+n).io.up.out

        }
        
    }




}
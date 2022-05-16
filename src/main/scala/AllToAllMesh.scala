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


class MeshCommand extends Bundle{
    //control signals
    val load = Bool()
    val store = Bool()
    val doAllToAll = Bool()

    //communiction between PE and controller
    val rs1 = Bits(64.W)
    val rs2 = Bits(64.W)
}

class MeshResponse extends Bundle{

    //communiction between PE and controller
    val data = Bits(64.W)
}

class MeshIO extends Bundle{
    val cmd = Flipped(Decoupled(new MeshCommand))
    val resp = Decoupled(new MeshResponse)
    val busy = Output(Bool())
}



/*
    AllToAllMesh respresents the mesh coposed of processing units
    n : is the dimension of the square matrix of PE
    cacheSize : is the number of lines of the memory of each PE
*/
class AllToAllMesh(n : Int, cacheSize : Int, queueSize: Int) extends Module{

    val io = IO(new MeshIO)

    val zero64 =  0.U(64.W)
    val zeroValue =  0.U


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

    def x_coord(i: Int): Int = (i%n)
    def y_coord(i: Int): Int = ((n-1)-(i/n))

    var x,y = 0

    //create the PEs of the mesh and assigning them the coordinates (x,y)
    for(i<-0 to (n*n)-1){

        x = x_coord(i)
        y = y_coord(i)

        if(upLeftCorner(i)){
            vector1 = vector1 :+  Module(new AllToAllPEupLeftCorner(n,cacheSize,queueSize,x,y))

        }else if(upRightCorner(i)){
            vector1 = vector1 :+  Module(new AllToAllPEupRightCorner(n,cacheSize,queueSize,x,y))
            
        }else if(bottomLeftCorner(i)){
            vector1 = vector1 :+  Module(new AllToAllPEbottomLeftCorner(n,cacheSize,queueSize,x,y))
            
        }else if(bottomRightCorner(i)){
            vector1 = vector1 :+  Module(new AllToAllPEbottomRightCorner(n,cacheSize,queueSize,x,y))
        }else if(up(i)){
            vector1 = vector1 :+  Module(new AllToAllPEup(n,cacheSize,queueSize,x,y))
            
        }else if(bottom(i)){
            vector1 = vector1 :+  Module(new AllToAllPEbottom(n,cacheSize,queueSize,x,y))
            
        }else if(left(i)){
            vector1 = vector1 :+  Module(new AllToAllPEleft(n,cacheSize,queueSize,x,y))
            
        }else if(right(i)){
            vector1 = vector1 :+  Module(new AllToAllPEright(n,cacheSize,queueSize,x,y))
            
        }else{ //elements not on the borders
            vector1 = vector1 :+  Module(new AllToAllPEmiddle(n,cacheSize,queueSize,x,y))
        }
        
    }
    val vector = vector1


    //connect all PEs with the controller on a common data bus
    //Mesh -> PE
    for(i<-0 to (n*n)-1){

        //input
        vector(i).io.cmd.valid := io.cmd.valid
        vector(i).io.cmd.bits.load := io.cmd.bits.load
        vector(i).io.cmd.bits.store := io.cmd.bits.store
        vector(i).io.cmd.bits.doAllToAll := io.cmd.bits.doAllToAll

        vector(i).io.cmd.bits.rs1 := io.cmd.bits.rs1
        vector(i).io.cmd.bits.rs2 := io.cmd.bits.rs2

        vector(i).io.resp.ready := io.resp.ready

        //when all PE are not busy -> alltoall is terminated
        vector(i).io.end_AllToAll := !io.busy

    }

    //PE -> Mesh
    io.busy := vector.map(_.io.busy).reduce(_ || _)
    io.cmd.ready := vector.map(_.io.cmd.ready).reduce(_ && _)
    io.resp.valid := vector.map(_.io.resp.valid).reduce(_ && _)

    /*
        MUX that puts on io.resp.bits.data the data of the correct PE
    */
    val myVec3 = vector.map{ _.io.resp.bits.write_enable }
    val myVec4 = vector.map{ _.io.resp.bits.data }

    io.resp.bits.data := PriorityMux(myVec3,myVec4)
    

    //connect each PE with each other
    for(i<-0 to (n*n)-1){

        if(upLeftCorner(i)){

            vector(i).io.left.in.valid := false.B
            vector(i).io.left.in.bits.data := zero64
            vector(i).io.left.in.bits.x_0 := zeroValue
            vector(i).io.left.in.bits.y_0 := zeroValue
            vector(i).io.left.in.bits.x_dest := zeroValue
            vector(i).io.left.in.bits.y_dest := zeroValue
            vector(i).io.left.out.ready :=  false.B

            vector(i).io.right.in.valid := vector(i+1).io.left.out.valid
            vector(i).io.right.in.bits.data := vector(i+1).io.left.out.bits.data
            vector(i).io.right.in.bits.x_0 := vector(i+1).io.left.out.bits.x_0
            vector(i).io.right.in.bits.y_0 := vector(i+1).io.left.out.bits.y_0
            vector(i).io.right.in.bits.x_dest := vector(i+1).io.left.out.bits.x_dest
            vector(i).io.right.in.bits.y_dest := vector(i+1).io.left.out.bits.y_dest
            vector(i).io.right.out.ready :=  vector(i+1).io.left.in.ready

            vector(i).io.up.in.valid := false.B
            vector(i).io.up.in.bits.data := zero64
            vector(i).io.up.in.bits.x_0 := zeroValue
            vector(i).io.up.in.bits.y_0 := zeroValue
            vector(i).io.up.in.bits.x_dest := zeroValue
            vector(i).io.up.in.bits.y_dest := zeroValue
            vector(i).io.up.out.ready :=  false.B

            vector(i).io.bottom.in.valid := vector(i+n).io.up.out.valid
            vector(i).io.bottom.in.bits.data := vector(i+n).io.up.out.bits.data
            vector(i).io.bottom.in.bits.x_0 := vector(i+n).io.up.out.bits.x_0
            vector(i).io.bottom.in.bits.y_0 := vector(i+n).io.up.out.bits.y_0
            vector(i).io.bottom.in.bits.x_dest := vector(i+n).io.up.out.bits.x_dest
            vector(i).io.bottom.in.bits.y_dest := vector(i+n).io.up.out.bits.y_dest
            vector(i).io.bottom.out.ready :=  vector(i+n).io.up.in.ready

        }else if(upRightCorner(i)){

            vector(i).io.left.in.valid := vector(i-1).io.right.out.valid
            vector(i).io.left.in.bits.data := vector(i-1).io.right.out.bits.data
            vector(i).io.left.in.bits.x_0 := vector(i-1).io.right.out.bits.x_0
            vector(i).io.left.in.bits.y_0 := vector(i-1).io.right.out.bits.y_0
            vector(i).io.left.in.bits.x_dest := vector(i-1).io.right.out.bits.x_dest
            vector(i).io.left.in.bits.y_dest := vector(i-1).io.right.out.bits.y_dest
            vector(i).io.left.out.ready :=  vector(i-1).io.right.in.ready

            vector(i).io.right.in.valid := false.B
            vector(i).io.right.in.bits.data := zero64
            vector(i).io.right.in.bits.x_0 := zeroValue
            vector(i).io.right.in.bits.y_0 := zeroValue
            vector(i).io.right.in.bits.x_dest := zeroValue
            vector(i).io.right.in.bits.y_dest := zeroValue
            vector(i).io.right.out.ready :=  false.B

            vector(i).io.up.in.valid := false.B
            vector(i).io.up.in.bits.data := zero64
            vector(i).io.up.in.bits.x_0 := zeroValue
            vector(i).io.up.in.bits.y_0 := zeroValue
            vector(i).io.up.in.bits.x_dest := zeroValue
            vector(i).io.up.in.bits.y_dest := zeroValue
            vector(i).io.up.out.ready :=  false.B

            vector(i).io.bottom.in.valid := vector(i+n).io.up.out.valid
            vector(i).io.bottom.in.bits.data := vector(i+n).io.up.out.bits.data
            vector(i).io.bottom.in.bits.x_0 := vector(i+n).io.up.out.bits.x_0
            vector(i).io.bottom.in.bits.y_0 := vector(i+n).io.up.out.bits.y_0
            vector(i).io.bottom.in.bits.x_dest := vector(i+n).io.up.out.bits.x_dest
            vector(i).io.bottom.in.bits.y_dest := vector(i+n).io.up.out.bits.y_dest
            vector(i).io.bottom.out.ready :=  vector(i+n).io.up.in.ready
            
        }else if(bottomLeftCorner(i)){

            vector(i).io.left.in.valid := false.B
            vector(i).io.left.in.bits.data := zero64
            vector(i).io.left.in.bits.x_0 := zeroValue
            vector(i).io.left.in.bits.y_0 := zeroValue
            vector(i).io.left.in.bits.x_dest := zeroValue
            vector(i).io.left.in.bits.y_dest := zeroValue
            vector(i).io.left.out.ready :=  false.B

            vector(i).io.right.in.valid := vector(i+1).io.left.out.valid
            vector(i).io.right.in.bits.data := vector(i+1).io.left.out.bits.data
            vector(i).io.right.in.bits.x_0 := vector(i+1).io.left.out.bits.x_0
            vector(i).io.right.in.bits.y_0 := vector(i+1).io.left.out.bits.y_0
            vector(i).io.right.in.bits.x_dest := vector(i+1).io.left.out.bits.x_dest
            vector(i).io.right.in.bits.y_dest := vector(i+1).io.left.out.bits.y_dest
            vector(i).io.right.out.ready :=  vector(i+1).io.left.in.ready

            vector(i).io.up.in.valid := vector(i-n).io.bottom.out.valid
            vector(i).io.up.in.bits.data := vector(i-n).io.bottom.out.bits.data
            vector(i).io.up.in.bits.x_0 := vector(i-n).io.bottom.out.bits.x_0
            vector(i).io.up.in.bits.y_0 := vector(i-n).io.bottom.out.bits.y_0
            vector(i).io.up.in.bits.x_dest := vector(i-n).io.bottom.out.bits.x_dest
            vector(i).io.up.in.bits.y_dest := vector(i-n).io.bottom.out.bits.y_dest
            vector(i).io.up.out.ready :=  vector(i-n).io.bottom.in.ready

            vector(i).io.bottom.in.valid := false.B
            vector(i).io.bottom.in.bits.data := zero64
            vector(i).io.bottom.in.bits.x_0 := zeroValue
            vector(i).io.bottom.in.bits.y_0 := zeroValue
            vector(i).io.bottom.in.bits.x_dest := zeroValue
            vector(i).io.bottom.in.bits.y_dest := zeroValue
            vector(i).io.bottom.out.ready := false.B
            
        }else if(bottomRightCorner(i)){
            vector(i).io.left.in.valid := vector(i-1).io.right.out.valid
            vector(i).io.left.in.bits.data := vector(i-1).io.right.out.bits.data
            vector(i).io.left.in.bits.x_0 := vector(i-1).io.right.out.bits.x_0
            vector(i).io.left.in.bits.y_0 := vector(i-1).io.right.out.bits.y_0
            vector(i).io.left.in.bits.x_dest := vector(i-1).io.right.out.bits.x_dest
            vector(i).io.left.in.bits.y_dest := vector(i-1).io.right.out.bits.y_dest
            vector(i).io.left.out.ready :=  vector(i-1).io.right.in.ready

            vector(i).io.right.in.valid := false.B
            vector(i).io.right.in.bits.data := zero64
            vector(i).io.right.in.bits.x_0 := zeroValue
            vector(i).io.right.in.bits.y_0 := zeroValue
            vector(i).io.right.in.bits.x_dest := zeroValue
            vector(i).io.right.in.bits.y_dest := zeroValue
            vector(i).io.right.out.ready :=  false.B

            vector(i).io.up.in.valid := vector(i-n).io.bottom.out.valid
            vector(i).io.up.in.bits.data := vector(i-n).io.bottom.out.bits.data
            vector(i).io.up.in.bits.x_0 := vector(i-n).io.bottom.out.bits.x_0
            vector(i).io.up.in.bits.y_0 := vector(i-n).io.bottom.out.bits.y_0
            vector(i).io.up.in.bits.x_dest := vector(i-n).io.bottom.out.bits.x_dest
            vector(i).io.up.in.bits.y_dest := vector(i-n).io.bottom.out.bits.y_dest
            vector(i).io.up.out.ready :=  vector(i-n).io.bottom.in.ready

            vector(i).io.bottom.in.valid := false.B
            vector(i).io.bottom.in.bits.data := zero64
            vector(i).io.bottom.in.bits.x_0 := zeroValue
            vector(i).io.bottom.in.bits.y_0 := zeroValue
            vector(i).io.bottom.in.bits.x_dest := zeroValue
            vector(i).io.bottom.in.bits.y_dest := zeroValue
            vector(i).io.bottom.out.ready := false.B
            
        }else if(up(i)){
            
            vector(i).io.left.in.valid := vector(i-1).io.right.out.valid
            vector(i).io.left.in.bits.data := vector(i-1).io.right.out.bits.data
            vector(i).io.left.in.bits.x_0 := vector(i-1).io.right.out.bits.x_0
            vector(i).io.left.in.bits.y_0 := vector(i-1).io.right.out.bits.y_0
            vector(i).io.left.in.bits.x_dest := vector(i-1).io.right.out.bits.x_dest
            vector(i).io.left.in.bits.y_dest := vector(i-1).io.right.out.bits.y_dest
            vector(i).io.left.out.ready :=  vector(i-1).io.right.in.ready

            vector(i).io.right.in.valid := vector(i+1).io.left.out.valid
            vector(i).io.right.in.bits.data := vector(i+1).io.left.out.bits.data
            vector(i).io.right.in.bits.x_0 := vector(i+1).io.left.out.bits.x_0
            vector(i).io.right.in.bits.y_0 := vector(i+1).io.left.out.bits.y_0
            vector(i).io.right.in.bits.x_dest := vector(i+1).io.left.out.bits.x_dest
            vector(i).io.right.in.bits.y_dest := vector(i+1).io.left.out.bits.y_dest
            vector(i).io.right.out.ready :=  vector(i+1).io.left.in.ready

            vector(i).io.up.in.valid := false.B
            vector(i).io.up.in.bits.data := zero64
            vector(i).io.up.in.bits.x_0 := zeroValue
            vector(i).io.up.in.bits.y_0 := zeroValue
            vector(i).io.up.in.bits.x_dest := zeroValue
            vector(i).io.up.in.bits.y_dest := zeroValue
            vector(i).io.up.out.ready :=  false.B

            vector(i).io.bottom.in.valid := vector(i+n).io.up.out.valid
            vector(i).io.bottom.in.bits.data := vector(i+n).io.up.out.bits.data
            vector(i).io.bottom.in.bits.x_0 := vector(i+n).io.up.out.bits.x_0
            vector(i).io.bottom.in.bits.y_0 := vector(i+n).io.up.out.bits.y_0
            vector(i).io.bottom.in.bits.x_dest := vector(i+n).io.up.out.bits.x_dest
            vector(i).io.bottom.in.bits.y_dest := vector(i+n).io.up.out.bits.y_dest
            vector(i).io.bottom.out.ready :=  vector(i+n).io.up.in.ready
            
        }else if(bottom(i)){
            vector(i).io.left.in.valid := vector(i-1).io.right.out.valid
            vector(i).io.left.in.bits.data := vector(i-1).io.right.out.bits.data
            vector(i).io.left.in.bits.x_0 := vector(i-1).io.right.out.bits.x_0
            vector(i).io.left.in.bits.y_0 := vector(i-1).io.right.out.bits.y_0
            vector(i).io.left.in.bits.x_dest := vector(i-1).io.right.out.bits.x_dest
            vector(i).io.left.in.bits.y_dest := vector(i-1).io.right.out.bits.y_dest
            vector(i).io.left.out.ready :=  vector(i-1).io.right.in.ready

            vector(i).io.right.in.valid := vector(i+1).io.left.out.valid
            vector(i).io.right.in.bits.data := vector(i+1).io.left.out.bits.data
            vector(i).io.right.in.bits.x_0 := vector(i+1).io.left.out.bits.x_0
            vector(i).io.right.in.bits.y_0 := vector(i+1).io.left.out.bits.y_0
            vector(i).io.right.in.bits.x_dest := vector(i+1).io.left.out.bits.x_dest
            vector(i).io.right.in.bits.y_dest := vector(i+1).io.left.out.bits.y_dest
            vector(i).io.right.out.ready :=  vector(i+1).io.left.in.ready

            vector(i).io.up.in.valid := vector(i-n).io.bottom.out.valid
            vector(i).io.up.in.bits.data := vector(i-n).io.bottom.out.bits.data
            vector(i).io.up.in.bits.x_0 := vector(i-n).io.bottom.out.bits.x_0
            vector(i).io.up.in.bits.y_0 := vector(i-n).io.bottom.out.bits.y_0
            vector(i).io.up.in.bits.x_dest := vector(i-n).io.bottom.out.bits.x_dest
            vector(i).io.up.in.bits.y_dest := vector(i-n).io.bottom.out.bits.y_dest
            vector(i).io.up.out.ready :=  vector(i-n).io.bottom.in.ready

            vector(i).io.bottom.in.valid := false.B
            vector(i).io.bottom.in.bits.data := zero64
            vector(i).io.bottom.in.bits.x_0 := zeroValue
            vector(i).io.bottom.in.bits.y_0 := zeroValue
            vector(i).io.bottom.in.bits.x_dest := zeroValue
            vector(i).io.bottom.in.bits.y_dest := zeroValue
            vector(i).io.bottom.out.ready := false.B
            
        }else if(left(i)){
            vector(i).io.left.in.valid := false.B
            vector(i).io.left.in.bits.data := zero64
            vector(i).io.left.in.bits.x_0 := zeroValue
            vector(i).io.left.in.bits.y_0 := zeroValue
            vector(i).io.left.in.bits.x_dest := zeroValue
            vector(i).io.left.in.bits.y_dest := zeroValue
            vector(i).io.left.out.ready :=  false.B

            vector(i).io.right.in.valid := vector(i+1).io.left.out.valid
            vector(i).io.right.in.bits.data := vector(i+1).io.left.out.bits.data
            vector(i).io.right.in.bits.x_0 := vector(i+1).io.left.out.bits.x_0
            vector(i).io.right.in.bits.y_0 := vector(i+1).io.left.out.bits.y_0
            vector(i).io.right.in.bits.x_dest := vector(i+1).io.left.out.bits.x_dest
            vector(i).io.right.in.bits.y_dest := vector(i+1).io.left.out.bits.y_dest
            vector(i).io.right.out.ready :=  vector(i+1).io.left.in.ready

            vector(i).io.up.in.valid := vector(i-n).io.bottom.out.valid
            vector(i).io.up.in.bits.data := vector(i-n).io.bottom.out.bits.data
            vector(i).io.up.in.bits.x_0 := vector(i-n).io.bottom.out.bits.x_0
            vector(i).io.up.in.bits.y_0 := vector(i-n).io.bottom.out.bits.y_0
            vector(i).io.up.in.bits.x_dest := vector(i-n).io.bottom.out.bits.x_dest
            vector(i).io.up.in.bits.y_dest := vector(i-n).io.bottom.out.bits.y_dest
            vector(i).io.up.out.ready :=  vector(i-n).io.bottom.in.ready

            vector(i).io.bottom.in.valid := vector(i+n).io.up.out.valid
            vector(i).io.bottom.in.bits.data := vector(i+n).io.up.out.bits.data
            vector(i).io.bottom.in.bits.x_0 := vector(i+n).io.up.out.bits.x_0
            vector(i).io.bottom.in.bits.y_0 := vector(i+n).io.up.out.bits.y_0
            vector(i).io.bottom.in.bits.x_dest := vector(i+n).io.up.out.bits.x_dest
            vector(i).io.bottom.in.bits.y_dest := vector(i+n).io.up.out.bits.y_dest
            vector(i).io.bottom.out.ready :=  vector(i+n).io.up.in.ready
            
        }else if(right(i)){
            vector(i).io.left.in.valid := vector(i-1).io.right.out.valid
            vector(i).io.left.in.bits.data := vector(i-1).io.right.out.bits.data
            vector(i).io.left.in.bits.x_0 := vector(i-1).io.right.out.bits.x_0
            vector(i).io.left.in.bits.y_0 := vector(i-1).io.right.out.bits.y_0
            vector(i).io.left.in.bits.x_dest := vector(i-1).io.right.out.bits.x_dest
            vector(i).io.left.in.bits.y_dest := vector(i-1).io.right.out.bits.y_dest
            vector(i).io.left.out.ready :=  vector(i-1).io.right.in.ready

            vector(i).io.right.in.valid := false.B
            vector(i).io.right.in.bits.data := zero64
            vector(i).io.right.in.bits.x_0 := zeroValue
            vector(i).io.right.in.bits.y_0 := zeroValue
            vector(i).io.right.in.bits.x_dest := zeroValue
            vector(i).io.right.in.bits.y_dest := zeroValue
            vector(i).io.right.out.ready :=  false.B

            vector(i).io.up.in.valid := vector(i-n).io.bottom.out.valid
            vector(i).io.up.in.bits.data := vector(i-n).io.bottom.out.bits.data
            vector(i).io.up.in.bits.x_0 := vector(i-n).io.bottom.out.bits.x_0
            vector(i).io.up.in.bits.y_0 := vector(i-n).io.bottom.out.bits.y_0
            vector(i).io.up.in.bits.x_dest := vector(i-n).io.bottom.out.bits.x_dest
            vector(i).io.up.in.bits.y_dest := vector(i-n).io.bottom.out.bits.y_dest
            vector(i).io.up.out.ready :=  vector(i-n).io.bottom.in.ready

            vector(i).io.bottom.in.valid := vector(i+n).io.up.out.valid
            vector(i).io.bottom.in.bits.data := vector(i+n).io.up.out.bits.data
            vector(i).io.bottom.in.bits.x_0 := vector(i+n).io.up.out.bits.x_0
            vector(i).io.bottom.in.bits.y_0 := vector(i+n).io.up.out.bits.y_0
            vector(i).io.bottom.in.bits.x_dest := vector(i+n).io.up.out.bits.x_dest
            vector(i).io.bottom.in.bits.y_dest := vector(i+n).io.up.out.bits.y_dest
            vector(i).io.bottom.out.ready :=  vector(i+n).io.up.in.ready
            
        }else{ //elements not on the borders

            vector(i).io.left.in.valid := vector(i-1).io.right.out.valid
            vector(i).io.left.in.bits.data := vector(i-1).io.right.out.bits.data
            vector(i).io.left.in.bits.x_0 := vector(i-1).io.right.out.bits.x_0
            vector(i).io.left.in.bits.y_0 := vector(i-1).io.right.out.bits.y_0
            vector(i).io.left.in.bits.x_dest := vector(i-1).io.right.out.bits.x_dest
            vector(i).io.left.in.bits.y_dest := vector(i-1).io.right.out.bits.y_dest
            vector(i).io.left.out.ready :=  vector(i-1).io.right.in.ready

            vector(i).io.right.in.valid := vector(i+1).io.left.out.valid
            vector(i).io.right.in.bits.data := vector(i+1).io.left.out.bits.data
            vector(i).io.right.in.bits.x_0 := vector(i+1).io.left.out.bits.x_0
            vector(i).io.right.in.bits.y_0 := vector(i+1).io.left.out.bits.y_0
            vector(i).io.right.in.bits.x_dest := vector(i+1).io.left.out.bits.x_dest
            vector(i).io.right.in.bits.y_dest := vector(i+1).io.left.out.bits.y_dest
            vector(i).io.right.out.ready :=  vector(i+1).io.left.in.ready

            vector(i).io.up.in.valid := vector(i-n).io.bottom.out.valid
            vector(i).io.up.in.bits.data := vector(i-n).io.bottom.out.bits.data
            vector(i).io.up.in.bits.x_0 := vector(i-n).io.bottom.out.bits.x_0
            vector(i).io.up.in.bits.y_0 := vector(i-n).io.bottom.out.bits.y_0
            vector(i).io.up.in.bits.x_dest := vector(i-n).io.bottom.out.bits.x_dest
            vector(i).io.up.in.bits.y_dest := vector(i-n).io.bottom.out.bits.y_dest
            vector(i).io.up.out.ready :=  vector(i-n).io.bottom.in.ready

            vector(i).io.bottom.in.valid := vector(i+n).io.up.out.valid
            vector(i).io.bottom.in.bits.data := vector(i+n).io.up.out.bits.data
            vector(i).io.bottom.in.bits.x_0 := vector(i+n).io.up.out.bits.x_0
            vector(i).io.bottom.in.bits.y_0 := vector(i+n).io.up.out.bits.y_0
            vector(i).io.bottom.in.bits.x_dest := vector(i+n).io.up.out.bits.x_dest
            vector(i).io.bottom.in.bits.y_dest := vector(i+n).io.up.out.bits.y_dest
            vector(i).io.bottom.out.ready :=  vector(i+n).io.up.in.ready
        }
        
    }


}
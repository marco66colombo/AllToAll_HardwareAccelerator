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
class AllToAllMesh(n : Int, cacheSize : Int) extends Module{

    val io = IO(new MeshIO)

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

    def x_coord(i: Int): Int = (i%n)
    def y_coord(i: Int): Int = ((n-1)-(i/n))

    var x,y = 0

    //create the PEs of the mesh and assigning them the coordinates (x,y)
    for(i<-0 to (n*n)-1){

        x = x_coord(i)
        y = y_coord(i)

        if(upLeftCorner(i)){
            vector1 = vector1 :+  Module(new AllToAllPEupLeftCorner(n,cacheSize,x,y))

        }else if(upRightCorner(i)){
            vector1 = vector1 :+  Module(new AllToAllPEupRightCorner(n,cacheSize,x,y))
            
        }else if(bottomLeftCorner(i)){
            vector1 = vector1 :+  Module(new AllToAllPEbottomLeftCorner(n,cacheSize,x,y))
            
        }else if(bottomRightCorner(i)){
            vector1 = vector1 :+  Module(new AllToAllPEbottomRightCorner(n,cacheSize,x,y))
        }else if(up(i)){
            vector1 = vector1 :+  Module(new AllToAllPEup(n,cacheSize,x,y))
            
        }else if(bottom(i)){
            vector1 = vector1 :+  Module(new AllToAllPEbottom(n,cacheSize,x,y))
            
        }else if(left(i)){
            vector1 = vector1 :+  Module(new AllToAllPEleft(n,cacheSize,x,y))
            
        }else if(right(i)){
            vector1 = vector1 :+  Module(new AllToAllPEright(n,cacheSize,x,y))
            
        }else{ //elements not on the borders
            vector1 = vector1 :+  Module(new AllToAllPEmiddle(n,cacheSize,x,y))
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

    }

    //PE -> Mesh
    io.busy := vector.map(_.io.busy).reduce(_ || _)
    io.cmd.ready := vector.map(_.io.cmd.ready).reduce(_ && _)
    io.resp.valid := vector.map(_.io.resp.valid).reduce(_ && _)

    /*
        MUX that puts on io.resp.bits.data the data of the correct PE
    */

    /*
    //compute number of PE starting from rs2
    def n_from_xy(i: UInt): UInt = {
        val x = i(15,0)
        val y = i(31,16)
        ((n.U-1.U-y)*n.U+x)
    }

    //can be a problem since division?
    val nPE = n_from_xy(io.cmd.bits.rs2)

    var myVec1 = Seq((nPE === 0.U) -> (vector(0).io.resp.bits.data))
     
    for(i<-1 to (n*n)-1){
        myVec1 :+ ((nPE === i.U) -> (vector(i).io.resp.bits.data))
    }

    val myVec = myVec1

    //io.resp.bits.data corresponds to the data conained in PE which has indexes x,y
    io.resp.bits.data := PriorityMux(myVec)
    */

    //var myVec1 = Seq((vector(0).io.resp.bits.write_enable === true.B) -> (vector(0).io.resp.bits.data))
    /*
    var myVec2 = Seq(vector(0).io.resp.bits.data)
    var myVec1 = Seq(vector(0).io.resp.bits.write_enable)
    for(i<- 1 to (n*n)-1){
        myVec1 :+ (vector(i).io.resp.bits.write_enable)
        myVec2 :+ (vector(i).io.resp.bits.data)
    } */

 
    /*   
    for(i<-1 to (n*n)-1){
        myVec1 :+ ((vector(i).io.resp.bits.write_enable === true.B) -> (vector(i).io.resp.bits.data))
    }*/

    //val myVec3 = myVec1
    //val myVec4 = myVec2

    val myVec3 = Seq(vector(0).io.resp.bits.write_enable,vector(1).io.resp.bits.write_enable,vector(2).io.resp.bits.write_enable,vector(3).io.resp.bits.write_enable,vector(4).io.resp.bits.write_enable,vector(5).io.resp.bits.write_enable,vector(6).io.resp.bits.write_enable,vector(7).io.resp.bits.write_enable,vector(8).io.resp.bits.write_enable)
    val myVec4 = Seq(vector(0).io.resp.bits.data,vector(1).io.resp.bits.data,vector(2).io.resp.bits.data,vector(3).io.resp.bits.data,vector(4).io.resp.bits.data,vector(5).io.resp.bits.data,vector(6).io.resp.bits.data,vector(7).io.resp.bits.data,vector(8).io.resp.bits.data)
    io.resp.bits.data := PriorityMux(myVec3,myVec4)
    

    //connect each PE with each other
    for(i<-0 to (n*n)-1){

        if(upLeftCorner(i)){
         
            vector(i).io.left.in := zero64
            vector(i).io.up.in := zero64
            
            vector(i).io.right.in := vector(i+1).io.left.out
            vector(i).io.bottom.in := vector(i+n).io.up.out

        }else if(upRightCorner(i)){
            
            vector(i).io.right.in := zero64
            vector(i).io.up.in := zero64
            
            vector(i).io.left.in := vector(i-1).io.right.out
            vector(i).io.bottom.in := vector(i+n).io.up.out
            
        }else if(bottomLeftCorner(i)){
            
            vector(i).io.left.in := zero64
            vector(i).io.bottom.in := zero64
            
            vector(i).io.right.in := vector(i+1).io.left.out
            vector(i).io.up.in := vector(i-n).io.bottom.out
            
        }else if(bottomRightCorner(i)){
            
            vector(i).io.right.in := zero64
            vector(i).io.bottom.in := zero64
            
            vector(i).io.left.in := vector(i-1).io.right.out
            vector(i).io.up.in := vector(i-n).io.bottom.out
            
        }else if(up(i)){
            
            vector(i).io.up.in := zero64

            vector(i).io.left.in := vector(i-1).io.right.out
            vector(i).io.right.in := vector(i+1).io.left.out
            vector(i).io.bottom.in := vector(i+n).io.up.out
            
        }else if(bottom(i)){
         
            vector(i).io.bottom.in := zero64

            vector(i).io.left.in := vector(i-1).io.right.out
            vector(i).io.right.in := vector(i+1).io.left.out
            vector(i).io.up.in := vector(i-n).io.bottom.out
            
        }else if(left(i)){

            vector(i).io.left.in := zero64

            vector(i).io.right.in := vector(i+1).io.left.out
            vector(i).io.up.in := vector(i-n).io.bottom.out
            vector(i).io.bottom.in := vector(i+n).io.up.out
            
        }else if(right(i)){
           
            vector(i).io.right.in := zero64

            vector(i).io.left.in := vector(i-1).io.right.out
            vector(i).io.up.in := vector(i-n).io.bottom.out
            vector(i).io.bottom.in := vector(i+n).io.up.out
            
        }else{ //elements not on the borders

            vector(i).io.left.in := vector(i-1).io.right.out
            vector(i).io.right.in := vector(i+1).io.left.out
            vector(i).io.up.in := vector(i-n).io.bottom.out
            vector(i).io.bottom.in := vector(i+n).io.up.out

        }
        
    }


}
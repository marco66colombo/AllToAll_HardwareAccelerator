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

    var vector1 = Seq[AllToAllPE]()
  
    def upLeftCorner(i: Int): Boolean = (i == ((n*n)-n))
    def upRightCorner(i: Int): Boolean = (i == ((n*n)-1))
    def bottomLeftCorner(i: Int): Boolean = (i == 0)
    def bottomRightCorner(i: Int): Boolean = (i == (n-1))

    def up(i: Int): Boolean = (i > ((n*n)-n) && i < ((n*n)-1))
    def bottom(i: Int): Boolean = ( i > 0 && i < n-1)
    def left(i: Int): Boolean = (!upLeftCorner(i) && !bottomLeftCorner(i) && (i%n == 0))
    def right(i: Int): Boolean = (!upRightCorner(i) && !bottomRightCorner(i) && (i%n == (n-1)))

    def x_coord(i: Int): Int = (i%n)
    def y_coord(i: Int): Int = (i/n)

    var x,y = 0

    //create the PEs of the mesh and assigning them the coordinates (x,y)
    for(i<-0 to (n*n)-1){

        x = x_coord(i)
        y = y_coord(i)

        vector1 = vector1 :+  Module(new AllToAllPE(n,cacheSize,queueSize,x,y))
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

    val no_valid_input = Wire(new OutputPE(log2Up(n)))
    no_valid_input.data := 0.U
    no_valid_input.x_0 := 0.U
    no_valid_input.y_0 := 0.U
    no_valid_input.x_dest := 0.U
    no_valid_input.y_dest := 0.U
    no_valid_input.pos := 0.U
    

    //connect each PE with each other
    for(i<-0 to (n*n)-1){

        if(upLeftCorner(i)){

            vector(i).io.left.in.valid := false.B
            vector(i).io.left.in.bits <> no_valid_input
            vector(i).io.left.out.ready :=  false.B

            vector(i).io.right.in.valid := vector(i+1).io.left.out.valid
            vector(i).io.right.in.bits <> vector(i+1).io.left.out.bits
            vector(i).io.right.out.ready :=  vector(i+1).io.left.in.ready

            
            vector(i).io.up.in.valid := false.B
            vector(i).io.up.in.bits <> no_valid_input
            vector(i).io.up.out.ready :=  false.B
    
            vector(i).io.bottom.in.valid := vector(i-n).io.up.out.valid
            vector(i).io.bottom.in.bits <> vector(i-n).io.up.out.bits
            vector(i).io.bottom.out.ready :=  vector(i-n).io.up.in.ready

        }else if(upRightCorner(i)){

            vector(i).io.left.in.valid := vector(i-1).io.right.out.valid
            vector(i).io.left.in.bits <> vector(i-1).io.right.out.bits
            vector(i).io.left.out.ready :=  vector(i-1).io.right.in.ready

            vector(i).io.right.in.valid := false.B
            vector(i).io.right.in.bits <> no_valid_input
            vector(i).io.right.out.ready :=  false.B

            vector(i).io.up.in.valid := false.B
            vector(i).io.up.in.bits <> no_valid_input
            vector(i).io.up.out.ready :=  false.B
            
            vector(i).io.bottom.in.valid := vector(i-n).io.up.out.valid
            vector(i).io.bottom.in.bits <> vector(i-n).io.up.out.bits
            vector(i).io.bottom.out.ready :=  vector(i-n).io.up.in.ready
            
        }else if(bottomLeftCorner(i)){

            vector(i).io.left.in.valid := false.B
            vector(i).io.left.in.bits <> no_valid_input
            vector(i).io.left.out.ready :=  false.B

            vector(i).io.right.in.valid := vector(i+1).io.left.out.valid
            vector(i).io.right.in.bits <> vector(i+1).io.left.out.bits
            vector(i).io.right.out.ready :=  vector(i+1).io.left.in.ready

            vector(i).io.up.in.valid := vector(i+n).io.bottom.out.valid
            vector(i).io.up.in.bits <> vector(i+n).io.bottom.out.bits
            vector(i).io.up.out.ready :=  vector(i+n).io.bottom.in.ready

            vector(i).io.bottom.in.valid := false.B
            vector(i).io.bottom.in.bits <> no_valid_input
            vector(i).io.bottom.out.ready := false.B
            
        }else if(bottomRightCorner(i)){

            vector(i).io.left.in.valid := vector(i-1).io.right.out.valid
            vector(i).io.left.in.bits <> vector(i-1).io.right.out.bits
            vector(i).io.left.out.ready :=  vector(i-1).io.right.in.ready

            vector(i).io.right.in.valid := false.B
            vector(i).io.right.in.bits <> no_valid_input
            vector(i).io.right.out.ready :=  false.B
        
            vector(i).io.up.in.valid := vector(i+n).io.bottom.out.valid
            vector(i).io.up.in.bits <> vector(i+n).io.bottom.out.bits
            vector(i).io.up.out.ready :=  vector(i+n).io.bottom.in.ready

            vector(i).io.bottom.in.valid := false.B
            vector(i).io.bottom.in.bits <> no_valid_input
            vector(i).io.bottom.out.ready := false.B
            
        }else if(up(i)){
            
            vector(i).io.left.in.valid := vector(i-1).io.right.out.valid
            vector(i).io.left.in.bits <> vector(i-1).io.right.out.bits
            vector(i).io.left.out.ready :=  vector(i-1).io.right.in.ready

            vector(i).io.right.in.valid := vector(i+1).io.left.out.valid
            vector(i).io.right.in.bits <> vector(i+1).io.left.out.bits
            vector(i).io.right.out.ready :=  vector(i+1).io.left.in.ready

            vector(i).io.up.in.valid := false.B
            vector(i).io.up.in.bits <> no_valid_input
            vector(i).io.up.out.ready :=  false.B

            vector(i).io.bottom.in.valid := vector(i-n).io.up.out.valid
            vector(i).io.bottom.in.bits <> vector(i-n).io.up.out.bits
            vector(i).io.bottom.out.ready :=  vector(i-n).io.up.in.ready
            
        }else if(bottom(i)){

            vector(i).io.left.in.valid := vector(i-1).io.right.out.valid
            vector(i).io.left.in.bits <> vector(i-1).io.right.out.bits
            vector(i).io.left.out.ready :=  vector(i-1).io.right.in.ready

            vector(i).io.right.in.valid := vector(i+1).io.left.out.valid
            vector(i).io.right.in.bits <> vector(i+1).io.left.out.bits
            vector(i).io.right.out.ready :=  vector(i+1).io.left.in.ready

            vector(i).io.up.in.valid := vector(i+n).io.bottom.out.valid
            vector(i).io.up.in.bits <> vector(i+n).io.bottom.out.bits
            vector(i).io.up.out.ready :=  vector(i+n).io.bottom.in.ready

            vector(i).io.bottom.in.valid := false.B
            vector(i).io.bottom.in.bits <> no_valid_input
            vector(i).io.bottom.out.ready := false.B
            
        }else if(left(i)){

            vector(i).io.left.in.valid := false.B
            vector(i).io.left.in.bits <> no_valid_input
            vector(i).io.left.out.ready :=  false.B

            vector(i).io.right.in.valid := vector(i+1).io.left.out.valid
            vector(i).io.right.in.bits <> vector(i+1).io.left.out.bits
            vector(i).io.right.out.ready :=  vector(i+1).io.left.in.ready

            vector(i).io.up.in.valid := vector(i+n).io.bottom.out.valid
            vector(i).io.up.in.bits <> vector(i+n).io.bottom.out.bits
            vector(i).io.up.out.ready :=  vector(i+n).io.bottom.in.ready

            vector(i).io.bottom.in.valid := vector(i-n).io.up.out.valid
            vector(i).io.bottom.in.bits <> vector(i-n).io.up.out.bits
            vector(i).io.bottom.out.ready :=  vector(i-n).io.up.in.ready
            
        }else if(right(i)){

            vector(i).io.left.in.valid := vector(i-1).io.right.out.valid
            vector(i).io.left.in.bits <> vector(i-1).io.right.out.bits
            vector(i).io.left.out.ready :=  vector(i-1).io.right.in.ready

            vector(i).io.right.in.valid := false.B
            vector(i).io.right.in.bits <> no_valid_input
            vector(i).io.right.out.ready :=  false.B

            vector(i).io.up.in.valid := vector(i+n).io.bottom.out.valid
            vector(i).io.up.in.bits <> vector(i+n).io.bottom.out.bits
            vector(i).io.up.out.ready :=  vector(i+n).io.bottom.in.ready

            vector(i).io.bottom.in.valid := vector(i-n).io.up.out.valid
            vector(i).io.bottom.in.bits <> vector(i-n).io.up.out.bits
            vector(i).io.bottom.out.ready :=  vector(i-n).io.up.in.ready
            
        }else{ //elements not on the borders

            vector(i).io.left.in.valid := vector(i-1).io.right.out.valid
            vector(i).io.left.in.bits <> vector(i-1).io.right.out.bits
            vector(i).io.left.out.ready :=  vector(i-1).io.right.in.ready

            vector(i).io.right.in.valid := vector(i+1).io.left.out.valid
            vector(i).io.right.in.bits <> vector(i+1).io.left.out.bits
            vector(i).io.right.out.ready :=  vector(i+1).io.left.in.ready

            vector(i).io.up.in.valid := vector(i+n).io.bottom.out.valid
            vector(i).io.up.in.bits <> vector(i+n).io.bottom.out.bits
            vector(i).io.up.out.ready :=  vector(i+n).io.bottom.in.ready

            vector(i).io.bottom.in.valid := vector(i-n).io.up.out.valid
            vector(i).io.bottom.in.bits <> vector(i-n).io.up.out.bits
            vector(i).io.bottom.out.ready :=  vector(i-n).io.up.in.ready
        }
        
    }

}
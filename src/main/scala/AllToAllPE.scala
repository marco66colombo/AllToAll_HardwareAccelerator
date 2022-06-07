package hppsProject

import freechips.rocketchip.tile._
import hppsProject._
import chisel3._
import chisel3.util._
import chisel3.experimental.IntParam
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.util.InOrderArbiter


class AllToAllPE(n : Int, cacheSize: Int, queueSize: Int, x : Int, y : Int) extends Module{

  var bitsWidth = log2Up(n)
  
  val io = IO(new AllToAllPEIO(bitsWidth))

  //memory
  val memPE = Mem(cacheSize, UInt(64.W)) 

  //It represents the number of the PE -> at most 2^16 PE -> n of mesh max 2^8 = 256
  val x_coord = RegInit(UInt(bitsWidth.W),x.U)
  val y_coord = RegInit(UInt(bitsWidth.W),y.U)
  
  val dim_N = Reg(Bits(16.W))
  val offset = Reg(UInt(32.W))
  val index_write_this_PE = Reg(UInt(32.W))
  
  //store rs1 and rs2 values and keep for all the cycle
  val rs1 = Reg(Bits(64.W))
  val rs2 = Reg(Bits(64.W))
  rs1 := io.cmd.bits.rs1
  rs2 := io.cmd.bits.rs2

  //notify when the response is ready
  val w_en = RegInit(Bool(),false.B)

  //states
  val idle :: action :: wait_action_resp :: action_resp :: do_load :: do_store :: store_resp :: stall_state :: Nil = Enum(8)

  val state = RegInit(idle) 
  val resp_value = RegInit(Bits(64.W),0.U)
  
  val x_value = rs2(15,0)
  val y_value = rs2(31,16)
  val memIndex = rs2(63,32)
  
  /*
    transitions values
  */
  val is_this_PE = (x_value === x_coord) && (y_value === y_coord)
  val load_signal = io.cmd.valid && io.cmd.bits.load 
  val store_signal = io.cmd.valid && io.cmd.bits.store 
  val allToAll_signal = io.cmd.valid && io.cmd.bits.doAllToAll 
  val stall_resp = !io.resp.ready && io.resp.valid
  val start_AllToAll = state === action

  val index_calcualtor = Module(new IndexCalculatorV1(n,n*n,bitsWidth))

  val end_push_data = Reg(Bool())
  val read_values = Reg(Vec(4, Bits(64.W)))
  val read_values_valid = RegInit(VecInit(Seq.fill(4)(false.B)))
  val read_x_dest = Reg(Vec(4,UInt(bitsWidth.W)))
  val read_y_dest = Reg(Vec(4,UInt(bitsWidth.W)))
  val read_pos = Reg(Vec(4,UInt(16.W)))

  val this_PE_generation_0= (read_x_dest(0) === x_coord) && (read_y_dest(0) === y_coord)
  val this_PE_generation_1= (read_x_dest(1) === x_coord) && (read_y_dest(1) === y_coord)
  val this_PE_generation_2= (read_x_dest(2) === x_coord) && (read_y_dest(2) === y_coord)
  val this_PE_generation_3= (read_x_dest(3) === x_coord) && (read_y_dest(3) === y_coord)

  val do_read = !read_values_valid(0) && !read_values_valid(1) && !read_values_valid(2) && !read_values_valid(3)

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


  //input queues, one for each edge of the PE
  val left_in = Queue(io.left.in, queueSize)
  val right_in = Queue(io.right.in, queueSize)
  val up_in = Queue(io.up.in, queueSize)
  val bottom_in = Queue(io.bottom.in, queueSize)

  //busy if there is something to read from input or something to write in output
  val left_busy = left_in.valid || io.left.out.valid
  val right_busy = right_in.valid || io.right.out.valid
  val up_busy = up_in.valid || io.up.out.valid
  val bottom_busy = bottom_in.valid || io.bottom.out.valid

  //dispatchers -> given value of input queue says where to forward the message
  //one dispatcher for each input queue of the PE
  val left_dispatcher = Module(new Dispatcher(bitsWidth))
  val right_dispatcher = Module(new Dispatcher(bitsWidth))
  val up_dispatcher = Module(new Dispatcher(bitsWidth))
  val bottom_dispatcher = Module(new Dispatcher(bitsWidth))

  //given the data read from memory says where to forward the message
  //during the generation phase, it is possible to read 4 mem lines at a time, so 4 dispatchers 
  //are required to manage each of these lines (they are independent, no assumptions can be done)
  val generation_dispatcher_0 = Module(new GenerationDispatcher(bitsWidth))
  val generation_dispatcher_1 = Module(new GenerationDispatcher(bitsWidth))
  val generation_dispatcher_2 = Module(new GenerationDispatcher(bitsWidth))
  val generation_dispatcher_3 = Module(new GenerationDispatcher(bitsWidth))

  //connect dispatchers input to the input queues
  left_dispatcher.io.x_0 := left_in.bits.x_0
  left_dispatcher.io.y_0 := left_in.bits.y_0
  left_dispatcher.io.x_dest := left_in.bits.x_dest
  left_dispatcher.io.y_dest := left_in.bits.y_dest
  left_dispatcher.io.x_PE := x_coord
  left_dispatcher.io.y_PE := y_coord

  right_dispatcher.io.x_0 := right_in.bits.x_0
  right_dispatcher.io.y_0 := right_in.bits.y_0
  right_dispatcher.io.x_dest := right_in.bits.x_dest
  right_dispatcher.io.y_dest := right_in.bits.y_dest
  right_dispatcher.io.x_PE := x_coord
  right_dispatcher.io.y_PE := y_coord

  up_dispatcher.io.x_0 := up_in.bits.x_0
  up_dispatcher.io.y_0 := up_in.bits.y_0
  up_dispatcher.io.x_dest := up_in.bits.x_dest
  up_dispatcher.io.y_dest := up_in.bits.y_dest
  up_dispatcher.io.x_PE := x_coord
  up_dispatcher.io.y_PE := y_coord

  bottom_dispatcher.io.x_0 := bottom_in.bits.x_0
  bottom_dispatcher.io.y_0 := bottom_in.bits.y_0
  bottom_dispatcher.io.x_dest := bottom_in.bits.x_dest
  bottom_dispatcher.io.y_dest := bottom_in.bits.y_dest
  bottom_dispatcher.io.x_PE := x_coord
  bottom_dispatcher.io.y_PE := y_coord

  //connect generation dispatchers to the buffer in which the 4 mem lines are temporarily stored
  generation_dispatcher_0.io.x_PE := x_coord
  generation_dispatcher_0.io.y_PE := y_coord
  generation_dispatcher_0.io.x_dest := read_x_dest(0)
  generation_dispatcher_0.io.y_dest := read_y_dest(0)

  generation_dispatcher_1.io.x_PE := x_coord
  generation_dispatcher_1.io.y_PE := y_coord
  generation_dispatcher_1.io.x_dest := read_x_dest(1)
  generation_dispatcher_1.io.y_dest := read_y_dest(1)

  generation_dispatcher_2.io.x_PE := x_coord
  generation_dispatcher_2.io.y_PE := y_coord
  generation_dispatcher_2.io.x_dest := read_x_dest(2)
  generation_dispatcher_2.io.y_dest := read_y_dest(2)

  generation_dispatcher_3.io.x_PE := x_coord
  generation_dispatcher_3.io.y_PE := y_coord
  generation_dispatcher_3.io.x_dest := read_x_dest(3)
  generation_dispatcher_3.io.y_dest := read_y_dest(3)


  //when a message in input has as destination the current PE, that message must be written in memory and not forwarded
  //write into mem at index + n*n
  when(left_dispatcher.io.this_PE){
    //memPE(left_in.bits.x_0 + left_in.bits.y_0 * n.U + offset) := left_in.bits.data
    memPE((left_in.bits.x_0 + left_in.bits.y_0 * n.U)*dim_N + left_in.bits.pos + offset) := left_in.bits.data
  }

  when(right_dispatcher.io.this_PE){
    //memPE(right_in.bits.x_0 + right_in.bits.y_0 * n.U + offset) := right_in.bits.data
    memPE((right_in.bits.x_0 + right_in.bits.y_0 * n.U)*dim_N + right_in.bits.pos + offset) := right_in.bits.data
  }

  when(up_dispatcher.io.this_PE){
    //memPE(up_in.bits.x_0 + up_in.bits.y_0 * n.U + offset) := up_in.bits.data
    memPE((up_in.bits.x_0 + up_in.bits.y_0 * n.U)*dim_N + up_in.bits.pos + offset) := up_in.bits.data
  }

  when(bottom_dispatcher.io.this_PE){
    //memPE(bottom_in.bits.x_0 + bottom_in.bits.y_0 * n.U + offset) := bottom_in.bits.data
    memPE((bottom_in.bits.x_0 + bottom_in.bits.y_0 * n.U)*dim_N + bottom_in.bits.pos + offset) := bottom_in.bits.data
  }

  //modules that implements a priority multiplexer
  //when more than one line of the buffer wants to forward data to the same output queue,
  //since only one line at a time can be handled by the output queue, only one of these messages can pass
  //this is handled by this multiplexers
  val left_mux = Module(new MyPriorityMux(bitsWidth))
  val right_mux = Module(new MyPriorityMux(bitsWidth))
  val up_mux = Module(new MyPriorityMux(bitsWidth))
  val bottom_mux = Module(new MyPriorityMux(bitsWidth))

  //connections of the input signals of the muxes

  //left out queue
  left_mux.io.valid(0) := read_values_valid(0) && generation_dispatcher_0.io.left && !this_PE_generation_0
  left_mux.io.valid(1) := read_values_valid(1) && generation_dispatcher_1.io.left && !this_PE_generation_1
  left_mux.io.valid(2) := read_values_valid(2) && generation_dispatcher_2.io.left && !this_PE_generation_2
  left_mux.io.valid(3) := read_values_valid(3) && generation_dispatcher_3.io.left && !this_PE_generation_3

  left_mux.io.in_bits(0).data := read_values(0)
  left_mux.io.in_bits(0).x_0 := x_coord
  left_mux.io.in_bits(0).y_0 := y_coord
  left_mux.io.in_bits(0).x_dest := read_x_dest(0)
  left_mux.io.in_bits(0).y_dest := read_y_dest(0)
  left_mux.io.in_bits(0).pos := read_pos(0)
  
  left_mux.io.in_bits(1).data := read_values(1)
  left_mux.io.in_bits(1).x_0 := x_coord
  left_mux.io.in_bits(1).y_0 := y_coord
  left_mux.io.in_bits(1).x_dest := read_x_dest(1)
  left_mux.io.in_bits(1).y_dest := read_y_dest(1)
  left_mux.io.in_bits(1).pos := read_pos(1)

  left_mux.io.in_bits(2).data := read_values(2)
  left_mux.io.in_bits(2).x_0 := x_coord
  left_mux.io.in_bits(2).y_0 := y_coord
  left_mux.io.in_bits(2).x_dest := read_x_dest(2)
  left_mux.io.in_bits(2).y_dest := read_y_dest(2)
  left_mux.io.in_bits(2).pos := read_pos(2)

  left_mux.io.in_bits(3).data := read_values(3)
  left_mux.io.in_bits(3).x_0 := x_coord
  left_mux.io.in_bits(3).y_0 := y_coord
  left_mux.io.in_bits(3).x_dest := read_x_dest(3)
  left_mux.io.in_bits(3).y_dest := read_y_dest(3)
  left_mux.io.in_bits(3).pos := read_pos(3)

  //right out queue
  right_mux.io.valid(0) := read_values_valid(0) && generation_dispatcher_0.io.right && !this_PE_generation_0
  right_mux.io.valid(1) := read_values_valid(1) && generation_dispatcher_1.io.right && !this_PE_generation_1
  right_mux.io.valid(2) := read_values_valid(2) && generation_dispatcher_2.io.right && !this_PE_generation_2
  right_mux.io.valid(3) := read_values_valid(3) && generation_dispatcher_3.io.right && !this_PE_generation_3

  right_mux.io.in_bits(0).data := read_values(0)
  right_mux.io.in_bits(0).x_0 := x_coord
  right_mux.io.in_bits(0).y_0 := y_coord
  right_mux.io.in_bits(0).x_dest := read_x_dest(0)
  right_mux.io.in_bits(0).y_dest := read_y_dest(0)
  right_mux.io.in_bits(0).pos := read_pos(0)
  
  right_mux.io.in_bits(1).data := read_values(1)
  right_mux.io.in_bits(1).x_0 := x_coord
  right_mux.io.in_bits(1).y_0 := y_coord
  right_mux.io.in_bits(1).x_dest := read_x_dest(1)
  right_mux.io.in_bits(1).y_dest := read_y_dest(1)
  right_mux.io.in_bits(1).pos := read_pos(1)

  right_mux.io.in_bits(2).data := read_values(2)
  right_mux.io.in_bits(2).x_0 := x_coord
  right_mux.io.in_bits(2).y_0 := y_coord
  right_mux.io.in_bits(2).x_dest := read_x_dest(2)
  right_mux.io.in_bits(2).y_dest := read_y_dest(2)
  right_mux.io.in_bits(2).pos := read_pos(2)

  right_mux.io.in_bits(3).data := read_values(3)
  right_mux.io.in_bits(3).x_0 := x_coord
  right_mux.io.in_bits(3).y_0 := y_coord
  right_mux.io.in_bits(3).x_dest := read_x_dest(3)
  right_mux.io.in_bits(3).y_dest := read_y_dest(3)
  right_mux.io.in_bits(3).pos := read_pos(3)

  //up out queue
  up_mux.io.valid(0) := read_values_valid(0) && generation_dispatcher_0.io.up && !this_PE_generation_0
  up_mux.io.valid(1) := read_values_valid(1) && generation_dispatcher_1.io.up && !this_PE_generation_1
  up_mux.io.valid(2) := read_values_valid(2) && generation_dispatcher_2.io.up && !this_PE_generation_2
  up_mux.io.valid(3) := read_values_valid(3) && generation_dispatcher_3.io.up && !this_PE_generation_3

  up_mux.io.in_bits(0).data := read_values(0)
  up_mux.io.in_bits(0).x_0 := x_coord
  up_mux.io.in_bits(0).y_0 := y_coord
  up_mux.io.in_bits(0).x_dest := read_x_dest(0)
  up_mux.io.in_bits(0).y_dest := read_y_dest(0)
  up_mux.io.in_bits(0).pos := read_pos(0)
  
  up_mux.io.in_bits(1).data := read_values(1)
  up_mux.io.in_bits(1).x_0 := x_coord
  up_mux.io.in_bits(1).y_0 := y_coord
  up_mux.io.in_bits(1).x_dest := read_x_dest(1)
  up_mux.io.in_bits(1).y_dest := read_y_dest(1)
  up_mux.io.in_bits(1).pos := read_pos(1)

  up_mux.io.in_bits(2).data := read_values(2)
  up_mux.io.in_bits(2).x_0 := x_coord
  up_mux.io.in_bits(2).y_0 := y_coord
  up_mux.io.in_bits(2).x_dest := read_x_dest(2)
  up_mux.io.in_bits(2).y_dest := read_y_dest(2)
  up_mux.io.in_bits(2).pos := read_pos(2)

  up_mux.io.in_bits(3).data := read_values(3)
  up_mux.io.in_bits(3).x_0 := x_coord
  up_mux.io.in_bits(3).y_0 := y_coord
  up_mux.io.in_bits(3).x_dest := read_x_dest(3)
  up_mux.io.in_bits(3).y_dest := read_y_dest(3)
  up_mux.io.in_bits(3).pos := read_pos(3)

  //bottom out queue
  bottom_mux.io.valid(0) := read_values_valid(0) && generation_dispatcher_0.io.bottom && !this_PE_generation_0
  bottom_mux.io.valid(1) := read_values_valid(1) && generation_dispatcher_1.io.bottom && !this_PE_generation_1
  bottom_mux.io.valid(2) := read_values_valid(2) && generation_dispatcher_2.io.bottom && !this_PE_generation_2
  bottom_mux.io.valid(3) := read_values_valid(3) && generation_dispatcher_3.io.bottom && !this_PE_generation_3

  bottom_mux.io.in_bits(0).data := read_values(0)
  bottom_mux.io.in_bits(0).x_0 := x_coord
  bottom_mux.io.in_bits(0).y_0 := y_coord
  bottom_mux.io.in_bits(0).x_dest := read_x_dest(0)
  bottom_mux.io.in_bits(0).y_dest := read_y_dest(0)
  bottom_mux.io.in_bits(0).pos := read_pos(0)
  
  bottom_mux.io.in_bits(1).data := read_values(1)
  bottom_mux.io.in_bits(1).x_0 := x_coord
  bottom_mux.io.in_bits(1).y_0 := y_coord
  bottom_mux.io.in_bits(1).x_dest := read_x_dest(1)
  bottom_mux.io.in_bits(1).y_dest := read_y_dest(1)
  bottom_mux.io.in_bits(1).pos := read_pos(1)

  bottom_mux.io.in_bits(2).data := read_values(2)
  bottom_mux.io.in_bits(2).x_0 := x_coord
  bottom_mux.io.in_bits(2).y_0 := y_coord
  bottom_mux.io.in_bits(2).x_dest := read_x_dest(2)
  bottom_mux.io.in_bits(2).y_dest := read_y_dest(2)
  bottom_mux.io.in_bits(2).pos := read_pos(2)

  bottom_mux.io.in_bits(3).data := read_values(3)
  bottom_mux.io.in_bits(3).x_0 := x_coord
  bottom_mux.io.in_bits(3).y_0 := y_coord
  bottom_mux.io.in_bits(3).x_dest := read_x_dest(3)
  bottom_mux.io.in_bits(3).y_dest := read_y_dest(3)
  bottom_mux.io.in_bits(3).pos := read_pos(3)


  /*
    round robin arbiters that selects which input is given to the output queue
    there are 4 possible inputs for each ouput queue:
      input 0: the output of the correspondent priority mux, it represents data generated by the current PE
      input 1-3: the ouputs of the 3 remaining input queues that try to write in output
  */
  val left_out_arbiter = Module(new RRArbiter(new OutputPE(bitsWidth),4))
  val right_out_arbiter = Module(new RRArbiter(new OutputPE(bitsWidth),4))
  val up_out_arbiter = Module(new RRArbiter(new OutputPE(bitsWidth),4))
  val bottom_out_arbiter =Module(new RRArbiter(new OutputPE(bitsWidth),4))

  //output queues
  val left_out = Queue(left_out_arbiter.io.out, queueSize)
  val right_out = Queue(right_out_arbiter.io.out, queueSize)
  val up_out = Queue(up_out_arbiter.io.out, queueSize)
  val bottom_out = Queue(bottom_out_arbiter.io.out, queueSize)

  //connect output queues to the ouptput of the PE
  io.left.out <> left_out
  io.right.out <> right_out
  io.up.out <> up_out
  io.bottom.out <> bottom_out


  //connect input of the arbiter with output of the dispatcher
  //arbiter.io.in(0) is connected with the data generated by the PE 
  //(so connected with the output of the correspondent mux)

  //left edge
  left_out_arbiter.io.in(0).valid := left_mux.io.out_valid 
  left_out_arbiter.io.in(0).bits <> left_mux.io.out_val.bits 
  left_out_arbiter.io.in(1).bits <> right_in.bits
  left_out_arbiter.io.in(1).valid := right_dispatcher.io.left && right_in.valid
  left_out_arbiter.io.in(2).bits <> up_in.bits
  left_out_arbiter.io.in(2).valid := up_dispatcher.io.left && up_in.valid
  left_out_arbiter.io.in(3).bits <> bottom_in.bits
  left_out_arbiter.io.in(3).valid := bottom_dispatcher.io.left && bottom_in.valid

  //right edge
  right_out_arbiter.io.in(0).valid := right_mux.io.out_valid
  right_out_arbiter.io.in(0).bits <> right_mux.io.out_val.bits
  right_out_arbiter.io.in(1).bits <> left_in.bits
  right_out_arbiter.io.in(1).valid := left_dispatcher.io.right && left_in.valid
  right_out_arbiter.io.in(2).bits <> up_in.bits
  right_out_arbiter.io.in(2).valid := up_dispatcher.io.right && up_in.valid
  right_out_arbiter.io.in(3).bits <> bottom_in.bits
  right_out_arbiter.io.in(3).valid := bottom_dispatcher.io.right && bottom_in.valid

  //up edge
  up_out_arbiter.io.in(0).valid := up_mux.io.out_valid
  up_out_arbiter.io.in(0).bits <> up_mux.io.out_val.bits
  up_out_arbiter.io.in(1).bits <> left_in.bits
  up_out_arbiter.io.in(1).valid := left_dispatcher.io.up && left_in.valid
  up_out_arbiter.io.in(2).bits <> right_in.bits
  up_out_arbiter.io.in(2).valid := right_dispatcher.io.up && right_in.valid
  up_out_arbiter.io.in(3).bits <> bottom_in.bits
  up_out_arbiter.io.in(3).valid := bottom_dispatcher.io.up && bottom_in.valid

  //bottom edge
  bottom_out_arbiter.io.in(0).valid := bottom_mux.io.out_valid
  bottom_out_arbiter.io.in(0).bits <> bottom_mux.io.out_val.bits
  bottom_out_arbiter.io.in(1).bits <> left_in.bits
  bottom_out_arbiter.io.in(1).valid := left_dispatcher.io.bottom && left_in.valid
  bottom_out_arbiter.io.in(2).bits <> right_in.bits
  bottom_out_arbiter.io.in(2).valid := right_dispatcher.io.bottom && right_in.valid
  bottom_out_arbiter.io.in(3).bits <> up_in.bits
  bottom_out_arbiter.io.in(3).valid := up_dispatcher.io.bottom && up_in.valid

  //manage ready bits of input queues (queue.io.deq.ready)
  //ready if: the message has to be written in memory or one output queue accepts it
  left_in.ready := left_dispatcher.io.this_PE || 
                  (left_dispatcher.io.right && right_out_arbiter.io.in(1).ready) ||
                  (left_dispatcher.io.up && up_out_arbiter.io.in(1).ready) ||
                  (left_dispatcher.io.bottom && bottom_out_arbiter.io.in(1).ready)
  
  right_in.ready := right_dispatcher.io.this_PE || 
                  (right_dispatcher.io.left && left_out_arbiter.io.in(1).ready) ||
                  (right_dispatcher.io.up && up_out_arbiter.io.in(2).ready) ||
                  (right_dispatcher.io.bottom && bottom_out_arbiter.io.in(2).ready)
  
  up_in.ready := up_dispatcher.io.this_PE || 
                  (up_dispatcher.io.left && left_out_arbiter.io.in(2).ready) ||
                  (up_dispatcher.io.right && right_out_arbiter.io.in(2).ready) ||
                  (up_dispatcher.io.bottom && bottom_out_arbiter.io.in(3).ready)

  bottom_in.ready := bottom_dispatcher.io.this_PE || 
                  (bottom_dispatcher.io.left && left_out_arbiter.io.in(3).ready) ||
                  (bottom_dispatcher.io.right && right_out_arbiter.io.in(3).ready) ||
                  (bottom_dispatcher.io.up && up_out_arbiter.io.in(3).ready)

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  when(state === idle){
    io.busy := false.B
    io.cmd.ready := true.B
    io.resp.valid := false.B
    io.resp.bits.data := 0.U

    io.resp.bits.write_enable := false.B
    w_en := false.B

    dim_N := io.cmd.bits.rs1(15,0)

    when(load_signal){
      state := do_load
    }.elsewhen(store_signal){
      state := do_store
    }.elsewhen(allToAll_signal){
      state := action
    }.otherwise{
      state := idle
    }

  }.elsewhen(state === do_load){
    io.busy := stall_resp
    io.cmd.ready := !stall_resp
    io.resp.valid := true.B
    io.resp.bits.data := 32.U
    resp_value := 32.U

    when(is_this_PE){
      memPE(memIndex) := rs1
      io.resp.bits.write_enable := true.B
      w_en := true.B
    }.otherwise{
      io.resp.bits.write_enable := false.B
      w_en := false.B
    }
   
    dim_N := io.cmd.bits.rs1(15,0)

    when(load_signal && !stall_resp){
      state := do_load
    }.elsewhen(store_signal && !stall_resp){
      state := do_store
    }.elsewhen(allToAll_signal && !stall_resp){
      state := action
    }.elsewhen(stall_resp){
      state := stall_state
    }.otherwise{
      state := idle
    }

  }.elsewhen(state === do_store){

    io.busy := true.B
    io.cmd.ready := false.B
    io.resp.valid := false.B
    io.resp.bits.data := 33.U
    
    when(is_this_PE){
      resp_value := memPE(memIndex)
      w_en := true.B
    }.otherwise{
      w_en := false.B
    }

    io.resp.bits.write_enable := false.B

    state := store_resp

  }.elsewhen(state === store_resp){

    io.busy := stall_resp
    io.cmd.ready := !stall_resp
    io.resp.valid := true.B
    io.resp.bits.data := resp_value
    io.resp.bits.write_enable := w_en

    dim_N := io.cmd.bits.rs1(15,0)
  
    when(load_signal && !stall_resp){
      state := do_load
    }.elsewhen(store_signal && !stall_resp){
      state := do_store
    }.elsewhen(allToAll_signal && !stall_resp){
      state := action
    }.elsewhen(stall_resp){
      state := stall_state
    }.otherwise{
      state := idle
    }
    
  }.elsewhen(state === stall_state){
    
    io.busy := true.B
    io.cmd.ready := false.B
    io.resp.valid := true.B
    io.resp.bits.data := resp_value

    io.resp.bits.write_enable := w_en
  
    when(stall_resp){
      state := stall_state
    }.otherwise{
      state := idle
    }
    
  }.elsewhen(state === action){

    io.busy := true.B
    io.cmd.ready := false.B
    io.resp.valid := false.B
    io.resp.bits.data := 30.U

    io.resp.bits.write_enable := false.B

    offset := (n*n).U * dim_N

    end_push_data := false.B

    state := wait_action_resp

  }.elsewhen(state === wait_action_resp){
    //busy iff at least one edge is busy
    io.busy := (left_busy || right_busy || up_busy || bottom_busy || !end_push_data)
    io.cmd.ready := false.B
    io.resp.valid := false.B
    io.resp.bits.data := 31.U

    index_write_this_PE := ((x+y*n).U * dim_N + offset)

    io.resp.bits.write_enable := false.B
    
    when (io.end_AllToAll){
      state := action_resp
    }.otherwise{
      state := wait_action_resp
    }

  }.elsewhen(state === action_resp){

    io.busy := false.B
    io.cmd.ready := false.B
    io.resp.valid := true.B
    io.resp.bits.data := 35.U
    //priority mux will take the first PE, not a problem since data of response are not used
    io.resp.bits.write_enable := true.B

    state := idle

  }.otherwise{
    
    io.busy := false.B
    io.cmd.ready := false.B
    io.resp.valid := false.B
    io.resp.bits.data := "b10101010101010101010101010101010".U(64.W)
    io.resp.bits.write_enable := true.B
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  //states
  val idle1 :: action1 :: Nil = Enum(2)

  val stateAction = RegInit(idle1) 

  index_calcualtor.io.dim_N := dim_N
  
  when(stateAction === idle1){

    index_calcualtor.io.enable := true.B
    index_calcualtor.io.reset := true.B
    
    read_values_valid(0) := false.B
    read_values_valid(1) := false.B
    read_values_valid(2) := false.B
    read_values_valid(3) := false.B

    when(start_AllToAll){
      stateAction := action1
    }.otherwise{
      stateAction := idle1
    }
  }.elsewhen(stateAction === action1){//cycle to push data into queues

    index_calcualtor.io.reset := false.B

    
    when(do_read && !index_calcualtor.io.last_iteration){
      
      index_calcualtor.io.enable := true.B

      read_values(0) := memPE(index_calcualtor.io.index0)
      read_values(1) := memPE(index_calcualtor.io.index1)
      read_values(2) := memPE(index_calcualtor.io.index2)
      read_values(3) := memPE(index_calcualtor.io.index3)

      read_values_valid(0) := index_calcualtor.io.valid0
      read_values_valid(1) := index_calcualtor.io.valid1
      read_values_valid(2) := index_calcualtor.io.valid2
      read_values_valid(3) := index_calcualtor.io.valid3

      read_x_dest(0) := index_calcualtor.io.x_dest_0
      read_x_dest(1) := index_calcualtor.io.x_dest_1
      read_x_dest(2) := index_calcualtor.io.x_dest_2
      read_x_dest(3) := index_calcualtor.io.x_dest_3

      read_y_dest(0) := index_calcualtor.io.y_dest_0
      read_y_dest(1) := index_calcualtor.io.y_dest_1
      read_y_dest(2) := index_calcualtor.io.y_dest_2
      read_y_dest(3) := index_calcualtor.io.y_dest_3

      read_pos(0) := index_calcualtor.io.pos_0
      read_pos(1) := index_calcualtor.io.pos_1
      read_pos(2) := index_calcualtor.io.pos_2
      read_pos(3) := index_calcualtor.io.pos_3

    }.otherwise{

      index_calcualtor.io.enable := false.B

      val left_fire = left_out_arbiter.io.in(0).ready
      val right_fire = right_out_arbiter.io.in(0).ready
      val up_fire = up_out_arbiter.io.in(0).ready
      val bottom_fire = bottom_out_arbiter.io.in(0).ready
    
      read_values_valid(0) := !(((left_mux.io.out_val.selected === "b0001".U) && left_fire) ||
                                ((right_mux.io.out_val.selected === "b0001".U) && right_fire) ||
                                ((up_mux.io.out_val.selected === "b0001".U) && up_fire) ||
                                ((bottom_mux.io.out_val.selected === "b0001".U) && bottom_fire) ||
                                this_PE_generation_0 ) && read_values_valid(0)

      read_values_valid(1) := !(((left_mux.io.out_val.selected === "b0010".U) && left_fire) ||
                                ((right_mux.io.out_val.selected === "b0010".U) && right_fire) ||
                                ((up_mux.io.out_val.selected === "b0010".U) && up_fire) ||
                                ((bottom_mux.io.out_val.selected === "b0010".U) && bottom_fire) ||
                                this_PE_generation_1 ) && read_values_valid(1)

      read_values_valid(2) := !(((left_mux.io.out_val.selected === "b0100".U) && left_fire) ||
                                ((right_mux.io.out_val.selected === "b0100".U) && right_fire) ||
                                ((up_mux.io.out_val.selected === "b0100".U) && up_fire) ||
                                ((bottom_mux.io.out_val.selected === "b0100".U) && bottom_fire) ||
                                this_PE_generation_2 ) && read_values_valid(2)

      read_values_valid(3) := !(((left_mux.io.out_val.selected === "b1000".U) && left_fire) ||
                                ((right_mux.io.out_val.selected === "b1000".U) && right_fire) ||
                                ((up_mux.io.out_val.selected === "b1000".U) && up_fire) ||
                                ((bottom_mux.io.out_val.selected === "b1000".U) && bottom_fire) ||
                                this_PE_generation_3 ) && read_values_valid(3)
    

      when(this_PE_generation_0){
        memPE(index_write_this_PE + read_pos(0)) := read_values(0)
      }
      when(this_PE_generation_1){
        memPE(index_write_this_PE + read_pos(1)) := read_values(1)
      }
      when(this_PE_generation_2){
        memPE(index_write_this_PE + read_pos(2)) := read_values(2)
      }
      when(this_PE_generation_3){
        memPE(index_write_this_PE + read_pos(3)) := read_values(3)
      }

    }

    //if last iteration and all values have been read -> goto idle
    when(index_calcualtor.io.last_iteration && do_read){
      end_push_data := true.B
      stateAction := idle1
    }.otherwise{
      stateAction := action1
    }

  }.otherwise{

    index_calcualtor.io.enable := true.B
    index_calcualtor.io.reset := true.B

    //error
  }

  
}

/*
class AllTOAllPEcorner(n : Int, cacheSize: Int, id : Int) extends AllToAllPE{
  override val io = IO(new AllToAllPEIOcorner)
  io.side1.out := 0.U(64.W)
  io.side2.out := 0.U(64.W)
 
  io.data := 0.U(64.W)

}

class AllTOAllPEedge(n : Int, cacheSize: Int, id : Int) extends AllToAllPE{
  override val io = IO(new AllToAllPEIOedge)
  io.side1.out := 0.U(64.W)
  io.side2.out := 0.U(64.W)
  io.side3.out := 0.U(64.W)
 
  io.data := 0.U(64.W)
  
}

class AllTOAllPEmiddle(n : Int, cacheSize: Int, id : Int) extends AllToAllPE{
  override val io = IO(new AllToAllPEIOmiddle)
  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  io.down.out := 0.U(64.W)
  io.data := 0.U(64.W)
  
}
*/
class AllToAllPEupLeftCorner(n : Int, cacheSize: Int, queueSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,queueSize,x,y){
  /*
  //io.left.in :=  0.U(64.W)
  io.left.out :=  0.U(64.W)
  //io.up.in :=  0.U(64.W)
  io.up.out :=  0.U(64.W)

  io.right.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 */
}

class AllToAllPEupRightCorner(n : Int, cacheSize: Int, queueSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,queueSize,x,y){
 /* 
  //io.right.in :=  0.U(64.W)
  io.right.out :=  0.U(64.W)
  //io.up.in :=  0.U(64.W)
  io.up.out :=  0.U(64.W)

  io.left.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
*/
}

class AllToAllPEbottomLeftCorner(n : Int, cacheSize: Int, queueSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,queueSize,x,y){
 /* 
  //io.left.in :=  0.U(64.W)
  io.left.out :=  0.U(64.W)
  //io.bottom.in :=  0.U(64.W)
  io.bottom.out :=  0.U(64.W)


  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
 
*/
}
class AllToAllPEbottomRightCorner(n : Int, cacheSize: Int, queueSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,queueSize,x,y){
 /* 
  //io.right.in :=  0.U(64.W)
  io.right.out :=  0.U(64.W)
  //io.bottom.in :=  0.U(64.W)
  io.bottom.out :=  0.U(64.W)

  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  
*/
}
class AllToAllPEup(n : Int, cacheSize: Int, queueSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,queueSize,x,y){
 /*
  //io.up.in :=  0.U(64.W)
  io.up.out :=  0.U(64.W)

  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 */
}
class AllToAllPEbottom(n : Int, cacheSize: Int, queueSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,queueSize,x,y){
 /* 
  //io.bottom.in :=  0.U(64.W)
  io.bottom.out :=  0.U(64.W)

  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
*/ 

}
class AllToAllPEleft(n : Int, cacheSize: Int, queueSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,queueSize,x,y){
 /* 
  
  //io.left.in :=  0.U(64.W)
  io.left.out :=  0.U(64.W)

  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
*/

}
class AllToAllPEright(n : Int, cacheSize: Int, queueSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,queueSize,x,y){
/*
  //io.right.in :=  0.U(64.W)
  io.right.out :=  0.U(64.W)

  io.left.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 
*/
}
class AllToAllPEmiddle(n : Int, cacheSize: Int, queueSize: Int, x : Int, y : Int) extends AllToAllPE(n,cacheSize,queueSize,x,y){
 /*
  io.left.out := 0.U(64.W)
  io.right.out := 0.U(64.W)
  io.up.out := 0.U(64.W)
  io.bottom.out := 0.U(64.W)
 */
}


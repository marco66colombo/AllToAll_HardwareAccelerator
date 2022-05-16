circuit AllToAllPE :
  module Queue :
    input clock : Clock
    input reset : UInt<1>
    output io_enq_ready : UInt<1>
    input io_enq_valid : UInt<1>
    input io_enq_bits_data : UInt<64>
    input io_enq_bits_x_0 : UInt<16>
    input io_enq_bits_y_0 : UInt<16>
    input io_enq_bits_x_dest : UInt<16>
    input io_enq_bits_y_dest : UInt<16>
    input io_deq_ready : UInt<1>
    output io_deq_valid : UInt<1>
    output io_deq_bits_data : UInt<64>
    output io_deq_bits_x_0 : UInt<16>
    output io_deq_bits_y_0 : UInt<16>
    output io_deq_bits_x_dest : UInt<16>
    output io_deq_bits_y_dest : UInt<16>
    output io_count : UInt<7>

    mem ram_data : @[Decoupled.scala 218:16]
      data-type => UInt<64>
      depth => 81
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_x_0 : @[Decoupled.scala 218:16]
      data-type => UInt<16>
      depth => 81
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_y_0 : @[Decoupled.scala 218:16]
      data-type => UInt<16>
      depth => 81
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_x_dest : @[Decoupled.scala 218:16]
      data-type => UInt<16>
      depth => 81
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_y_dest : @[Decoupled.scala 218:16]
      data-type => UInt<16>
      depth => 81
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    reg value : UInt<7>, clock with :
      reset => (UInt<1>("h0"), value) @[Counter.scala 60:40]
    reg value_1 : UInt<7>, clock with :
      reset => (UInt<1>("h0"), value_1) @[Counter.scala 60:40]
    reg maybe_full : UInt<1>, clock with :
      reset => (UInt<1>("h0"), maybe_full) @[Decoupled.scala 221:27]
    node ptr_match = eq(value, value_1) @[Decoupled.scala 223:33]
    node _empty_T = eq(maybe_full, UInt<1>("h0")) @[Decoupled.scala 224:28]
    node empty = and(ptr_match, _empty_T) @[Decoupled.scala 224:25]
    node full = and(ptr_match, maybe_full) @[Decoupled.scala 225:24]
    node _do_enq_T = and(io_enq_ready, io_enq_valid) @[Decoupled.scala 40:37]
    node _do_deq_T = and(io_deq_ready, io_deq_valid) @[Decoupled.scala 40:37]
    node wrap = eq(value, UInt<7>("h50")) @[Counter.scala 72:24]
    node _value_T = add(value, UInt<1>("h1")) @[Counter.scala 76:24]
    node _value_T_1 = tail(_value_T, 1) @[Counter.scala 76:24]
    node _GEN_0 = mux(wrap, UInt<1>("h0"), _value_T_1) @[Counter.scala 86:20 Counter.scala 86:28 Counter.scala 76:15]
    node do_enq = _do_enq_T
    node _GEN_1 = validif(do_enq, value) @[Decoupled.scala 229:17 Decoupled.scala 230:8]
    node _GEN_2 = validif(do_enq, clock) @[Decoupled.scala 229:17 Decoupled.scala 230:8]
    node _GEN_3 = mux(do_enq, UInt<1>("h1"), UInt<1>("h0")) @[Decoupled.scala 229:17 Decoupled.scala 230:8 Decoupled.scala 218:16]
    node _GEN_4 = validif(do_enq, UInt<1>("h1")) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_5 = validif(do_enq, io_enq_bits_y_dest) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_6 = validif(do_enq, io_enq_bits_x_dest) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_7 = validif(do_enq, io_enq_bits_y_0) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_8 = validif(do_enq, io_enq_bits_x_0) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_9 = validif(do_enq, io_enq_bits_data) @[Decoupled.scala 229:17 Decoupled.scala 230:24]
    node _GEN_10 = mux(do_enq, _GEN_0, value) @[Decoupled.scala 229:17 Counter.scala 60:40]
    node wrap_1 = eq(value_1, UInt<7>("h50")) @[Counter.scala 72:24]
    node _value_T_2 = add(value_1, UInt<1>("h1")) @[Counter.scala 76:24]
    node _value_T_3 = tail(_value_T_2, 1) @[Counter.scala 76:24]
    node _GEN_11 = mux(wrap_1, UInt<1>("h0"), _value_T_3) @[Counter.scala 86:20 Counter.scala 86:28 Counter.scala 76:15]
    node do_deq = _do_deq_T
    node _GEN_12 = mux(do_deq, _GEN_11, value_1) @[Decoupled.scala 233:17 Counter.scala 60:40]
    node _T = neq(do_enq, do_deq) @[Decoupled.scala 236:16]
    node _GEN_13 = mux(_T, do_enq, maybe_full) @[Decoupled.scala 236:28 Decoupled.scala 237:16 Decoupled.scala 221:27]
    node _io_deq_valid_T = eq(empty, UInt<1>("h0")) @[Decoupled.scala 240:19]
    node _io_enq_ready_T = eq(full, UInt<1>("h0")) @[Decoupled.scala 241:19]
    node _ptr_diff_T = sub(value, value_1) @[Decoupled.scala 257:32]
    node ptr_diff = tail(_ptr_diff_T, 1) @[Decoupled.scala 257:32]
    node _io_count_T = mux(maybe_full, UInt<7>("h51"), UInt<1>("h0")) @[Decoupled.scala 262:24]
    node _io_count_T_1 = gt(value_1, value) @[Decoupled.scala 264:39]
    node _io_count_T_2 = add(UInt<7>("h51"), ptr_diff) @[Decoupled.scala 265:38]
    node _io_count_T_3 = tail(_io_count_T_2, 1) @[Decoupled.scala 265:38]
    node _io_count_T_4 = mux(_io_count_T_1, _io_count_T_3, ptr_diff) @[Decoupled.scala 264:24]
    node _io_count_T_5 = mux(ptr_match, _io_count_T, _io_count_T_4) @[Decoupled.scala 261:20]
    io_enq_ready <= _io_enq_ready_T @[Decoupled.scala 241:16]
    io_deq_valid <= _io_deq_valid_T @[Decoupled.scala 240:16]
    io_deq_bits_data <= ram_data.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_deq_bits_x_0 <= ram_x_0.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_deq_bits_y_0 <= ram_y_0.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_deq_bits_x_dest <= ram_x_dest.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_deq_bits_y_dest <= ram_y_dest.io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    io_count <= _io_count_T_5 @[Decoupled.scala 261:14]
    ram_data.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_x_0.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_y_0.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_x_dest.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_y_dest.io_deq_bits_MPORT.addr <= value_1 @[Decoupled.scala 242:21]
    ram_data.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_x_0.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_y_0.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_x_dest.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_y_dest.io_deq_bits_MPORT.en <= UInt<1>("h1") @[Decoupled.scala 242:21]
    ram_data.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_x_0.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_y_0.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_x_dest.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_y_dest.io_deq_bits_MPORT.clk <= clock @[Decoupled.scala 242:21]
    ram_data.MPORT.addr <= _GEN_1
    ram_x_0.MPORT.addr <= _GEN_1
    ram_y_0.MPORT.addr <= _GEN_1
    ram_x_dest.MPORT.addr <= _GEN_1
    ram_y_dest.MPORT.addr <= _GEN_1
    ram_data.MPORT.en <= _GEN_3
    ram_x_0.MPORT.en <= _GEN_3
    ram_y_0.MPORT.en <= _GEN_3
    ram_x_dest.MPORT.en <= _GEN_3
    ram_y_dest.MPORT.en <= _GEN_3
    ram_data.MPORT.clk <= _GEN_2
    ram_x_0.MPORT.clk <= _GEN_2
    ram_y_0.MPORT.clk <= _GEN_2
    ram_x_dest.MPORT.clk <= _GEN_2
    ram_y_dest.MPORT.clk <= _GEN_2
    ram_data.MPORT.data <= _GEN_9
    ram_x_0.MPORT.data <= _GEN_8
    ram_y_0.MPORT.data <= _GEN_7
    ram_x_dest.MPORT.data <= _GEN_6
    ram_y_dest.MPORT.data <= _GEN_5
    ram_data.MPORT.mask <= _GEN_4
    ram_x_0.MPORT.mask <= _GEN_4
    ram_y_0.MPORT.mask <= _GEN_4
    ram_x_dest.MPORT.mask <= _GEN_4
    ram_y_dest.MPORT.mask <= _GEN_4
    value <= mux(reset, UInt<7>("h0"), _GEN_10) @[Counter.scala 60:40 Counter.scala 60:40]
    value_1 <= mux(reset, UInt<7>("h0"), _GEN_12) @[Counter.scala 60:40 Counter.scala 60:40]
    maybe_full <= mux(reset, UInt<1>("h0"), _GEN_13) @[Decoupled.scala 221:27 Decoupled.scala 221:27]

  module AllToAllPE :
    input clock : Clock
    input reset : UInt<1>
    output io_busy : UInt<1>
    output io_cmd_ready : UInt<1>
    input io_cmd_valid : UInt<1>
    input io_cmd_bits_load : UInt<1>
    input io_cmd_bits_store : UInt<1>
    input io_cmd_bits_doAllToAll : UInt<1>
    input io_cmd_bits_rs1 : UInt<64>
    input io_cmd_bits_rs2 : UInt<64>
    input io_resp_ready : UInt<1>
    output io_resp_valid : UInt<1>
    output io_resp_bits_data : UInt<64>
    output io_resp_bits_write_enable : UInt<1>
    input io_left_out_ready : UInt<1>
    output io_left_out_valid : UInt<1>
    output io_left_out_bits_data : UInt<64>
    output io_left_out_bits_x_0 : UInt<16>
    output io_left_out_bits_y_0 : UInt<16>
    output io_left_out_bits_x_dest : UInt<16>
    output io_left_out_bits_y_dest : UInt<16>
    output io_left_in_ready : UInt<1>
    input io_left_in_valid : UInt<1>
    input io_left_in_bits_data : UInt<64>
    input io_left_in_bits_x_0 : UInt<16>
    input io_left_in_bits_y_0 : UInt<16>
    input io_left_in_bits_x_dest : UInt<16>
    input io_left_in_bits_y_dest : UInt<16>
    input io_right_out_ready : UInt<1>
    output io_right_out_valid : UInt<1>
    output io_right_out_bits_data : UInt<64>
    output io_right_out_bits_x_0 : UInt<16>
    output io_right_out_bits_y_0 : UInt<16>
    output io_right_out_bits_x_dest : UInt<16>
    output io_right_out_bits_y_dest : UInt<16>
    output io_right_in_ready : UInt<1>
    input io_right_in_valid : UInt<1>
    input io_right_in_bits_data : UInt<64>
    input io_right_in_bits_x_0 : UInt<16>
    input io_right_in_bits_y_0 : UInt<16>
    input io_right_in_bits_x_dest : UInt<16>
    input io_right_in_bits_y_dest : UInt<16>
    input io_up_out_ready : UInt<1>
    output io_up_out_valid : UInt<1>
    output io_up_out_bits_data : UInt<64>
    output io_up_out_bits_x_0 : UInt<16>
    output io_up_out_bits_y_0 : UInt<16>
    output io_up_out_bits_x_dest : UInt<16>
    output io_up_out_bits_y_dest : UInt<16>
    output io_up_in_ready : UInt<1>
    input io_up_in_valid : UInt<1>
    input io_up_in_bits_data : UInt<64>
    input io_up_in_bits_x_0 : UInt<16>
    input io_up_in_bits_y_0 : UInt<16>
    input io_up_in_bits_x_dest : UInt<16>
    input io_up_in_bits_y_dest : UInt<16>
    input io_bottom_out_ready : UInt<1>
    output io_bottom_out_valid : UInt<1>
    output io_bottom_out_bits_data : UInt<64>
    output io_bottom_out_bits_x_0 : UInt<16>
    output io_bottom_out_bits_y_0 : UInt<16>
    output io_bottom_out_bits_x_dest : UInt<16>
    output io_bottom_out_bits_y_dest : UInt<16>
    output io_bottom_in_ready : UInt<1>
    input io_bottom_in_valid : UInt<1>
    input io_bottom_in_bits_data : UInt<64>
    input io_bottom_in_bits_x_0 : UInt<16>
    input io_bottom_in_bits_y_0 : UInt<16>
    input io_bottom_in_bits_x_dest : UInt<16>
    input io_bottom_in_bits_y_dest : UInt<16>

    mem memPE : @[AllToAllPE.scala 129:18]
      data-type => UInt<64>
      depth => 1024
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    inst left_in of Queue @[Decoupled.scala 296:21]
    inst right_in of Queue @[Decoupled.scala 296:21]
    inst up_in of Queue @[Decoupled.scala 296:21]
    inst bottom_in of Queue @[Decoupled.scala 296:21]
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:24]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 136:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 137:16]
    reg w_en : UInt<1>, clock with :
      reset => (UInt<1>("h0"), w_en) @[AllToAllPE.scala 145:21]
    reg state : UInt<3>, clock with :
      reset => (UInt<1>("h0"), state) @[AllToAllPE.scala 150:22]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 151:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 153:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 154:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 155:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 163:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 163:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 163:42]
    node load_signal = and(io_cmd_valid, io_cmd_bits_load) @[AllToAllPE.scala 164:34]
    node store_signal = and(io_cmd_valid, io_cmd_bits_store) @[AllToAllPE.scala 165:35]
    node allToAll_signal = and(io_cmd_valid, io_cmd_bits_doAllToAll) @[AllToAllPE.scala 166:38]
    node _T_2 = eq(io_resp_ready, UInt<1>("h0")) @[AllToAllPE.scala 168:20]
    node stall_resp = and(_T_2, io_resp_valid) @[AllToAllPE.scala 168:35]
    node _T_3 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 170:14]
    node _GEN_0 = mux(allToAll_signal, UInt<3>("h1"), UInt<3>("h0")) @[AllToAllPE.scala 183:32 AllToAllPE.scala 184:13 AllToAllPE.scala 186:13]
    node _GEN_1 = mux(store_signal, UInt<3>("h4"), _GEN_0) @[AllToAllPE.scala 181:29 AllToAllPE.scala 182:13]
    node _GEN_2 = mux(load_signal, UInt<3>("h3"), _GEN_1) @[AllToAllPE.scala 179:22 AllToAllPE.scala 180:13]
    node _T_4 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 189:20]
    node _T_5 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 191:21]
    node _T_6 = bits(memIndex, 9, 0) @[AllToAllPE.scala 197:12]
    node _GEN_3 = validif(is_this_PE, _T_6) @[AllToAllPE.scala 196:21 AllToAllPE.scala 197:12]
    node _GEN_4 = validif(is_this_PE, clock) @[AllToAllPE.scala 196:21 AllToAllPE.scala 197:12]
    node _GEN_5 = mux(is_this_PE, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 196:21 AllToAllPE.scala 197:12 AllToAllPE.scala 129:18]
    node _GEN_6 = validif(is_this_PE, UInt<1>("h1")) @[AllToAllPE.scala 196:21 AllToAllPE.scala 197:23]
    node _GEN_7 = validif(is_this_PE, rs1) @[AllToAllPE.scala 196:21 AllToAllPE.scala 197:23]
    node _T_7 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 205:25]
    node _T_8 = and(load_signal, _T_7) @[AllToAllPE.scala 205:22]
    node _T_9 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 207:32]
    node _T_10 = and(store_signal, _T_9) @[AllToAllPE.scala 207:29]
    node _T_11 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 209:35]
    node _T_12 = and(allToAll_signal, _T_11) @[AllToAllPE.scala 209:32]
    node _GEN_8 = mux(stall_resp, UInt<3>("h6"), UInt<3>("h0")) @[AllToAllPE.scala 211:27 AllToAllPE.scala 212:13 AllToAllPE.scala 214:13]
    node _GEN_9 = mux(_T_12, UInt<3>("h1"), _GEN_8) @[AllToAllPE.scala 209:47 AllToAllPE.scala 210:13]
    node _GEN_10 = mux(_T_10, UInt<3>("h4"), _GEN_9) @[AllToAllPE.scala 207:44 AllToAllPE.scala 208:13]
    node _GEN_11 = mux(_T_8, UInt<3>("h3"), _GEN_10) @[AllToAllPE.scala 205:37 AllToAllPE.scala 206:13]
    node _T_13 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 217:20]
    node _T_14 = bits(memIndex, 9, 0) @[AllToAllPE.scala 225:26]
    node _GEN_12 = validif(is_this_PE, _T_14) @[AllToAllPE.scala 224:21 AllToAllPE.scala 225:26]
    node _GEN_13 = mux(is_this_PE, memPE.MPORT_1.data, resp_value) @[AllToAllPE.scala 224:21 AllToAllPE.scala 225:18 AllToAllPE.scala 151:27]
    node _T_15 = eq(state, UInt<3>("h5")) @[AllToAllPE.scala 235:20]
    node _T_16 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 238:21]
    node _T_17 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 243:25]
    node _T_18 = and(load_signal, _T_17) @[AllToAllPE.scala 243:22]
    node _T_19 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 245:32]
    node _T_20 = and(store_signal, _T_19) @[AllToAllPE.scala 245:29]
    node _T_21 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 247:35]
    node _T_22 = and(allToAll_signal, _T_21) @[AllToAllPE.scala 247:32]
    node _GEN_14 = mux(_T_22, UInt<3>("h1"), _GEN_8) @[AllToAllPE.scala 247:47 AllToAllPE.scala 248:13]
    node _GEN_15 = mux(_T_20, UInt<3>("h4"), _GEN_14) @[AllToAllPE.scala 245:44 AllToAllPE.scala 246:13]
    node _GEN_16 = mux(_T_18, UInt<3>("h3"), _GEN_15) @[AllToAllPE.scala 243:37 AllToAllPE.scala 244:13]
    node _T_23 = eq(state, UInt<3>("h6")) @[AllToAllPE.scala 255:20]
    node _T_24 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 270:20]
    node _T_25 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 281:20]
    node _GEN_17 = mux(_T_25, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 281:36 AllToAllPE.scala 282:13 AllToAllPE.scala 292:13]
    node _GEN_18 = mux(_T_25, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllPE.scala 281:36 AllToAllPE.scala 283:18 AllToAllPE.scala 293:18]
    node _GEN_19 = mux(_T_25, resp_value, UInt<64>("haaaaaaaa")) @[AllToAllPE.scala 281:36 AllToAllPE.scala 285:23 AllToAllPE.scala 295:23]
    node _GEN_20 = mux(_T_25, UInt<1>("h0"), UInt<1>("h1")) @[AllToAllPE.scala 281:36 AllToAllPE.scala 286:31 AllToAllPE.scala 296:31]
    node _GEN_21 = mux(_T_25, UInt<3>("h0"), state) @[AllToAllPE.scala 281:36 AllToAllPE.scala 288:11 AllToAllPE.scala 150:22]
    node _GEN_22 = mux(_T_24, UInt<1>("h1"), _GEN_17) @[AllToAllPE.scala 270:31 AllToAllPE.scala 271:13]
    node _GEN_23 = mux(_T_24, UInt<1>("h0"), _GEN_18) @[AllToAllPE.scala 270:31 AllToAllPE.scala 272:18]
    node _GEN_24 = mux(_T_24, UInt<1>("h0"), _GEN_17) @[AllToAllPE.scala 270:31 AllToAllPE.scala 273:19]
    node _GEN_25 = mux(_T_24, resp_value, _GEN_19) @[AllToAllPE.scala 270:31 AllToAllPE.scala 274:23]
    node _GEN_26 = mux(_T_24, UInt<1>("h0"), w_en) @[AllToAllPE.scala 270:31 AllToAllPE.scala 276:10 AllToAllPE.scala 145:21]
    node _GEN_27 = mux(_T_24, UInt<1>("h0"), _GEN_20) @[AllToAllPE.scala 270:31 AllToAllPE.scala 277:31]
    node _GEN_28 = mux(_T_24, UInt<3>("h2"), _GEN_21) @[AllToAllPE.scala 270:31 AllToAllPE.scala 279:11]
    node _GEN_29 = mux(_T_23, UInt<1>("h1"), _GEN_22) @[AllToAllPE.scala 255:36 AllToAllPE.scala 257:13]
    node _GEN_30 = mux(_T_23, UInt<1>("h0"), _GEN_23) @[AllToAllPE.scala 255:36 AllToAllPE.scala 258:18]
    node _GEN_31 = mux(_T_23, UInt<1>("h1"), _GEN_24) @[AllToAllPE.scala 255:36 AllToAllPE.scala 259:19]
    node _GEN_32 = mux(_T_23, resp_value, _GEN_25) @[AllToAllPE.scala 255:36 AllToAllPE.scala 260:23]
    node _GEN_33 = mux(_T_23, w_en, _GEN_27) @[AllToAllPE.scala 255:36 AllToAllPE.scala 262:31]
    node _GEN_34 = mux(_T_23, _GEN_8, _GEN_28) @[AllToAllPE.scala 255:36]
    node _GEN_35 = mux(_T_23, w_en, _GEN_26) @[AllToAllPE.scala 255:36 AllToAllPE.scala 145:21]
    node _GEN_36 = mux(_T_15, stall_resp, _GEN_29) @[AllToAllPE.scala 235:35 AllToAllPE.scala 237:13]
    node _GEN_37 = mux(_T_15, _T_16, _GEN_30) @[AllToAllPE.scala 235:35 AllToAllPE.scala 238:18]
    node _GEN_38 = mux(_T_15, UInt<1>("h1"), _GEN_31) @[AllToAllPE.scala 235:35 AllToAllPE.scala 239:19]
    node _GEN_39 = mux(_T_15, resp_value, _GEN_32) @[AllToAllPE.scala 235:35 AllToAllPE.scala 240:23]
    node _GEN_40 = mux(_T_15, w_en, _GEN_33) @[AllToAllPE.scala 235:35 AllToAllPE.scala 241:31]
    node _GEN_41 = mux(_T_15, _GEN_16, _GEN_34) @[AllToAllPE.scala 235:35]
    node _GEN_42 = mux(_T_15, w_en, _GEN_35) @[AllToAllPE.scala 235:35 AllToAllPE.scala 145:21]
    node _GEN_43 = mux(_T_13, UInt<1>("h1"), _GEN_36) @[AllToAllPE.scala 217:33 AllToAllPE.scala 219:13]
    node _GEN_44 = mux(_T_13, UInt<1>("h0"), _GEN_37) @[AllToAllPE.scala 217:33 AllToAllPE.scala 220:18]
    node _GEN_45 = mux(_T_13, UInt<1>("h0"), _GEN_38) @[AllToAllPE.scala 217:33 AllToAllPE.scala 221:19]
    node _GEN_46 = mux(_T_13, UInt<6>("h21"), _GEN_39) @[AllToAllPE.scala 217:33 AllToAllPE.scala 222:23]
    node _GEN_47 = validif(_T_13, _GEN_12) @[AllToAllPE.scala 217:33]
    node _GEN_48 = validif(_T_13, _GEN_4) @[AllToAllPE.scala 217:33]
    node _GEN_49 = mux(_T_13, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 217:33 AllToAllPE.scala 129:18]
    node _GEN_50 = mux(_T_13, _GEN_13, resp_value) @[AllToAllPE.scala 217:33 AllToAllPE.scala 151:27]
    node _GEN_51 = mux(_T_13, _GEN_5, _GEN_42) @[AllToAllPE.scala 217:33]
    node _GEN_52 = mux(_T_13, UInt<1>("h0"), _GEN_40) @[AllToAllPE.scala 217:33 AllToAllPE.scala 231:31]
    node _GEN_53 = mux(_T_13, UInt<3>("h5"), _GEN_41) @[AllToAllPE.scala 217:33 AllToAllPE.scala 233:11]
    node _GEN_54 = mux(_T_4, stall_resp, _GEN_43) @[AllToAllPE.scala 189:32 AllToAllPE.scala 190:13]
    node _GEN_55 = mux(_T_4, _T_5, _GEN_44) @[AllToAllPE.scala 189:32 AllToAllPE.scala 191:18]
    node _GEN_56 = mux(_T_4, UInt<1>("h1"), _GEN_45) @[AllToAllPE.scala 189:32 AllToAllPE.scala 192:19]
    node _GEN_57 = mux(_T_4, UInt<6>("h20"), _GEN_46) @[AllToAllPE.scala 189:32 AllToAllPE.scala 193:23]
    node _GEN_58 = mux(_T_4, UInt<6>("h20"), _GEN_50) @[AllToAllPE.scala 189:32 AllToAllPE.scala 194:16]
    node _GEN_59 = validif(_T_4, _GEN_3) @[AllToAllPE.scala 189:32]
    node _GEN_60 = validif(_T_4, _GEN_4) @[AllToAllPE.scala 189:32]
    node _GEN_61 = mux(_T_4, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 189:32 AllToAllPE.scala 129:18]
    node _GEN_62 = validif(_T_4, _GEN_6) @[AllToAllPE.scala 189:32]
    node _GEN_63 = validif(_T_4, _GEN_7) @[AllToAllPE.scala 189:32]
    node _GEN_64 = mux(_T_4, _GEN_5, _GEN_52) @[AllToAllPE.scala 189:32]
    node _GEN_65 = mux(_T_4, _GEN_5, _GEN_51) @[AllToAllPE.scala 189:32]
    node _GEN_66 = mux(_T_4, _GEN_11, _GEN_53) @[AllToAllPE.scala 189:32]
    node _GEN_67 = validif(eq(_T_4, UInt<1>("h0")), _GEN_47) @[AllToAllPE.scala 189:32]
    node _GEN_68 = validif(eq(_T_4, UInt<1>("h0")), _GEN_48) @[AllToAllPE.scala 189:32]
    node _GEN_69 = mux(_T_4, UInt<1>("h0"), _GEN_49) @[AllToAllPE.scala 189:32 AllToAllPE.scala 129:18]
    node _GEN_70 = mux(_T_3, UInt<1>("h0"), _GEN_54) @[AllToAllPE.scala 170:23 AllToAllPE.scala 171:13]
    node _GEN_71 = mux(_T_3, UInt<1>("h1"), _GEN_55) @[AllToAllPE.scala 170:23 AllToAllPE.scala 172:18]
    node _GEN_72 = mux(_T_3, UInt<1>("h0"), _GEN_56) @[AllToAllPE.scala 170:23 AllToAllPE.scala 173:19]
    node _GEN_73 = mux(_T_3, UInt<1>("h0"), _GEN_57) @[AllToAllPE.scala 170:23 AllToAllPE.scala 174:23]
    node _GEN_74 = mux(_T_3, UInt<1>("h0"), _GEN_64) @[AllToAllPE.scala 170:23 AllToAllPE.scala 176:31]
    node _GEN_75 = mux(_T_3, UInt<1>("h0"), _GEN_65) @[AllToAllPE.scala 170:23 AllToAllPE.scala 177:10]
    node _GEN_76 = mux(_T_3, _GEN_2, _GEN_66) @[AllToAllPE.scala 170:23]
    node _GEN_77 = mux(_T_3, resp_value, _GEN_58) @[AllToAllPE.scala 170:23 AllToAllPE.scala 151:27]
    node _GEN_78 = validif(eq(_T_3, UInt<1>("h0")), _GEN_59) @[AllToAllPE.scala 170:23]
    node _GEN_79 = validif(eq(_T_3, UInt<1>("h0")), _GEN_60) @[AllToAllPE.scala 170:23]
    node _GEN_80 = mux(_T_3, UInt<1>("h0"), _GEN_61) @[AllToAllPE.scala 170:23 AllToAllPE.scala 129:18]
    node _GEN_81 = validif(eq(_T_3, UInt<1>("h0")), _GEN_62) @[AllToAllPE.scala 170:23]
    node _GEN_82 = validif(eq(_T_3, UInt<1>("h0")), _GEN_63) @[AllToAllPE.scala 170:23]
    node _GEN_83 = validif(eq(_T_3, UInt<1>("h0")), _GEN_67) @[AllToAllPE.scala 170:23]
    node _GEN_84 = validif(eq(_T_3, UInt<1>("h0")), _GEN_68) @[AllToAllPE.scala 170:23]
    node _GEN_85 = mux(_T_3, UInt<1>("h0"), _GEN_69) @[AllToAllPE.scala 170:23 AllToAllPE.scala 129:18]
    io_busy <= _GEN_70
    io_cmd_ready <= _GEN_71
    io_resp_valid <= _GEN_72
    io_resp_bits_data <= _GEN_73
    io_resp_bits_write_enable <= _GEN_74
    io_left_out_valid <= UInt<1>("h0") @[AllToAllPE.scala 306:21]
    io_left_out_bits_data <= UInt<64>("h0") @[AllToAllPE.scala 301:25]
    io_left_out_bits_x_0 <= UInt<16>("h0") @[AllToAllPE.scala 302:24]
    io_left_out_bits_y_0 <= UInt<16>("h0") @[AllToAllPE.scala 303:24]
    io_left_out_bits_x_dest <= UInt<16>("h0") @[AllToAllPE.scala 304:27]
    io_left_out_bits_y_dest <= UInt<16>("h0") @[AllToAllPE.scala 305:27]
    io_left_in_ready <= left_in.io_enq_ready @[Decoupled.scala 299:17]
    io_right_out_valid <= UInt<1>("h0") @[AllToAllPE.scala 314:22]
    io_right_out_bits_data <= UInt<64>("h0") @[AllToAllPE.scala 309:26]
    io_right_out_bits_x_0 <= UInt<16>("h0") @[AllToAllPE.scala 310:25]
    io_right_out_bits_y_0 <= UInt<16>("h0") @[AllToAllPE.scala 311:25]
    io_right_out_bits_x_dest <= UInt<16>("h0") @[AllToAllPE.scala 312:28]
    io_right_out_bits_y_dest <= UInt<16>("h0") @[AllToAllPE.scala 313:28]
    io_right_in_ready <= right_in.io_enq_ready @[Decoupled.scala 299:17]
    io_up_out_valid <= UInt<1>("h0") @[AllToAllPE.scala 322:19]
    io_up_out_bits_data <= UInt<64>("h0") @[AllToAllPE.scala 317:23]
    io_up_out_bits_x_0 <= UInt<16>("h0") @[AllToAllPE.scala 318:22]
    io_up_out_bits_y_0 <= UInt<16>("h0") @[AllToAllPE.scala 319:22]
    io_up_out_bits_x_dest <= UInt<16>("h0") @[AllToAllPE.scala 320:25]
    io_up_out_bits_y_dest <= UInt<16>("h0") @[AllToAllPE.scala 321:25]
    io_up_in_ready <= up_in.io_enq_ready @[Decoupled.scala 299:17]
    io_bottom_out_valid <= UInt<1>("h0") @[AllToAllPE.scala 330:23]
    io_bottom_out_bits_data <= UInt<64>("h0") @[AllToAllPE.scala 325:27]
    io_bottom_out_bits_x_0 <= UInt<16>("h0") @[AllToAllPE.scala 326:26]
    io_bottom_out_bits_y_0 <= UInt<16>("h0") @[AllToAllPE.scala 327:26]
    io_bottom_out_bits_x_dest <= UInt<16>("h0") @[AllToAllPE.scala 328:29]
    io_bottom_out_bits_y_dest <= UInt<16>("h0") @[AllToAllPE.scala 329:29]
    io_bottom_in_ready <= bottom_in.io_enq_ready @[Decoupled.scala 299:17]
    memPE.MPORT_1.addr <= _GEN_83
    memPE.MPORT_1.en <= _GEN_85
    memPE.MPORT_1.clk <= _GEN_84
    memPE.MPORT.addr <= _GEN_78
    memPE.MPORT.en <= _GEN_80
    memPE.MPORT.clk <= _GEN_79
    memPE.MPORT.data <= _GEN_82
    memPE.MPORT.mask <= _GEN_81
    x_coord <= mux(reset, UInt<2>("h2"), x_coord) @[AllToAllPE.scala 132:24 AllToAllPE.scala 132:24 AllToAllPE.scala 132:24]
    y_coord <= mux(reset, UInt<1>("h1"), y_coord) @[AllToAllPE.scala 133:24 AllToAllPE.scala 133:24 AllToAllPE.scala 133:24]
    rs1 <= io_cmd_bits_rs1 @[AllToAllPE.scala 140:7]
    rs2 <= io_cmd_bits_rs2 @[AllToAllPE.scala 141:7]
    w_en <= mux(reset, UInt<1>("h0"), _GEN_75) @[AllToAllPE.scala 145:21 AllToAllPE.scala 145:21]
    state <= mux(reset, UInt<3>("h0"), _GEN_76) @[AllToAllPE.scala 150:22 AllToAllPE.scala 150:22]
    resp_value <= mux(reset, UInt<1>("h0"), _GEN_77) @[AllToAllPE.scala 151:27 AllToAllPE.scala 151:27]
    left_in.clock <= clock
    left_in.reset <= reset
    left_in.io_enq_valid <= io_left_in_valid @[Decoupled.scala 297:22]
    left_in.io_enq_bits_data <= io_left_in_bits_data @[Decoupled.scala 298:21]
    left_in.io_enq_bits_x_0 <= io_left_in_bits_x_0 @[Decoupled.scala 298:21]
    left_in.io_enq_bits_y_0 <= io_left_in_bits_y_0 @[Decoupled.scala 298:21]
    left_in.io_enq_bits_x_dest <= io_left_in_bits_x_dest @[Decoupled.scala 298:21]
    left_in.io_enq_bits_y_dest <= io_left_in_bits_y_dest @[Decoupled.scala 298:21]
    left_in.io_deq_ready <= UInt<1>("h0") @[AllToAllPE.scala 346:17]
    right_in.clock <= clock
    right_in.reset <= reset
    right_in.io_enq_valid <= io_right_in_valid @[Decoupled.scala 297:22]
    right_in.io_enq_bits_data <= io_right_in_bits_data @[Decoupled.scala 298:21]
    right_in.io_enq_bits_x_0 <= io_right_in_bits_x_0 @[Decoupled.scala 298:21]
    right_in.io_enq_bits_y_0 <= io_right_in_bits_y_0 @[Decoupled.scala 298:21]
    right_in.io_enq_bits_x_dest <= io_right_in_bits_x_dest @[Decoupled.scala 298:21]
    right_in.io_enq_bits_y_dest <= io_right_in_bits_y_dest @[Decoupled.scala 298:21]
    right_in.io_deq_ready <= UInt<1>("h0") @[AllToAllPE.scala 347:18]
    up_in.clock <= clock
    up_in.reset <= reset
    up_in.io_enq_valid <= io_up_in_valid @[Decoupled.scala 297:22]
    up_in.io_enq_bits_data <= io_up_in_bits_data @[Decoupled.scala 298:21]
    up_in.io_enq_bits_x_0 <= io_up_in_bits_x_0 @[Decoupled.scala 298:21]
    up_in.io_enq_bits_y_0 <= io_up_in_bits_y_0 @[Decoupled.scala 298:21]
    up_in.io_enq_bits_x_dest <= io_up_in_bits_x_dest @[Decoupled.scala 298:21]
    up_in.io_enq_bits_y_dest <= io_up_in_bits_y_dest @[Decoupled.scala 298:21]
    up_in.io_deq_ready <= UInt<1>("h0") @[AllToAllPE.scala 348:15]
    bottom_in.clock <= clock
    bottom_in.reset <= reset
    bottom_in.io_enq_valid <= io_bottom_in_valid @[Decoupled.scala 297:22]
    bottom_in.io_enq_bits_data <= io_bottom_in_bits_data @[Decoupled.scala 298:21]
    bottom_in.io_enq_bits_x_0 <= io_bottom_in_bits_x_0 @[Decoupled.scala 298:21]
    bottom_in.io_enq_bits_y_0 <= io_bottom_in_bits_y_0 @[Decoupled.scala 298:21]
    bottom_in.io_enq_bits_x_dest <= io_bottom_in_bits_x_dest @[Decoupled.scala 298:21]
    bottom_in.io_enq_bits_y_dest <= io_bottom_in_bits_y_dest @[Decoupled.scala 298:21]
    bottom_in.io_deq_ready <= UInt<1>("h0") @[AllToAllPE.scala 349:19]

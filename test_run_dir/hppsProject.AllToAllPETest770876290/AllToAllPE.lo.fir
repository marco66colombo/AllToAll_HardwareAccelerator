circuit AllToAllPE :
  module Queue :
    input clock : Clock
    input reset : UInt<1>
    output io_enq_ready : UInt<1>
    input io_enq_valid : UInt<1>
    input io_enq_bits_data : UInt<64>
    input io_enq_bits_x_0 : UInt<2>
    input io_enq_bits_y_0 : UInt<2>
    input io_enq_bits_x_dest : UInt<2>
    input io_enq_bits_y_dest : UInt<2>
    input io_deq_ready : UInt<1>
    output io_deq_valid : UInt<1>
    output io_deq_bits_data : UInt<64>
    output io_deq_bits_x_0 : UInt<2>
    output io_deq_bits_y_0 : UInt<2>
    output io_deq_bits_x_dest : UInt<2>
    output io_deq_bits_y_dest : UInt<2>
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
      data-type => UInt<2>
      depth => 81
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_y_0 : @[Decoupled.scala 218:16]
      data-type => UInt<2>
      depth => 81
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_x_dest : @[Decoupled.scala 218:16]
      data-type => UInt<2>
      depth => 81
      read-latency => 0
      write-latency => 1
      reader => io_deq_bits_MPORT
      writer => MPORT
      read-under-write => undefined
    mem ram_y_dest : @[Decoupled.scala 218:16]
      data-type => UInt<2>
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
    input io_end_AllToAll : UInt<1>
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
    output io_left_out_bits_x_0 : UInt<2>
    output io_left_out_bits_y_0 : UInt<2>
    output io_left_out_bits_x_dest : UInt<2>
    output io_left_out_bits_y_dest : UInt<2>
    output io_left_in_ready : UInt<1>
    input io_left_in_valid : UInt<1>
    input io_left_in_bits_data : UInt<64>
    input io_left_in_bits_x_0 : UInt<2>
    input io_left_in_bits_y_0 : UInt<2>
    input io_left_in_bits_x_dest : UInt<2>
    input io_left_in_bits_y_dest : UInt<2>
    input io_right_out_ready : UInt<1>
    output io_right_out_valid : UInt<1>
    output io_right_out_bits_data : UInt<64>
    output io_right_out_bits_x_0 : UInt<2>
    output io_right_out_bits_y_0 : UInt<2>
    output io_right_out_bits_x_dest : UInt<2>
    output io_right_out_bits_y_dest : UInt<2>
    output io_right_in_ready : UInt<1>
    input io_right_in_valid : UInt<1>
    input io_right_in_bits_data : UInt<64>
    input io_right_in_bits_x_0 : UInt<2>
    input io_right_in_bits_y_0 : UInt<2>
    input io_right_in_bits_x_dest : UInt<2>
    input io_right_in_bits_y_dest : UInt<2>
    input io_up_out_ready : UInt<1>
    output io_up_out_valid : UInt<1>
    output io_up_out_bits_data : UInt<64>
    output io_up_out_bits_x_0 : UInt<2>
    output io_up_out_bits_y_0 : UInt<2>
    output io_up_out_bits_x_dest : UInt<2>
    output io_up_out_bits_y_dest : UInt<2>
    output io_up_in_ready : UInt<1>
    input io_up_in_valid : UInt<1>
    input io_up_in_bits_data : UInt<64>
    input io_up_in_bits_x_0 : UInt<2>
    input io_up_in_bits_y_0 : UInt<2>
    input io_up_in_bits_x_dest : UInt<2>
    input io_up_in_bits_y_dest : UInt<2>
    input io_bottom_out_ready : UInt<1>
    output io_bottom_out_valid : UInt<1>
    output io_bottom_out_bits_data : UInt<64>
    output io_bottom_out_bits_x_0 : UInt<2>
    output io_bottom_out_bits_y_0 : UInt<2>
    output io_bottom_out_bits_x_dest : UInt<2>
    output io_bottom_out_bits_y_dest : UInt<2>
    output io_bottom_in_ready : UInt<1>
    input io_bottom_in_valid : UInt<1>
    input io_bottom_in_bits_data : UInt<64>
    input io_bottom_in_bits_x_0 : UInt<2>
    input io_bottom_in_bits_y_0 : UInt<2>
    input io_bottom_in_bits_x_dest : UInt<2>
    input io_bottom_in_bits_y_dest : UInt<2>

    mem memPE : @[AllToAllPE.scala 72:18]
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
    reg x_coord : UInt<2>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 75:24]
    reg y_coord : UInt<2>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 76:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 79:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 80:16]
    reg w_en : UInt<1>, clock with :
      reset => (UInt<1>("h0"), w_en) @[AllToAllPE.scala 91:21]
    reg state : UInt<3>, clock with :
      reset => (UInt<1>("h0"), state) @[AllToAllPE.scala 96:22]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 97:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 99:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 100:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 101:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 109:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 109:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 109:42]
    node load_signal = and(io_cmd_valid, io_cmd_bits_load) @[AllToAllPE.scala 110:34]
    node store_signal = and(io_cmd_valid, io_cmd_bits_store) @[AllToAllPE.scala 111:35]
    node allToAll_signal = and(io_cmd_valid, io_cmd_bits_doAllToAll) @[AllToAllPE.scala 112:38]
    node _T_2 = eq(io_resp_ready, UInt<1>("h0")) @[AllToAllPE.scala 114:20]
    node stall_resp = and(_T_2, io_resp_valid) @[AllToAllPE.scala 114:35]
    node start_AllToAll = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 115:30]
    node _T_3 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 128:14]
    node _GEN_0 = mux(allToAll_signal, UInt<3>("h1"), UInt<3>("h0")) @[AllToAllPE.scala 141:32 AllToAllPE.scala 142:13 AllToAllPE.scala 144:13]
    node _GEN_1 = mux(store_signal, UInt<3>("h5"), _GEN_0) @[AllToAllPE.scala 139:29 AllToAllPE.scala 140:13]
    node _GEN_2 = mux(load_signal, UInt<3>("h4"), _GEN_1) @[AllToAllPE.scala 137:22 AllToAllPE.scala 138:13]
    node _T_4 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 147:20]
    node _T_5 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 149:21]
    node _T_6 = bits(memIndex, 9, 0) @[AllToAllPE.scala 155:12]
    node _GEN_3 = validif(is_this_PE, _T_6) @[AllToAllPE.scala 154:21 AllToAllPE.scala 155:12]
    node _GEN_4 = validif(is_this_PE, clock) @[AllToAllPE.scala 154:21 AllToAllPE.scala 155:12]
    node _GEN_5 = mux(is_this_PE, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 154:21 AllToAllPE.scala 155:12 AllToAllPE.scala 72:18]
    node _GEN_6 = validif(is_this_PE, UInt<1>("h1")) @[AllToAllPE.scala 154:21 AllToAllPE.scala 155:23]
    node _GEN_7 = validif(is_this_PE, rs1) @[AllToAllPE.scala 154:21 AllToAllPE.scala 155:23]
    node _T_7 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 163:25]
    node _T_8 = and(load_signal, _T_7) @[AllToAllPE.scala 163:22]
    node _T_9 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 165:32]
    node _T_10 = and(store_signal, _T_9) @[AllToAllPE.scala 165:29]
    node _T_11 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 167:35]
    node _T_12 = and(allToAll_signal, _T_11) @[AllToAllPE.scala 167:32]
    node _GEN_8 = mux(stall_resp, UInt<3>("h7"), UInt<3>("h0")) @[AllToAllPE.scala 169:27 AllToAllPE.scala 170:13 AllToAllPE.scala 172:13]
    node _GEN_9 = mux(_T_12, UInt<3>("h1"), _GEN_8) @[AllToAllPE.scala 167:47 AllToAllPE.scala 168:13]
    node _GEN_10 = mux(_T_10, UInt<3>("h5"), _GEN_9) @[AllToAllPE.scala 165:44 AllToAllPE.scala 166:13]
    node _GEN_11 = mux(_T_8, UInt<3>("h4"), _GEN_10) @[AllToAllPE.scala 163:37 AllToAllPE.scala 164:13]
    node _T_13 = eq(state, UInt<3>("h5")) @[AllToAllPE.scala 175:20]
    node _T_14 = bits(memIndex, 9, 0) @[AllToAllPE.scala 183:26]
    node _GEN_12 = validif(is_this_PE, _T_14) @[AllToAllPE.scala 182:21 AllToAllPE.scala 183:26]
    node _GEN_13 = mux(is_this_PE, memPE.MPORT_1.data, resp_value) @[AllToAllPE.scala 182:21 AllToAllPE.scala 183:18 AllToAllPE.scala 97:27]
    node _T_15 = eq(state, UInt<3>("h6")) @[AllToAllPE.scala 193:20]
    node _T_16 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 196:21]
    node _T_17 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 201:25]
    node _T_18 = and(load_signal, _T_17) @[AllToAllPE.scala 201:22]
    node _T_19 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 203:32]
    node _T_20 = and(store_signal, _T_19) @[AllToAllPE.scala 203:29]
    node _T_21 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 205:35]
    node _T_22 = and(allToAll_signal, _T_21) @[AllToAllPE.scala 205:32]
    node _GEN_14 = mux(_T_22, UInt<3>("h1"), _GEN_8) @[AllToAllPE.scala 205:47 AllToAllPE.scala 206:13]
    node _GEN_15 = mux(_T_20, UInt<3>("h5"), _GEN_14) @[AllToAllPE.scala 203:44 AllToAllPE.scala 204:13]
    node _GEN_16 = mux(_T_18, UInt<3>("h4"), _GEN_15) @[AllToAllPE.scala 201:37 AllToAllPE.scala 202:13]
    node _T_23 = eq(state, UInt<3>("h7")) @[AllToAllPE.scala 213:20]
    node _T_24 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 228:20]
    node _T_25 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 245:20]
    node leftBusy = UInt<1>("h0") @[AllToAllPE.scala 117:22 AllToAllPE.scala 122:12]
    node rightBusy = UInt<1>("h0") @[AllToAllPE.scala 118:23 AllToAllPE.scala 124:13]
    node _T_26 = or(leftBusy, rightBusy) @[AllToAllPE.scala 247:25]
    node upBusy = UInt<1>("h0") @[AllToAllPE.scala 119:20 AllToAllPE.scala 125:10]
    node _T_27 = or(_T_26, upBusy) @[AllToAllPE.scala 247:38]
    node bottomBusy = UInt<1>("h0") @[AllToAllPE.scala 120:24 AllToAllPE.scala 126:14]
    node _T_28 = or(_T_27, bottomBusy) @[AllToAllPE.scala 247:48]
    node _GEN_17 = mux(io_end_AllToAll, UInt<3>("h3"), UInt<3>("h2")) @[AllToAllPE.scala 259:27 AllToAllPE.scala 260:13 AllToAllPE.scala 262:13]
    node _T_29 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 265:20]
    node _GEN_18 = mux(_T_29, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllPE.scala 265:36 AllToAllPE.scala 266:13 AllToAllPE.scala 276:13]
    node _GEN_19 = mux(_T_29, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 265:36 AllToAllPE.scala 268:19 AllToAllPE.scala 278:19]
    node _GEN_20 = mux(_T_29, UInt<1>("h0"), UInt<64>("haaaaaaaa")) @[AllToAllPE.scala 265:36 AllToAllPE.scala 269:23 AllToAllPE.scala 279:23]
    node _GEN_21 = mux(_T_29, UInt<1>("h0"), UInt<1>("h1")) @[AllToAllPE.scala 265:36 AllToAllPE.scala 270:31 AllToAllPE.scala 280:31]
    node _GEN_22 = mux(_T_29, UInt<3>("h0"), state) @[AllToAllPE.scala 265:36 AllToAllPE.scala 272:11 AllToAllPE.scala 96:22]
    node _GEN_23 = mux(_T_25, _T_28, _GEN_18) @[AllToAllPE.scala 245:41 AllToAllPE.scala 247:13]
    node _GEN_24 = mux(_T_25, UInt<1>("h0"), _GEN_18) @[AllToAllPE.scala 245:41 AllToAllPE.scala 248:18]
    node _GEN_25 = mux(_T_25, UInt<1>("h0"), _GEN_19) @[AllToAllPE.scala 245:41 AllToAllPE.scala 249:19]
    node _GEN_26 = mux(_T_25, resp_value, _GEN_20) @[AllToAllPE.scala 245:41 AllToAllPE.scala 250:23]
    node _GEN_27 = mux(_T_25, UInt<1>("h0"), _GEN_21) @[AllToAllPE.scala 245:41 AllToAllPE.scala 251:31]
    node _GEN_28 = mux(_T_25, _GEN_17, _GEN_22) @[AllToAllPE.scala 245:41]
    node _GEN_29 = mux(_T_24, UInt<1>("h1"), _GEN_23) @[AllToAllPE.scala 228:31 AllToAllPE.scala 229:13]
    node _GEN_30 = mux(_T_24, UInt<1>("h0"), _GEN_24) @[AllToAllPE.scala 228:31 AllToAllPE.scala 230:18]
    node _GEN_31 = mux(_T_24, UInt<1>("h0"), _GEN_25) @[AllToAllPE.scala 228:31 AllToAllPE.scala 231:19]
    node _GEN_32 = mux(_T_24, resp_value, _GEN_26) @[AllToAllPE.scala 228:31 AllToAllPE.scala 232:23]
    node _GEN_33 = mux(_T_24, UInt<1>("h0"), w_en) @[AllToAllPE.scala 228:31 AllToAllPE.scala 234:10 AllToAllPE.scala 91:21]
    node _GEN_34 = mux(_T_24, UInt<1>("h0"), _GEN_27) @[AllToAllPE.scala 228:31 AllToAllPE.scala 235:31]
    node _GEN_35 = mux(_T_24, UInt<3>("h3"), _GEN_28) @[AllToAllPE.scala 228:31 AllToAllPE.scala 243:11]
    node _GEN_36 = mux(_T_23, UInt<1>("h1"), _GEN_29) @[AllToAllPE.scala 213:36 AllToAllPE.scala 215:13]
    node _GEN_37 = mux(_T_23, UInt<1>("h0"), _GEN_30) @[AllToAllPE.scala 213:36 AllToAllPE.scala 216:18]
    node _GEN_38 = mux(_T_23, UInt<1>("h1"), _GEN_31) @[AllToAllPE.scala 213:36 AllToAllPE.scala 217:19]
    node _GEN_39 = mux(_T_23, resp_value, _GEN_32) @[AllToAllPE.scala 213:36 AllToAllPE.scala 218:23]
    node _GEN_40 = mux(_T_23, w_en, _GEN_34) @[AllToAllPE.scala 213:36 AllToAllPE.scala 220:31]
    node _GEN_41 = mux(_T_23, _GEN_8, _GEN_35) @[AllToAllPE.scala 213:36]
    node _GEN_42 = mux(_T_23, w_en, _GEN_33) @[AllToAllPE.scala 213:36 AllToAllPE.scala 91:21]
    node _GEN_43 = mux(_T_15, stall_resp, _GEN_36) @[AllToAllPE.scala 193:35 AllToAllPE.scala 195:13]
    node _GEN_44 = mux(_T_15, _T_16, _GEN_37) @[AllToAllPE.scala 193:35 AllToAllPE.scala 196:18]
    node _GEN_45 = mux(_T_15, UInt<1>("h1"), _GEN_38) @[AllToAllPE.scala 193:35 AllToAllPE.scala 197:19]
    node _GEN_46 = mux(_T_15, resp_value, _GEN_39) @[AllToAllPE.scala 193:35 AllToAllPE.scala 198:23]
    node _GEN_47 = mux(_T_15, w_en, _GEN_40) @[AllToAllPE.scala 193:35 AllToAllPE.scala 199:31]
    node _GEN_48 = mux(_T_15, _GEN_16, _GEN_41) @[AllToAllPE.scala 193:35]
    node _GEN_49 = mux(_T_15, w_en, _GEN_42) @[AllToAllPE.scala 193:35 AllToAllPE.scala 91:21]
    node _GEN_50 = mux(_T_13, UInt<1>("h1"), _GEN_43) @[AllToAllPE.scala 175:33 AllToAllPE.scala 177:13]
    node _GEN_51 = mux(_T_13, UInt<1>("h0"), _GEN_44) @[AllToAllPE.scala 175:33 AllToAllPE.scala 178:18]
    node _GEN_52 = mux(_T_13, UInt<1>("h0"), _GEN_45) @[AllToAllPE.scala 175:33 AllToAllPE.scala 179:19]
    node _GEN_53 = mux(_T_13, UInt<6>("h21"), _GEN_46) @[AllToAllPE.scala 175:33 AllToAllPE.scala 180:23]
    node _GEN_54 = validif(_T_13, _GEN_12) @[AllToAllPE.scala 175:33]
    node _GEN_55 = validif(_T_13, _GEN_4) @[AllToAllPE.scala 175:33]
    node _GEN_56 = mux(_T_13, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 175:33 AllToAllPE.scala 72:18]
    node _GEN_57 = mux(_T_13, _GEN_13, resp_value) @[AllToAllPE.scala 175:33 AllToAllPE.scala 97:27]
    node _GEN_58 = mux(_T_13, _GEN_5, _GEN_49) @[AllToAllPE.scala 175:33]
    node _GEN_59 = mux(_T_13, UInt<1>("h0"), _GEN_47) @[AllToAllPE.scala 175:33 AllToAllPE.scala 189:31]
    node _GEN_60 = mux(_T_13, UInt<3>("h6"), _GEN_48) @[AllToAllPE.scala 175:33 AllToAllPE.scala 191:11]
    node _GEN_61 = mux(_T_4, stall_resp, _GEN_50) @[AllToAllPE.scala 147:32 AllToAllPE.scala 148:13]
    node _GEN_62 = mux(_T_4, _T_5, _GEN_51) @[AllToAllPE.scala 147:32 AllToAllPE.scala 149:18]
    node _GEN_63 = mux(_T_4, UInt<1>("h1"), _GEN_52) @[AllToAllPE.scala 147:32 AllToAllPE.scala 150:19]
    node _GEN_64 = mux(_T_4, UInt<6>("h20"), _GEN_53) @[AllToAllPE.scala 147:32 AllToAllPE.scala 151:23]
    node _GEN_65 = mux(_T_4, UInt<6>("h20"), _GEN_57) @[AllToAllPE.scala 147:32 AllToAllPE.scala 152:16]
    node _GEN_66 = validif(_T_4, _GEN_3) @[AllToAllPE.scala 147:32]
    node _GEN_67 = validif(_T_4, _GEN_4) @[AllToAllPE.scala 147:32]
    node _GEN_68 = mux(_T_4, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 147:32 AllToAllPE.scala 72:18]
    node _GEN_69 = validif(_T_4, _GEN_6) @[AllToAllPE.scala 147:32]
    node _GEN_70 = validif(_T_4, _GEN_7) @[AllToAllPE.scala 147:32]
    node _GEN_71 = mux(_T_4, _GEN_5, _GEN_59) @[AllToAllPE.scala 147:32]
    node _GEN_72 = mux(_T_4, _GEN_5, _GEN_58) @[AllToAllPE.scala 147:32]
    node _GEN_73 = mux(_T_4, _GEN_11, _GEN_60) @[AllToAllPE.scala 147:32]
    node _GEN_74 = validif(eq(_T_4, UInt<1>("h0")), _GEN_54) @[AllToAllPE.scala 147:32]
    node _GEN_75 = validif(eq(_T_4, UInt<1>("h0")), _GEN_55) @[AllToAllPE.scala 147:32]
    node _GEN_76 = mux(_T_4, UInt<1>("h0"), _GEN_56) @[AllToAllPE.scala 147:32 AllToAllPE.scala 72:18]
    node _GEN_77 = mux(_T_3, UInt<1>("h0"), _GEN_61) @[AllToAllPE.scala 128:23 AllToAllPE.scala 129:13]
    node _GEN_78 = mux(_T_3, UInt<1>("h1"), _GEN_62) @[AllToAllPE.scala 128:23 AllToAllPE.scala 130:18]
    node _GEN_79 = mux(_T_3, UInt<1>("h0"), _GEN_63) @[AllToAllPE.scala 128:23 AllToAllPE.scala 131:19]
    node _GEN_80 = mux(_T_3, UInt<1>("h0"), _GEN_64) @[AllToAllPE.scala 128:23 AllToAllPE.scala 132:23]
    node _GEN_81 = mux(_T_3, UInt<1>("h0"), _GEN_71) @[AllToAllPE.scala 128:23 AllToAllPE.scala 134:31]
    node _GEN_82 = mux(_T_3, UInt<1>("h0"), _GEN_72) @[AllToAllPE.scala 128:23 AllToAllPE.scala 135:10]
    node _GEN_83 = mux(_T_3, _GEN_2, _GEN_73) @[AllToAllPE.scala 128:23]
    node _GEN_84 = mux(_T_3, resp_value, _GEN_65) @[AllToAllPE.scala 128:23 AllToAllPE.scala 97:27]
    node _GEN_85 = validif(eq(_T_3, UInt<1>("h0")), _GEN_66) @[AllToAllPE.scala 128:23]
    node _GEN_86 = validif(eq(_T_3, UInt<1>("h0")), _GEN_67) @[AllToAllPE.scala 128:23]
    node _GEN_87 = mux(_T_3, UInt<1>("h0"), _GEN_68) @[AllToAllPE.scala 128:23 AllToAllPE.scala 72:18]
    node _GEN_88 = validif(eq(_T_3, UInt<1>("h0")), _GEN_69) @[AllToAllPE.scala 128:23]
    node _GEN_89 = validif(eq(_T_3, UInt<1>("h0")), _GEN_70) @[AllToAllPE.scala 128:23]
    node _GEN_90 = validif(eq(_T_3, UInt<1>("h0")), _GEN_74) @[AllToAllPE.scala 128:23]
    node _GEN_91 = validif(eq(_T_3, UInt<1>("h0")), _GEN_75) @[AllToAllPE.scala 128:23]
    node _GEN_92 = mux(_T_3, UInt<1>("h0"), _GEN_76) @[AllToAllPE.scala 128:23 AllToAllPE.scala 72:18]
    reg stateAction : UInt<3>, clock with :
      reset => (UInt<1>("h0"), stateAction) @[AllToAllPE.scala 289:28]
    node _T_30 = eq(stateAction, UInt<3>("h0")) @[AllToAllPE.scala 293:20]
    node _GEN_93 = mux(start_AllToAll, UInt<3>("h1"), UInt<3>("h0")) @[AllToAllPE.scala 300:25 AllToAllPE.scala 301:19 AllToAllPE.scala 303:19]
    node _T_31 = eq(stateAction, UInt<3>("h1")) @[AllToAllPE.scala 305:26]
    node _GEN_94 = mux(io_end_AllToAll, UInt<3>("h0"), UInt<3>("h1")) @[AllToAllPE.scala 313:26 AllToAllPE.scala 314:19 AllToAllPE.scala 316:19]
    node _GEN_95 = mux(_T_31, _GEN_94, stateAction) @[AllToAllPE.scala 305:37 AllToAllPE.scala 289:28]
    node _GEN_96 = mux(_T_30, _GEN_93, _GEN_95) @[AllToAllPE.scala 293:29]
    io_busy <= _GEN_77
    io_cmd_ready <= _GEN_78
    io_resp_valid <= _GEN_79
    io_resp_bits_data <= _GEN_80
    io_resp_bits_write_enable <= _GEN_81
    io_left_out_valid <= UInt<1>("h0") @[AllToAllPE.scala 329:21]
    io_left_out_bits_data <= UInt<64>("h0") @[AllToAllPE.scala 324:25]
    io_left_out_bits_x_0 <= UInt<1>("h0") @[AllToAllPE.scala 325:24]
    io_left_out_bits_y_0 <= UInt<1>("h0") @[AllToAllPE.scala 326:24]
    io_left_out_bits_x_dest <= UInt<1>("h0") @[AllToAllPE.scala 327:27]
    io_left_out_bits_y_dest <= UInt<1>("h0") @[AllToAllPE.scala 328:27]
    io_left_in_ready <= left_in.io_enq_ready @[Decoupled.scala 299:17]
    io_right_out_valid <= UInt<1>("h0") @[AllToAllPE.scala 337:22]
    io_right_out_bits_data <= UInt<64>("h0") @[AllToAllPE.scala 332:26]
    io_right_out_bits_x_0 <= UInt<1>("h0") @[AllToAllPE.scala 333:25]
    io_right_out_bits_y_0 <= UInt<1>("h0") @[AllToAllPE.scala 334:25]
    io_right_out_bits_x_dest <= UInt<1>("h0") @[AllToAllPE.scala 335:28]
    io_right_out_bits_y_dest <= UInt<1>("h0") @[AllToAllPE.scala 336:28]
    io_right_in_ready <= right_in.io_enq_ready @[Decoupled.scala 299:17]
    io_up_out_valid <= UInt<1>("h0") @[AllToAllPE.scala 345:19]
    io_up_out_bits_data <= UInt<64>("h0") @[AllToAllPE.scala 340:23]
    io_up_out_bits_x_0 <= UInt<1>("h0") @[AllToAllPE.scala 341:22]
    io_up_out_bits_y_0 <= UInt<1>("h0") @[AllToAllPE.scala 342:22]
    io_up_out_bits_x_dest <= UInt<1>("h0") @[AllToAllPE.scala 343:25]
    io_up_out_bits_y_dest <= UInt<1>("h0") @[AllToAllPE.scala 344:25]
    io_up_in_ready <= up_in.io_enq_ready @[Decoupled.scala 299:17]
    io_bottom_out_valid <= UInt<1>("h0") @[AllToAllPE.scala 353:23]
    io_bottom_out_bits_data <= UInt<64>("h0") @[AllToAllPE.scala 348:27]
    io_bottom_out_bits_x_0 <= UInt<1>("h0") @[AllToAllPE.scala 349:26]
    io_bottom_out_bits_y_0 <= UInt<1>("h0") @[AllToAllPE.scala 350:26]
    io_bottom_out_bits_x_dest <= UInt<1>("h0") @[AllToAllPE.scala 351:29]
    io_bottom_out_bits_y_dest <= UInt<1>("h0") @[AllToAllPE.scala 352:29]
    io_bottom_in_ready <= bottom_in.io_enq_ready @[Decoupled.scala 299:17]
    memPE.MPORT_1.addr <= _GEN_90
    memPE.MPORT_1.en <= _GEN_92
    memPE.MPORT_1.clk <= _GEN_91
    memPE.MPORT.addr <= _GEN_85
    memPE.MPORT.en <= _GEN_87
    memPE.MPORT.clk <= _GEN_86
    memPE.MPORT.data <= _GEN_89
    memPE.MPORT.mask <= _GEN_88
    x_coord <= mux(reset, UInt<2>("h2"), x_coord) @[AllToAllPE.scala 75:24 AllToAllPE.scala 75:24 AllToAllPE.scala 75:24]
    y_coord <= mux(reset, UInt<1>("h1"), y_coord) @[AllToAllPE.scala 76:24 AllToAllPE.scala 76:24 AllToAllPE.scala 76:24]
    rs1 <= io_cmd_bits_rs1 @[AllToAllPE.scala 86:7]
    rs2 <= io_cmd_bits_rs2 @[AllToAllPE.scala 87:7]
    w_en <= mux(reset, UInt<1>("h0"), _GEN_82) @[AllToAllPE.scala 91:21 AllToAllPE.scala 91:21]
    state <= mux(reset, UInt<3>("h0"), _GEN_83) @[AllToAllPE.scala 96:22 AllToAllPE.scala 96:22]
    resp_value <= mux(reset, UInt<1>("h0"), _GEN_84) @[AllToAllPE.scala 97:27 AllToAllPE.scala 97:27]
    stateAction <= mux(reset, UInt<3>("h0"), _GEN_96) @[AllToAllPE.scala 289:28 AllToAllPE.scala 289:28]
    left_in.clock <= clock
    left_in.reset <= reset
    left_in.io_enq_valid <= io_left_in_valid @[Decoupled.scala 297:22]
    left_in.io_enq_bits_data <= io_left_in_bits_data @[Decoupled.scala 298:21]
    left_in.io_enq_bits_x_0 <= io_left_in_bits_x_0 @[Decoupled.scala 298:21]
    left_in.io_enq_bits_y_0 <= io_left_in_bits_y_0 @[Decoupled.scala 298:21]
    left_in.io_enq_bits_x_dest <= io_left_in_bits_x_dest @[Decoupled.scala 298:21]
    left_in.io_enq_bits_y_dest <= io_left_in_bits_y_dest @[Decoupled.scala 298:21]
    left_in.io_deq_ready <= io_left_in_ready @[AllToAllPE.scala 373:17]
    right_in.clock <= clock
    right_in.reset <= reset
    right_in.io_enq_valid <= io_right_in_valid @[Decoupled.scala 297:22]
    right_in.io_enq_bits_data <= io_right_in_bits_data @[Decoupled.scala 298:21]
    right_in.io_enq_bits_x_0 <= io_right_in_bits_x_0 @[Decoupled.scala 298:21]
    right_in.io_enq_bits_y_0 <= io_right_in_bits_y_0 @[Decoupled.scala 298:21]
    right_in.io_enq_bits_x_dest <= io_right_in_bits_x_dest @[Decoupled.scala 298:21]
    right_in.io_enq_bits_y_dest <= io_right_in_bits_y_dest @[Decoupled.scala 298:21]
    right_in.io_deq_ready <= io_right_in_ready @[AllToAllPE.scala 374:18]
    up_in.clock <= clock
    up_in.reset <= reset
    up_in.io_enq_valid <= io_up_in_valid @[Decoupled.scala 297:22]
    up_in.io_enq_bits_data <= io_up_in_bits_data @[Decoupled.scala 298:21]
    up_in.io_enq_bits_x_0 <= io_up_in_bits_x_0 @[Decoupled.scala 298:21]
    up_in.io_enq_bits_y_0 <= io_up_in_bits_y_0 @[Decoupled.scala 298:21]
    up_in.io_enq_bits_x_dest <= io_up_in_bits_x_dest @[Decoupled.scala 298:21]
    up_in.io_enq_bits_y_dest <= io_up_in_bits_y_dest @[Decoupled.scala 298:21]
    up_in.io_deq_ready <= io_up_in_ready @[AllToAllPE.scala 375:15]
    bottom_in.clock <= clock
    bottom_in.reset <= reset
    bottom_in.io_enq_valid <= io_bottom_in_valid @[Decoupled.scala 297:22]
    bottom_in.io_enq_bits_data <= io_bottom_in_bits_data @[Decoupled.scala 298:21]
    bottom_in.io_enq_bits_x_0 <= io_bottom_in_bits_x_0 @[Decoupled.scala 298:21]
    bottom_in.io_enq_bits_y_0 <= io_bottom_in_bits_y_0 @[Decoupled.scala 298:21]
    bottom_in.io_enq_bits_x_dest <= io_bottom_in_bits_x_dest @[Decoupled.scala 298:21]
    bottom_in.io_enq_bits_y_dest <= io_bottom_in_bits_y_dest @[Decoupled.scala 298:21]
    bottom_in.io_deq_ready <= io_bottom_in_ready @[AllToAllPE.scala 376:19]

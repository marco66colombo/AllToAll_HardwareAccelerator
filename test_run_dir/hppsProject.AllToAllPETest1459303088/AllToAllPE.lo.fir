circuit AllToAllPE :
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

    mem memPE : @[AllToAllPE.scala 141:18]
      data-type => UInt<64>
      depth => 1024
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 144:24]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 145:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 148:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 149:16]
    reg w_en : UInt<1>, clock with :
      reset => (UInt<1>("h0"), w_en) @[AllToAllPE.scala 155:17]
    reg state : UInt<3>, clock with :
      reset => (UInt<1>("h0"), state) @[AllToAllPE.scala 161:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 162:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 163:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 165:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 166:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 167:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 173:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 173:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 173:42]
    node load_signal = and(io_cmd_valid, io_cmd_bits_load) @[AllToAllPE.scala 174:34]
    node store_signal = and(io_cmd_valid, io_cmd_bits_store) @[AllToAllPE.scala 175:35]
    node allToAll_signal = and(io_cmd_valid, io_cmd_bits_doAllToAll) @[AllToAllPE.scala 176:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 178:14]
    node _GEN_0 = mux(allToAll_signal, UInt<3>("h1"), UInt<3>("h0")) @[AllToAllPE.scala 191:32 AllToAllPE.scala 192:13 AllToAllPE.scala 194:13]
    node _GEN_1 = mux(store_signal, UInt<3>("h4"), _GEN_0) @[AllToAllPE.scala 189:29 AllToAllPE.scala 190:13]
    node _GEN_2 = mux(load_signal, UInt<3>("h3"), _GEN_1) @[AllToAllPE.scala 187:22 AllToAllPE.scala 188:13]
    node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 197:20]
    node _T_4 = bits(memIndex, 9, 0) @[AllToAllPE.scala 205:12]
    node _GEN_3 = validif(is_this_PE, _T_4) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:12]
    node _GEN_4 = validif(is_this_PE, clock) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:12]
    node _GEN_5 = mux(is_this_PE, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:12 AllToAllPE.scala 141:18]
    node _GEN_6 = validif(is_this_PE, UInt<1>("h1")) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:23]
    node _GEN_7 = validif(is_this_PE, rs1) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:23]
    node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 222:20]
    node _T_6 = bits(memIndex, 9, 0) @[AllToAllPE.scala 231:26]
    node _GEN_8 = validif(is_this_PE, _T_6) @[AllToAllPE.scala 230:21 AllToAllPE.scala 231:26]
    node _GEN_9 = mux(is_this_PE, memPE.MPORT_1.data, resp_value) @[AllToAllPE.scala 230:21 AllToAllPE.scala 231:18 AllToAllPE.scala 163:27]
    node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 247:20]
    node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 259:20]
    node _GEN_10 = mux(_T_8, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 259:36 AllToAllPE.scala 260:13 AllToAllPE.scala 269:13]
    node _GEN_11 = mux(_T_8, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllPE.scala 259:36 AllToAllPE.scala 261:18 AllToAllPE.scala 270:18]
    node _GEN_12 = mux(_T_8, resp_value, UInt<64>("haaaaaaaa")) @[AllToAllPE.scala 259:36 AllToAllPE.scala 263:23 AllToAllPE.scala 272:23]
    node _GEN_13 = mux(_T_8, UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 259:36 AllToAllPE.scala 265:17 AllToAllPE.scala 162:28]
    node _GEN_14 = mux(_T_8, UInt<3>("h0"), state) @[AllToAllPE.scala 259:36 AllToAllPE.scala 267:11 AllToAllPE.scala 161:22]
    node _GEN_15 = mux(_T_7, UInt<1>("h1"), _GEN_10) @[AllToAllPE.scala 247:31 AllToAllPE.scala 248:13]
    node _GEN_16 = mux(_T_7, UInt<1>("h0"), _GEN_11) @[AllToAllPE.scala 247:31 AllToAllPE.scala 249:18]
    node _GEN_17 = mux(_T_7, resp_signal, _GEN_10) @[AllToAllPE.scala 247:31 AllToAllPE.scala 250:19]
    node _GEN_18 = mux(_T_7, resp_value, _GEN_12) @[AllToAllPE.scala 247:31 AllToAllPE.scala 251:23]
    node _GEN_19 = mux(_T_7, UInt<1>("h0"), _GEN_13) @[AllToAllPE.scala 247:31 AllToAllPE.scala 254:17]
    node _GEN_20 = mux(_T_7, UInt<1>("h0"), w_en) @[AllToAllPE.scala 247:31 AllToAllPE.scala 256:10 AllToAllPE.scala 155:17]
    node _GEN_21 = mux(_T_7, UInt<3>("h2"), _GEN_14) @[AllToAllPE.scala 247:31 AllToAllPE.scala 258:11]
    node _GEN_22 = mux(_T_5, UInt<1>("h0"), _GEN_15) @[AllToAllPE.scala 222:33 AllToAllPE.scala 224:13]
    node _GEN_23 = mux(_T_5, UInt<1>("h1"), _GEN_16) @[AllToAllPE.scala 222:33 AllToAllPE.scala 225:18]
    node _GEN_24 = mux(_T_5, resp_signal, _GEN_17) @[AllToAllPE.scala 222:33 AllToAllPE.scala 226:19]
    node _GEN_25 = mux(_T_5, resp_value, _GEN_18) @[AllToAllPE.scala 222:33 AllToAllPE.scala 227:23]
    node _GEN_26 = mux(_T_5, UInt<1>("h1"), _GEN_19) @[AllToAllPE.scala 222:33 AllToAllPE.scala 228:17]
    node _GEN_27 = validif(_T_5, _GEN_8) @[AllToAllPE.scala 222:33]
    node _GEN_28 = validif(_T_5, _GEN_4) @[AllToAllPE.scala 222:33]
    node _GEN_29 = mux(_T_5, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 222:33 AllToAllPE.scala 141:18]
    node _GEN_30 = mux(_T_5, _GEN_9, resp_value) @[AllToAllPE.scala 222:33 AllToAllPE.scala 163:27]
    node _GEN_31 = mux(_T_5, _GEN_5, _GEN_20) @[AllToAllPE.scala 222:33]
    node _GEN_32 = mux(_T_5, _GEN_2, _GEN_21) @[AllToAllPE.scala 222:33]
    node _GEN_33 = mux(_T_3, UInt<1>("h0"), _GEN_22) @[AllToAllPE.scala 197:32 AllToAllPE.scala 198:13]
    node _GEN_34 = mux(_T_3, UInt<1>("h1"), _GEN_23) @[AllToAllPE.scala 197:32 AllToAllPE.scala 199:18]
    node _GEN_35 = mux(_T_3, resp_signal, _GEN_24) @[AllToAllPE.scala 197:32 AllToAllPE.scala 200:19]
    node _GEN_36 = mux(_T_3, resp_value, _GEN_25) @[AllToAllPE.scala 197:32 AllToAllPE.scala 201:23]
    node _GEN_37 = mux(_T_3, UInt<1>("h1"), _GEN_26) @[AllToAllPE.scala 197:32 AllToAllPE.scala 202:17]
    node _GEN_38 = validif(_T_3, _GEN_3) @[AllToAllPE.scala 197:32]
    node _GEN_39 = validif(_T_3, _GEN_4) @[AllToAllPE.scala 197:32]
    node _GEN_40 = mux(_T_3, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 197:32 AllToAllPE.scala 141:18]
    node _GEN_41 = validif(_T_3, _GEN_6) @[AllToAllPE.scala 197:32]
    node _GEN_42 = validif(_T_3, _GEN_7) @[AllToAllPE.scala 197:32]
    node _GEN_43 = mux(_T_3, _GEN_5, _GEN_31) @[AllToAllPE.scala 197:32]
    node _GEN_44 = mux(_T_3, UInt<64>("h20"), _GEN_30) @[AllToAllPE.scala 197:32 AllToAllPE.scala 210:16]
    node _GEN_45 = mux(_T_3, _GEN_2, _GEN_32) @[AllToAllPE.scala 197:32]
    node _GEN_46 = validif(eq(_T_3, UInt<1>("h0")), _GEN_27) @[AllToAllPE.scala 197:32]
    node _GEN_47 = validif(eq(_T_3, UInt<1>("h0")), _GEN_28) @[AllToAllPE.scala 197:32]
    node _GEN_48 = mux(_T_3, UInt<1>("h0"), _GEN_29) @[AllToAllPE.scala 197:32 AllToAllPE.scala 141:18]
    node _GEN_49 = mux(_T_2, UInt<1>("h0"), _GEN_33) @[AllToAllPE.scala 178:23 AllToAllPE.scala 179:13]
    node _GEN_50 = mux(_T_2, UInt<1>("h1"), _GEN_34) @[AllToAllPE.scala 178:23 AllToAllPE.scala 180:18]
    node _GEN_51 = mux(_T_2, resp_signal, _GEN_35) @[AllToAllPE.scala 178:23 AllToAllPE.scala 181:19]
    node _GEN_52 = mux(_T_2, resp_value, _GEN_36) @[AllToAllPE.scala 178:23 AllToAllPE.scala 182:23]
    node _GEN_53 = mux(_T_2, UInt<1>("h0"), _GEN_44) @[AllToAllPE.scala 178:23 AllToAllPE.scala 183:16]
    node _GEN_54 = mux(_T_2, UInt<1>("h0"), _GEN_37) @[AllToAllPE.scala 178:23 AllToAllPE.scala 184:17]
    node _GEN_55 = mux(_T_2, UInt<1>("h0"), _GEN_43) @[AllToAllPE.scala 178:23 AllToAllPE.scala 185:10]
    node _GEN_56 = mux(_T_2, _GEN_2, _GEN_45) @[AllToAllPE.scala 178:23]
    node _GEN_57 = validif(eq(_T_2, UInt<1>("h0")), _GEN_38) @[AllToAllPE.scala 178:23]
    node _GEN_58 = validif(eq(_T_2, UInt<1>("h0")), _GEN_39) @[AllToAllPE.scala 178:23]
    node _GEN_59 = mux(_T_2, UInt<1>("h0"), _GEN_40) @[AllToAllPE.scala 178:23 AllToAllPE.scala 141:18]
    node _GEN_60 = validif(eq(_T_2, UInt<1>("h0")), _GEN_41) @[AllToAllPE.scala 178:23]
    node _GEN_61 = validif(eq(_T_2, UInt<1>("h0")), _GEN_42) @[AllToAllPE.scala 178:23]
    node _GEN_62 = validif(eq(_T_2, UInt<1>("h0")), _GEN_46) @[AllToAllPE.scala 178:23]
    node _GEN_63 = validif(eq(_T_2, UInt<1>("h0")), _GEN_47) @[AllToAllPE.scala 178:23]
    node _GEN_64 = mux(_T_2, UInt<1>("h0"), _GEN_48) @[AllToAllPE.scala 178:23 AllToAllPE.scala 141:18]
    io_busy <= _GEN_49
    io_cmd_ready <= _GEN_50
    io_resp_valid <= _GEN_51
    io_resp_bits_data <= _GEN_52
    io_resp_bits_write_enable <= w_en @[AllToAllPE.scala 156:29]
    io_left_out_valid <= UInt<1>("h0") @[AllToAllPE.scala 282:21]
    io_left_out_bits_data <= UInt<64>("h0") @[AllToAllPE.scala 277:25]
    io_left_out_bits_x_0 <= UInt<16>("h0") @[AllToAllPE.scala 278:24]
    io_left_out_bits_y_0 <= UInt<16>("h0") @[AllToAllPE.scala 279:24]
    io_left_out_bits_x_dest <= UInt<16>("h0") @[AllToAllPE.scala 280:27]
    io_left_out_bits_y_dest <= UInt<16>("h0") @[AllToAllPE.scala 281:27]
    io_left_in_ready <= UInt<1>("h0") @[AllToAllPE.scala 283:20]
    io_right_out_valid <= UInt<1>("h0") @[AllToAllPE.scala 290:22]
    io_right_out_bits_data <= UInt<64>("h0") @[AllToAllPE.scala 285:26]
    io_right_out_bits_x_0 <= UInt<16>("h0") @[AllToAllPE.scala 286:25]
    io_right_out_bits_y_0 <= UInt<16>("h0") @[AllToAllPE.scala 287:25]
    io_right_out_bits_x_dest <= UInt<16>("h0") @[AllToAllPE.scala 288:28]
    io_right_out_bits_y_dest <= UInt<16>("h0") @[AllToAllPE.scala 289:28]
    io_right_in_ready <= UInt<1>("h0") @[AllToAllPE.scala 291:21]
    io_up_out_valid <= UInt<1>("h0") @[AllToAllPE.scala 298:19]
    io_up_out_bits_data <= UInt<64>("h0") @[AllToAllPE.scala 293:23]
    io_up_out_bits_x_0 <= UInt<16>("h0") @[AllToAllPE.scala 294:22]
    io_up_out_bits_y_0 <= UInt<16>("h0") @[AllToAllPE.scala 295:22]
    io_up_out_bits_x_dest <= UInt<16>("h0") @[AllToAllPE.scala 296:25]
    io_up_out_bits_y_dest <= UInt<16>("h0") @[AllToAllPE.scala 297:25]
    io_up_in_ready <= UInt<1>("h0") @[AllToAllPE.scala 299:18]
    io_bottom_out_valid <= UInt<1>("h0") @[AllToAllPE.scala 306:23]
    io_bottom_out_bits_data <= UInt<64>("h0") @[AllToAllPE.scala 301:27]
    io_bottom_out_bits_x_0 <= UInt<16>("h0") @[AllToAllPE.scala 302:26]
    io_bottom_out_bits_y_0 <= UInt<16>("h0") @[AllToAllPE.scala 303:26]
    io_bottom_out_bits_x_dest <= UInt<16>("h0") @[AllToAllPE.scala 304:29]
    io_bottom_out_bits_y_dest <= UInt<16>("h0") @[AllToAllPE.scala 305:29]
    io_bottom_in_ready <= UInt<1>("h0") @[AllToAllPE.scala 307:22]
    memPE.MPORT_1.addr <= _GEN_62
    memPE.MPORT_1.en <= _GEN_64
    memPE.MPORT_1.clk <= _GEN_63
    memPE.MPORT.addr <= _GEN_57
    memPE.MPORT.en <= _GEN_59
    memPE.MPORT.clk <= _GEN_58
    memPE.MPORT.data <= _GEN_61
    memPE.MPORT.mask <= _GEN_60
    x_coord <= mux(reset, UInt<2>("h2"), x_coord) @[AllToAllPE.scala 144:24 AllToAllPE.scala 144:24 AllToAllPE.scala 144:24]
    y_coord <= mux(reset, UInt<1>("h1"), y_coord) @[AllToAllPE.scala 145:24 AllToAllPE.scala 145:24 AllToAllPE.scala 145:24]
    rs1 <= io_cmd_bits_rs1 @[AllToAllPE.scala 151:7]
    rs2 <= io_cmd_bits_rs2 @[AllToAllPE.scala 152:7]
    w_en <= _GEN_55
    state <= mux(reset, UInt<3>("h0"), _GEN_56) @[AllToAllPE.scala 161:22 AllToAllPE.scala 161:22]
    resp_signal <= mux(reset, UInt<1>("h0"), _GEN_54) @[AllToAllPE.scala 162:28 AllToAllPE.scala 162:28]
    resp_value <= mux(reset, UInt<1>("h0"), _GEN_53) @[AllToAllPE.scala 163:27 AllToAllPE.scala 163:27]

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
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 175:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 175:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 175:42]
    node load_signal = and(io_cmd_valid, io_cmd_bits_load) @[AllToAllPE.scala 176:34]
    node store_signal = and(io_cmd_valid, io_cmd_bits_store) @[AllToAllPE.scala 177:35]
    node allToAll_signal = and(io_cmd_valid, io_cmd_bits_doAllToAll) @[AllToAllPE.scala 178:38]
    node _T_2 = eq(io_resp_ready, UInt<1>("h0")) @[AllToAllPE.scala 180:20]
    node stall_resp = and(_T_2, resp_signal) @[AllToAllPE.scala 180:35]
    node _T_3 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 182:14]
    node _GEN_0 = mux(stall_resp, UInt<3>("h5"), UInt<3>("h0")) @[AllToAllPE.scala 197:27 AllToAllPE.scala 198:13 AllToAllPE.scala 200:13]
    node _GEN_1 = mux(allToAll_signal, UInt<3>("h1"), _GEN_0) @[AllToAllPE.scala 195:32 AllToAllPE.scala 196:13]
    node _GEN_2 = mux(store_signal, UInt<3>("h4"), _GEN_1) @[AllToAllPE.scala 193:29 AllToAllPE.scala 194:13]
    node _GEN_3 = mux(load_signal, UInt<3>("h3"), _GEN_2) @[AllToAllPE.scala 191:22 AllToAllPE.scala 192:13]
    node _T_4 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 203:20]
    node _T_5 = bits(memIndex, 9, 0) @[AllToAllPE.scala 211:12]
    node _GEN_4 = validif(is_this_PE, _T_5) @[AllToAllPE.scala 210:21 AllToAllPE.scala 211:12]
    node _GEN_5 = validif(is_this_PE, clock) @[AllToAllPE.scala 210:21 AllToAllPE.scala 211:12]
    node _GEN_6 = mux(is_this_PE, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 210:21 AllToAllPE.scala 211:12 AllToAllPE.scala 141:18]
    node _GEN_7 = validif(is_this_PE, UInt<1>("h1")) @[AllToAllPE.scala 210:21 AllToAllPE.scala 211:23]
    node _GEN_8 = validif(is_this_PE, rs1) @[AllToAllPE.scala 210:21 AllToAllPE.scala 211:23]
    node _T_6 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 230:20]
    node _T_7 = bits(memIndex, 9, 0) @[AllToAllPE.scala 239:26]
    node _GEN_9 = validif(is_this_PE, _T_7) @[AllToAllPE.scala 238:21 AllToAllPE.scala 239:26]
    node _GEN_10 = mux(is_this_PE, memPE.MPORT_1.data, resp_value) @[AllToAllPE.scala 238:21 AllToAllPE.scala 239:18 AllToAllPE.scala 163:27]
    node _T_8 = eq(state, UInt<3>("h5")) @[AllToAllPE.scala 257:20]
    node _GEN_11 = mux(stall_resp, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 264:21 AllToAllPE.scala 266:19 AllToAllPE.scala 271:19]
    node _T_9 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 275:20]
    node _T_10 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 287:20]
    node _GEN_12 = mux(_T_10, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 287:36 AllToAllPE.scala 288:13 AllToAllPE.scala 297:13]
    node _GEN_13 = mux(_T_10, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllPE.scala 287:36 AllToAllPE.scala 289:18 AllToAllPE.scala 298:18]
    node _GEN_14 = mux(_T_10, resp_value, UInt<64>("haaaaaaaa")) @[AllToAllPE.scala 287:36 AllToAllPE.scala 291:23 AllToAllPE.scala 300:23]
    node _GEN_15 = mux(_T_10, UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 287:36 AllToAllPE.scala 293:17 AllToAllPE.scala 162:28]
    node _GEN_16 = mux(_T_10, UInt<3>("h0"), state) @[AllToAllPE.scala 287:36 AllToAllPE.scala 295:11 AllToAllPE.scala 161:22]
    node _GEN_17 = mux(_T_9, UInt<1>("h1"), _GEN_12) @[AllToAllPE.scala 275:31 AllToAllPE.scala 276:13]
    node _GEN_18 = mux(_T_9, UInt<1>("h0"), _GEN_13) @[AllToAllPE.scala 275:31 AllToAllPE.scala 277:18]
    node _GEN_19 = mux(_T_9, resp_signal, _GEN_12) @[AllToAllPE.scala 275:31 AllToAllPE.scala 278:19]
    node _GEN_20 = mux(_T_9, resp_value, _GEN_14) @[AllToAllPE.scala 275:31 AllToAllPE.scala 279:23]
    node _GEN_21 = mux(_T_9, UInt<1>("h0"), _GEN_15) @[AllToAllPE.scala 275:31 AllToAllPE.scala 282:17]
    node _GEN_22 = mux(_T_9, UInt<1>("h0"), w_en) @[AllToAllPE.scala 275:31 AllToAllPE.scala 284:10 AllToAllPE.scala 155:17]
    node _GEN_23 = mux(_T_9, UInt<3>("h2"), _GEN_16) @[AllToAllPE.scala 275:31 AllToAllPE.scala 286:11]
    node _GEN_24 = mux(_T_8, UInt<1>("h1"), _GEN_17) @[AllToAllPE.scala 257:36 AllToAllPE.scala 259:13]
    node _GEN_25 = mux(_T_8, UInt<1>("h0"), _GEN_18) @[AllToAllPE.scala 257:36 AllToAllPE.scala 260:18]
    node _GEN_26 = mux(_T_8, resp_signal, _GEN_19) @[AllToAllPE.scala 257:36 AllToAllPE.scala 261:19]
    node _GEN_27 = mux(_T_8, resp_value, _GEN_20) @[AllToAllPE.scala 257:36 AllToAllPE.scala 262:23]
    node _GEN_28 = mux(_T_8, _GEN_11, _GEN_21) @[AllToAllPE.scala 257:36]
    node _GEN_29 = mux(_T_8, _GEN_0, _GEN_23) @[AllToAllPE.scala 257:36]
    node _GEN_30 = mux(_T_8, w_en, _GEN_22) @[AllToAllPE.scala 257:36 AllToAllPE.scala 155:17]
    node _GEN_31 = mux(_T_6, UInt<1>("h0"), _GEN_24) @[AllToAllPE.scala 230:33 AllToAllPE.scala 232:13]
    node _GEN_32 = mux(_T_6, UInt<1>("h1"), _GEN_25) @[AllToAllPE.scala 230:33 AllToAllPE.scala 233:18]
    node _GEN_33 = mux(_T_6, resp_signal, _GEN_26) @[AllToAllPE.scala 230:33 AllToAllPE.scala 234:19]
    node _GEN_34 = mux(_T_6, resp_value, _GEN_27) @[AllToAllPE.scala 230:33 AllToAllPE.scala 235:23]
    node _GEN_35 = mux(_T_6, UInt<1>("h1"), _GEN_28) @[AllToAllPE.scala 230:33 AllToAllPE.scala 236:17]
    node _GEN_36 = validif(_T_6, _GEN_9) @[AllToAllPE.scala 230:33]
    node _GEN_37 = validif(_T_6, _GEN_5) @[AllToAllPE.scala 230:33]
    node _GEN_38 = mux(_T_6, _GEN_6, UInt<1>("h0")) @[AllToAllPE.scala 230:33 AllToAllPE.scala 141:18]
    node _GEN_39 = mux(_T_6, _GEN_10, resp_value) @[AllToAllPE.scala 230:33 AllToAllPE.scala 163:27]
    node _GEN_40 = mux(_T_6, _GEN_6, _GEN_30) @[AllToAllPE.scala 230:33]
    node _GEN_41 = mux(_T_6, _GEN_3, _GEN_29) @[AllToAllPE.scala 230:33]
    node _GEN_42 = mux(_T_4, UInt<1>("h0"), _GEN_31) @[AllToAllPE.scala 203:32 AllToAllPE.scala 204:13]
    node _GEN_43 = mux(_T_4, UInt<1>("h1"), _GEN_32) @[AllToAllPE.scala 203:32 AllToAllPE.scala 205:18]
    node _GEN_44 = mux(_T_4, resp_signal, _GEN_33) @[AllToAllPE.scala 203:32 AllToAllPE.scala 206:19]
    node _GEN_45 = mux(_T_4, resp_value, _GEN_34) @[AllToAllPE.scala 203:32 AllToAllPE.scala 207:23]
    node _GEN_46 = mux(_T_4, UInt<1>("h1"), _GEN_35) @[AllToAllPE.scala 203:32 AllToAllPE.scala 208:17]
    node _GEN_47 = validif(_T_4, _GEN_4) @[AllToAllPE.scala 203:32]
    node _GEN_48 = validif(_T_4, _GEN_5) @[AllToAllPE.scala 203:32]
    node _GEN_49 = mux(_T_4, _GEN_6, UInt<1>("h0")) @[AllToAllPE.scala 203:32 AllToAllPE.scala 141:18]
    node _GEN_50 = validif(_T_4, _GEN_7) @[AllToAllPE.scala 203:32]
    node _GEN_51 = validif(_T_4, _GEN_8) @[AllToAllPE.scala 203:32]
    node _GEN_52 = mux(_T_4, _GEN_6, _GEN_40) @[AllToAllPE.scala 203:32]
    node _GEN_53 = mux(_T_4, UInt<64>("h20"), _GEN_39) @[AllToAllPE.scala 203:32 AllToAllPE.scala 216:16]
    node _GEN_54 = mux(_T_4, _GEN_3, _GEN_41) @[AllToAllPE.scala 203:32]
    node _GEN_55 = validif(eq(_T_4, UInt<1>("h0")), _GEN_36) @[AllToAllPE.scala 203:32]
    node _GEN_56 = validif(eq(_T_4, UInt<1>("h0")), _GEN_37) @[AllToAllPE.scala 203:32]
    node _GEN_57 = mux(_T_4, UInt<1>("h0"), _GEN_38) @[AllToAllPE.scala 203:32 AllToAllPE.scala 141:18]
    node _GEN_58 = mux(_T_3, UInt<1>("h0"), _GEN_42) @[AllToAllPE.scala 182:23 AllToAllPE.scala 183:13]
    node _GEN_59 = mux(_T_3, UInt<1>("h1"), _GEN_43) @[AllToAllPE.scala 182:23 AllToAllPE.scala 184:18]
    node _GEN_60 = mux(_T_3, resp_signal, _GEN_44) @[AllToAllPE.scala 182:23 AllToAllPE.scala 185:19]
    node _GEN_61 = mux(_T_3, resp_value, _GEN_45) @[AllToAllPE.scala 182:23 AllToAllPE.scala 186:23]
    node _GEN_62 = mux(_T_3, UInt<1>("h0"), _GEN_53) @[AllToAllPE.scala 182:23 AllToAllPE.scala 187:16]
    node _GEN_63 = mux(_T_3, UInt<1>("h0"), _GEN_46) @[AllToAllPE.scala 182:23 AllToAllPE.scala 188:17]
    node _GEN_64 = mux(_T_3, UInt<1>("h0"), _GEN_52) @[AllToAllPE.scala 182:23 AllToAllPE.scala 189:10]
    node _GEN_65 = mux(_T_3, _GEN_3, _GEN_54) @[AllToAllPE.scala 182:23]
    node _GEN_66 = validif(eq(_T_3, UInt<1>("h0")), _GEN_47) @[AllToAllPE.scala 182:23]
    node _GEN_67 = validif(eq(_T_3, UInt<1>("h0")), _GEN_48) @[AllToAllPE.scala 182:23]
    node _GEN_68 = mux(_T_3, UInt<1>("h0"), _GEN_49) @[AllToAllPE.scala 182:23 AllToAllPE.scala 141:18]
    node _GEN_69 = validif(eq(_T_3, UInt<1>("h0")), _GEN_50) @[AllToAllPE.scala 182:23]
    node _GEN_70 = validif(eq(_T_3, UInt<1>("h0")), _GEN_51) @[AllToAllPE.scala 182:23]
    node _GEN_71 = validif(eq(_T_3, UInt<1>("h0")), _GEN_55) @[AllToAllPE.scala 182:23]
    node _GEN_72 = validif(eq(_T_3, UInt<1>("h0")), _GEN_56) @[AllToAllPE.scala 182:23]
    node _GEN_73 = mux(_T_3, UInt<1>("h0"), _GEN_57) @[AllToAllPE.scala 182:23 AllToAllPE.scala 141:18]
    io_busy <= _GEN_58
    io_cmd_ready <= _GEN_59
    io_resp_valid <= _GEN_60
    io_resp_bits_data <= _GEN_61
    io_resp_bits_write_enable <= w_en @[AllToAllPE.scala 156:29]
    io_left_out_valid <= UInt<1>("h0") @[AllToAllPE.scala 310:21]
    io_left_out_bits_data <= UInt<64>("h0") @[AllToAllPE.scala 305:25]
    io_left_out_bits_x_0 <= UInt<16>("h0") @[AllToAllPE.scala 306:24]
    io_left_out_bits_y_0 <= UInt<16>("h0") @[AllToAllPE.scala 307:24]
    io_left_out_bits_x_dest <= UInt<16>("h0") @[AllToAllPE.scala 308:27]
    io_left_out_bits_y_dest <= UInt<16>("h0") @[AllToAllPE.scala 309:27]
    io_left_in_ready <= UInt<1>("h0") @[AllToAllPE.scala 311:20]
    io_right_out_valid <= UInt<1>("h0") @[AllToAllPE.scala 318:22]
    io_right_out_bits_data <= UInt<64>("h0") @[AllToAllPE.scala 313:26]
    io_right_out_bits_x_0 <= UInt<16>("h0") @[AllToAllPE.scala 314:25]
    io_right_out_bits_y_0 <= UInt<16>("h0") @[AllToAllPE.scala 315:25]
    io_right_out_bits_x_dest <= UInt<16>("h0") @[AllToAllPE.scala 316:28]
    io_right_out_bits_y_dest <= UInt<16>("h0") @[AllToAllPE.scala 317:28]
    io_right_in_ready <= UInt<1>("h0") @[AllToAllPE.scala 319:21]
    io_up_out_valid <= UInt<1>("h0") @[AllToAllPE.scala 326:19]
    io_up_out_bits_data <= UInt<64>("h0") @[AllToAllPE.scala 321:23]
    io_up_out_bits_x_0 <= UInt<16>("h0") @[AllToAllPE.scala 322:22]
    io_up_out_bits_y_0 <= UInt<16>("h0") @[AllToAllPE.scala 323:22]
    io_up_out_bits_x_dest <= UInt<16>("h0") @[AllToAllPE.scala 324:25]
    io_up_out_bits_y_dest <= UInt<16>("h0") @[AllToAllPE.scala 325:25]
    io_up_in_ready <= UInt<1>("h0") @[AllToAllPE.scala 327:18]
    io_bottom_out_valid <= UInt<1>("h0") @[AllToAllPE.scala 334:23]
    io_bottom_out_bits_data <= UInt<64>("h0") @[AllToAllPE.scala 329:27]
    io_bottom_out_bits_x_0 <= UInt<16>("h0") @[AllToAllPE.scala 330:26]
    io_bottom_out_bits_y_0 <= UInt<16>("h0") @[AllToAllPE.scala 331:26]
    io_bottom_out_bits_x_dest <= UInt<16>("h0") @[AllToAllPE.scala 332:29]
    io_bottom_out_bits_y_dest <= UInt<16>("h0") @[AllToAllPE.scala 333:29]
    io_bottom_in_ready <= UInt<1>("h0") @[AllToAllPE.scala 335:22]
    memPE.MPORT_1.addr <= _GEN_71
    memPE.MPORT_1.en <= _GEN_73
    memPE.MPORT_1.clk <= _GEN_72
    memPE.MPORT.addr <= _GEN_66
    memPE.MPORT.en <= _GEN_68
    memPE.MPORT.clk <= _GEN_67
    memPE.MPORT.data <= _GEN_70
    memPE.MPORT.mask <= _GEN_69
    x_coord <= mux(reset, UInt<2>("h2"), x_coord) @[AllToAllPE.scala 144:24 AllToAllPE.scala 144:24 AllToAllPE.scala 144:24]
    y_coord <= mux(reset, UInt<1>("h1"), y_coord) @[AllToAllPE.scala 145:24 AllToAllPE.scala 145:24 AllToAllPE.scala 145:24]
    rs1 <= io_cmd_bits_rs1 @[AllToAllPE.scala 151:7]
    rs2 <= io_cmd_bits_rs2 @[AllToAllPE.scala 152:7]
    w_en <= _GEN_64
    state <= mux(reset, UInt<3>("h0"), _GEN_65) @[AllToAllPE.scala 161:22 AllToAllPE.scala 161:22]
    resp_signal <= mux(reset, UInt<1>("h0"), _GEN_63) @[AllToAllPE.scala 162:28 AllToAllPE.scala 162:28]
    resp_value <= mux(reset, UInt<1>("h0"), _GEN_62) @[AllToAllPE.scala 163:27 AllToAllPE.scala 163:27]

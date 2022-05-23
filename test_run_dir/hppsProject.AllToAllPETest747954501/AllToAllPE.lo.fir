circuit AllToAllPE :
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
    reg x_coord : UInt<2>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 75:24]
    reg y_coord : UInt<2>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 76:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 79:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 80:16]
    reg w_en : UInt<1>, clock with :
      reset => (UInt<1>("h0"), w_en) @[AllToAllPE.scala 92:21]
    reg state : UInt<3>, clock with :
      reset => (UInt<1>("h0"), state) @[AllToAllPE.scala 97:22]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 98:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 100:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 101:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 102:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 110:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 110:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 110:42]
    node load_signal = and(io_cmd_valid, io_cmd_bits_load) @[AllToAllPE.scala 111:34]
    node store_signal = and(io_cmd_valid, io_cmd_bits_store) @[AllToAllPE.scala 112:35]
    node allToAll_signal = and(io_cmd_valid, io_cmd_bits_doAllToAll) @[AllToAllPE.scala 113:38]
    node _T_2 = eq(io_resp_ready, UInt<1>("h0")) @[AllToAllPE.scala 115:20]
    node stall_resp = and(_T_2, io_resp_valid) @[AllToAllPE.scala 115:35]
    node start_AllToAll = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 116:30]
    node _T_3 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 129:14]
    node _GEN_0 = mux(allToAll_signal, UInt<3>("h1"), UInt<3>("h0")) @[AllToAllPE.scala 142:32 AllToAllPE.scala 143:13 AllToAllPE.scala 145:13]
    node _GEN_1 = mux(store_signal, UInt<3>("h5"), _GEN_0) @[AllToAllPE.scala 140:29 AllToAllPE.scala 141:13]
    node _GEN_2 = mux(load_signal, UInt<3>("h4"), _GEN_1) @[AllToAllPE.scala 138:22 AllToAllPE.scala 139:13]
    node _T_4 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 148:20]
    node _T_5 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 150:21]
    node _T_6 = bits(memIndex, 9, 0) @[AllToAllPE.scala 156:12]
    node _GEN_3 = validif(is_this_PE, _T_6) @[AllToAllPE.scala 155:21 AllToAllPE.scala 156:12]
    node _GEN_4 = validif(is_this_PE, clock) @[AllToAllPE.scala 155:21 AllToAllPE.scala 156:12]
    node _GEN_5 = mux(is_this_PE, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 155:21 AllToAllPE.scala 156:12 AllToAllPE.scala 72:18]
    node _GEN_6 = validif(is_this_PE, UInt<1>("h1")) @[AllToAllPE.scala 155:21 AllToAllPE.scala 156:23]
    node _GEN_7 = validif(is_this_PE, rs1) @[AllToAllPE.scala 155:21 AllToAllPE.scala 156:23]
    node _T_7 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 164:25]
    node _T_8 = and(load_signal, _T_7) @[AllToAllPE.scala 164:22]
    node _T_9 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 166:32]
    node _T_10 = and(store_signal, _T_9) @[AllToAllPE.scala 166:29]
    node _T_11 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 168:35]
    node _T_12 = and(allToAll_signal, _T_11) @[AllToAllPE.scala 168:32]
    node _GEN_8 = mux(stall_resp, UInt<3>("h7"), UInt<3>("h0")) @[AllToAllPE.scala 170:27 AllToAllPE.scala 171:13 AllToAllPE.scala 173:13]
    node _GEN_9 = mux(_T_12, UInt<3>("h1"), _GEN_8) @[AllToAllPE.scala 168:47 AllToAllPE.scala 169:13]
    node _GEN_10 = mux(_T_10, UInt<3>("h5"), _GEN_9) @[AllToAllPE.scala 166:44 AllToAllPE.scala 167:13]
    node _GEN_11 = mux(_T_8, UInt<3>("h4"), _GEN_10) @[AllToAllPE.scala 164:37 AllToAllPE.scala 165:13]
    node _T_13 = eq(state, UInt<3>("h5")) @[AllToAllPE.scala 176:20]
    node _T_14 = bits(memIndex, 9, 0) @[AllToAllPE.scala 184:26]
    node _GEN_12 = validif(is_this_PE, _T_14) @[AllToAllPE.scala 183:21 AllToAllPE.scala 184:26]
    node _GEN_13 = mux(is_this_PE, memPE.MPORT_1.data, resp_value) @[AllToAllPE.scala 183:21 AllToAllPE.scala 184:18 AllToAllPE.scala 98:27]
    node _T_15 = eq(state, UInt<3>("h6")) @[AllToAllPE.scala 194:20]
    node _T_16 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 197:21]
    node _T_17 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 202:25]
    node _T_18 = and(load_signal, _T_17) @[AllToAllPE.scala 202:22]
    node _T_19 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 204:32]
    node _T_20 = and(store_signal, _T_19) @[AllToAllPE.scala 204:29]
    node _T_21 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 206:35]
    node _T_22 = and(allToAll_signal, _T_21) @[AllToAllPE.scala 206:32]
    node _GEN_14 = mux(_T_22, UInt<3>("h1"), _GEN_8) @[AllToAllPE.scala 206:47 AllToAllPE.scala 207:13]
    node _GEN_15 = mux(_T_20, UInt<3>("h5"), _GEN_14) @[AllToAllPE.scala 204:44 AllToAllPE.scala 205:13]
    node _GEN_16 = mux(_T_18, UInt<3>("h4"), _GEN_15) @[AllToAllPE.scala 202:37 AllToAllPE.scala 203:13]
    node _T_23 = eq(state, UInt<3>("h7")) @[AllToAllPE.scala 214:20]
    node _T_24 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 229:20]
    node _T_25 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 246:20]
    node leftBusy = UInt<1>("h0") @[AllToAllPE.scala 118:22 AllToAllPE.scala 123:12]
    node rightBusy = UInt<1>("h0") @[AllToAllPE.scala 119:23 AllToAllPE.scala 125:13]
    node _T_26 = or(leftBusy, rightBusy) @[AllToAllPE.scala 248:25]
    node upBusy = UInt<1>("h0") @[AllToAllPE.scala 120:20 AllToAllPE.scala 126:10]
    node _T_27 = or(_T_26, upBusy) @[AllToAllPE.scala 248:38]
    node bottomBusy = UInt<1>("h0") @[AllToAllPE.scala 121:24 AllToAllPE.scala 127:14]
    node _T_28 = or(_T_27, bottomBusy) @[AllToAllPE.scala 248:48]
    node _GEN_17 = mux(io_end_AllToAll, UInt<3>("h3"), UInt<3>("h2")) @[AllToAllPE.scala 260:27 AllToAllPE.scala 261:13 AllToAllPE.scala 263:13]
    node _T_29 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 266:20]
    node _GEN_18 = mux(_T_29, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllPE.scala 266:36 AllToAllPE.scala 267:13 AllToAllPE.scala 277:13]
    node _GEN_19 = mux(_T_29, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 266:36 AllToAllPE.scala 269:19 AllToAllPE.scala 279:19]
    node _GEN_20 = mux(_T_29, UInt<1>("h0"), UInt<64>("haaaaaaaa")) @[AllToAllPE.scala 266:36 AllToAllPE.scala 270:23 AllToAllPE.scala 280:23]
    node _GEN_21 = mux(_T_29, UInt<1>("h0"), UInt<1>("h1")) @[AllToAllPE.scala 266:36 AllToAllPE.scala 271:31 AllToAllPE.scala 281:31]
    node _GEN_22 = mux(_T_29, UInt<3>("h0"), state) @[AllToAllPE.scala 266:36 AllToAllPE.scala 273:11 AllToAllPE.scala 97:22]
    node _GEN_23 = mux(_T_25, _T_28, _GEN_18) @[AllToAllPE.scala 246:41 AllToAllPE.scala 248:13]
    node _GEN_24 = mux(_T_25, UInt<1>("h0"), _GEN_18) @[AllToAllPE.scala 246:41 AllToAllPE.scala 249:18]
    node _GEN_25 = mux(_T_25, UInt<1>("h0"), _GEN_19) @[AllToAllPE.scala 246:41 AllToAllPE.scala 250:19]
    node _GEN_26 = mux(_T_25, resp_value, _GEN_20) @[AllToAllPE.scala 246:41 AllToAllPE.scala 251:23]
    node _GEN_27 = mux(_T_25, UInt<1>("h0"), _GEN_21) @[AllToAllPE.scala 246:41 AllToAllPE.scala 252:31]
    node _GEN_28 = mux(_T_25, _GEN_17, _GEN_22) @[AllToAllPE.scala 246:41]
    node _GEN_29 = mux(_T_24, UInt<1>("h1"), _GEN_23) @[AllToAllPE.scala 229:31 AllToAllPE.scala 230:13]
    node _GEN_30 = mux(_T_24, UInt<1>("h0"), _GEN_24) @[AllToAllPE.scala 229:31 AllToAllPE.scala 231:18]
    node _GEN_31 = mux(_T_24, UInt<1>("h0"), _GEN_25) @[AllToAllPE.scala 229:31 AllToAllPE.scala 232:19]
    node _GEN_32 = mux(_T_24, resp_value, _GEN_26) @[AllToAllPE.scala 229:31 AllToAllPE.scala 233:23]
    node _GEN_33 = mux(_T_24, UInt<1>("h0"), w_en) @[AllToAllPE.scala 229:31 AllToAllPE.scala 235:10 AllToAllPE.scala 92:21]
    node _GEN_34 = mux(_T_24, UInt<1>("h0"), _GEN_27) @[AllToAllPE.scala 229:31 AllToAllPE.scala 236:31]
    node _GEN_35 = mux(_T_24, UInt<3>("h3"), _GEN_28) @[AllToAllPE.scala 229:31 AllToAllPE.scala 244:11]
    node _GEN_36 = mux(_T_23, UInt<1>("h1"), _GEN_29) @[AllToAllPE.scala 214:36 AllToAllPE.scala 216:13]
    node _GEN_37 = mux(_T_23, UInt<1>("h0"), _GEN_30) @[AllToAllPE.scala 214:36 AllToAllPE.scala 217:18]
    node _GEN_38 = mux(_T_23, UInt<1>("h1"), _GEN_31) @[AllToAllPE.scala 214:36 AllToAllPE.scala 218:19]
    node _GEN_39 = mux(_T_23, resp_value, _GEN_32) @[AllToAllPE.scala 214:36 AllToAllPE.scala 219:23]
    node _GEN_40 = mux(_T_23, w_en, _GEN_34) @[AllToAllPE.scala 214:36 AllToAllPE.scala 221:31]
    node _GEN_41 = mux(_T_23, _GEN_8, _GEN_35) @[AllToAllPE.scala 214:36]
    node _GEN_42 = mux(_T_23, w_en, _GEN_33) @[AllToAllPE.scala 214:36 AllToAllPE.scala 92:21]
    node _GEN_43 = mux(_T_15, stall_resp, _GEN_36) @[AllToAllPE.scala 194:35 AllToAllPE.scala 196:13]
    node _GEN_44 = mux(_T_15, _T_16, _GEN_37) @[AllToAllPE.scala 194:35 AllToAllPE.scala 197:18]
    node _GEN_45 = mux(_T_15, UInt<1>("h1"), _GEN_38) @[AllToAllPE.scala 194:35 AllToAllPE.scala 198:19]
    node _GEN_46 = mux(_T_15, resp_value, _GEN_39) @[AllToAllPE.scala 194:35 AllToAllPE.scala 199:23]
    node _GEN_47 = mux(_T_15, w_en, _GEN_40) @[AllToAllPE.scala 194:35 AllToAllPE.scala 200:31]
    node _GEN_48 = mux(_T_15, _GEN_16, _GEN_41) @[AllToAllPE.scala 194:35]
    node _GEN_49 = mux(_T_15, w_en, _GEN_42) @[AllToAllPE.scala 194:35 AllToAllPE.scala 92:21]
    node _GEN_50 = mux(_T_13, UInt<1>("h1"), _GEN_43) @[AllToAllPE.scala 176:33 AllToAllPE.scala 178:13]
    node _GEN_51 = mux(_T_13, UInt<1>("h0"), _GEN_44) @[AllToAllPE.scala 176:33 AllToAllPE.scala 179:18]
    node _GEN_52 = mux(_T_13, UInt<1>("h0"), _GEN_45) @[AllToAllPE.scala 176:33 AllToAllPE.scala 180:19]
    node _GEN_53 = mux(_T_13, UInt<6>("h21"), _GEN_46) @[AllToAllPE.scala 176:33 AllToAllPE.scala 181:23]
    node _GEN_54 = validif(_T_13, _GEN_12) @[AllToAllPE.scala 176:33]
    node _GEN_55 = validif(_T_13, _GEN_4) @[AllToAllPE.scala 176:33]
    node _GEN_56 = mux(_T_13, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 176:33 AllToAllPE.scala 72:18]
    node _GEN_57 = mux(_T_13, _GEN_13, resp_value) @[AllToAllPE.scala 176:33 AllToAllPE.scala 98:27]
    node _GEN_58 = mux(_T_13, _GEN_5, _GEN_49) @[AllToAllPE.scala 176:33]
    node _GEN_59 = mux(_T_13, UInt<1>("h0"), _GEN_47) @[AllToAllPE.scala 176:33 AllToAllPE.scala 190:31]
    node _GEN_60 = mux(_T_13, UInt<3>("h6"), _GEN_48) @[AllToAllPE.scala 176:33 AllToAllPE.scala 192:11]
    node _GEN_61 = mux(_T_4, stall_resp, _GEN_50) @[AllToAllPE.scala 148:32 AllToAllPE.scala 149:13]
    node _GEN_62 = mux(_T_4, _T_5, _GEN_51) @[AllToAllPE.scala 148:32 AllToAllPE.scala 150:18]
    node _GEN_63 = mux(_T_4, UInt<1>("h1"), _GEN_52) @[AllToAllPE.scala 148:32 AllToAllPE.scala 151:19]
    node _GEN_64 = mux(_T_4, UInt<6>("h20"), _GEN_53) @[AllToAllPE.scala 148:32 AllToAllPE.scala 152:23]
    node _GEN_65 = mux(_T_4, UInt<6>("h20"), _GEN_57) @[AllToAllPE.scala 148:32 AllToAllPE.scala 153:16]
    node _GEN_66 = validif(_T_4, _GEN_3) @[AllToAllPE.scala 148:32]
    node _GEN_67 = validif(_T_4, _GEN_4) @[AllToAllPE.scala 148:32]
    node _GEN_68 = mux(_T_4, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 148:32 AllToAllPE.scala 72:18]
    node _GEN_69 = validif(_T_4, _GEN_6) @[AllToAllPE.scala 148:32]
    node _GEN_70 = validif(_T_4, _GEN_7) @[AllToAllPE.scala 148:32]
    node _GEN_71 = mux(_T_4, _GEN_5, _GEN_59) @[AllToAllPE.scala 148:32]
    node _GEN_72 = mux(_T_4, _GEN_5, _GEN_58) @[AllToAllPE.scala 148:32]
    node _GEN_73 = mux(_T_4, _GEN_11, _GEN_60) @[AllToAllPE.scala 148:32]
    node _GEN_74 = validif(eq(_T_4, UInt<1>("h0")), _GEN_54) @[AllToAllPE.scala 148:32]
    node _GEN_75 = validif(eq(_T_4, UInt<1>("h0")), _GEN_55) @[AllToAllPE.scala 148:32]
    node _GEN_76 = mux(_T_4, UInt<1>("h0"), _GEN_56) @[AllToAllPE.scala 148:32 AllToAllPE.scala 72:18]
    node _GEN_77 = mux(_T_3, UInt<1>("h0"), _GEN_61) @[AllToAllPE.scala 129:23 AllToAllPE.scala 130:13]
    node _GEN_78 = mux(_T_3, UInt<1>("h1"), _GEN_62) @[AllToAllPE.scala 129:23 AllToAllPE.scala 131:18]
    node _GEN_79 = mux(_T_3, UInt<1>("h0"), _GEN_63) @[AllToAllPE.scala 129:23 AllToAllPE.scala 132:19]
    node _GEN_80 = mux(_T_3, UInt<1>("h0"), _GEN_64) @[AllToAllPE.scala 129:23 AllToAllPE.scala 133:23]
    node _GEN_81 = mux(_T_3, UInt<1>("h0"), _GEN_71) @[AllToAllPE.scala 129:23 AllToAllPE.scala 135:31]
    node _GEN_82 = mux(_T_3, UInt<1>("h0"), _GEN_72) @[AllToAllPE.scala 129:23 AllToAllPE.scala 136:10]
    node _GEN_83 = mux(_T_3, _GEN_2, _GEN_73) @[AllToAllPE.scala 129:23]
    node _GEN_84 = mux(_T_3, resp_value, _GEN_65) @[AllToAllPE.scala 129:23 AllToAllPE.scala 98:27]
    node _GEN_85 = validif(eq(_T_3, UInt<1>("h0")), _GEN_66) @[AllToAllPE.scala 129:23]
    node _GEN_86 = validif(eq(_T_3, UInt<1>("h0")), _GEN_67) @[AllToAllPE.scala 129:23]
    node _GEN_87 = mux(_T_3, UInt<1>("h0"), _GEN_68) @[AllToAllPE.scala 129:23 AllToAllPE.scala 72:18]
    node _GEN_88 = validif(eq(_T_3, UInt<1>("h0")), _GEN_69) @[AllToAllPE.scala 129:23]
    node _GEN_89 = validif(eq(_T_3, UInt<1>("h0")), _GEN_70) @[AllToAllPE.scala 129:23]
    node _GEN_90 = validif(eq(_T_3, UInt<1>("h0")), _GEN_74) @[AllToAllPE.scala 129:23]
    node _GEN_91 = validif(eq(_T_3, UInt<1>("h0")), _GEN_75) @[AllToAllPE.scala 129:23]
    node _GEN_92 = mux(_T_3, UInt<1>("h0"), _GEN_76) @[AllToAllPE.scala 129:23 AllToAllPE.scala 72:18]
    reg stateAction : UInt<3>, clock with :
      reset => (UInt<1>("h0"), stateAction) @[AllToAllPE.scala 290:28]
    node _T_30 = eq(stateAction, UInt<3>("h0")) @[AllToAllPE.scala 294:20]
    node _GEN_93 = mux(start_AllToAll, UInt<3>("h1"), UInt<3>("h0")) @[AllToAllPE.scala 301:25 AllToAllPE.scala 302:19 AllToAllPE.scala 304:19]
    node _T_31 = eq(stateAction, UInt<3>("h1")) @[AllToAllPE.scala 306:26]
    node _GEN_94 = mux(io_end_AllToAll, UInt<3>("h0"), UInt<3>("h1")) @[AllToAllPE.scala 314:26 AllToAllPE.scala 315:19 AllToAllPE.scala 317:19]
    node _GEN_95 = mux(_T_31, _GEN_94, stateAction) @[AllToAllPE.scala 306:37 AllToAllPE.scala 290:28]
    node _GEN_96 = mux(_T_30, _GEN_93, _GEN_95) @[AllToAllPE.scala 294:29]
    io_busy <= _GEN_77
    io_cmd_ready <= _GEN_78
    io_resp_valid <= _GEN_79
    io_resp_bits_data <= _GEN_80
    io_resp_bits_write_enable <= _GEN_81
    io_left_out_valid <= UInt<1>("h0") @[AllToAllPE.scala 347:21]
    io_left_out_bits_data <= UInt<64>("h0") @[AllToAllPE.scala 342:25]
    io_left_out_bits_x_0 <= UInt<1>("h0") @[AllToAllPE.scala 343:24]
    io_left_out_bits_y_0 <= UInt<1>("h0") @[AllToAllPE.scala 344:24]
    io_left_out_bits_x_dest <= UInt<1>("h0") @[AllToAllPE.scala 345:27]
    io_left_out_bits_y_dest <= UInt<1>("h0") @[AllToAllPE.scala 346:27]
    io_left_in_ready <= UInt<1>("h0") @[AllToAllPE.scala 348:20]
    io_right_out_valid <= UInt<1>("h0") @[AllToAllPE.scala 355:22]
    io_right_out_bits_data <= UInt<64>("h0") @[AllToAllPE.scala 350:26]
    io_right_out_bits_x_0 <= UInt<1>("h0") @[AllToAllPE.scala 351:25]
    io_right_out_bits_y_0 <= UInt<1>("h0") @[AllToAllPE.scala 352:25]
    io_right_out_bits_x_dest <= UInt<1>("h0") @[AllToAllPE.scala 353:28]
    io_right_out_bits_y_dest <= UInt<1>("h0") @[AllToAllPE.scala 354:28]
    io_right_in_ready <= UInt<1>("h0") @[AllToAllPE.scala 356:21]
    io_up_out_valid <= UInt<1>("h0") @[AllToAllPE.scala 363:19]
    io_up_out_bits_data <= UInt<64>("h0") @[AllToAllPE.scala 358:23]
    io_up_out_bits_x_0 <= UInt<1>("h0") @[AllToAllPE.scala 359:22]
    io_up_out_bits_y_0 <= UInt<1>("h0") @[AllToAllPE.scala 360:22]
    io_up_out_bits_x_dest <= UInt<1>("h0") @[AllToAllPE.scala 361:25]
    io_up_out_bits_y_dest <= UInt<1>("h0") @[AllToAllPE.scala 362:25]
    io_up_in_ready <= UInt<1>("h0") @[AllToAllPE.scala 364:18]
    io_bottom_out_valid <= UInt<1>("h0") @[AllToAllPE.scala 371:23]
    io_bottom_out_bits_data <= UInt<64>("h0") @[AllToAllPE.scala 366:27]
    io_bottom_out_bits_x_0 <= UInt<1>("h0") @[AllToAllPE.scala 367:26]
    io_bottom_out_bits_y_0 <= UInt<1>("h0") @[AllToAllPE.scala 368:26]
    io_bottom_out_bits_x_dest <= UInt<1>("h0") @[AllToAllPE.scala 369:29]
    io_bottom_out_bits_y_dest <= UInt<1>("h0") @[AllToAllPE.scala 370:29]
    io_bottom_in_ready <= UInt<1>("h0") @[AllToAllPE.scala 372:22]
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
    rs1 <= io_cmd_bits_rs1 @[AllToAllPE.scala 82:7]
    rs2 <= io_cmd_bits_rs2 @[AllToAllPE.scala 83:7]
    w_en <= mux(reset, UInt<1>("h0"), _GEN_82) @[AllToAllPE.scala 92:21 AllToAllPE.scala 92:21]
    state <= mux(reset, UInt<3>("h0"), _GEN_83) @[AllToAllPE.scala 97:22 AllToAllPE.scala 97:22]
    resp_value <= mux(reset, UInt<1>("h0"), _GEN_84) @[AllToAllPE.scala 98:27 AllToAllPE.scala 98:27]
    stateAction <= mux(reset, UInt<3>("h0"), _GEN_96) @[AllToAllPE.scala 290:28 AllToAllPE.scala 290:28]

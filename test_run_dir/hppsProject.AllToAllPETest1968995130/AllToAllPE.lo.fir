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
    output io_left_out : UInt<64>
    input io_left_in : UInt<64>
    output io_right_out : UInt<64>
    input io_right_in : UInt<64>
    output io_up_out : UInt<64>
    input io_up_in : UInt<64>
    output io_bottom_out : UInt<64>
    input io_bottom_in : UInt<64>

    mem memPE : @[AllToAllPE.scala 129:18]
      data-type => UInt<64>
      depth => 1024
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:24]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 143:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 144:16]
    reg state : UInt<3>, clock with :
      reset => (UInt<1>("h0"), state) @[AllToAllPE.scala 150:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 151:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 152:27]
    node x_value = bits(io_cmd_bits_rs2, 15, 0) @[AllToAllPE.scala 153:32]
    node y_value = bits(io_cmd_bits_rs2, 31, 16) @[AllToAllPE.scala 154:32]
    node memIndex = bits(io_cmd_bits_rs2, 63, 32) @[AllToAllPE.scala 155:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 158:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 158:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 158:42]
    node load_signal = and(io_cmd_valid, io_cmd_bits_load) @[AllToAllPE.scala 159:34]
    node store_signal = and(io_cmd_valid, io_cmd_bits_store) @[AllToAllPE.scala 160:35]
    node allToAll_signal = and(io_cmd_valid, io_cmd_bits_doAllToAll) @[AllToAllPE.scala 161:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 163:14]
    node _GEN_0 = mux(allToAll_signal, UInt<3>("h1"), UInt<3>("h0")) @[AllToAllPE.scala 175:32 AllToAllPE.scala 176:13 AllToAllPE.scala 178:13]
    node _GEN_1 = mux(store_signal, UInt<3>("h4"), _GEN_0) @[AllToAllPE.scala 173:29 AllToAllPE.scala 174:13]
    node _GEN_2 = mux(load_signal, UInt<3>("h3"), _GEN_1) @[AllToAllPE.scala 171:22 AllToAllPE.scala 172:13]
    node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 181:20]
    node _T_4 = bits(memIndex, 9, 0) @[AllToAllPE.scala 189:12]
    node _GEN_3 = validif(is_this_PE, _T_4) @[AllToAllPE.scala 188:21 AllToAllPE.scala 189:12]
    node _GEN_4 = validif(is_this_PE, clock) @[AllToAllPE.scala 188:21 AllToAllPE.scala 189:12]
    node _GEN_5 = mux(is_this_PE, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 188:21 AllToAllPE.scala 189:12 AllToAllPE.scala 129:18]
    node _GEN_6 = validif(is_this_PE, UInt<1>("h1")) @[AllToAllPE.scala 188:21 AllToAllPE.scala 189:23]
    node _GEN_7 = validif(is_this_PE, io_cmd_bits_rs1) @[AllToAllPE.scala 188:21 AllToAllPE.scala 189:23]
    node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 203:20]
    node _T_6 = bits(memIndex, 9, 0) @[AllToAllPE.scala 212:26]
    node _GEN_8 = validif(is_this_PE, _T_6) @[AllToAllPE.scala 211:21 AllToAllPE.scala 212:26]
    node _GEN_9 = mux(is_this_PE, memPE.MPORT_1.data, resp_value) @[AllToAllPE.scala 211:21 AllToAllPE.scala 212:18 AllToAllPE.scala 152:27]
    node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 225:20]
    node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 234:20]
    node _GEN_10 = mux(_T_8, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 234:36 AllToAllPE.scala 235:13 AllToAllPE.scala 244:13]
    node _GEN_11 = mux(_T_8, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllPE.scala 234:36 AllToAllPE.scala 236:18 AllToAllPE.scala 245:18]
    node _GEN_12 = mux(_T_8, resp_value, UInt<64>("haaaaaaaa")) @[AllToAllPE.scala 234:36 AllToAllPE.scala 238:23 AllToAllPE.scala 247:23]
    node _GEN_13 = mux(_T_8, UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 234:36 AllToAllPE.scala 240:17 AllToAllPE.scala 151:28]
    node _GEN_14 = mux(_T_8, UInt<3>("h0"), state) @[AllToAllPE.scala 234:36 AllToAllPE.scala 242:11 AllToAllPE.scala 150:22]
    node _GEN_15 = mux(_T_7, UInt<1>("h1"), _GEN_10) @[AllToAllPE.scala 225:31 AllToAllPE.scala 226:13]
    node _GEN_16 = mux(_T_7, UInt<1>("h0"), _GEN_11) @[AllToAllPE.scala 225:31 AllToAllPE.scala 227:18]
    node _GEN_17 = mux(_T_7, resp_signal, _GEN_10) @[AllToAllPE.scala 225:31 AllToAllPE.scala 228:19]
    node _GEN_18 = mux(_T_7, resp_value, _GEN_12) @[AllToAllPE.scala 225:31 AllToAllPE.scala 229:23]
    node _GEN_19 = mux(_T_7, UInt<1>("h0"), _GEN_13) @[AllToAllPE.scala 225:31 AllToAllPE.scala 231:17]
    node _GEN_20 = mux(_T_7, UInt<3>("h2"), _GEN_14) @[AllToAllPE.scala 225:31 AllToAllPE.scala 233:11]
    node _GEN_21 = mux(_T_5, UInt<1>("h0"), _GEN_15) @[AllToAllPE.scala 203:33 AllToAllPE.scala 205:13]
    node _GEN_22 = mux(_T_5, UInt<1>("h1"), _GEN_16) @[AllToAllPE.scala 203:33 AllToAllPE.scala 206:18]
    node _GEN_23 = mux(_T_5, resp_signal, _GEN_17) @[AllToAllPE.scala 203:33 AllToAllPE.scala 207:19]
    node _GEN_24 = mux(_T_5, resp_value, _GEN_18) @[AllToAllPE.scala 203:33 AllToAllPE.scala 208:23]
    node _GEN_25 = mux(_T_5, UInt<1>("h1"), _GEN_19) @[AllToAllPE.scala 203:33 AllToAllPE.scala 209:17]
    node _GEN_26 = validif(_T_5, _GEN_8) @[AllToAllPE.scala 203:33]
    node _GEN_27 = validif(_T_5, _GEN_4) @[AllToAllPE.scala 203:33]
    node _GEN_28 = mux(_T_5, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 203:33 AllToAllPE.scala 129:18]
    node _GEN_29 = mux(_T_5, _GEN_9, resp_value) @[AllToAllPE.scala 203:33 AllToAllPE.scala 152:27]
    node _GEN_30 = mux(_T_5, _GEN_2, _GEN_20) @[AllToAllPE.scala 203:33]
    node _GEN_31 = mux(_T_3, UInt<1>("h0"), _GEN_21) @[AllToAllPE.scala 181:32 AllToAllPE.scala 182:13]
    node _GEN_32 = mux(_T_3, UInt<1>("h1"), _GEN_22) @[AllToAllPE.scala 181:32 AllToAllPE.scala 183:18]
    node _GEN_33 = mux(_T_3, resp_signal, _GEN_23) @[AllToAllPE.scala 181:32 AllToAllPE.scala 184:19]
    node _GEN_34 = mux(_T_3, resp_value, _GEN_24) @[AllToAllPE.scala 181:32 AllToAllPE.scala 185:23]
    node _GEN_35 = mux(_T_3, UInt<1>("h1"), _GEN_25) @[AllToAllPE.scala 181:32 AllToAllPE.scala 186:17]
    node _GEN_36 = validif(_T_3, _GEN_3) @[AllToAllPE.scala 181:32]
    node _GEN_37 = validif(_T_3, _GEN_4) @[AllToAllPE.scala 181:32]
    node _GEN_38 = mux(_T_3, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 181:32 AllToAllPE.scala 129:18]
    node _GEN_39 = validif(_T_3, _GEN_6) @[AllToAllPE.scala 181:32]
    node _GEN_40 = validif(_T_3, _GEN_7) @[AllToAllPE.scala 181:32]
    node _GEN_41 = mux(_T_3, UInt<64>("h20"), _GEN_29) @[AllToAllPE.scala 181:32 AllToAllPE.scala 191:16]
    node _GEN_42 = mux(_T_3, _GEN_2, _GEN_30) @[AllToAllPE.scala 181:32]
    node _GEN_43 = validif(eq(_T_3, UInt<1>("h0")), _GEN_26) @[AllToAllPE.scala 181:32]
    node _GEN_44 = validif(eq(_T_3, UInt<1>("h0")), _GEN_27) @[AllToAllPE.scala 181:32]
    node _GEN_45 = mux(_T_3, UInt<1>("h0"), _GEN_28) @[AllToAllPE.scala 181:32 AllToAllPE.scala 129:18]
    node _GEN_46 = mux(_T_2, UInt<1>("h0"), _GEN_31) @[AllToAllPE.scala 163:23 AllToAllPE.scala 164:13]
    node _GEN_47 = mux(_T_2, UInt<1>("h1"), _GEN_32) @[AllToAllPE.scala 163:23 AllToAllPE.scala 165:18]
    node _GEN_48 = mux(_T_2, resp_signal, _GEN_33) @[AllToAllPE.scala 163:23 AllToAllPE.scala 166:19]
    node _GEN_49 = mux(_T_2, resp_value, _GEN_34) @[AllToAllPE.scala 163:23 AllToAllPE.scala 167:23]
    node _GEN_50 = mux(_T_2, UInt<1>("h0"), _GEN_41) @[AllToAllPE.scala 163:23 AllToAllPE.scala 168:16]
    node _GEN_51 = mux(_T_2, UInt<1>("h0"), _GEN_35) @[AllToAllPE.scala 163:23 AllToAllPE.scala 169:17]
    node _GEN_52 = mux(_T_2, _GEN_2, _GEN_42) @[AllToAllPE.scala 163:23]
    node _GEN_53 = validif(eq(_T_2, UInt<1>("h0")), _GEN_36) @[AllToAllPE.scala 163:23]
    node _GEN_54 = validif(eq(_T_2, UInt<1>("h0")), _GEN_37) @[AllToAllPE.scala 163:23]
    node _GEN_55 = mux(_T_2, UInt<1>("h0"), _GEN_38) @[AllToAllPE.scala 163:23 AllToAllPE.scala 129:18]
    node _GEN_56 = validif(eq(_T_2, UInt<1>("h0")), _GEN_39) @[AllToAllPE.scala 163:23]
    node _GEN_57 = validif(eq(_T_2, UInt<1>("h0")), _GEN_40) @[AllToAllPE.scala 163:23]
    node _GEN_58 = validif(eq(_T_2, UInt<1>("h0")), _GEN_43) @[AllToAllPE.scala 163:23]
    node _GEN_59 = validif(eq(_T_2, UInt<1>("h0")), _GEN_44) @[AllToAllPE.scala 163:23]
    node _GEN_60 = mux(_T_2, UInt<1>("h0"), _GEN_45) @[AllToAllPE.scala 163:23 AllToAllPE.scala 129:18]
    io_busy <= _GEN_46
    io_cmd_ready <= _GEN_47
    io_resp_valid <= _GEN_48
    io_resp_bits_data <= _GEN_49
    io_left_out <= UInt<64>("h0") @[AllToAllPE.scala 250:15]
    io_right_out <= UInt<64>("h0") @[AllToAllPE.scala 251:16]
    io_up_out <= UInt<64>("h0") @[AllToAllPE.scala 252:13]
    io_bottom_out <= UInt<64>("h0") @[AllToAllPE.scala 253:17]
    memPE.MPORT_1.addr <= _GEN_58
    memPE.MPORT_1.en <= _GEN_60
    memPE.MPORT_1.clk <= _GEN_59
    memPE.MPORT.addr <= _GEN_53
    memPE.MPORT.en <= _GEN_55
    memPE.MPORT.clk <= _GEN_54
    memPE.MPORT.data <= _GEN_57
    memPE.MPORT.mask <= _GEN_56
    x_coord <= mux(reset, UInt<2>("h2"), x_coord) @[AllToAllPE.scala 132:24 AllToAllPE.scala 132:24 AllToAllPE.scala 132:24]
    y_coord <= mux(reset, UInt<1>("h1"), y_coord) @[AllToAllPE.scala 133:24 AllToAllPE.scala 133:24 AllToAllPE.scala 133:24]
    rs1 <= io_cmd_bits_rs1 @[AllToAllPE.scala 146:7]
    rs2 <= io_cmd_bits_rs2 @[AllToAllPE.scala 147:7]
    state <= mux(reset, UInt<3>("h0"), _GEN_52) @[AllToAllPE.scala 150:22 AllToAllPE.scala 150:22]
    resp_signal <= mux(reset, UInt<1>("h0"), _GEN_51) @[AllToAllPE.scala 151:28 AllToAllPE.scala 151:28]
    resp_value <= mux(reset, UInt<1>("h0"), _GEN_50) @[AllToAllPE.scala 152:27 AllToAllPE.scala 152:27]

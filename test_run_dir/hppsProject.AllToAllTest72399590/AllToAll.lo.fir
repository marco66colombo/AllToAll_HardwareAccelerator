circuit AllToAll :
  module AllToAllController :
    input clock : Clock
    input reset : UInt<1>
    output io_processor_cmd_ready : UInt<1>
    input io_processor_cmd_valid : UInt<1>
    input io_processor_cmd_bits_inst_funct : UInt<7>
    input io_processor_cmd_bits_inst_rs2 : UInt<5>
    input io_processor_cmd_bits_inst_rs1 : UInt<5>
    input io_processor_cmd_bits_inst_xd : UInt<1>
    input io_processor_cmd_bits_inst_xs1 : UInt<1>
    input io_processor_cmd_bits_inst_xs2 : UInt<1>
    input io_processor_cmd_bits_inst_rd : UInt<5>
    input io_processor_cmd_bits_inst_opcode : UInt<7>
    input io_processor_cmd_bits_rs1 : UInt<64>
    input io_processor_cmd_bits_rs2 : UInt<64>
    input io_processor_resp_ready : UInt<1>
    output io_processor_resp_valid : UInt<1>
    output io_processor_resp_bits_rd : UInt<5>
    output io_processor_resp_bits_data : UInt<64>
    output io_processor_busy : UInt<1>
    output io_processor_interrupt : UInt<1>
    input io_processor_exception : UInt<1>
    input io_mesh_cmd_ready : UInt<1>
    output io_mesh_cmd_valid : UInt<1>
    output io_mesh_cmd_bits_load : UInt<1>
    output io_mesh_cmd_bits_store : UInt<1>
    output io_mesh_cmd_bits_doAllToAll : UInt<1>
    output io_mesh_cmd_bits_rs1 : UInt<64>
    output io_mesh_cmd_bits_rs2 : UInt<64>
    output io_mesh_resp_ready : UInt<1>
    input io_mesh_resp_valid : UInt<1>
    input io_mesh_resp_bits_data : UInt<64>
    input io_mesh_busy : UInt<1>

    reg state : UInt<3>, clock with :
      reset => (UInt<1>("h0"), state) @[AllToAllController.scala 45:22]
    reg rd_address : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address) @[AllToAllController.scala 46:23]
    node _T = eq(state, UInt<3>("h0")) @[AllToAllController.scala 53:43]
    node _T_1 = mux(_T, io_processor_cmd_bits_inst_rd, rd_address) @[AllToAllController.scala 53:35]
    node _T_2 = eq(io_processor_cmd_bits_inst_opcode, UInt<6>("h2b")) @[AllToAllController.scala 77:59]
    node goto_excange = and(io_processor_cmd_valid, _T_2) @[AllToAllController.scala 77:33]
    node goto_done_exchange = eq(io_mesh_busy, UInt<1>("h0")) @[AllToAllController.scala 80:28]
    node loadSignal = eq(io_processor_cmd_bits_inst_funct, UInt<1>("h1")) @[AllToAllController.scala 81:41]
    node storeSignal = eq(io_processor_cmd_bits_inst_funct, UInt<2>("h2")) @[AllToAllController.scala 82:42]
    node _T_3 = eq(io_processor_cmd_bits_inst_opcode, UInt<4>("hb")) @[AllToAllController.scala 83:54]
    node mem_cmd = and(io_processor_cmd_valid, _T_3) @[AllToAllController.scala 83:28]
    node _T_4 = eq(state, UInt<3>("h0")) @[AllToAllController.scala 85:14]
    node _GEN_0 = mux(mem_cmd, UInt<3>("h3"), UInt<3>("h0")) @[AllToAllController.scala 102:24 AllToAllController.scala 103:13 AllToAllController.scala 105:13]
    node _GEN_1 = mux(goto_excange, UInt<3>("h1"), _GEN_0) @[AllToAllController.scala 100:23 AllToAllController.scala 101:13]
    node _T_5 = eq(state, UInt<3>("h3")) @[AllToAllController.scala 107:20]
    node _GEN_2 = mux(storeSignal, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllController.scala 122:28 AllToAllController.scala 123:29 AllToAllController.scala 126:29]
    node _GEN_3 = mux(storeSignal, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllController.scala 122:28 AllToAllController.scala 124:30 AllToAllController.scala 127:30]
    node _GEN_4 = mux(loadSignal, UInt<1>("h1"), _GEN_2) @[AllToAllController.scala 119:21 AllToAllController.scala 120:29]
    node _GEN_5 = mux(loadSignal, UInt<1>("h0"), _GEN_3) @[AllToAllController.scala 119:21 AllToAllController.scala 121:30]
    node _GEN_6 = mux(mem_cmd, UInt<3>("h4"), UInt<3>("h5")) @[AllToAllController.scala 132:24 AllToAllController.scala 133:13 AllToAllController.scala 135:13]
    node _GEN_7 = mux(goto_excange, UInt<3>("h6"), _GEN_6) @[AllToAllController.scala 130:23 AllToAllController.scala 131:13]
    node _T_6 = eq(state, UInt<3>("h5")) @[AllToAllController.scala 138:20]
    node _T_7 = eq(state, UInt<3>("h4")) @[AllToAllController.scala 153:20]
    node _T_8 = eq(state, UInt<3>("h6")) @[AllToAllController.scala 183:20]
    node _T_9 = eq(state, UInt<3>("h1")) @[AllToAllController.scala 198:20]
    node _T_10 = eq(state, UInt<3>("h7")) @[AllToAllController.scala 213:20]
    node _GEN_8 = mux(goto_done_exchange, UInt<3>("h2"), UInt<3>("h7")) @[AllToAllController.scala 226:29 AllToAllController.scala 227:13 AllToAllController.scala 229:13]
    node _T_11 = eq(state, UInt<3>("h2")) @[AllToAllController.scala 231:20]
    node _GEN_9 = mux(_T_11, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllController.scala 231:36 AllToAllController.scala 232:23 AllToAllController.scala 244:23]
    node _GEN_10 = mux(_T_11, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllController.scala 231:36 AllToAllController.scala 234:16 AllToAllController.scala 246:16]
    node _GEN_11 = mux(_T_10, UInt<1>("h1"), _GEN_9) @[AllToAllController.scala 213:41 AllToAllController.scala 215:23]
    node _GEN_12 = mux(_T_10, UInt<1>("h0"), _GEN_10) @[AllToAllController.scala 213:41 AllToAllController.scala 217:16]
    node _GEN_13 = mux(_T_10, UInt<1>("h0"), _GEN_9) @[AllToAllController.scala 213:41 AllToAllController.scala 223:24]
    node _GEN_14 = mux(_T_10, _GEN_8, state) @[AllToAllController.scala 213:41 AllToAllController.scala 45:22]
    node _GEN_15 = mux(_T_9, UInt<1>("h1"), _GEN_11) @[AllToAllController.scala 198:31 AllToAllController.scala 200:23]
    node _GEN_16 = mux(_T_9, UInt<1>("h0"), _GEN_12) @[AllToAllController.scala 198:31 AllToAllController.scala 202:16]
    node _GEN_17 = mux(_T_9, io_processor_cmd_bits_inst_rd, rd_address) @[AllToAllController.scala 198:31 AllToAllController.scala 204:16 AllToAllController.scala 46:23]
    node _GEN_18 = mux(_T_9, UInt<1>("h1"), _GEN_12) @[AllToAllController.scala 198:31 AllToAllController.scala 208:33]
    node _GEN_19 = mux(_T_9, UInt<1>("h0"), _GEN_13) @[AllToAllController.scala 198:31 AllToAllController.scala 209:24]
    node _GEN_20 = mux(_T_9, UInt<3>("h7"), _GEN_14) @[AllToAllController.scala 198:31 AllToAllController.scala 212:11]
    node _GEN_21 = mux(_T_8, UInt<1>("h0"), _GEN_15) @[AllToAllController.scala 183:44 AllToAllController.scala 185:23]
    node _GEN_22 = mux(_T_8, UInt<1>("h1"), _GEN_16) @[AllToAllController.scala 183:44 AllToAllController.scala 187:16]
    node _GEN_23 = mux(_T_8, io_processor_cmd_bits_inst_rd, _GEN_17) @[AllToAllController.scala 183:44 AllToAllController.scala 189:16]
    node _GEN_24 = mux(_T_8, UInt<1>("h0"), _GEN_16) @[AllToAllController.scala 183:44 AllToAllController.scala 191:27]
    node _GEN_25 = mux(_T_8, UInt<1>("h1"), _GEN_18) @[AllToAllController.scala 183:44 AllToAllController.scala 193:33]
    node _GEN_26 = mux(_T_8, UInt<1>("h1"), _GEN_19) @[AllToAllController.scala 183:44 AllToAllController.scala 194:24]
    node _GEN_27 = mux(_T_8, UInt<3>("h7"), _GEN_20) @[AllToAllController.scala 183:44 AllToAllController.scala 197:11]
    node _GEN_28 = mux(_T_7, UInt<1>("h0"), _GEN_21) @[AllToAllController.scala 153:41 AllToAllController.scala 155:23]
    node _GEN_29 = mux(_T_7, UInt<1>("h1"), _GEN_22) @[AllToAllController.scala 153:41 AllToAllController.scala 157:16]
    node _GEN_30 = mux(_T_7, io_processor_cmd_bits_inst_rd, _GEN_23) @[AllToAllController.scala 153:41 AllToAllController.scala 159:16]
    node _GEN_31 = mux(_T_7, UInt<1>("h0"), _GEN_25) @[AllToAllController.scala 153:41 AllToAllController.scala 161:33]
    node _GEN_32 = mux(_T_7, UInt<1>("h1"), _GEN_26) @[AllToAllController.scala 153:41 AllToAllController.scala 162:24]
    node _GEN_33 = mux(_T_7, _GEN_4, _GEN_24) @[AllToAllController.scala 153:41]
    node _GEN_34 = mux(_T_7, _GEN_5, _GEN_24) @[AllToAllController.scala 153:41]
    node _GEN_35 = mux(_T_7, _GEN_7, _GEN_27) @[AllToAllController.scala 153:41]
    node _GEN_36 = mux(_T_6, UInt<1>("h1"), _GEN_28) @[AllToAllController.scala 138:38 AllToAllController.scala 140:23]
    node _GEN_37 = mux(_T_6, UInt<1>("h0"), _GEN_29) @[AllToAllController.scala 138:38 AllToAllController.scala 142:16]
    node _GEN_38 = mux(_T_6, io_processor_cmd_bits_inst_rd, _GEN_30) @[AllToAllController.scala 138:38 AllToAllController.scala 144:16]
    node _GEN_39 = mux(_T_6, UInt<1>("h0"), _GEN_33) @[AllToAllController.scala 138:38 AllToAllController.scala 146:27]
    node _GEN_40 = mux(_T_6, UInt<1>("h0"), _GEN_34) @[AllToAllController.scala 138:38 AllToAllController.scala 147:28]
    node _GEN_41 = mux(_T_6, UInt<1>("h0"), _GEN_31) @[AllToAllController.scala 138:38 AllToAllController.scala 148:33]
    node _GEN_42 = mux(_T_6, UInt<1>("h1"), _GEN_32) @[AllToAllController.scala 138:38 AllToAllController.scala 149:24]
    node _GEN_43 = mux(_T_6, UInt<3>("h0"), _GEN_35) @[AllToAllController.scala 138:38 AllToAllController.scala 151:11]
    node _GEN_44 = mux(_T_5, UInt<1>("h0"), _GEN_36) @[AllToAllController.scala 107:38 AllToAllController.scala 110:23]
    node _GEN_45 = mux(_T_5, UInt<1>("h1"), _GEN_37) @[AllToAllController.scala 107:38 AllToAllController.scala 112:16]
    node _GEN_46 = mux(_T_5, io_processor_cmd_bits_inst_rd, _GEN_38) @[AllToAllController.scala 107:38 AllToAllController.scala 114:16]
    node _GEN_47 = mux(_T_5, UInt<1>("h0"), _GEN_41) @[AllToAllController.scala 107:38 AllToAllController.scala 116:33]
    node _GEN_48 = mux(_T_5, UInt<1>("h0"), _GEN_42) @[AllToAllController.scala 107:38 AllToAllController.scala 117:24]
    node _GEN_49 = mux(_T_5, _GEN_4, _GEN_39) @[AllToAllController.scala 107:38]
    node _GEN_50 = mux(_T_5, _GEN_5, _GEN_40) @[AllToAllController.scala 107:38]
    node _GEN_51 = mux(_T_5, _GEN_7, _GEN_43) @[AllToAllController.scala 107:38]
    node _GEN_52 = mux(_T_4, UInt<1>("h0"), _GEN_44) @[AllToAllController.scala 85:23 AllToAllController.scala 87:23]
    node _GEN_53 = mux(_T_4, UInt<1>("h1"), _GEN_45) @[AllToAllController.scala 85:23 AllToAllController.scala 89:16]
    node _GEN_54 = mux(_T_4, UInt<1>("h0"), _GEN_49) @[AllToAllController.scala 85:23 AllToAllController.scala 93:27]
    node _GEN_55 = mux(_T_4, UInt<1>("h0"), _GEN_50) @[AllToAllController.scala 85:23 AllToAllController.scala 94:28]
    node _GEN_56 = mux(_T_4, UInt<1>("h0"), _GEN_47) @[AllToAllController.scala 85:23 AllToAllController.scala 95:33]
    node _GEN_57 = mux(_T_4, UInt<1>("h0"), _GEN_48) @[AllToAllController.scala 85:23 AllToAllController.scala 97:24]
    node _GEN_58 = mux(_T_4, _GEN_1, _GEN_51) @[AllToAllController.scala 85:23]
    node _GEN_59 = mux(_T_4, rd_address, _GEN_46) @[AllToAllController.scala 85:23 AllToAllController.scala 46:23]
    io_processor_cmd_ready <= _GEN_53
    io_processor_resp_valid <= io_mesh_resp_ready @[AllToAllController.scala 69:15]
    io_processor_resp_bits_rd <= _T_1 @[AllToAllController.scala 53:29]
    io_processor_resp_bits_data <= io_mesh_resp_bits_data @[AllToAllController.scala 67:19]
    io_processor_busy <= _GEN_52
    io_processor_interrupt <= UInt<1>("h0") @[AllToAllController.scala 61:26]
    io_mesh_cmd_valid <= io_processor_cmd_valid @[AllToAllController.scala 63:21]
    io_mesh_cmd_bits_load <= _GEN_54
    io_mesh_cmd_bits_store <= _GEN_55
    io_mesh_cmd_bits_doAllToAll <= _GEN_56
    io_mesh_cmd_bits_rs1 <= io_processor_cmd_bits_rs1 @[AllToAllController.scala 64:24]
    io_mesh_cmd_bits_rs2 <= io_processor_cmd_bits_rs2 @[AllToAllController.scala 65:24]
    io_mesh_resp_ready <= _GEN_57
    state <= mux(reset, UInt<3>("h0"), _GEN_58) @[AllToAllController.scala 45:22 AllToAllController.scala 45:22]
    rd_address <= _GEN_59

  module AllToAllPEupLeftCorner :
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
      depth => 9
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:20]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:20]
    reg state : UInt<3>, clock with :
      reset => (UInt<1>("h0"), state) @[AllToAllPE.scala 144:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 145:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 146:27]
    node x_value = bits(io_cmd_bits_rs2, 15, 0) @[AllToAllPE.scala 147:32]
    node y_value = bits(io_cmd_bits_rs2, 31, 16) @[AllToAllPE.scala 148:32]
    node memIndex = bits(io_cmd_bits_rs2, 63, 32) @[AllToAllPE.scala 149:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 152:28]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 152:51]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 152:40]
    node load_signal = and(io_cmd_valid, io_cmd_bits_load) @[AllToAllPE.scala 153:34]
    node store_signal = and(io_cmd_valid, io_cmd_bits_store) @[AllToAllPE.scala 154:35]
    node allToAll_signal = and(io_cmd_valid, io_cmd_bits_doAllToAll) @[AllToAllPE.scala 155:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 157:14]
    node _GEN_0 = mux(allToAll_signal, UInt<3>("h1"), UInt<3>("h0")) @[AllToAllPE.scala 168:32 AllToAllPE.scala 169:13 AllToAllPE.scala 171:13]
    node _GEN_1 = mux(store_signal, UInt<3>("h4"), _GEN_0) @[AllToAllPE.scala 166:29 AllToAllPE.scala 167:13]
    node _GEN_2 = mux(load_signal, UInt<3>("h3"), _GEN_1) @[AllToAllPE.scala 164:22 AllToAllPE.scala 165:13]
    node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 174:20]
    node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 182:12]
    node _GEN_3 = validif(is_this_PE, _T_4) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12]
    node _GEN_4 = validif(is_this_PE, clock) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12]
    node _GEN_5 = mux(is_this_PE, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12 AllToAllPE.scala 129:18]
    node _GEN_6 = validif(is_this_PE, UInt<1>("h1")) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:23]
    node _GEN_7 = validif(is_this_PE, io_cmd_bits_rs1) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:23]
    node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 196:20]
    node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 205:26]
    node _GEN_8 = validif(is_this_PE, _T_6) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:26]
    node _GEN_9 = mux(is_this_PE, memPE.MPORT_1.data, resp_value) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:18 AllToAllPE.scala 146:27]
    node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 218:20]
    node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 227:20]
    node _GEN_10 = mux(_T_8, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 228:13 AllToAllPE.scala 237:13]
    node _GEN_11 = mux(_T_8, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 229:18 AllToAllPE.scala 238:18]
    node _GEN_12 = mux(_T_8, resp_value, UInt<64>("haaaaaaaa")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 231:23 AllToAllPE.scala 240:23]
    node _GEN_13 = mux(_T_8, UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 227:36 AllToAllPE.scala 233:17 AllToAllPE.scala 145:28]
    node _GEN_14 = mux(_T_8, UInt<3>("h0"), state) @[AllToAllPE.scala 227:36 AllToAllPE.scala 235:11 AllToAllPE.scala 144:22]
    node _GEN_15 = mux(_T_7, UInt<1>("h1"), _GEN_10) @[AllToAllPE.scala 218:31 AllToAllPE.scala 219:13]
    node _GEN_16 = mux(_T_7, UInt<1>("h0"), _GEN_11) @[AllToAllPE.scala 218:31 AllToAllPE.scala 220:18]
    node _GEN_17 = mux(_T_7, resp_signal, _GEN_10) @[AllToAllPE.scala 218:31 AllToAllPE.scala 221:19]
    node _GEN_18 = mux(_T_7, resp_value, _GEN_12) @[AllToAllPE.scala 218:31 AllToAllPE.scala 222:23]
    node _GEN_19 = mux(_T_7, UInt<1>("h0"), _GEN_13) @[AllToAllPE.scala 218:31 AllToAllPE.scala 224:17]
    node _GEN_20 = mux(_T_7, UInt<3>("h2"), _GEN_14) @[AllToAllPE.scala 218:31 AllToAllPE.scala 226:11]
    node _GEN_21 = mux(_T_5, UInt<1>("h0"), _GEN_15) @[AllToAllPE.scala 196:33 AllToAllPE.scala 198:13]
    node _GEN_22 = mux(_T_5, UInt<1>("h1"), _GEN_16) @[AllToAllPE.scala 196:33 AllToAllPE.scala 199:18]
    node _GEN_23 = mux(_T_5, resp_signal, _GEN_17) @[AllToAllPE.scala 196:33 AllToAllPE.scala 200:19]
    node _GEN_24 = mux(_T_5, resp_value, _GEN_18) @[AllToAllPE.scala 196:33 AllToAllPE.scala 201:23]
    node _GEN_25 = mux(_T_5, UInt<1>("h1"), _GEN_19) @[AllToAllPE.scala 196:33 AllToAllPE.scala 202:17]
    node _GEN_26 = validif(_T_5, _GEN_8) @[AllToAllPE.scala 196:33]
    node _GEN_27 = validif(_T_5, _GEN_4) @[AllToAllPE.scala 196:33]
    node _GEN_28 = mux(_T_5, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 196:33 AllToAllPE.scala 129:18]
    node _GEN_29 = mux(_T_5, _GEN_9, resp_value) @[AllToAllPE.scala 196:33 AllToAllPE.scala 146:27]
    node _GEN_30 = mux(_T_5, _GEN_2, _GEN_20) @[AllToAllPE.scala 196:33]
    node _GEN_31 = mux(_T_3, UInt<1>("h0"), _GEN_21) @[AllToAllPE.scala 174:32 AllToAllPE.scala 175:13]
    node _GEN_32 = mux(_T_3, UInt<1>("h1"), _GEN_22) @[AllToAllPE.scala 174:32 AllToAllPE.scala 176:18]
    node _GEN_33 = mux(_T_3, resp_signal, _GEN_23) @[AllToAllPE.scala 174:32 AllToAllPE.scala 177:19]
    node _GEN_34 = mux(_T_3, resp_value, _GEN_24) @[AllToAllPE.scala 174:32 AllToAllPE.scala 178:23]
    node _GEN_35 = mux(_T_3, UInt<1>("h1"), _GEN_25) @[AllToAllPE.scala 174:32 AllToAllPE.scala 179:17]
    node _GEN_36 = validif(_T_3, _GEN_3) @[AllToAllPE.scala 174:32]
    node _GEN_37 = validif(_T_3, _GEN_4) @[AllToAllPE.scala 174:32]
    node _GEN_38 = mux(_T_3, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 174:32 AllToAllPE.scala 129:18]
    node _GEN_39 = validif(_T_3, _GEN_6) @[AllToAllPE.scala 174:32]
    node _GEN_40 = validif(_T_3, _GEN_7) @[AllToAllPE.scala 174:32]
    node _GEN_41 = mux(_T_3, UInt<64>("h20"), _GEN_29) @[AllToAllPE.scala 174:32 AllToAllPE.scala 184:16]
    node _GEN_42 = mux(_T_3, _GEN_2, _GEN_30) @[AllToAllPE.scala 174:32]
    node _GEN_43 = validif(eq(_T_3, UInt<1>("h0")), _GEN_26) @[AllToAllPE.scala 174:32]
    node _GEN_44 = validif(eq(_T_3, UInt<1>("h0")), _GEN_27) @[AllToAllPE.scala 174:32]
    node _GEN_45 = mux(_T_3, UInt<1>("h0"), _GEN_28) @[AllToAllPE.scala 174:32 AllToAllPE.scala 129:18]
    node _GEN_46 = mux(_T_2, UInt<1>("h0"), _GEN_31) @[AllToAllPE.scala 157:23 AllToAllPE.scala 158:13]
    node _GEN_47 = mux(_T_2, UInt<1>("h1"), _GEN_32) @[AllToAllPE.scala 157:23 AllToAllPE.scala 159:18]
    node _GEN_48 = mux(_T_2, resp_signal, _GEN_33) @[AllToAllPE.scala 157:23 AllToAllPE.scala 160:19]
    node _GEN_49 = mux(_T_2, resp_value, _GEN_34) @[AllToAllPE.scala 157:23 AllToAllPE.scala 161:23]
    node _GEN_50 = mux(_T_2, UInt<1>("h0"), _GEN_35) @[AllToAllPE.scala 157:23 AllToAllPE.scala 162:17]
    node _GEN_51 = mux(_T_2, _GEN_2, _GEN_42) @[AllToAllPE.scala 157:23]
    node _GEN_52 = validif(eq(_T_2, UInt<1>("h0")), _GEN_36) @[AllToAllPE.scala 157:23]
    node _GEN_53 = validif(eq(_T_2, UInt<1>("h0")), _GEN_37) @[AllToAllPE.scala 157:23]
    node _GEN_54 = mux(_T_2, UInt<1>("h0"), _GEN_38) @[AllToAllPE.scala 157:23 AllToAllPE.scala 129:18]
    node _GEN_55 = validif(eq(_T_2, UInt<1>("h0")), _GEN_39) @[AllToAllPE.scala 157:23]
    node _GEN_56 = validif(eq(_T_2, UInt<1>("h0")), _GEN_40) @[AllToAllPE.scala 157:23]
    node _GEN_57 = mux(_T_2, resp_value, _GEN_41) @[AllToAllPE.scala 157:23 AllToAllPE.scala 146:27]
    node _GEN_58 = validif(eq(_T_2, UInt<1>("h0")), _GEN_43) @[AllToAllPE.scala 157:23]
    node _GEN_59 = validif(eq(_T_2, UInt<1>("h0")), _GEN_44) @[AllToAllPE.scala 157:23]
    node _GEN_60 = mux(_T_2, UInt<1>("h0"), _GEN_45) @[AllToAllPE.scala 157:23 AllToAllPE.scala 129:18]
    io_busy <= _GEN_46
    io_cmd_ready <= _GEN_47
    io_resp_valid <= _GEN_48
    io_resp_bits_data <= _GEN_49
    io_left_out <= UInt<64>("h0") @[AllToAllPE.scala 305:15]
    io_right_out <= UInt<64>("h0") @[AllToAllPE.scala 309:16]
    io_up_out <= UInt<64>("h0") @[AllToAllPE.scala 307:13]
    io_bottom_out <= UInt<64>("h0") @[AllToAllPE.scala 310:17]
    memPE.MPORT_1.addr <= _GEN_58
    memPE.MPORT_1.en <= _GEN_60
    memPE.MPORT_1.clk <= _GEN_59
    memPE.MPORT.addr <= _GEN_52
    memPE.MPORT.en <= _GEN_54
    memPE.MPORT.clk <= _GEN_53
    memPE.MPORT.data <= _GEN_56
    memPE.MPORT.mask <= _GEN_55
    x_coord <= UInt<16>("h0") @[AllToAllPE.scala 134:11]
    y_coord <= UInt<16>("h2") @[AllToAllPE.scala 135:11]
    state <= mux(reset, UInt<3>("h0"), _GEN_51) @[AllToAllPE.scala 144:22 AllToAllPE.scala 144:22]
    resp_signal <= mux(reset, UInt<1>("h0"), _GEN_50) @[AllToAllPE.scala 145:28 AllToAllPE.scala 145:28]
    resp_value <= mux(reset, UInt<1>("h0"), _GEN_57) @[AllToAllPE.scala 146:27 AllToAllPE.scala 146:27]

  module AllToAllPEup :
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
      depth => 9
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:20]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:20]
    reg state : UInt<3>, clock with :
      reset => (UInt<1>("h0"), state) @[AllToAllPE.scala 144:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 145:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 146:27]
    node x_value = bits(io_cmd_bits_rs2, 15, 0) @[AllToAllPE.scala 147:32]
    node y_value = bits(io_cmd_bits_rs2, 31, 16) @[AllToAllPE.scala 148:32]
    node memIndex = bits(io_cmd_bits_rs2, 63, 32) @[AllToAllPE.scala 149:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 152:28]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 152:51]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 152:40]
    node load_signal = and(io_cmd_valid, io_cmd_bits_load) @[AllToAllPE.scala 153:34]
    node store_signal = and(io_cmd_valid, io_cmd_bits_store) @[AllToAllPE.scala 154:35]
    node allToAll_signal = and(io_cmd_valid, io_cmd_bits_doAllToAll) @[AllToAllPE.scala 155:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 157:14]
    node _GEN_0 = mux(allToAll_signal, UInt<3>("h1"), UInt<3>("h0")) @[AllToAllPE.scala 168:32 AllToAllPE.scala 169:13 AllToAllPE.scala 171:13]
    node _GEN_1 = mux(store_signal, UInt<3>("h4"), _GEN_0) @[AllToAllPE.scala 166:29 AllToAllPE.scala 167:13]
    node _GEN_2 = mux(load_signal, UInt<3>("h3"), _GEN_1) @[AllToAllPE.scala 164:22 AllToAllPE.scala 165:13]
    node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 174:20]
    node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 182:12]
    node _GEN_3 = validif(is_this_PE, _T_4) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12]
    node _GEN_4 = validif(is_this_PE, clock) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12]
    node _GEN_5 = mux(is_this_PE, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12 AllToAllPE.scala 129:18]
    node _GEN_6 = validif(is_this_PE, UInt<1>("h1")) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:23]
    node _GEN_7 = validif(is_this_PE, io_cmd_bits_rs1) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:23]
    node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 196:20]
    node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 205:26]
    node _GEN_8 = validif(is_this_PE, _T_6) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:26]
    node _GEN_9 = mux(is_this_PE, memPE.MPORT_1.data, resp_value) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:18 AllToAllPE.scala 146:27]
    node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 218:20]
    node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 227:20]
    node _GEN_10 = mux(_T_8, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 228:13 AllToAllPE.scala 237:13]
    node _GEN_11 = mux(_T_8, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 229:18 AllToAllPE.scala 238:18]
    node _GEN_12 = mux(_T_8, resp_value, UInt<64>("haaaaaaaa")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 231:23 AllToAllPE.scala 240:23]
    node _GEN_13 = mux(_T_8, UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 227:36 AllToAllPE.scala 233:17 AllToAllPE.scala 145:28]
    node _GEN_14 = mux(_T_8, UInt<3>("h0"), state) @[AllToAllPE.scala 227:36 AllToAllPE.scala 235:11 AllToAllPE.scala 144:22]
    node _GEN_15 = mux(_T_7, UInt<1>("h1"), _GEN_10) @[AllToAllPE.scala 218:31 AllToAllPE.scala 219:13]
    node _GEN_16 = mux(_T_7, UInt<1>("h0"), _GEN_11) @[AllToAllPE.scala 218:31 AllToAllPE.scala 220:18]
    node _GEN_17 = mux(_T_7, resp_signal, _GEN_10) @[AllToAllPE.scala 218:31 AllToAllPE.scala 221:19]
    node _GEN_18 = mux(_T_7, resp_value, _GEN_12) @[AllToAllPE.scala 218:31 AllToAllPE.scala 222:23]
    node _GEN_19 = mux(_T_7, UInt<1>("h0"), _GEN_13) @[AllToAllPE.scala 218:31 AllToAllPE.scala 224:17]
    node _GEN_20 = mux(_T_7, UInt<3>("h2"), _GEN_14) @[AllToAllPE.scala 218:31 AllToAllPE.scala 226:11]
    node _GEN_21 = mux(_T_5, UInt<1>("h0"), _GEN_15) @[AllToAllPE.scala 196:33 AllToAllPE.scala 198:13]
    node _GEN_22 = mux(_T_5, UInt<1>("h1"), _GEN_16) @[AllToAllPE.scala 196:33 AllToAllPE.scala 199:18]
    node _GEN_23 = mux(_T_5, resp_signal, _GEN_17) @[AllToAllPE.scala 196:33 AllToAllPE.scala 200:19]
    node _GEN_24 = mux(_T_5, resp_value, _GEN_18) @[AllToAllPE.scala 196:33 AllToAllPE.scala 201:23]
    node _GEN_25 = mux(_T_5, UInt<1>("h1"), _GEN_19) @[AllToAllPE.scala 196:33 AllToAllPE.scala 202:17]
    node _GEN_26 = validif(_T_5, _GEN_8) @[AllToAllPE.scala 196:33]
    node _GEN_27 = validif(_T_5, _GEN_4) @[AllToAllPE.scala 196:33]
    node _GEN_28 = mux(_T_5, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 196:33 AllToAllPE.scala 129:18]
    node _GEN_29 = mux(_T_5, _GEN_9, resp_value) @[AllToAllPE.scala 196:33 AllToAllPE.scala 146:27]
    node _GEN_30 = mux(_T_5, _GEN_2, _GEN_20) @[AllToAllPE.scala 196:33]
    node _GEN_31 = mux(_T_3, UInt<1>("h0"), _GEN_21) @[AllToAllPE.scala 174:32 AllToAllPE.scala 175:13]
    node _GEN_32 = mux(_T_3, UInt<1>("h1"), _GEN_22) @[AllToAllPE.scala 174:32 AllToAllPE.scala 176:18]
    node _GEN_33 = mux(_T_3, resp_signal, _GEN_23) @[AllToAllPE.scala 174:32 AllToAllPE.scala 177:19]
    node _GEN_34 = mux(_T_3, resp_value, _GEN_24) @[AllToAllPE.scala 174:32 AllToAllPE.scala 178:23]
    node _GEN_35 = mux(_T_3, UInt<1>("h1"), _GEN_25) @[AllToAllPE.scala 174:32 AllToAllPE.scala 179:17]
    node _GEN_36 = validif(_T_3, _GEN_3) @[AllToAllPE.scala 174:32]
    node _GEN_37 = validif(_T_3, _GEN_4) @[AllToAllPE.scala 174:32]
    node _GEN_38 = mux(_T_3, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 174:32 AllToAllPE.scala 129:18]
    node _GEN_39 = validif(_T_3, _GEN_6) @[AllToAllPE.scala 174:32]
    node _GEN_40 = validif(_T_3, _GEN_7) @[AllToAllPE.scala 174:32]
    node _GEN_41 = mux(_T_3, UInt<64>("h20"), _GEN_29) @[AllToAllPE.scala 174:32 AllToAllPE.scala 184:16]
    node _GEN_42 = mux(_T_3, _GEN_2, _GEN_30) @[AllToAllPE.scala 174:32]
    node _GEN_43 = validif(eq(_T_3, UInt<1>("h0")), _GEN_26) @[AllToAllPE.scala 174:32]
    node _GEN_44 = validif(eq(_T_3, UInt<1>("h0")), _GEN_27) @[AllToAllPE.scala 174:32]
    node _GEN_45 = mux(_T_3, UInt<1>("h0"), _GEN_28) @[AllToAllPE.scala 174:32 AllToAllPE.scala 129:18]
    node _GEN_46 = mux(_T_2, UInt<1>("h0"), _GEN_31) @[AllToAllPE.scala 157:23 AllToAllPE.scala 158:13]
    node _GEN_47 = mux(_T_2, UInt<1>("h1"), _GEN_32) @[AllToAllPE.scala 157:23 AllToAllPE.scala 159:18]
    node _GEN_48 = mux(_T_2, resp_signal, _GEN_33) @[AllToAllPE.scala 157:23 AllToAllPE.scala 160:19]
    node _GEN_49 = mux(_T_2, resp_value, _GEN_34) @[AllToAllPE.scala 157:23 AllToAllPE.scala 161:23]
    node _GEN_50 = mux(_T_2, UInt<1>("h0"), _GEN_35) @[AllToAllPE.scala 157:23 AllToAllPE.scala 162:17]
    node _GEN_51 = mux(_T_2, _GEN_2, _GEN_42) @[AllToAllPE.scala 157:23]
    node _GEN_52 = validif(eq(_T_2, UInt<1>("h0")), _GEN_36) @[AllToAllPE.scala 157:23]
    node _GEN_53 = validif(eq(_T_2, UInt<1>("h0")), _GEN_37) @[AllToAllPE.scala 157:23]
    node _GEN_54 = mux(_T_2, UInt<1>("h0"), _GEN_38) @[AllToAllPE.scala 157:23 AllToAllPE.scala 129:18]
    node _GEN_55 = validif(eq(_T_2, UInt<1>("h0")), _GEN_39) @[AllToAllPE.scala 157:23]
    node _GEN_56 = validif(eq(_T_2, UInt<1>("h0")), _GEN_40) @[AllToAllPE.scala 157:23]
    node _GEN_57 = mux(_T_2, resp_value, _GEN_41) @[AllToAllPE.scala 157:23 AllToAllPE.scala 146:27]
    node _GEN_58 = validif(eq(_T_2, UInt<1>("h0")), _GEN_43) @[AllToAllPE.scala 157:23]
    node _GEN_59 = validif(eq(_T_2, UInt<1>("h0")), _GEN_44) @[AllToAllPE.scala 157:23]
    node _GEN_60 = mux(_T_2, UInt<1>("h0"), _GEN_45) @[AllToAllPE.scala 157:23 AllToAllPE.scala 129:18]
    io_busy <= _GEN_46
    io_cmd_ready <= _GEN_47
    io_resp_valid <= _GEN_48
    io_resp_bits_data <= _GEN_49
    io_left_out <= UInt<64>("h0") @[AllToAllPE.scala 357:15]
    io_right_out <= UInt<64>("h0") @[AllToAllPE.scala 358:16]
    io_up_out <= UInt<64>("h0") @[AllToAllPE.scala 355:13]
    io_bottom_out <= UInt<64>("h0") @[AllToAllPE.scala 359:17]
    memPE.MPORT_1.addr <= _GEN_58
    memPE.MPORT_1.en <= _GEN_60
    memPE.MPORT_1.clk <= _GEN_59
    memPE.MPORT.addr <= _GEN_52
    memPE.MPORT.en <= _GEN_54
    memPE.MPORT.clk <= _GEN_53
    memPE.MPORT.data <= _GEN_56
    memPE.MPORT.mask <= _GEN_55
    x_coord <= UInt<16>("h1") @[AllToAllPE.scala 134:11]
    y_coord <= UInt<16>("h2") @[AllToAllPE.scala 135:11]
    state <= mux(reset, UInt<3>("h0"), _GEN_51) @[AllToAllPE.scala 144:22 AllToAllPE.scala 144:22]
    resp_signal <= mux(reset, UInt<1>("h0"), _GEN_50) @[AllToAllPE.scala 145:28 AllToAllPE.scala 145:28]
    resp_value <= mux(reset, UInt<1>("h0"), _GEN_57) @[AllToAllPE.scala 146:27 AllToAllPE.scala 146:27]

  module AllToAllPEupRightCorner :
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
      depth => 9
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:20]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:20]
    reg state : UInt<3>, clock with :
      reset => (UInt<1>("h0"), state) @[AllToAllPE.scala 144:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 145:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 146:27]
    node x_value = bits(io_cmd_bits_rs2, 15, 0) @[AllToAllPE.scala 147:32]
    node y_value = bits(io_cmd_bits_rs2, 31, 16) @[AllToAllPE.scala 148:32]
    node memIndex = bits(io_cmd_bits_rs2, 63, 32) @[AllToAllPE.scala 149:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 152:28]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 152:51]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 152:40]
    node load_signal = and(io_cmd_valid, io_cmd_bits_load) @[AllToAllPE.scala 153:34]
    node store_signal = and(io_cmd_valid, io_cmd_bits_store) @[AllToAllPE.scala 154:35]
    node allToAll_signal = and(io_cmd_valid, io_cmd_bits_doAllToAll) @[AllToAllPE.scala 155:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 157:14]
    node _GEN_0 = mux(allToAll_signal, UInt<3>("h1"), UInt<3>("h0")) @[AllToAllPE.scala 168:32 AllToAllPE.scala 169:13 AllToAllPE.scala 171:13]
    node _GEN_1 = mux(store_signal, UInt<3>("h4"), _GEN_0) @[AllToAllPE.scala 166:29 AllToAllPE.scala 167:13]
    node _GEN_2 = mux(load_signal, UInt<3>("h3"), _GEN_1) @[AllToAllPE.scala 164:22 AllToAllPE.scala 165:13]
    node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 174:20]
    node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 182:12]
    node _GEN_3 = validif(is_this_PE, _T_4) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12]
    node _GEN_4 = validif(is_this_PE, clock) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12]
    node _GEN_5 = mux(is_this_PE, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12 AllToAllPE.scala 129:18]
    node _GEN_6 = validif(is_this_PE, UInt<1>("h1")) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:23]
    node _GEN_7 = validif(is_this_PE, io_cmd_bits_rs1) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:23]
    node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 196:20]
    node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 205:26]
    node _GEN_8 = validif(is_this_PE, _T_6) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:26]
    node _GEN_9 = mux(is_this_PE, memPE.MPORT_1.data, resp_value) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:18 AllToAllPE.scala 146:27]
    node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 218:20]
    node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 227:20]
    node _GEN_10 = mux(_T_8, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 228:13 AllToAllPE.scala 237:13]
    node _GEN_11 = mux(_T_8, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 229:18 AllToAllPE.scala 238:18]
    node _GEN_12 = mux(_T_8, resp_value, UInt<64>("haaaaaaaa")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 231:23 AllToAllPE.scala 240:23]
    node _GEN_13 = mux(_T_8, UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 227:36 AllToAllPE.scala 233:17 AllToAllPE.scala 145:28]
    node _GEN_14 = mux(_T_8, UInt<3>("h0"), state) @[AllToAllPE.scala 227:36 AllToAllPE.scala 235:11 AllToAllPE.scala 144:22]
    node _GEN_15 = mux(_T_7, UInt<1>("h1"), _GEN_10) @[AllToAllPE.scala 218:31 AllToAllPE.scala 219:13]
    node _GEN_16 = mux(_T_7, UInt<1>("h0"), _GEN_11) @[AllToAllPE.scala 218:31 AllToAllPE.scala 220:18]
    node _GEN_17 = mux(_T_7, resp_signal, _GEN_10) @[AllToAllPE.scala 218:31 AllToAllPE.scala 221:19]
    node _GEN_18 = mux(_T_7, resp_value, _GEN_12) @[AllToAllPE.scala 218:31 AllToAllPE.scala 222:23]
    node _GEN_19 = mux(_T_7, UInt<1>("h0"), _GEN_13) @[AllToAllPE.scala 218:31 AllToAllPE.scala 224:17]
    node _GEN_20 = mux(_T_7, UInt<3>("h2"), _GEN_14) @[AllToAllPE.scala 218:31 AllToAllPE.scala 226:11]
    node _GEN_21 = mux(_T_5, UInt<1>("h0"), _GEN_15) @[AllToAllPE.scala 196:33 AllToAllPE.scala 198:13]
    node _GEN_22 = mux(_T_5, UInt<1>("h1"), _GEN_16) @[AllToAllPE.scala 196:33 AllToAllPE.scala 199:18]
    node _GEN_23 = mux(_T_5, resp_signal, _GEN_17) @[AllToAllPE.scala 196:33 AllToAllPE.scala 200:19]
    node _GEN_24 = mux(_T_5, resp_value, _GEN_18) @[AllToAllPE.scala 196:33 AllToAllPE.scala 201:23]
    node _GEN_25 = mux(_T_5, UInt<1>("h1"), _GEN_19) @[AllToAllPE.scala 196:33 AllToAllPE.scala 202:17]
    node _GEN_26 = validif(_T_5, _GEN_8) @[AllToAllPE.scala 196:33]
    node _GEN_27 = validif(_T_5, _GEN_4) @[AllToAllPE.scala 196:33]
    node _GEN_28 = mux(_T_5, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 196:33 AllToAllPE.scala 129:18]
    node _GEN_29 = mux(_T_5, _GEN_9, resp_value) @[AllToAllPE.scala 196:33 AllToAllPE.scala 146:27]
    node _GEN_30 = mux(_T_5, _GEN_2, _GEN_20) @[AllToAllPE.scala 196:33]
    node _GEN_31 = mux(_T_3, UInt<1>("h0"), _GEN_21) @[AllToAllPE.scala 174:32 AllToAllPE.scala 175:13]
    node _GEN_32 = mux(_T_3, UInt<1>("h1"), _GEN_22) @[AllToAllPE.scala 174:32 AllToAllPE.scala 176:18]
    node _GEN_33 = mux(_T_3, resp_signal, _GEN_23) @[AllToAllPE.scala 174:32 AllToAllPE.scala 177:19]
    node _GEN_34 = mux(_T_3, resp_value, _GEN_24) @[AllToAllPE.scala 174:32 AllToAllPE.scala 178:23]
    node _GEN_35 = mux(_T_3, UInt<1>("h1"), _GEN_25) @[AllToAllPE.scala 174:32 AllToAllPE.scala 179:17]
    node _GEN_36 = validif(_T_3, _GEN_3) @[AllToAllPE.scala 174:32]
    node _GEN_37 = validif(_T_3, _GEN_4) @[AllToAllPE.scala 174:32]
    node _GEN_38 = mux(_T_3, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 174:32 AllToAllPE.scala 129:18]
    node _GEN_39 = validif(_T_3, _GEN_6) @[AllToAllPE.scala 174:32]
    node _GEN_40 = validif(_T_3, _GEN_7) @[AllToAllPE.scala 174:32]
    node _GEN_41 = mux(_T_3, UInt<64>("h20"), _GEN_29) @[AllToAllPE.scala 174:32 AllToAllPE.scala 184:16]
    node _GEN_42 = mux(_T_3, _GEN_2, _GEN_30) @[AllToAllPE.scala 174:32]
    node _GEN_43 = validif(eq(_T_3, UInt<1>("h0")), _GEN_26) @[AllToAllPE.scala 174:32]
    node _GEN_44 = validif(eq(_T_3, UInt<1>("h0")), _GEN_27) @[AllToAllPE.scala 174:32]
    node _GEN_45 = mux(_T_3, UInt<1>("h0"), _GEN_28) @[AllToAllPE.scala 174:32 AllToAllPE.scala 129:18]
    node _GEN_46 = mux(_T_2, UInt<1>("h0"), _GEN_31) @[AllToAllPE.scala 157:23 AllToAllPE.scala 158:13]
    node _GEN_47 = mux(_T_2, UInt<1>("h1"), _GEN_32) @[AllToAllPE.scala 157:23 AllToAllPE.scala 159:18]
    node _GEN_48 = mux(_T_2, resp_signal, _GEN_33) @[AllToAllPE.scala 157:23 AllToAllPE.scala 160:19]
    node _GEN_49 = mux(_T_2, resp_value, _GEN_34) @[AllToAllPE.scala 157:23 AllToAllPE.scala 161:23]
    node _GEN_50 = mux(_T_2, UInt<1>("h0"), _GEN_35) @[AllToAllPE.scala 157:23 AllToAllPE.scala 162:17]
    node _GEN_51 = mux(_T_2, _GEN_2, _GEN_42) @[AllToAllPE.scala 157:23]
    node _GEN_52 = validif(eq(_T_2, UInt<1>("h0")), _GEN_36) @[AllToAllPE.scala 157:23]
    node _GEN_53 = validif(eq(_T_2, UInt<1>("h0")), _GEN_37) @[AllToAllPE.scala 157:23]
    node _GEN_54 = mux(_T_2, UInt<1>("h0"), _GEN_38) @[AllToAllPE.scala 157:23 AllToAllPE.scala 129:18]
    node _GEN_55 = validif(eq(_T_2, UInt<1>("h0")), _GEN_39) @[AllToAllPE.scala 157:23]
    node _GEN_56 = validif(eq(_T_2, UInt<1>("h0")), _GEN_40) @[AllToAllPE.scala 157:23]
    node _GEN_57 = mux(_T_2, resp_value, _GEN_41) @[AllToAllPE.scala 157:23 AllToAllPE.scala 146:27]
    node _GEN_58 = validif(eq(_T_2, UInt<1>("h0")), _GEN_43) @[AllToAllPE.scala 157:23]
    node _GEN_59 = validif(eq(_T_2, UInt<1>("h0")), _GEN_44) @[AllToAllPE.scala 157:23]
    node _GEN_60 = mux(_T_2, UInt<1>("h0"), _GEN_45) @[AllToAllPE.scala 157:23 AllToAllPE.scala 129:18]
    io_busy <= _GEN_46
    io_cmd_ready <= _GEN_47
    io_resp_valid <= _GEN_48
    io_resp_bits_data <= _GEN_49
    io_left_out <= UInt<64>("h0") @[AllToAllPE.scala 321:15]
    io_right_out <= UInt<64>("h0") @[AllToAllPE.scala 317:16]
    io_up_out <= UInt<64>("h0") @[AllToAllPE.scala 319:13]
    io_bottom_out <= UInt<64>("h0") @[AllToAllPE.scala 322:17]
    memPE.MPORT_1.addr <= _GEN_58
    memPE.MPORT_1.en <= _GEN_60
    memPE.MPORT_1.clk <= _GEN_59
    memPE.MPORT.addr <= _GEN_52
    memPE.MPORT.en <= _GEN_54
    memPE.MPORT.clk <= _GEN_53
    memPE.MPORT.data <= _GEN_56
    memPE.MPORT.mask <= _GEN_55
    x_coord <= UInt<16>("h2") @[AllToAllPE.scala 134:11]
    y_coord <= UInt<16>("h2") @[AllToAllPE.scala 135:11]
    state <= mux(reset, UInt<3>("h0"), _GEN_51) @[AllToAllPE.scala 144:22 AllToAllPE.scala 144:22]
    resp_signal <= mux(reset, UInt<1>("h0"), _GEN_50) @[AllToAllPE.scala 145:28 AllToAllPE.scala 145:28]
    resp_value <= mux(reset, UInt<1>("h0"), _GEN_57) @[AllToAllPE.scala 146:27 AllToAllPE.scala 146:27]

  module AllToAllPEleft :
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
      depth => 9
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:20]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:20]
    reg state : UInt<3>, clock with :
      reset => (UInt<1>("h0"), state) @[AllToAllPE.scala 144:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 145:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 146:27]
    node x_value = bits(io_cmd_bits_rs2, 15, 0) @[AllToAllPE.scala 147:32]
    node y_value = bits(io_cmd_bits_rs2, 31, 16) @[AllToAllPE.scala 148:32]
    node memIndex = bits(io_cmd_bits_rs2, 63, 32) @[AllToAllPE.scala 149:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 152:28]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 152:51]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 152:40]
    node load_signal = and(io_cmd_valid, io_cmd_bits_load) @[AllToAllPE.scala 153:34]
    node store_signal = and(io_cmd_valid, io_cmd_bits_store) @[AllToAllPE.scala 154:35]
    node allToAll_signal = and(io_cmd_valid, io_cmd_bits_doAllToAll) @[AllToAllPE.scala 155:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 157:14]
    node _GEN_0 = mux(allToAll_signal, UInt<3>("h1"), UInt<3>("h0")) @[AllToAllPE.scala 168:32 AllToAllPE.scala 169:13 AllToAllPE.scala 171:13]
    node _GEN_1 = mux(store_signal, UInt<3>("h4"), _GEN_0) @[AllToAllPE.scala 166:29 AllToAllPE.scala 167:13]
    node _GEN_2 = mux(load_signal, UInt<3>("h3"), _GEN_1) @[AllToAllPE.scala 164:22 AllToAllPE.scala 165:13]
    node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 174:20]
    node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 182:12]
    node _GEN_3 = validif(is_this_PE, _T_4) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12]
    node _GEN_4 = validif(is_this_PE, clock) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12]
    node _GEN_5 = mux(is_this_PE, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12 AllToAllPE.scala 129:18]
    node _GEN_6 = validif(is_this_PE, UInt<1>("h1")) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:23]
    node _GEN_7 = validif(is_this_PE, io_cmd_bits_rs1) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:23]
    node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 196:20]
    node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 205:26]
    node _GEN_8 = validif(is_this_PE, _T_6) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:26]
    node _GEN_9 = mux(is_this_PE, memPE.MPORT_1.data, resp_value) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:18 AllToAllPE.scala 146:27]
    node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 218:20]
    node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 227:20]
    node _GEN_10 = mux(_T_8, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 228:13 AllToAllPE.scala 237:13]
    node _GEN_11 = mux(_T_8, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 229:18 AllToAllPE.scala 238:18]
    node _GEN_12 = mux(_T_8, resp_value, UInt<64>("haaaaaaaa")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 231:23 AllToAllPE.scala 240:23]
    node _GEN_13 = mux(_T_8, UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 227:36 AllToAllPE.scala 233:17 AllToAllPE.scala 145:28]
    node _GEN_14 = mux(_T_8, UInt<3>("h0"), state) @[AllToAllPE.scala 227:36 AllToAllPE.scala 235:11 AllToAllPE.scala 144:22]
    node _GEN_15 = mux(_T_7, UInt<1>("h1"), _GEN_10) @[AllToAllPE.scala 218:31 AllToAllPE.scala 219:13]
    node _GEN_16 = mux(_T_7, UInt<1>("h0"), _GEN_11) @[AllToAllPE.scala 218:31 AllToAllPE.scala 220:18]
    node _GEN_17 = mux(_T_7, resp_signal, _GEN_10) @[AllToAllPE.scala 218:31 AllToAllPE.scala 221:19]
    node _GEN_18 = mux(_T_7, resp_value, _GEN_12) @[AllToAllPE.scala 218:31 AllToAllPE.scala 222:23]
    node _GEN_19 = mux(_T_7, UInt<1>("h0"), _GEN_13) @[AllToAllPE.scala 218:31 AllToAllPE.scala 224:17]
    node _GEN_20 = mux(_T_7, UInt<3>("h2"), _GEN_14) @[AllToAllPE.scala 218:31 AllToAllPE.scala 226:11]
    node _GEN_21 = mux(_T_5, UInt<1>("h0"), _GEN_15) @[AllToAllPE.scala 196:33 AllToAllPE.scala 198:13]
    node _GEN_22 = mux(_T_5, UInt<1>("h1"), _GEN_16) @[AllToAllPE.scala 196:33 AllToAllPE.scala 199:18]
    node _GEN_23 = mux(_T_5, resp_signal, _GEN_17) @[AllToAllPE.scala 196:33 AllToAllPE.scala 200:19]
    node _GEN_24 = mux(_T_5, resp_value, _GEN_18) @[AllToAllPE.scala 196:33 AllToAllPE.scala 201:23]
    node _GEN_25 = mux(_T_5, UInt<1>("h1"), _GEN_19) @[AllToAllPE.scala 196:33 AllToAllPE.scala 202:17]
    node _GEN_26 = validif(_T_5, _GEN_8) @[AllToAllPE.scala 196:33]
    node _GEN_27 = validif(_T_5, _GEN_4) @[AllToAllPE.scala 196:33]
    node _GEN_28 = mux(_T_5, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 196:33 AllToAllPE.scala 129:18]
    node _GEN_29 = mux(_T_5, _GEN_9, resp_value) @[AllToAllPE.scala 196:33 AllToAllPE.scala 146:27]
    node _GEN_30 = mux(_T_5, _GEN_2, _GEN_20) @[AllToAllPE.scala 196:33]
    node _GEN_31 = mux(_T_3, UInt<1>("h0"), _GEN_21) @[AllToAllPE.scala 174:32 AllToAllPE.scala 175:13]
    node _GEN_32 = mux(_T_3, UInt<1>("h1"), _GEN_22) @[AllToAllPE.scala 174:32 AllToAllPE.scala 176:18]
    node _GEN_33 = mux(_T_3, resp_signal, _GEN_23) @[AllToAllPE.scala 174:32 AllToAllPE.scala 177:19]
    node _GEN_34 = mux(_T_3, resp_value, _GEN_24) @[AllToAllPE.scala 174:32 AllToAllPE.scala 178:23]
    node _GEN_35 = mux(_T_3, UInt<1>("h1"), _GEN_25) @[AllToAllPE.scala 174:32 AllToAllPE.scala 179:17]
    node _GEN_36 = validif(_T_3, _GEN_3) @[AllToAllPE.scala 174:32]
    node _GEN_37 = validif(_T_3, _GEN_4) @[AllToAllPE.scala 174:32]
    node _GEN_38 = mux(_T_3, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 174:32 AllToAllPE.scala 129:18]
    node _GEN_39 = validif(_T_3, _GEN_6) @[AllToAllPE.scala 174:32]
    node _GEN_40 = validif(_T_3, _GEN_7) @[AllToAllPE.scala 174:32]
    node _GEN_41 = mux(_T_3, UInt<64>("h20"), _GEN_29) @[AllToAllPE.scala 174:32 AllToAllPE.scala 184:16]
    node _GEN_42 = mux(_T_3, _GEN_2, _GEN_30) @[AllToAllPE.scala 174:32]
    node _GEN_43 = validif(eq(_T_3, UInt<1>("h0")), _GEN_26) @[AllToAllPE.scala 174:32]
    node _GEN_44 = validif(eq(_T_3, UInt<1>("h0")), _GEN_27) @[AllToAllPE.scala 174:32]
    node _GEN_45 = mux(_T_3, UInt<1>("h0"), _GEN_28) @[AllToAllPE.scala 174:32 AllToAllPE.scala 129:18]
    node _GEN_46 = mux(_T_2, UInt<1>("h0"), _GEN_31) @[AllToAllPE.scala 157:23 AllToAllPE.scala 158:13]
    node _GEN_47 = mux(_T_2, UInt<1>("h1"), _GEN_32) @[AllToAllPE.scala 157:23 AllToAllPE.scala 159:18]
    node _GEN_48 = mux(_T_2, resp_signal, _GEN_33) @[AllToAllPE.scala 157:23 AllToAllPE.scala 160:19]
    node _GEN_49 = mux(_T_2, resp_value, _GEN_34) @[AllToAllPE.scala 157:23 AllToAllPE.scala 161:23]
    node _GEN_50 = mux(_T_2, UInt<1>("h0"), _GEN_35) @[AllToAllPE.scala 157:23 AllToAllPE.scala 162:17]
    node _GEN_51 = mux(_T_2, _GEN_2, _GEN_42) @[AllToAllPE.scala 157:23]
    node _GEN_52 = validif(eq(_T_2, UInt<1>("h0")), _GEN_36) @[AllToAllPE.scala 157:23]
    node _GEN_53 = validif(eq(_T_2, UInt<1>("h0")), _GEN_37) @[AllToAllPE.scala 157:23]
    node _GEN_54 = mux(_T_2, UInt<1>("h0"), _GEN_38) @[AllToAllPE.scala 157:23 AllToAllPE.scala 129:18]
    node _GEN_55 = validif(eq(_T_2, UInt<1>("h0")), _GEN_39) @[AllToAllPE.scala 157:23]
    node _GEN_56 = validif(eq(_T_2, UInt<1>("h0")), _GEN_40) @[AllToAllPE.scala 157:23]
    node _GEN_57 = mux(_T_2, resp_value, _GEN_41) @[AllToAllPE.scala 157:23 AllToAllPE.scala 146:27]
    node _GEN_58 = validif(eq(_T_2, UInt<1>("h0")), _GEN_43) @[AllToAllPE.scala 157:23]
    node _GEN_59 = validif(eq(_T_2, UInt<1>("h0")), _GEN_44) @[AllToAllPE.scala 157:23]
    node _GEN_60 = mux(_T_2, UInt<1>("h0"), _GEN_45) @[AllToAllPE.scala 157:23 AllToAllPE.scala 129:18]
    io_busy <= _GEN_46
    io_cmd_ready <= _GEN_47
    io_resp_valid <= _GEN_48
    io_resp_bits_data <= _GEN_49
    io_left_out <= UInt<64>("h0") @[AllToAllPE.scala 377:15]
    io_right_out <= UInt<64>("h0") @[AllToAllPE.scala 379:16]
    io_up_out <= UInt<64>("h0") @[AllToAllPE.scala 380:13]
    io_bottom_out <= UInt<64>("h0") @[AllToAllPE.scala 381:17]
    memPE.MPORT_1.addr <= _GEN_58
    memPE.MPORT_1.en <= _GEN_60
    memPE.MPORT_1.clk <= _GEN_59
    memPE.MPORT.addr <= _GEN_52
    memPE.MPORT.en <= _GEN_54
    memPE.MPORT.clk <= _GEN_53
    memPE.MPORT.data <= _GEN_56
    memPE.MPORT.mask <= _GEN_55
    x_coord <= UInt<16>("h0") @[AllToAllPE.scala 134:11]
    y_coord <= UInt<16>("h1") @[AllToAllPE.scala 135:11]
    state <= mux(reset, UInt<3>("h0"), _GEN_51) @[AllToAllPE.scala 144:22 AllToAllPE.scala 144:22]
    resp_signal <= mux(reset, UInt<1>("h0"), _GEN_50) @[AllToAllPE.scala 145:28 AllToAllPE.scala 145:28]
    resp_value <= mux(reset, UInt<1>("h0"), _GEN_57) @[AllToAllPE.scala 146:27 AllToAllPE.scala 146:27]

  module AllToAllPEmiddle :
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
      depth => 9
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:20]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:20]
    reg state : UInt<3>, clock with :
      reset => (UInt<1>("h0"), state) @[AllToAllPE.scala 144:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 145:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 146:27]
    node x_value = bits(io_cmd_bits_rs2, 15, 0) @[AllToAllPE.scala 147:32]
    node y_value = bits(io_cmd_bits_rs2, 31, 16) @[AllToAllPE.scala 148:32]
    node memIndex = bits(io_cmd_bits_rs2, 63, 32) @[AllToAllPE.scala 149:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 152:28]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 152:51]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 152:40]
    node load_signal = and(io_cmd_valid, io_cmd_bits_load) @[AllToAllPE.scala 153:34]
    node store_signal = and(io_cmd_valid, io_cmd_bits_store) @[AllToAllPE.scala 154:35]
    node allToAll_signal = and(io_cmd_valid, io_cmd_bits_doAllToAll) @[AllToAllPE.scala 155:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 157:14]
    node _GEN_0 = mux(allToAll_signal, UInt<3>("h1"), UInt<3>("h0")) @[AllToAllPE.scala 168:32 AllToAllPE.scala 169:13 AllToAllPE.scala 171:13]
    node _GEN_1 = mux(store_signal, UInt<3>("h4"), _GEN_0) @[AllToAllPE.scala 166:29 AllToAllPE.scala 167:13]
    node _GEN_2 = mux(load_signal, UInt<3>("h3"), _GEN_1) @[AllToAllPE.scala 164:22 AllToAllPE.scala 165:13]
    node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 174:20]
    node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 182:12]
    node _GEN_3 = validif(is_this_PE, _T_4) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12]
    node _GEN_4 = validif(is_this_PE, clock) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12]
    node _GEN_5 = mux(is_this_PE, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12 AllToAllPE.scala 129:18]
    node _GEN_6 = validif(is_this_PE, UInt<1>("h1")) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:23]
    node _GEN_7 = validif(is_this_PE, io_cmd_bits_rs1) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:23]
    node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 196:20]
    node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 205:26]
    node _GEN_8 = validif(is_this_PE, _T_6) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:26]
    node _GEN_9 = mux(is_this_PE, memPE.MPORT_1.data, resp_value) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:18 AllToAllPE.scala 146:27]
    node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 218:20]
    node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 227:20]
    node _GEN_10 = mux(_T_8, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 228:13 AllToAllPE.scala 237:13]
    node _GEN_11 = mux(_T_8, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 229:18 AllToAllPE.scala 238:18]
    node _GEN_12 = mux(_T_8, resp_value, UInt<64>("haaaaaaaa")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 231:23 AllToAllPE.scala 240:23]
    node _GEN_13 = mux(_T_8, UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 227:36 AllToAllPE.scala 233:17 AllToAllPE.scala 145:28]
    node _GEN_14 = mux(_T_8, UInt<3>("h0"), state) @[AllToAllPE.scala 227:36 AllToAllPE.scala 235:11 AllToAllPE.scala 144:22]
    node _GEN_15 = mux(_T_7, UInt<1>("h1"), _GEN_10) @[AllToAllPE.scala 218:31 AllToAllPE.scala 219:13]
    node _GEN_16 = mux(_T_7, UInt<1>("h0"), _GEN_11) @[AllToAllPE.scala 218:31 AllToAllPE.scala 220:18]
    node _GEN_17 = mux(_T_7, resp_signal, _GEN_10) @[AllToAllPE.scala 218:31 AllToAllPE.scala 221:19]
    node _GEN_18 = mux(_T_7, resp_value, _GEN_12) @[AllToAllPE.scala 218:31 AllToAllPE.scala 222:23]
    node _GEN_19 = mux(_T_7, UInt<1>("h0"), _GEN_13) @[AllToAllPE.scala 218:31 AllToAllPE.scala 224:17]
    node _GEN_20 = mux(_T_7, UInt<3>("h2"), _GEN_14) @[AllToAllPE.scala 218:31 AllToAllPE.scala 226:11]
    node _GEN_21 = mux(_T_5, UInt<1>("h0"), _GEN_15) @[AllToAllPE.scala 196:33 AllToAllPE.scala 198:13]
    node _GEN_22 = mux(_T_5, UInt<1>("h1"), _GEN_16) @[AllToAllPE.scala 196:33 AllToAllPE.scala 199:18]
    node _GEN_23 = mux(_T_5, resp_signal, _GEN_17) @[AllToAllPE.scala 196:33 AllToAllPE.scala 200:19]
    node _GEN_24 = mux(_T_5, resp_value, _GEN_18) @[AllToAllPE.scala 196:33 AllToAllPE.scala 201:23]
    node _GEN_25 = mux(_T_5, UInt<1>("h1"), _GEN_19) @[AllToAllPE.scala 196:33 AllToAllPE.scala 202:17]
    node _GEN_26 = validif(_T_5, _GEN_8) @[AllToAllPE.scala 196:33]
    node _GEN_27 = validif(_T_5, _GEN_4) @[AllToAllPE.scala 196:33]
    node _GEN_28 = mux(_T_5, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 196:33 AllToAllPE.scala 129:18]
    node _GEN_29 = mux(_T_5, _GEN_9, resp_value) @[AllToAllPE.scala 196:33 AllToAllPE.scala 146:27]
    node _GEN_30 = mux(_T_5, _GEN_2, _GEN_20) @[AllToAllPE.scala 196:33]
    node _GEN_31 = mux(_T_3, UInt<1>("h0"), _GEN_21) @[AllToAllPE.scala 174:32 AllToAllPE.scala 175:13]
    node _GEN_32 = mux(_T_3, UInt<1>("h1"), _GEN_22) @[AllToAllPE.scala 174:32 AllToAllPE.scala 176:18]
    node _GEN_33 = mux(_T_3, resp_signal, _GEN_23) @[AllToAllPE.scala 174:32 AllToAllPE.scala 177:19]
    node _GEN_34 = mux(_T_3, resp_value, _GEN_24) @[AllToAllPE.scala 174:32 AllToAllPE.scala 178:23]
    node _GEN_35 = mux(_T_3, UInt<1>("h1"), _GEN_25) @[AllToAllPE.scala 174:32 AllToAllPE.scala 179:17]
    node _GEN_36 = validif(_T_3, _GEN_3) @[AllToAllPE.scala 174:32]
    node _GEN_37 = validif(_T_3, _GEN_4) @[AllToAllPE.scala 174:32]
    node _GEN_38 = mux(_T_3, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 174:32 AllToAllPE.scala 129:18]
    node _GEN_39 = validif(_T_3, _GEN_6) @[AllToAllPE.scala 174:32]
    node _GEN_40 = validif(_T_3, _GEN_7) @[AllToAllPE.scala 174:32]
    node _GEN_41 = mux(_T_3, UInt<64>("h20"), _GEN_29) @[AllToAllPE.scala 174:32 AllToAllPE.scala 184:16]
    node _GEN_42 = mux(_T_3, _GEN_2, _GEN_30) @[AllToAllPE.scala 174:32]
    node _GEN_43 = validif(eq(_T_3, UInt<1>("h0")), _GEN_26) @[AllToAllPE.scala 174:32]
    node _GEN_44 = validif(eq(_T_3, UInt<1>("h0")), _GEN_27) @[AllToAllPE.scala 174:32]
    node _GEN_45 = mux(_T_3, UInt<1>("h0"), _GEN_28) @[AllToAllPE.scala 174:32 AllToAllPE.scala 129:18]
    node _GEN_46 = mux(_T_2, UInt<1>("h0"), _GEN_31) @[AllToAllPE.scala 157:23 AllToAllPE.scala 158:13]
    node _GEN_47 = mux(_T_2, UInt<1>("h1"), _GEN_32) @[AllToAllPE.scala 157:23 AllToAllPE.scala 159:18]
    node _GEN_48 = mux(_T_2, resp_signal, _GEN_33) @[AllToAllPE.scala 157:23 AllToAllPE.scala 160:19]
    node _GEN_49 = mux(_T_2, resp_value, _GEN_34) @[AllToAllPE.scala 157:23 AllToAllPE.scala 161:23]
    node _GEN_50 = mux(_T_2, UInt<1>("h0"), _GEN_35) @[AllToAllPE.scala 157:23 AllToAllPE.scala 162:17]
    node _GEN_51 = mux(_T_2, _GEN_2, _GEN_42) @[AllToAllPE.scala 157:23]
    node _GEN_52 = validif(eq(_T_2, UInt<1>("h0")), _GEN_36) @[AllToAllPE.scala 157:23]
    node _GEN_53 = validif(eq(_T_2, UInt<1>("h0")), _GEN_37) @[AllToAllPE.scala 157:23]
    node _GEN_54 = mux(_T_2, UInt<1>("h0"), _GEN_38) @[AllToAllPE.scala 157:23 AllToAllPE.scala 129:18]
    node _GEN_55 = validif(eq(_T_2, UInt<1>("h0")), _GEN_39) @[AllToAllPE.scala 157:23]
    node _GEN_56 = validif(eq(_T_2, UInt<1>("h0")), _GEN_40) @[AllToAllPE.scala 157:23]
    node _GEN_57 = mux(_T_2, resp_value, _GEN_41) @[AllToAllPE.scala 157:23 AllToAllPE.scala 146:27]
    node _GEN_58 = validif(eq(_T_2, UInt<1>("h0")), _GEN_43) @[AllToAllPE.scala 157:23]
    node _GEN_59 = validif(eq(_T_2, UInt<1>("h0")), _GEN_44) @[AllToAllPE.scala 157:23]
    node _GEN_60 = mux(_T_2, UInt<1>("h0"), _GEN_45) @[AllToAllPE.scala 157:23 AllToAllPE.scala 129:18]
    io_busy <= _GEN_46
    io_cmd_ready <= _GEN_47
    io_resp_valid <= _GEN_48
    io_resp_bits_data <= _GEN_49
    io_left_out <= UInt<64>("h0") @[AllToAllPE.scala 398:15]
    io_right_out <= UInt<64>("h0") @[AllToAllPE.scala 399:16]
    io_up_out <= UInt<64>("h0") @[AllToAllPE.scala 400:13]
    io_bottom_out <= UInt<64>("h0") @[AllToAllPE.scala 401:17]
    memPE.MPORT_1.addr <= _GEN_58
    memPE.MPORT_1.en <= _GEN_60
    memPE.MPORT_1.clk <= _GEN_59
    memPE.MPORT.addr <= _GEN_52
    memPE.MPORT.en <= _GEN_54
    memPE.MPORT.clk <= _GEN_53
    memPE.MPORT.data <= _GEN_56
    memPE.MPORT.mask <= _GEN_55
    x_coord <= UInt<16>("h1") @[AllToAllPE.scala 134:11]
    y_coord <= UInt<16>("h1") @[AllToAllPE.scala 135:11]
    state <= mux(reset, UInt<3>("h0"), _GEN_51) @[AllToAllPE.scala 144:22 AllToAllPE.scala 144:22]
    resp_signal <= mux(reset, UInt<1>("h0"), _GEN_50) @[AllToAllPE.scala 145:28 AllToAllPE.scala 145:28]
    resp_value <= mux(reset, UInt<1>("h0"), _GEN_57) @[AllToAllPE.scala 146:27 AllToAllPE.scala 146:27]

  module AllToAllPEright :
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
      depth => 9
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:20]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:20]
    reg state : UInt<3>, clock with :
      reset => (UInt<1>("h0"), state) @[AllToAllPE.scala 144:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 145:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 146:27]
    node x_value = bits(io_cmd_bits_rs2, 15, 0) @[AllToAllPE.scala 147:32]
    node y_value = bits(io_cmd_bits_rs2, 31, 16) @[AllToAllPE.scala 148:32]
    node memIndex = bits(io_cmd_bits_rs2, 63, 32) @[AllToAllPE.scala 149:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 152:28]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 152:51]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 152:40]
    node load_signal = and(io_cmd_valid, io_cmd_bits_load) @[AllToAllPE.scala 153:34]
    node store_signal = and(io_cmd_valid, io_cmd_bits_store) @[AllToAllPE.scala 154:35]
    node allToAll_signal = and(io_cmd_valid, io_cmd_bits_doAllToAll) @[AllToAllPE.scala 155:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 157:14]
    node _GEN_0 = mux(allToAll_signal, UInt<3>("h1"), UInt<3>("h0")) @[AllToAllPE.scala 168:32 AllToAllPE.scala 169:13 AllToAllPE.scala 171:13]
    node _GEN_1 = mux(store_signal, UInt<3>("h4"), _GEN_0) @[AllToAllPE.scala 166:29 AllToAllPE.scala 167:13]
    node _GEN_2 = mux(load_signal, UInt<3>("h3"), _GEN_1) @[AllToAllPE.scala 164:22 AllToAllPE.scala 165:13]
    node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 174:20]
    node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 182:12]
    node _GEN_3 = validif(is_this_PE, _T_4) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12]
    node _GEN_4 = validif(is_this_PE, clock) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12]
    node _GEN_5 = mux(is_this_PE, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12 AllToAllPE.scala 129:18]
    node _GEN_6 = validif(is_this_PE, UInt<1>("h1")) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:23]
    node _GEN_7 = validif(is_this_PE, io_cmd_bits_rs1) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:23]
    node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 196:20]
    node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 205:26]
    node _GEN_8 = validif(is_this_PE, _T_6) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:26]
    node _GEN_9 = mux(is_this_PE, memPE.MPORT_1.data, resp_value) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:18 AllToAllPE.scala 146:27]
    node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 218:20]
    node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 227:20]
    node _GEN_10 = mux(_T_8, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 228:13 AllToAllPE.scala 237:13]
    node _GEN_11 = mux(_T_8, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 229:18 AllToAllPE.scala 238:18]
    node _GEN_12 = mux(_T_8, resp_value, UInt<64>("haaaaaaaa")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 231:23 AllToAllPE.scala 240:23]
    node _GEN_13 = mux(_T_8, UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 227:36 AllToAllPE.scala 233:17 AllToAllPE.scala 145:28]
    node _GEN_14 = mux(_T_8, UInt<3>("h0"), state) @[AllToAllPE.scala 227:36 AllToAllPE.scala 235:11 AllToAllPE.scala 144:22]
    node _GEN_15 = mux(_T_7, UInt<1>("h1"), _GEN_10) @[AllToAllPE.scala 218:31 AllToAllPE.scala 219:13]
    node _GEN_16 = mux(_T_7, UInt<1>("h0"), _GEN_11) @[AllToAllPE.scala 218:31 AllToAllPE.scala 220:18]
    node _GEN_17 = mux(_T_7, resp_signal, _GEN_10) @[AllToAllPE.scala 218:31 AllToAllPE.scala 221:19]
    node _GEN_18 = mux(_T_7, resp_value, _GEN_12) @[AllToAllPE.scala 218:31 AllToAllPE.scala 222:23]
    node _GEN_19 = mux(_T_7, UInt<1>("h0"), _GEN_13) @[AllToAllPE.scala 218:31 AllToAllPE.scala 224:17]
    node _GEN_20 = mux(_T_7, UInt<3>("h2"), _GEN_14) @[AllToAllPE.scala 218:31 AllToAllPE.scala 226:11]
    node _GEN_21 = mux(_T_5, UInt<1>("h0"), _GEN_15) @[AllToAllPE.scala 196:33 AllToAllPE.scala 198:13]
    node _GEN_22 = mux(_T_5, UInt<1>("h1"), _GEN_16) @[AllToAllPE.scala 196:33 AllToAllPE.scala 199:18]
    node _GEN_23 = mux(_T_5, resp_signal, _GEN_17) @[AllToAllPE.scala 196:33 AllToAllPE.scala 200:19]
    node _GEN_24 = mux(_T_5, resp_value, _GEN_18) @[AllToAllPE.scala 196:33 AllToAllPE.scala 201:23]
    node _GEN_25 = mux(_T_5, UInt<1>("h1"), _GEN_19) @[AllToAllPE.scala 196:33 AllToAllPE.scala 202:17]
    node _GEN_26 = validif(_T_5, _GEN_8) @[AllToAllPE.scala 196:33]
    node _GEN_27 = validif(_T_5, _GEN_4) @[AllToAllPE.scala 196:33]
    node _GEN_28 = mux(_T_5, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 196:33 AllToAllPE.scala 129:18]
    node _GEN_29 = mux(_T_5, _GEN_9, resp_value) @[AllToAllPE.scala 196:33 AllToAllPE.scala 146:27]
    node _GEN_30 = mux(_T_5, _GEN_2, _GEN_20) @[AllToAllPE.scala 196:33]
    node _GEN_31 = mux(_T_3, UInt<1>("h0"), _GEN_21) @[AllToAllPE.scala 174:32 AllToAllPE.scala 175:13]
    node _GEN_32 = mux(_T_3, UInt<1>("h1"), _GEN_22) @[AllToAllPE.scala 174:32 AllToAllPE.scala 176:18]
    node _GEN_33 = mux(_T_3, resp_signal, _GEN_23) @[AllToAllPE.scala 174:32 AllToAllPE.scala 177:19]
    node _GEN_34 = mux(_T_3, resp_value, _GEN_24) @[AllToAllPE.scala 174:32 AllToAllPE.scala 178:23]
    node _GEN_35 = mux(_T_3, UInt<1>("h1"), _GEN_25) @[AllToAllPE.scala 174:32 AllToAllPE.scala 179:17]
    node _GEN_36 = validif(_T_3, _GEN_3) @[AllToAllPE.scala 174:32]
    node _GEN_37 = validif(_T_3, _GEN_4) @[AllToAllPE.scala 174:32]
    node _GEN_38 = mux(_T_3, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 174:32 AllToAllPE.scala 129:18]
    node _GEN_39 = validif(_T_3, _GEN_6) @[AllToAllPE.scala 174:32]
    node _GEN_40 = validif(_T_3, _GEN_7) @[AllToAllPE.scala 174:32]
    node _GEN_41 = mux(_T_3, UInt<64>("h20"), _GEN_29) @[AllToAllPE.scala 174:32 AllToAllPE.scala 184:16]
    node _GEN_42 = mux(_T_3, _GEN_2, _GEN_30) @[AllToAllPE.scala 174:32]
    node _GEN_43 = validif(eq(_T_3, UInt<1>("h0")), _GEN_26) @[AllToAllPE.scala 174:32]
    node _GEN_44 = validif(eq(_T_3, UInt<1>("h0")), _GEN_27) @[AllToAllPE.scala 174:32]
    node _GEN_45 = mux(_T_3, UInt<1>("h0"), _GEN_28) @[AllToAllPE.scala 174:32 AllToAllPE.scala 129:18]
    node _GEN_46 = mux(_T_2, UInt<1>("h0"), _GEN_31) @[AllToAllPE.scala 157:23 AllToAllPE.scala 158:13]
    node _GEN_47 = mux(_T_2, UInt<1>("h1"), _GEN_32) @[AllToAllPE.scala 157:23 AllToAllPE.scala 159:18]
    node _GEN_48 = mux(_T_2, resp_signal, _GEN_33) @[AllToAllPE.scala 157:23 AllToAllPE.scala 160:19]
    node _GEN_49 = mux(_T_2, resp_value, _GEN_34) @[AllToAllPE.scala 157:23 AllToAllPE.scala 161:23]
    node _GEN_50 = mux(_T_2, UInt<1>("h0"), _GEN_35) @[AllToAllPE.scala 157:23 AllToAllPE.scala 162:17]
    node _GEN_51 = mux(_T_2, _GEN_2, _GEN_42) @[AllToAllPE.scala 157:23]
    node _GEN_52 = validif(eq(_T_2, UInt<1>("h0")), _GEN_36) @[AllToAllPE.scala 157:23]
    node _GEN_53 = validif(eq(_T_2, UInt<1>("h0")), _GEN_37) @[AllToAllPE.scala 157:23]
    node _GEN_54 = mux(_T_2, UInt<1>("h0"), _GEN_38) @[AllToAllPE.scala 157:23 AllToAllPE.scala 129:18]
    node _GEN_55 = validif(eq(_T_2, UInt<1>("h0")), _GEN_39) @[AllToAllPE.scala 157:23]
    node _GEN_56 = validif(eq(_T_2, UInt<1>("h0")), _GEN_40) @[AllToAllPE.scala 157:23]
    node _GEN_57 = mux(_T_2, resp_value, _GEN_41) @[AllToAllPE.scala 157:23 AllToAllPE.scala 146:27]
    node _GEN_58 = validif(eq(_T_2, UInt<1>("h0")), _GEN_43) @[AllToAllPE.scala 157:23]
    node _GEN_59 = validif(eq(_T_2, UInt<1>("h0")), _GEN_44) @[AllToAllPE.scala 157:23]
    node _GEN_60 = mux(_T_2, UInt<1>("h0"), _GEN_45) @[AllToAllPE.scala 157:23 AllToAllPE.scala 129:18]
    io_busy <= _GEN_46
    io_cmd_ready <= _GEN_47
    io_resp_valid <= _GEN_48
    io_resp_bits_data <= _GEN_49
    io_left_out <= UInt<64>("h0") @[AllToAllPE.scala 390:15]
    io_right_out <= UInt<64>("h0") @[AllToAllPE.scala 388:16]
    io_up_out <= UInt<64>("h0") @[AllToAllPE.scala 391:13]
    io_bottom_out <= UInt<64>("h0") @[AllToAllPE.scala 392:17]
    memPE.MPORT_1.addr <= _GEN_58
    memPE.MPORT_1.en <= _GEN_60
    memPE.MPORT_1.clk <= _GEN_59
    memPE.MPORT.addr <= _GEN_52
    memPE.MPORT.en <= _GEN_54
    memPE.MPORT.clk <= _GEN_53
    memPE.MPORT.data <= _GEN_56
    memPE.MPORT.mask <= _GEN_55
    x_coord <= UInt<16>("h2") @[AllToAllPE.scala 134:11]
    y_coord <= UInt<16>("h1") @[AllToAllPE.scala 135:11]
    state <= mux(reset, UInt<3>("h0"), _GEN_51) @[AllToAllPE.scala 144:22 AllToAllPE.scala 144:22]
    resp_signal <= mux(reset, UInt<1>("h0"), _GEN_50) @[AllToAllPE.scala 145:28 AllToAllPE.scala 145:28]
    resp_value <= mux(reset, UInt<1>("h0"), _GEN_57) @[AllToAllPE.scala 146:27 AllToAllPE.scala 146:27]

  module AllToAllPEbottomLeftCorner :
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
      depth => 9
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:20]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:20]
    reg state : UInt<3>, clock with :
      reset => (UInt<1>("h0"), state) @[AllToAllPE.scala 144:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 145:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 146:27]
    node x_value = bits(io_cmd_bits_rs2, 15, 0) @[AllToAllPE.scala 147:32]
    node y_value = bits(io_cmd_bits_rs2, 31, 16) @[AllToAllPE.scala 148:32]
    node memIndex = bits(io_cmd_bits_rs2, 63, 32) @[AllToAllPE.scala 149:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 152:28]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 152:51]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 152:40]
    node load_signal = and(io_cmd_valid, io_cmd_bits_load) @[AllToAllPE.scala 153:34]
    node store_signal = and(io_cmd_valid, io_cmd_bits_store) @[AllToAllPE.scala 154:35]
    node allToAll_signal = and(io_cmd_valid, io_cmd_bits_doAllToAll) @[AllToAllPE.scala 155:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 157:14]
    node _GEN_0 = mux(allToAll_signal, UInt<3>("h1"), UInt<3>("h0")) @[AllToAllPE.scala 168:32 AllToAllPE.scala 169:13 AllToAllPE.scala 171:13]
    node _GEN_1 = mux(store_signal, UInt<3>("h4"), _GEN_0) @[AllToAllPE.scala 166:29 AllToAllPE.scala 167:13]
    node _GEN_2 = mux(load_signal, UInt<3>("h3"), _GEN_1) @[AllToAllPE.scala 164:22 AllToAllPE.scala 165:13]
    node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 174:20]
    node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 182:12]
    node _GEN_3 = validif(is_this_PE, _T_4) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12]
    node _GEN_4 = validif(is_this_PE, clock) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12]
    node _GEN_5 = mux(is_this_PE, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12 AllToAllPE.scala 129:18]
    node _GEN_6 = validif(is_this_PE, UInt<1>("h1")) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:23]
    node _GEN_7 = validif(is_this_PE, io_cmd_bits_rs1) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:23]
    node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 196:20]
    node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 205:26]
    node _GEN_8 = validif(is_this_PE, _T_6) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:26]
    node _GEN_9 = mux(is_this_PE, memPE.MPORT_1.data, resp_value) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:18 AllToAllPE.scala 146:27]
    node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 218:20]
    node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 227:20]
    node _GEN_10 = mux(_T_8, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 228:13 AllToAllPE.scala 237:13]
    node _GEN_11 = mux(_T_8, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 229:18 AllToAllPE.scala 238:18]
    node _GEN_12 = mux(_T_8, resp_value, UInt<64>("haaaaaaaa")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 231:23 AllToAllPE.scala 240:23]
    node _GEN_13 = mux(_T_8, UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 227:36 AllToAllPE.scala 233:17 AllToAllPE.scala 145:28]
    node _GEN_14 = mux(_T_8, UInt<3>("h0"), state) @[AllToAllPE.scala 227:36 AllToAllPE.scala 235:11 AllToAllPE.scala 144:22]
    node _GEN_15 = mux(_T_7, UInt<1>("h1"), _GEN_10) @[AllToAllPE.scala 218:31 AllToAllPE.scala 219:13]
    node _GEN_16 = mux(_T_7, UInt<1>("h0"), _GEN_11) @[AllToAllPE.scala 218:31 AllToAllPE.scala 220:18]
    node _GEN_17 = mux(_T_7, resp_signal, _GEN_10) @[AllToAllPE.scala 218:31 AllToAllPE.scala 221:19]
    node _GEN_18 = mux(_T_7, resp_value, _GEN_12) @[AllToAllPE.scala 218:31 AllToAllPE.scala 222:23]
    node _GEN_19 = mux(_T_7, UInt<1>("h0"), _GEN_13) @[AllToAllPE.scala 218:31 AllToAllPE.scala 224:17]
    node _GEN_20 = mux(_T_7, UInt<3>("h2"), _GEN_14) @[AllToAllPE.scala 218:31 AllToAllPE.scala 226:11]
    node _GEN_21 = mux(_T_5, UInt<1>("h0"), _GEN_15) @[AllToAllPE.scala 196:33 AllToAllPE.scala 198:13]
    node _GEN_22 = mux(_T_5, UInt<1>("h1"), _GEN_16) @[AllToAllPE.scala 196:33 AllToAllPE.scala 199:18]
    node _GEN_23 = mux(_T_5, resp_signal, _GEN_17) @[AllToAllPE.scala 196:33 AllToAllPE.scala 200:19]
    node _GEN_24 = mux(_T_5, resp_value, _GEN_18) @[AllToAllPE.scala 196:33 AllToAllPE.scala 201:23]
    node _GEN_25 = mux(_T_5, UInt<1>("h1"), _GEN_19) @[AllToAllPE.scala 196:33 AllToAllPE.scala 202:17]
    node _GEN_26 = validif(_T_5, _GEN_8) @[AllToAllPE.scala 196:33]
    node _GEN_27 = validif(_T_5, _GEN_4) @[AllToAllPE.scala 196:33]
    node _GEN_28 = mux(_T_5, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 196:33 AllToAllPE.scala 129:18]
    node _GEN_29 = mux(_T_5, _GEN_9, resp_value) @[AllToAllPE.scala 196:33 AllToAllPE.scala 146:27]
    node _GEN_30 = mux(_T_5, _GEN_2, _GEN_20) @[AllToAllPE.scala 196:33]
    node _GEN_31 = mux(_T_3, UInt<1>("h0"), _GEN_21) @[AllToAllPE.scala 174:32 AllToAllPE.scala 175:13]
    node _GEN_32 = mux(_T_3, UInt<1>("h1"), _GEN_22) @[AllToAllPE.scala 174:32 AllToAllPE.scala 176:18]
    node _GEN_33 = mux(_T_3, resp_signal, _GEN_23) @[AllToAllPE.scala 174:32 AllToAllPE.scala 177:19]
    node _GEN_34 = mux(_T_3, resp_value, _GEN_24) @[AllToAllPE.scala 174:32 AllToAllPE.scala 178:23]
    node _GEN_35 = mux(_T_3, UInt<1>("h1"), _GEN_25) @[AllToAllPE.scala 174:32 AllToAllPE.scala 179:17]
    node _GEN_36 = validif(_T_3, _GEN_3) @[AllToAllPE.scala 174:32]
    node _GEN_37 = validif(_T_3, _GEN_4) @[AllToAllPE.scala 174:32]
    node _GEN_38 = mux(_T_3, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 174:32 AllToAllPE.scala 129:18]
    node _GEN_39 = validif(_T_3, _GEN_6) @[AllToAllPE.scala 174:32]
    node _GEN_40 = validif(_T_3, _GEN_7) @[AllToAllPE.scala 174:32]
    node _GEN_41 = mux(_T_3, UInt<64>("h20"), _GEN_29) @[AllToAllPE.scala 174:32 AllToAllPE.scala 184:16]
    node _GEN_42 = mux(_T_3, _GEN_2, _GEN_30) @[AllToAllPE.scala 174:32]
    node _GEN_43 = validif(eq(_T_3, UInt<1>("h0")), _GEN_26) @[AllToAllPE.scala 174:32]
    node _GEN_44 = validif(eq(_T_3, UInt<1>("h0")), _GEN_27) @[AllToAllPE.scala 174:32]
    node _GEN_45 = mux(_T_3, UInt<1>("h0"), _GEN_28) @[AllToAllPE.scala 174:32 AllToAllPE.scala 129:18]
    node _GEN_46 = mux(_T_2, UInt<1>("h0"), _GEN_31) @[AllToAllPE.scala 157:23 AllToAllPE.scala 158:13]
    node _GEN_47 = mux(_T_2, UInt<1>("h1"), _GEN_32) @[AllToAllPE.scala 157:23 AllToAllPE.scala 159:18]
    node _GEN_48 = mux(_T_2, resp_signal, _GEN_33) @[AllToAllPE.scala 157:23 AllToAllPE.scala 160:19]
    node _GEN_49 = mux(_T_2, resp_value, _GEN_34) @[AllToAllPE.scala 157:23 AllToAllPE.scala 161:23]
    node _GEN_50 = mux(_T_2, UInt<1>("h0"), _GEN_35) @[AllToAllPE.scala 157:23 AllToAllPE.scala 162:17]
    node _GEN_51 = mux(_T_2, _GEN_2, _GEN_42) @[AllToAllPE.scala 157:23]
    node _GEN_52 = validif(eq(_T_2, UInt<1>("h0")), _GEN_36) @[AllToAllPE.scala 157:23]
    node _GEN_53 = validif(eq(_T_2, UInt<1>("h0")), _GEN_37) @[AllToAllPE.scala 157:23]
    node _GEN_54 = mux(_T_2, UInt<1>("h0"), _GEN_38) @[AllToAllPE.scala 157:23 AllToAllPE.scala 129:18]
    node _GEN_55 = validif(eq(_T_2, UInt<1>("h0")), _GEN_39) @[AllToAllPE.scala 157:23]
    node _GEN_56 = validif(eq(_T_2, UInt<1>("h0")), _GEN_40) @[AllToAllPE.scala 157:23]
    node _GEN_57 = mux(_T_2, resp_value, _GEN_41) @[AllToAllPE.scala 157:23 AllToAllPE.scala 146:27]
    node _GEN_58 = validif(eq(_T_2, UInt<1>("h0")), _GEN_43) @[AllToAllPE.scala 157:23]
    node _GEN_59 = validif(eq(_T_2, UInt<1>("h0")), _GEN_44) @[AllToAllPE.scala 157:23]
    node _GEN_60 = mux(_T_2, UInt<1>("h0"), _GEN_45) @[AllToAllPE.scala 157:23 AllToAllPE.scala 129:18]
    io_busy <= _GEN_46
    io_cmd_ready <= _GEN_47
    io_resp_valid <= _GEN_48
    io_resp_bits_data <= _GEN_49
    io_left_out <= UInt<64>("h0") @[AllToAllPE.scala 329:15]
    io_right_out <= UInt<64>("h0") @[AllToAllPE.scala 334:16]
    io_up_out <= UInt<64>("h0") @[AllToAllPE.scala 335:13]
    io_bottom_out <= UInt<64>("h0") @[AllToAllPE.scala 331:17]
    memPE.MPORT_1.addr <= _GEN_58
    memPE.MPORT_1.en <= _GEN_60
    memPE.MPORT_1.clk <= _GEN_59
    memPE.MPORT.addr <= _GEN_52
    memPE.MPORT.en <= _GEN_54
    memPE.MPORT.clk <= _GEN_53
    memPE.MPORT.data <= _GEN_56
    memPE.MPORT.mask <= _GEN_55
    x_coord <= UInt<16>("h0") @[AllToAllPE.scala 134:11]
    y_coord <= UInt<16>("h0") @[AllToAllPE.scala 135:11]
    state <= mux(reset, UInt<3>("h0"), _GEN_51) @[AllToAllPE.scala 144:22 AllToAllPE.scala 144:22]
    resp_signal <= mux(reset, UInt<1>("h0"), _GEN_50) @[AllToAllPE.scala 145:28 AllToAllPE.scala 145:28]
    resp_value <= mux(reset, UInt<1>("h0"), _GEN_57) @[AllToAllPE.scala 146:27 AllToAllPE.scala 146:27]

  module AllToAllPEbottom :
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
      depth => 9
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:20]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:20]
    reg state : UInt<3>, clock with :
      reset => (UInt<1>("h0"), state) @[AllToAllPE.scala 144:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 145:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 146:27]
    node x_value = bits(io_cmd_bits_rs2, 15, 0) @[AllToAllPE.scala 147:32]
    node y_value = bits(io_cmd_bits_rs2, 31, 16) @[AllToAllPE.scala 148:32]
    node memIndex = bits(io_cmd_bits_rs2, 63, 32) @[AllToAllPE.scala 149:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 152:28]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 152:51]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 152:40]
    node load_signal = and(io_cmd_valid, io_cmd_bits_load) @[AllToAllPE.scala 153:34]
    node store_signal = and(io_cmd_valid, io_cmd_bits_store) @[AllToAllPE.scala 154:35]
    node allToAll_signal = and(io_cmd_valid, io_cmd_bits_doAllToAll) @[AllToAllPE.scala 155:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 157:14]
    node _GEN_0 = mux(allToAll_signal, UInt<3>("h1"), UInt<3>("h0")) @[AllToAllPE.scala 168:32 AllToAllPE.scala 169:13 AllToAllPE.scala 171:13]
    node _GEN_1 = mux(store_signal, UInt<3>("h4"), _GEN_0) @[AllToAllPE.scala 166:29 AllToAllPE.scala 167:13]
    node _GEN_2 = mux(load_signal, UInt<3>("h3"), _GEN_1) @[AllToAllPE.scala 164:22 AllToAllPE.scala 165:13]
    node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 174:20]
    node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 182:12]
    node _GEN_3 = validif(is_this_PE, _T_4) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12]
    node _GEN_4 = validif(is_this_PE, clock) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12]
    node _GEN_5 = mux(is_this_PE, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12 AllToAllPE.scala 129:18]
    node _GEN_6 = validif(is_this_PE, UInt<1>("h1")) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:23]
    node _GEN_7 = validif(is_this_PE, io_cmd_bits_rs1) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:23]
    node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 196:20]
    node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 205:26]
    node _GEN_8 = validif(is_this_PE, _T_6) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:26]
    node _GEN_9 = mux(is_this_PE, memPE.MPORT_1.data, resp_value) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:18 AllToAllPE.scala 146:27]
    node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 218:20]
    node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 227:20]
    node _GEN_10 = mux(_T_8, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 228:13 AllToAllPE.scala 237:13]
    node _GEN_11 = mux(_T_8, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 229:18 AllToAllPE.scala 238:18]
    node _GEN_12 = mux(_T_8, resp_value, UInt<64>("haaaaaaaa")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 231:23 AllToAllPE.scala 240:23]
    node _GEN_13 = mux(_T_8, UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 227:36 AllToAllPE.scala 233:17 AllToAllPE.scala 145:28]
    node _GEN_14 = mux(_T_8, UInt<3>("h0"), state) @[AllToAllPE.scala 227:36 AllToAllPE.scala 235:11 AllToAllPE.scala 144:22]
    node _GEN_15 = mux(_T_7, UInt<1>("h1"), _GEN_10) @[AllToAllPE.scala 218:31 AllToAllPE.scala 219:13]
    node _GEN_16 = mux(_T_7, UInt<1>("h0"), _GEN_11) @[AllToAllPE.scala 218:31 AllToAllPE.scala 220:18]
    node _GEN_17 = mux(_T_7, resp_signal, _GEN_10) @[AllToAllPE.scala 218:31 AllToAllPE.scala 221:19]
    node _GEN_18 = mux(_T_7, resp_value, _GEN_12) @[AllToAllPE.scala 218:31 AllToAllPE.scala 222:23]
    node _GEN_19 = mux(_T_7, UInt<1>("h0"), _GEN_13) @[AllToAllPE.scala 218:31 AllToAllPE.scala 224:17]
    node _GEN_20 = mux(_T_7, UInt<3>("h2"), _GEN_14) @[AllToAllPE.scala 218:31 AllToAllPE.scala 226:11]
    node _GEN_21 = mux(_T_5, UInt<1>("h0"), _GEN_15) @[AllToAllPE.scala 196:33 AllToAllPE.scala 198:13]
    node _GEN_22 = mux(_T_5, UInt<1>("h1"), _GEN_16) @[AllToAllPE.scala 196:33 AllToAllPE.scala 199:18]
    node _GEN_23 = mux(_T_5, resp_signal, _GEN_17) @[AllToAllPE.scala 196:33 AllToAllPE.scala 200:19]
    node _GEN_24 = mux(_T_5, resp_value, _GEN_18) @[AllToAllPE.scala 196:33 AllToAllPE.scala 201:23]
    node _GEN_25 = mux(_T_5, UInt<1>("h1"), _GEN_19) @[AllToAllPE.scala 196:33 AllToAllPE.scala 202:17]
    node _GEN_26 = validif(_T_5, _GEN_8) @[AllToAllPE.scala 196:33]
    node _GEN_27 = validif(_T_5, _GEN_4) @[AllToAllPE.scala 196:33]
    node _GEN_28 = mux(_T_5, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 196:33 AllToAllPE.scala 129:18]
    node _GEN_29 = mux(_T_5, _GEN_9, resp_value) @[AllToAllPE.scala 196:33 AllToAllPE.scala 146:27]
    node _GEN_30 = mux(_T_5, _GEN_2, _GEN_20) @[AllToAllPE.scala 196:33]
    node _GEN_31 = mux(_T_3, UInt<1>("h0"), _GEN_21) @[AllToAllPE.scala 174:32 AllToAllPE.scala 175:13]
    node _GEN_32 = mux(_T_3, UInt<1>("h1"), _GEN_22) @[AllToAllPE.scala 174:32 AllToAllPE.scala 176:18]
    node _GEN_33 = mux(_T_3, resp_signal, _GEN_23) @[AllToAllPE.scala 174:32 AllToAllPE.scala 177:19]
    node _GEN_34 = mux(_T_3, resp_value, _GEN_24) @[AllToAllPE.scala 174:32 AllToAllPE.scala 178:23]
    node _GEN_35 = mux(_T_3, UInt<1>("h1"), _GEN_25) @[AllToAllPE.scala 174:32 AllToAllPE.scala 179:17]
    node _GEN_36 = validif(_T_3, _GEN_3) @[AllToAllPE.scala 174:32]
    node _GEN_37 = validif(_T_3, _GEN_4) @[AllToAllPE.scala 174:32]
    node _GEN_38 = mux(_T_3, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 174:32 AllToAllPE.scala 129:18]
    node _GEN_39 = validif(_T_3, _GEN_6) @[AllToAllPE.scala 174:32]
    node _GEN_40 = validif(_T_3, _GEN_7) @[AllToAllPE.scala 174:32]
    node _GEN_41 = mux(_T_3, UInt<64>("h20"), _GEN_29) @[AllToAllPE.scala 174:32 AllToAllPE.scala 184:16]
    node _GEN_42 = mux(_T_3, _GEN_2, _GEN_30) @[AllToAllPE.scala 174:32]
    node _GEN_43 = validif(eq(_T_3, UInt<1>("h0")), _GEN_26) @[AllToAllPE.scala 174:32]
    node _GEN_44 = validif(eq(_T_3, UInt<1>("h0")), _GEN_27) @[AllToAllPE.scala 174:32]
    node _GEN_45 = mux(_T_3, UInt<1>("h0"), _GEN_28) @[AllToAllPE.scala 174:32 AllToAllPE.scala 129:18]
    node _GEN_46 = mux(_T_2, UInt<1>("h0"), _GEN_31) @[AllToAllPE.scala 157:23 AllToAllPE.scala 158:13]
    node _GEN_47 = mux(_T_2, UInt<1>("h1"), _GEN_32) @[AllToAllPE.scala 157:23 AllToAllPE.scala 159:18]
    node _GEN_48 = mux(_T_2, resp_signal, _GEN_33) @[AllToAllPE.scala 157:23 AllToAllPE.scala 160:19]
    node _GEN_49 = mux(_T_2, resp_value, _GEN_34) @[AllToAllPE.scala 157:23 AllToAllPE.scala 161:23]
    node _GEN_50 = mux(_T_2, UInt<1>("h0"), _GEN_35) @[AllToAllPE.scala 157:23 AllToAllPE.scala 162:17]
    node _GEN_51 = mux(_T_2, _GEN_2, _GEN_42) @[AllToAllPE.scala 157:23]
    node _GEN_52 = validif(eq(_T_2, UInt<1>("h0")), _GEN_36) @[AllToAllPE.scala 157:23]
    node _GEN_53 = validif(eq(_T_2, UInt<1>("h0")), _GEN_37) @[AllToAllPE.scala 157:23]
    node _GEN_54 = mux(_T_2, UInt<1>("h0"), _GEN_38) @[AllToAllPE.scala 157:23 AllToAllPE.scala 129:18]
    node _GEN_55 = validif(eq(_T_2, UInt<1>("h0")), _GEN_39) @[AllToAllPE.scala 157:23]
    node _GEN_56 = validif(eq(_T_2, UInt<1>("h0")), _GEN_40) @[AllToAllPE.scala 157:23]
    node _GEN_57 = mux(_T_2, resp_value, _GEN_41) @[AllToAllPE.scala 157:23 AllToAllPE.scala 146:27]
    node _GEN_58 = validif(eq(_T_2, UInt<1>("h0")), _GEN_43) @[AllToAllPE.scala 157:23]
    node _GEN_59 = validif(eq(_T_2, UInt<1>("h0")), _GEN_44) @[AllToAllPE.scala 157:23]
    node _GEN_60 = mux(_T_2, UInt<1>("h0"), _GEN_45) @[AllToAllPE.scala 157:23 AllToAllPE.scala 129:18]
    io_busy <= _GEN_46
    io_cmd_ready <= _GEN_47
    io_resp_valid <= _GEN_48
    io_resp_bits_data <= _GEN_49
    io_left_out <= UInt<64>("h0") @[AllToAllPE.scala 367:15]
    io_right_out <= UInt<64>("h0") @[AllToAllPE.scala 368:16]
    io_up_out <= UInt<64>("h0") @[AllToAllPE.scala 369:13]
    io_bottom_out <= UInt<64>("h0") @[AllToAllPE.scala 365:17]
    memPE.MPORT_1.addr <= _GEN_58
    memPE.MPORT_1.en <= _GEN_60
    memPE.MPORT_1.clk <= _GEN_59
    memPE.MPORT.addr <= _GEN_52
    memPE.MPORT.en <= _GEN_54
    memPE.MPORT.clk <= _GEN_53
    memPE.MPORT.data <= _GEN_56
    memPE.MPORT.mask <= _GEN_55
    x_coord <= UInt<16>("h1") @[AllToAllPE.scala 134:11]
    y_coord <= UInt<16>("h0") @[AllToAllPE.scala 135:11]
    state <= mux(reset, UInt<3>("h0"), _GEN_51) @[AllToAllPE.scala 144:22 AllToAllPE.scala 144:22]
    resp_signal <= mux(reset, UInt<1>("h0"), _GEN_50) @[AllToAllPE.scala 145:28 AllToAllPE.scala 145:28]
    resp_value <= mux(reset, UInt<1>("h0"), _GEN_57) @[AllToAllPE.scala 146:27 AllToAllPE.scala 146:27]

  module AllToAllPEbottomRightCorner :
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
      depth => 9
      read-latency => 0
      write-latency => 1
      reader => MPORT_1
      writer => MPORT
      read-under-write => undefined
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:20]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:20]
    reg state : UInt<3>, clock with :
      reset => (UInt<1>("h0"), state) @[AllToAllPE.scala 144:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 145:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 146:27]
    node x_value = bits(io_cmd_bits_rs2, 15, 0) @[AllToAllPE.scala 147:32]
    node y_value = bits(io_cmd_bits_rs2, 31, 16) @[AllToAllPE.scala 148:32]
    node memIndex = bits(io_cmd_bits_rs2, 63, 32) @[AllToAllPE.scala 149:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 152:28]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 152:51]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 152:40]
    node load_signal = and(io_cmd_valid, io_cmd_bits_load) @[AllToAllPE.scala 153:34]
    node store_signal = and(io_cmd_valid, io_cmd_bits_store) @[AllToAllPE.scala 154:35]
    node allToAll_signal = and(io_cmd_valid, io_cmd_bits_doAllToAll) @[AllToAllPE.scala 155:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 157:14]
    node _GEN_0 = mux(allToAll_signal, UInt<3>("h1"), UInt<3>("h0")) @[AllToAllPE.scala 168:32 AllToAllPE.scala 169:13 AllToAllPE.scala 171:13]
    node _GEN_1 = mux(store_signal, UInt<3>("h4"), _GEN_0) @[AllToAllPE.scala 166:29 AllToAllPE.scala 167:13]
    node _GEN_2 = mux(load_signal, UInt<3>("h3"), _GEN_1) @[AllToAllPE.scala 164:22 AllToAllPE.scala 165:13]
    node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 174:20]
    node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 182:12]
    node _GEN_3 = validif(is_this_PE, _T_4) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12]
    node _GEN_4 = validif(is_this_PE, clock) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12]
    node _GEN_5 = mux(is_this_PE, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:12 AllToAllPE.scala 129:18]
    node _GEN_6 = validif(is_this_PE, UInt<1>("h1")) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:23]
    node _GEN_7 = validif(is_this_PE, io_cmd_bits_rs1) @[AllToAllPE.scala 181:21 AllToAllPE.scala 182:23]
    node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 196:20]
    node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 205:26]
    node _GEN_8 = validif(is_this_PE, _T_6) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:26]
    node _GEN_9 = mux(is_this_PE, memPE.MPORT_1.data, resp_value) @[AllToAllPE.scala 204:21 AllToAllPE.scala 205:18 AllToAllPE.scala 146:27]
    node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 218:20]
    node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 227:20]
    node _GEN_10 = mux(_T_8, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 228:13 AllToAllPE.scala 237:13]
    node _GEN_11 = mux(_T_8, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 229:18 AllToAllPE.scala 238:18]
    node _GEN_12 = mux(_T_8, resp_value, UInt<64>("haaaaaaaa")) @[AllToAllPE.scala 227:36 AllToAllPE.scala 231:23 AllToAllPE.scala 240:23]
    node _GEN_13 = mux(_T_8, UInt<1>("h0"), resp_signal) @[AllToAllPE.scala 227:36 AllToAllPE.scala 233:17 AllToAllPE.scala 145:28]
    node _GEN_14 = mux(_T_8, UInt<3>("h0"), state) @[AllToAllPE.scala 227:36 AllToAllPE.scala 235:11 AllToAllPE.scala 144:22]
    node _GEN_15 = mux(_T_7, UInt<1>("h1"), _GEN_10) @[AllToAllPE.scala 218:31 AllToAllPE.scala 219:13]
    node _GEN_16 = mux(_T_7, UInt<1>("h0"), _GEN_11) @[AllToAllPE.scala 218:31 AllToAllPE.scala 220:18]
    node _GEN_17 = mux(_T_7, resp_signal, _GEN_10) @[AllToAllPE.scala 218:31 AllToAllPE.scala 221:19]
    node _GEN_18 = mux(_T_7, resp_value, _GEN_12) @[AllToAllPE.scala 218:31 AllToAllPE.scala 222:23]
    node _GEN_19 = mux(_T_7, UInt<1>("h0"), _GEN_13) @[AllToAllPE.scala 218:31 AllToAllPE.scala 224:17]
    node _GEN_20 = mux(_T_7, UInt<3>("h2"), _GEN_14) @[AllToAllPE.scala 218:31 AllToAllPE.scala 226:11]
    node _GEN_21 = mux(_T_5, UInt<1>("h0"), _GEN_15) @[AllToAllPE.scala 196:33 AllToAllPE.scala 198:13]
    node _GEN_22 = mux(_T_5, UInt<1>("h1"), _GEN_16) @[AllToAllPE.scala 196:33 AllToAllPE.scala 199:18]
    node _GEN_23 = mux(_T_5, resp_signal, _GEN_17) @[AllToAllPE.scala 196:33 AllToAllPE.scala 200:19]
    node _GEN_24 = mux(_T_5, resp_value, _GEN_18) @[AllToAllPE.scala 196:33 AllToAllPE.scala 201:23]
    node _GEN_25 = mux(_T_5, UInt<1>("h1"), _GEN_19) @[AllToAllPE.scala 196:33 AllToAllPE.scala 202:17]
    node _GEN_26 = validif(_T_5, _GEN_8) @[AllToAllPE.scala 196:33]
    node _GEN_27 = validif(_T_5, _GEN_4) @[AllToAllPE.scala 196:33]
    node _GEN_28 = mux(_T_5, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 196:33 AllToAllPE.scala 129:18]
    node _GEN_29 = mux(_T_5, _GEN_9, resp_value) @[AllToAllPE.scala 196:33 AllToAllPE.scala 146:27]
    node _GEN_30 = mux(_T_5, _GEN_2, _GEN_20) @[AllToAllPE.scala 196:33]
    node _GEN_31 = mux(_T_3, UInt<1>("h0"), _GEN_21) @[AllToAllPE.scala 174:32 AllToAllPE.scala 175:13]
    node _GEN_32 = mux(_T_3, UInt<1>("h1"), _GEN_22) @[AllToAllPE.scala 174:32 AllToAllPE.scala 176:18]
    node _GEN_33 = mux(_T_3, resp_signal, _GEN_23) @[AllToAllPE.scala 174:32 AllToAllPE.scala 177:19]
    node _GEN_34 = mux(_T_3, resp_value, _GEN_24) @[AllToAllPE.scala 174:32 AllToAllPE.scala 178:23]
    node _GEN_35 = mux(_T_3, UInt<1>("h1"), _GEN_25) @[AllToAllPE.scala 174:32 AllToAllPE.scala 179:17]
    node _GEN_36 = validif(_T_3, _GEN_3) @[AllToAllPE.scala 174:32]
    node _GEN_37 = validif(_T_3, _GEN_4) @[AllToAllPE.scala 174:32]
    node _GEN_38 = mux(_T_3, _GEN_5, UInt<1>("h0")) @[AllToAllPE.scala 174:32 AllToAllPE.scala 129:18]
    node _GEN_39 = validif(_T_3, _GEN_6) @[AllToAllPE.scala 174:32]
    node _GEN_40 = validif(_T_3, _GEN_7) @[AllToAllPE.scala 174:32]
    node _GEN_41 = mux(_T_3, UInt<64>("h20"), _GEN_29) @[AllToAllPE.scala 174:32 AllToAllPE.scala 184:16]
    node _GEN_42 = mux(_T_3, _GEN_2, _GEN_30) @[AllToAllPE.scala 174:32]
    node _GEN_43 = validif(eq(_T_3, UInt<1>("h0")), _GEN_26) @[AllToAllPE.scala 174:32]
    node _GEN_44 = validif(eq(_T_3, UInt<1>("h0")), _GEN_27) @[AllToAllPE.scala 174:32]
    node _GEN_45 = mux(_T_3, UInt<1>("h0"), _GEN_28) @[AllToAllPE.scala 174:32 AllToAllPE.scala 129:18]
    node _GEN_46 = mux(_T_2, UInt<1>("h0"), _GEN_31) @[AllToAllPE.scala 157:23 AllToAllPE.scala 158:13]
    node _GEN_47 = mux(_T_2, UInt<1>("h1"), _GEN_32) @[AllToAllPE.scala 157:23 AllToAllPE.scala 159:18]
    node _GEN_48 = mux(_T_2, resp_signal, _GEN_33) @[AllToAllPE.scala 157:23 AllToAllPE.scala 160:19]
    node _GEN_49 = mux(_T_2, resp_value, _GEN_34) @[AllToAllPE.scala 157:23 AllToAllPE.scala 161:23]
    node _GEN_50 = mux(_T_2, UInt<1>("h0"), _GEN_35) @[AllToAllPE.scala 157:23 AllToAllPE.scala 162:17]
    node _GEN_51 = mux(_T_2, _GEN_2, _GEN_42) @[AllToAllPE.scala 157:23]
    node _GEN_52 = validif(eq(_T_2, UInt<1>("h0")), _GEN_36) @[AllToAllPE.scala 157:23]
    node _GEN_53 = validif(eq(_T_2, UInt<1>("h0")), _GEN_37) @[AllToAllPE.scala 157:23]
    node _GEN_54 = mux(_T_2, UInt<1>("h0"), _GEN_38) @[AllToAllPE.scala 157:23 AllToAllPE.scala 129:18]
    node _GEN_55 = validif(eq(_T_2, UInt<1>("h0")), _GEN_39) @[AllToAllPE.scala 157:23]
    node _GEN_56 = validif(eq(_T_2, UInt<1>("h0")), _GEN_40) @[AllToAllPE.scala 157:23]
    node _GEN_57 = mux(_T_2, resp_value, _GEN_41) @[AllToAllPE.scala 157:23 AllToAllPE.scala 146:27]
    node _GEN_58 = validif(eq(_T_2, UInt<1>("h0")), _GEN_43) @[AllToAllPE.scala 157:23]
    node _GEN_59 = validif(eq(_T_2, UInt<1>("h0")), _GEN_44) @[AllToAllPE.scala 157:23]
    node _GEN_60 = mux(_T_2, UInt<1>("h0"), _GEN_45) @[AllToAllPE.scala 157:23 AllToAllPE.scala 129:18]
    io_busy <= _GEN_46
    io_cmd_ready <= _GEN_47
    io_resp_valid <= _GEN_48
    io_resp_bits_data <= _GEN_49
    io_left_out <= UInt<64>("h0") @[AllToAllPE.scala 346:15]
    io_right_out <= UInt<64>("h0") @[AllToAllPE.scala 347:16]
    io_up_out <= UInt<64>("h0") @[AllToAllPE.scala 348:13]
    io_bottom_out <= UInt<64>("h0") @[AllToAllPE.scala 344:17]
    memPE.MPORT_1.addr <= _GEN_58
    memPE.MPORT_1.en <= _GEN_60
    memPE.MPORT_1.clk <= _GEN_59
    memPE.MPORT.addr <= _GEN_52
    memPE.MPORT.en <= _GEN_54
    memPE.MPORT.clk <= _GEN_53
    memPE.MPORT.data <= _GEN_56
    memPE.MPORT.mask <= _GEN_55
    x_coord <= UInt<16>("h2") @[AllToAllPE.scala 134:11]
    y_coord <= UInt<16>("h0") @[AllToAllPE.scala 135:11]
    state <= mux(reset, UInt<3>("h0"), _GEN_51) @[AllToAllPE.scala 144:22 AllToAllPE.scala 144:22]
    resp_signal <= mux(reset, UInt<1>("h0"), _GEN_50) @[AllToAllPE.scala 145:28 AllToAllPE.scala 145:28]
    resp_value <= mux(reset, UInt<1>("h0"), _GEN_57) @[AllToAllPE.scala 146:27 AllToAllPE.scala 146:27]

  module AllToAllMesh :
    input clock : Clock
    input reset : UInt<1>
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
    output io_busy : UInt<1>

    inst vector_0 of AllToAllPEupLeftCorner @[AllToAllMesh.scala 95:41]
    inst vector_1 of AllToAllPEup @[AllToAllMesh.scala 106:41]
    inst vector_2 of AllToAllPEupRightCorner @[AllToAllMesh.scala 98:41]
    inst vector_3 of AllToAllPEleft @[AllToAllMesh.scala 112:41]
    inst vector_4 of AllToAllPEmiddle @[AllToAllMesh.scala 118:41]
    inst vector_5 of AllToAllPEright @[AllToAllMesh.scala 115:41]
    inst vector_6 of AllToAllPEbottomLeftCorner @[AllToAllMesh.scala 101:41]
    inst vector_7 of AllToAllPEbottom @[AllToAllMesh.scala 109:41]
    inst vector_8 of AllToAllPEbottomRightCorner @[AllToAllMesh.scala 104:41]
    node _T = or(vector_0.io_busy, vector_1.io_busy) @[AllToAllMesh.scala 143:47]
    node _T_1 = or(_T, vector_2.io_busy) @[AllToAllMesh.scala 143:47]
    node _T_2 = or(_T_1, vector_3.io_busy) @[AllToAllMesh.scala 143:47]
    node _T_3 = or(_T_2, vector_4.io_busy) @[AllToAllMesh.scala 143:47]
    node _T_4 = or(_T_3, vector_5.io_busy) @[AllToAllMesh.scala 143:47]
    node _T_5 = or(_T_4, vector_6.io_busy) @[AllToAllMesh.scala 143:47]
    node _T_6 = or(_T_5, vector_7.io_busy) @[AllToAllMesh.scala 143:47]
    node _T_7 = or(_T_6, vector_8.io_busy) @[AllToAllMesh.scala 143:47]
    node _T_8 = and(vector_0.io_cmd_ready, vector_1.io_cmd_ready) @[AllToAllMesh.scala 144:57]
    node _T_9 = and(_T_8, vector_2.io_cmd_ready) @[AllToAllMesh.scala 144:57]
    node _T_10 = and(_T_9, vector_3.io_cmd_ready) @[AllToAllMesh.scala 144:57]
    node _T_11 = and(_T_10, vector_4.io_cmd_ready) @[AllToAllMesh.scala 144:57]
    node _T_12 = and(_T_11, vector_5.io_cmd_ready) @[AllToAllMesh.scala 144:57]
    node _T_13 = and(_T_12, vector_6.io_cmd_ready) @[AllToAllMesh.scala 144:57]
    node _T_14 = and(_T_13, vector_7.io_cmd_ready) @[AllToAllMesh.scala 144:57]
    node _T_15 = and(_T_14, vector_8.io_cmd_ready) @[AllToAllMesh.scala 144:57]
    node _T_16 = and(vector_0.io_resp_valid, vector_1.io_resp_valid) @[AllToAllMesh.scala 145:59]
    node _T_17 = and(_T_16, vector_2.io_resp_valid) @[AllToAllMesh.scala 145:59]
    node _T_18 = and(_T_17, vector_3.io_resp_valid) @[AllToAllMesh.scala 145:59]
    node _T_19 = and(_T_18, vector_4.io_resp_valid) @[AllToAllMesh.scala 145:59]
    node _T_20 = and(_T_19, vector_5.io_resp_valid) @[AllToAllMesh.scala 145:59]
    node _T_21 = and(_T_20, vector_6.io_resp_valid) @[AllToAllMesh.scala 145:59]
    node _T_22 = and(_T_21, vector_7.io_resp_valid) @[AllToAllMesh.scala 145:59]
    node _T_23 = and(_T_22, vector_8.io_resp_valid) @[AllToAllMesh.scala 145:59]
    node _T_24 = bits(io_cmd_bits_rs2, 15, 0) @[AllToAllMesh.scala 150:18]
    node _T_25 = bits(io_cmd_bits_rs2, 31, 16) @[AllToAllMesh.scala 151:18]
    node _T_26 = sub(UInt<2>("h3"), UInt<1>("h1")) @[AllToAllMesh.scala 152:14]
    node _T_27 = tail(_T_26, 1) @[AllToAllMesh.scala 152:14]
    node _T_28 = sub(_T_27, _T_25) @[AllToAllMesh.scala 152:18]
    node _T_29 = tail(_T_28, 1) @[AllToAllMesh.scala 152:18]
    node _T_30 = mul(_T_29, UInt<2>("h3")) @[AllToAllMesh.scala 152:21]
    node _T_31 = add(_T_30, _T_24) @[AllToAllMesh.scala 152:25]
    node nPE = tail(_T_31, 1) @[AllToAllMesh.scala 152:25]
    node _T_32 = eq(nPE, UInt<1>("h0")) @[AllToAllMesh.scala 159:27]
    node _T_33 = eq(nPE, UInt<1>("h1")) @[AllToAllMesh.scala 162:25]
    node _T_34 = eq(nPE, UInt<2>("h2")) @[AllToAllMesh.scala 162:25]
    node _T_35 = eq(nPE, UInt<2>("h3")) @[AllToAllMesh.scala 162:25]
    node _T_36 = eq(nPE, UInt<3>("h4")) @[AllToAllMesh.scala 162:25]
    node _T_37 = eq(nPE, UInt<3>("h5")) @[AllToAllMesh.scala 162:25]
    node _T_38 = eq(nPE, UInt<3>("h6")) @[AllToAllMesh.scala 162:25]
    node _T_39 = eq(nPE, UInt<3>("h7")) @[AllToAllMesh.scala 162:25]
    node _T_40 = eq(nPE, UInt<4>("h8")) @[AllToAllMesh.scala 162:25]
    io_cmd_ready <= _T_15 @[AllToAllMesh.scala 144:18]
    io_resp_valid <= _T_23 @[AllToAllMesh.scala 145:19]
    io_resp_bits_data <= vector_0.io_resp_bits_data @[AllToAllMesh.scala 168:23]
    io_busy <= _T_7 @[AllToAllMesh.scala 143:13]
    vector_0.clock <= clock
    vector_0.reset <= reset
    vector_0.io_cmd_valid <= io_cmd_valid @[AllToAllMesh.scala 130:32]
    vector_0.io_cmd_bits_load <= io_cmd_bits_load @[AllToAllMesh.scala 131:36]
    vector_0.io_cmd_bits_store <= io_cmd_bits_store @[AllToAllMesh.scala 132:37]
    vector_0.io_cmd_bits_doAllToAll <= io_cmd_bits_doAllToAll @[AllToAllMesh.scala 133:42]
    vector_0.io_cmd_bits_rs1 <= io_cmd_bits_rs1 @[AllToAllMesh.scala 135:35]
    vector_0.io_cmd_bits_rs2 <= io_cmd_bits_rs2 @[AllToAllMesh.scala 136:35]
    vector_0.io_resp_ready <= io_resp_ready @[AllToAllMesh.scala 138:33]
    vector_0.io_left_in <= UInt<64>("h0") @[AllToAllMesh.scala 177:34]
    vector_0.io_right_in <= vector_1.io_left_out @[AllToAllMesh.scala 183:35]
    vector_0.io_up_in <= UInt<64>("h0") @[AllToAllMesh.scala 179:32]
    vector_0.io_bottom_in <= vector_3.io_up_out @[AllToAllMesh.scala 185:36]
    vector_1.clock <= clock
    vector_1.reset <= reset
    vector_1.io_cmd_valid <= io_cmd_valid @[AllToAllMesh.scala 130:32]
    vector_1.io_cmd_bits_load <= io_cmd_bits_load @[AllToAllMesh.scala 131:36]
    vector_1.io_cmd_bits_store <= io_cmd_bits_store @[AllToAllMesh.scala 132:37]
    vector_1.io_cmd_bits_doAllToAll <= io_cmd_bits_doAllToAll @[AllToAllMesh.scala 133:42]
    vector_1.io_cmd_bits_rs1 <= io_cmd_bits_rs1 @[AllToAllMesh.scala 135:35]
    vector_1.io_cmd_bits_rs2 <= io_cmd_bits_rs2 @[AllToAllMesh.scala 136:35]
    vector_1.io_resp_ready <= io_resp_ready @[AllToAllMesh.scala 138:33]
    vector_1.io_left_in <= vector_0.io_right_out @[AllToAllMesh.scala 232:34]
    vector_1.io_right_in <= vector_2.io_left_out @[AllToAllMesh.scala 234:35]
    vector_1.io_up_in <= UInt<64>("h0") @[AllToAllMesh.scala 229:32]
    vector_1.io_bottom_in <= vector_4.io_up_out @[AllToAllMesh.scala 236:36]
    vector_2.clock <= clock
    vector_2.reset <= reset
    vector_2.io_cmd_valid <= io_cmd_valid @[AllToAllMesh.scala 130:32]
    vector_2.io_cmd_bits_load <= io_cmd_bits_load @[AllToAllMesh.scala 131:36]
    vector_2.io_cmd_bits_store <= io_cmd_bits_store @[AllToAllMesh.scala 132:37]
    vector_2.io_cmd_bits_doAllToAll <= io_cmd_bits_doAllToAll @[AllToAllMesh.scala 133:42]
    vector_2.io_cmd_bits_rs1 <= io_cmd_bits_rs1 @[AllToAllMesh.scala 135:35]
    vector_2.io_cmd_bits_rs2 <= io_cmd_bits_rs2 @[AllToAllMesh.scala 136:35]
    vector_2.io_resp_ready <= io_resp_ready @[AllToAllMesh.scala 138:33]
    vector_2.io_left_in <= vector_1.io_right_out @[AllToAllMesh.scala 197:34]
    vector_2.io_right_in <= UInt<64>("h0") @[AllToAllMesh.scala 191:35]
    vector_2.io_up_in <= UInt<64>("h0") @[AllToAllMesh.scala 193:32]
    vector_2.io_bottom_in <= vector_5.io_up_out @[AllToAllMesh.scala 199:36]
    vector_3.clock <= clock
    vector_3.reset <= reset
    vector_3.io_cmd_valid <= io_cmd_valid @[AllToAllMesh.scala 130:32]
    vector_3.io_cmd_bits_load <= io_cmd_bits_load @[AllToAllMesh.scala 131:36]
    vector_3.io_cmd_bits_store <= io_cmd_bits_store @[AllToAllMesh.scala 132:37]
    vector_3.io_cmd_bits_doAllToAll <= io_cmd_bits_doAllToAll @[AllToAllMesh.scala 133:42]
    vector_3.io_cmd_bits_rs1 <= io_cmd_bits_rs1 @[AllToAllMesh.scala 135:35]
    vector_3.io_cmd_bits_rs2 <= io_cmd_bits_rs2 @[AllToAllMesh.scala 136:35]
    vector_3.io_resp_ready <= io_resp_ready @[AllToAllMesh.scala 138:33]
    vector_3.io_left_in <= UInt<64>("h0") @[AllToAllMesh.scala 251:34]
    vector_3.io_right_in <= vector_4.io_left_out @[AllToAllMesh.scala 254:35]
    vector_3.io_up_in <= vector_0.io_bottom_out @[AllToAllMesh.scala 256:32]
    vector_3.io_bottom_in <= vector_6.io_up_out @[AllToAllMesh.scala 258:36]
    vector_4.clock <= clock
    vector_4.reset <= reset
    vector_4.io_cmd_valid <= io_cmd_valid @[AllToAllMesh.scala 130:32]
    vector_4.io_cmd_bits_load <= io_cmd_bits_load @[AllToAllMesh.scala 131:36]
    vector_4.io_cmd_bits_store <= io_cmd_bits_store @[AllToAllMesh.scala 132:37]
    vector_4.io_cmd_bits_doAllToAll <= io_cmd_bits_doAllToAll @[AllToAllMesh.scala 133:42]
    vector_4.io_cmd_bits_rs1 <= io_cmd_bits_rs1 @[AllToAllMesh.scala 135:35]
    vector_4.io_cmd_bits_rs2 <= io_cmd_bits_rs2 @[AllToAllMesh.scala 136:35]
    vector_4.io_resp_ready <= io_resp_ready @[AllToAllMesh.scala 138:33]
    vector_4.io_left_in <= vector_3.io_right_out @[AllToAllMesh.scala 274:34]
    vector_4.io_right_in <= vector_5.io_left_out @[AllToAllMesh.scala 276:35]
    vector_4.io_up_in <= vector_1.io_bottom_out @[AllToAllMesh.scala 278:32]
    vector_4.io_bottom_in <= vector_7.io_up_out @[AllToAllMesh.scala 280:36]
    vector_5.clock <= clock
    vector_5.reset <= reset
    vector_5.io_cmd_valid <= io_cmd_valid @[AllToAllMesh.scala 130:32]
    vector_5.io_cmd_bits_load <= io_cmd_bits_load @[AllToAllMesh.scala 131:36]
    vector_5.io_cmd_bits_store <= io_cmd_bits_store @[AllToAllMesh.scala 132:37]
    vector_5.io_cmd_bits_doAllToAll <= io_cmd_bits_doAllToAll @[AllToAllMesh.scala 133:42]
    vector_5.io_cmd_bits_rs1 <= io_cmd_bits_rs1 @[AllToAllMesh.scala 135:35]
    vector_5.io_cmd_bits_rs2 <= io_cmd_bits_rs2 @[AllToAllMesh.scala 136:35]
    vector_5.io_resp_ready <= io_resp_ready @[AllToAllMesh.scala 138:33]
    vector_5.io_left_in <= vector_4.io_right_out @[AllToAllMesh.scala 265:34]
    vector_5.io_right_in <= UInt<64>("h0") @[AllToAllMesh.scala 262:35]
    vector_5.io_up_in <= vector_2.io_bottom_out @[AllToAllMesh.scala 267:32]
    vector_5.io_bottom_in <= vector_8.io_up_out @[AllToAllMesh.scala 269:36]
    vector_6.clock <= clock
    vector_6.reset <= reset
    vector_6.io_cmd_valid <= io_cmd_valid @[AllToAllMesh.scala 130:32]
    vector_6.io_cmd_bits_load <= io_cmd_bits_load @[AllToAllMesh.scala 131:36]
    vector_6.io_cmd_bits_store <= io_cmd_bits_store @[AllToAllMesh.scala 132:37]
    vector_6.io_cmd_bits_doAllToAll <= io_cmd_bits_doAllToAll @[AllToAllMesh.scala 133:42]
    vector_6.io_cmd_bits_rs1 <= io_cmd_bits_rs1 @[AllToAllMesh.scala 135:35]
    vector_6.io_cmd_bits_rs2 <= io_cmd_bits_rs2 @[AllToAllMesh.scala 136:35]
    vector_6.io_resp_ready <= io_resp_ready @[AllToAllMesh.scala 138:33]
    vector_6.io_left_in <= UInt<64>("h0") @[AllToAllMesh.scala 204:34]
    vector_6.io_right_in <= vector_7.io_left_out @[AllToAllMesh.scala 210:35]
    vector_6.io_up_in <= vector_3.io_bottom_out @[AllToAllMesh.scala 212:32]
    vector_6.io_bottom_in <= UInt<64>("h0") @[AllToAllMesh.scala 206:36]
    vector_7.clock <= clock
    vector_7.reset <= reset
    vector_7.io_cmd_valid <= io_cmd_valid @[AllToAllMesh.scala 130:32]
    vector_7.io_cmd_bits_load <= io_cmd_bits_load @[AllToAllMesh.scala 131:36]
    vector_7.io_cmd_bits_store <= io_cmd_bits_store @[AllToAllMesh.scala 132:37]
    vector_7.io_cmd_bits_doAllToAll <= io_cmd_bits_doAllToAll @[AllToAllMesh.scala 133:42]
    vector_7.io_cmd_bits_rs1 <= io_cmd_bits_rs1 @[AllToAllMesh.scala 135:35]
    vector_7.io_cmd_bits_rs2 <= io_cmd_bits_rs2 @[AllToAllMesh.scala 136:35]
    vector_7.io_resp_ready <= io_resp_ready @[AllToAllMesh.scala 138:33]
    vector_7.io_left_in <= vector_6.io_right_out @[AllToAllMesh.scala 243:34]
    vector_7.io_right_in <= vector_8.io_left_out @[AllToAllMesh.scala 245:35]
    vector_7.io_up_in <= vector_4.io_bottom_out @[AllToAllMesh.scala 247:32]
    vector_7.io_bottom_in <= UInt<64>("h0") @[AllToAllMesh.scala 240:36]
    vector_8.clock <= clock
    vector_8.reset <= reset
    vector_8.io_cmd_valid <= io_cmd_valid @[AllToAllMesh.scala 130:32]
    vector_8.io_cmd_bits_load <= io_cmd_bits_load @[AllToAllMesh.scala 131:36]
    vector_8.io_cmd_bits_store <= io_cmd_bits_store @[AllToAllMesh.scala 132:37]
    vector_8.io_cmd_bits_doAllToAll <= io_cmd_bits_doAllToAll @[AllToAllMesh.scala 133:42]
    vector_8.io_cmd_bits_rs1 <= io_cmd_bits_rs1 @[AllToAllMesh.scala 135:35]
    vector_8.io_cmd_bits_rs2 <= io_cmd_bits_rs2 @[AllToAllMesh.scala 136:35]
    vector_8.io_resp_ready <= io_resp_ready @[AllToAllMesh.scala 138:33]
    vector_8.io_left_in <= vector_7.io_right_out @[AllToAllMesh.scala 223:34]
    vector_8.io_right_in <= UInt<64>("h0") @[AllToAllMesh.scala 217:35]
    vector_8.io_up_in <= vector_5.io_bottom_out @[AllToAllMesh.scala 225:32]
    vector_8.io_bottom_in <= UInt<64>("h0") @[AllToAllMesh.scala 219:36]

  module AllToAllModule :
    input clock : Clock
    input reset : UInt<1>
    output io_cmd_ready : UInt<1>
    input io_cmd_valid : UInt<1>
    input io_cmd_bits_inst_funct : UInt<7>
    input io_cmd_bits_inst_rs2 : UInt<5>
    input io_cmd_bits_inst_rs1 : UInt<5>
    input io_cmd_bits_inst_xd : UInt<1>
    input io_cmd_bits_inst_xs1 : UInt<1>
    input io_cmd_bits_inst_xs2 : UInt<1>
    input io_cmd_bits_inst_rd : UInt<5>
    input io_cmd_bits_inst_opcode : UInt<7>
    input io_cmd_bits_rs1 : UInt<64>
    input io_cmd_bits_rs2 : UInt<64>
    input io_resp_ready : UInt<1>
    output io_resp_valid : UInt<1>
    output io_resp_bits_rd : UInt<5>
    output io_resp_bits_data : UInt<64>
    output io_busy : UInt<1>
    output io_interrupt : UInt<1>
    input io_exception : UInt<1>

    inst controller of AllToAllController @[AllToAllAccelerator.scala 71:26]
    inst mesh of AllToAllMesh @[AllToAllAccelerator.scala 72:20]
    io_cmd_ready <= controller.io_processor_cmd_ready @[AllToAllAccelerator.scala 78:6]
    io_resp_valid <= controller.io_processor_resp_valid @[AllToAllAccelerator.scala 78:6]
    io_resp_bits_rd <= controller.io_processor_resp_bits_rd @[AllToAllAccelerator.scala 78:6]
    io_resp_bits_data <= controller.io_processor_resp_bits_data @[AllToAllAccelerator.scala 78:6]
    io_busy <= controller.io_processor_busy @[AllToAllAccelerator.scala 78:6]
    io_interrupt <= controller.io_processor_interrupt @[AllToAllAccelerator.scala 78:6]
    controller.clock <= clock
    controller.reset <= reset
    controller.io_processor_cmd_valid <= io_cmd_valid @[AllToAllAccelerator.scala 78:6]
    controller.io_processor_cmd_bits_inst_funct <= io_cmd_bits_inst_funct @[AllToAllAccelerator.scala 78:6]
    controller.io_processor_cmd_bits_inst_rs2 <= io_cmd_bits_inst_rs2 @[AllToAllAccelerator.scala 78:6]
    controller.io_processor_cmd_bits_inst_rs1 <= io_cmd_bits_inst_rs1 @[AllToAllAccelerator.scala 78:6]
    controller.io_processor_cmd_bits_inst_xd <= io_cmd_bits_inst_xd @[AllToAllAccelerator.scala 78:6]
    controller.io_processor_cmd_bits_inst_xs1 <= io_cmd_bits_inst_xs1 @[AllToAllAccelerator.scala 78:6]
    controller.io_processor_cmd_bits_inst_xs2 <= io_cmd_bits_inst_xs2 @[AllToAllAccelerator.scala 78:6]
    controller.io_processor_cmd_bits_inst_rd <= io_cmd_bits_inst_rd @[AllToAllAccelerator.scala 78:6]
    controller.io_processor_cmd_bits_inst_opcode <= io_cmd_bits_inst_opcode @[AllToAllAccelerator.scala 78:6]
    controller.io_processor_cmd_bits_rs1 <= io_cmd_bits_rs1 @[AllToAllAccelerator.scala 78:6]
    controller.io_processor_cmd_bits_rs2 <= io_cmd_bits_rs2 @[AllToAllAccelerator.scala 78:6]
    controller.io_processor_resp_ready <= io_resp_ready @[AllToAllAccelerator.scala 78:6]
    controller.io_processor_exception <= io_exception @[AllToAllAccelerator.scala 78:6]
    controller.io_mesh_cmd_ready <= mesh.io_cmd_ready @[AllToAllAccelerator.scala 92:32]
    controller.io_mesh_resp_valid <= mesh.io_resp_valid @[AllToAllAccelerator.scala 93:33]
    controller.io_mesh_resp_bits_data <= mesh.io_resp_bits_data @[AllToAllAccelerator.scala 94:37]
    controller.io_mesh_busy <= mesh.io_busy @[AllToAllAccelerator.scala 95:27]
    mesh.clock <= clock
    mesh.reset <= reset
    mesh.io_cmd_valid <= controller.io_mesh_cmd_valid @[AllToAllAccelerator.scala 83:21]
    mesh.io_cmd_bits_load <= controller.io_mesh_cmd_bits_load @[AllToAllAccelerator.scala 84:25]
    mesh.io_cmd_bits_store <= controller.io_mesh_cmd_bits_store @[AllToAllAccelerator.scala 85:26]
    mesh.io_cmd_bits_doAllToAll <= controller.io_mesh_cmd_bits_doAllToAll @[AllToAllAccelerator.scala 86:31]
    mesh.io_cmd_bits_rs1 <= controller.io_mesh_cmd_bits_rs1 @[AllToAllAccelerator.scala 87:24]
    mesh.io_cmd_bits_rs2 <= controller.io_mesh_cmd_bits_rs2 @[AllToAllAccelerator.scala 88:24]
    mesh.io_resp_ready <= controller.io_mesh_resp_ready @[AllToAllAccelerator.scala 89:22]

  module AllToAll :
    input clock : Clock
    input reset : UInt<1>
    output io_cmd_ready : UInt<1>
    input io_cmd_valid : UInt<1>
    input io_cmd_bits_inst_funct : UInt<7>
    input io_cmd_bits_inst_rs2 : UInt<5>
    input io_cmd_bits_inst_rs1 : UInt<5>
    input io_cmd_bits_inst_xd : UInt<1>
    input io_cmd_bits_inst_xs1 : UInt<1>
    input io_cmd_bits_inst_xs2 : UInt<1>
    input io_cmd_bits_inst_rd : UInt<5>
    input io_cmd_bits_inst_opcode : UInt<7>
    input io_cmd_bits_rs1 : UInt<64>
    input io_cmd_bits_rs2 : UInt<64>
    input io_resp_ready : UInt<1>
    output io_resp_valid : UInt<1>
    output io_resp_bits_rd : UInt<5>
    output io_resp_bits_data : UInt<64>
    output io_busy : UInt<1>
    output io_interrupt : UInt<1>
    input io_exception : UInt<1>

    inst aTaModule of AllToAllModule @[AllToAllTest.scala 13:25]
    io_cmd_ready <= aTaModule.io_cmd_ready @[AllToAllTest.scala 31:16]
    io_resp_valid <= aTaModule.io_resp_valid @[AllToAllTest.scala 32:17]
    io_resp_bits_rd <= aTaModule.io_resp_bits_rd @[AllToAllTest.scala 33:19]
    io_resp_bits_data <= aTaModule.io_resp_bits_data @[AllToAllTest.scala 34:21]
    io_busy <= aTaModule.io_busy @[AllToAllTest.scala 38:11]
    io_interrupt <= aTaModule.io_interrupt @[AllToAllTest.scala 37:16]
    aTaModule.clock <= clock
    aTaModule.reset <= reset
    aTaModule.io_cmd_valid <= io_cmd_valid @[AllToAllTest.scala 16:26]
    aTaModule.io_cmd_bits_inst_funct <= io_cmd_bits_inst_funct @[AllToAllTest.scala 17:36]
    aTaModule.io_cmd_bits_inst_rs2 <= io_cmd_bits_inst_rs2 @[AllToAllTest.scala 18:34]
    aTaModule.io_cmd_bits_inst_rs1 <= io_cmd_bits_inst_rs1 @[AllToAllTest.scala 19:34]
    aTaModule.io_cmd_bits_inst_xd <= io_cmd_bits_inst_xd @[AllToAllTest.scala 20:33]
    aTaModule.io_cmd_bits_inst_xs1 <= io_cmd_bits_inst_xs1 @[AllToAllTest.scala 21:34]
    aTaModule.io_cmd_bits_inst_xs2 <= io_cmd_bits_inst_xs2 @[AllToAllTest.scala 22:34]
    aTaModule.io_cmd_bits_inst_rd <= io_cmd_bits_inst_rd @[AllToAllTest.scala 23:33]
    aTaModule.io_cmd_bits_inst_opcode <= io_cmd_bits_inst_opcode @[AllToAllTest.scala 24:37]
    aTaModule.io_cmd_bits_rs1 <= io_cmd_bits_rs1 @[AllToAllTest.scala 25:29]
    aTaModule.io_cmd_bits_rs2 <= io_cmd_bits_rs2 @[AllToAllTest.scala 26:29]
    aTaModule.io_resp_ready <= io_resp_ready @[AllToAllTest.scala 27:27]
    aTaModule.io_exception <= io_exception @[AllToAllTest.scala 41:26]

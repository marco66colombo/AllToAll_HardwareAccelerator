circuit AllToAllController :
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

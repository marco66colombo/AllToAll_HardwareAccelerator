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
      reset => (UInt<1>("h0"), state) @[AllToAllController.scala 40:22]
    reg rd_address : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address) @[AllToAllController.scala 47:23]
    node _T = eq(io_processor_resp_ready, UInt<1>("h0")) @[AllToAllController.scala 52:20]
    node stall_resp = and(_T, io_mesh_resp_valid) @[AllToAllController.scala 52:33]
    node _T_1 = and(io_processor_cmd_valid, io_processor_cmd_ready) @[AllToAllController.scala 71:34]
    node _T_2 = eq(io_processor_cmd_bits_inst_opcode, UInt<4>("hb")) @[AllToAllController.scala 71:74]
    node _T_3 = and(_T_1, _T_2) @[AllToAllController.scala 71:48]
    node _T_4 = eq(io_processor_cmd_bits_inst_funct, UInt<2>("h3")) @[AllToAllController.scala 71:117]
    node action_signal = and(_T_3, _T_4) @[AllToAllController.scala 71:92]
    node done_action_signal = eq(io_mesh_busy, UInt<1>("h0")) @[AllToAllController.scala 72:28]
    node _T_5 = and(io_processor_cmd_valid, io_processor_cmd_ready) @[AllToAllController.scala 75:28]
    node _T_6 = eq(io_processor_cmd_bits_inst_opcode, UInt<4>("hb")) @[AllToAllController.scala 75:68]
    node mem_cmd = and(_T_5, _T_6) @[AllToAllController.scala 75:42]
    node load_signal = eq(io_processor_cmd_bits_inst_funct, UInt<1>("h1")) @[AllToAllController.scala 77:42]
    node store_signal = eq(io_processor_cmd_bits_inst_funct, UInt<2>("h2")) @[AllToAllController.scala 79:43]
    node _T_7 = and(mem_cmd, load_signal) @[AllToAllController.scala 83:36]
    node _T_8 = and(mem_cmd, store_signal) @[AllToAllController.scala 84:37]
    node _T_9 = eq(state, UInt<3>("h0")) @[AllToAllController.scala 87:14]
    node _T_10 = and(mem_cmd, load_signal) @[AllToAllController.scala 99:24]
    node _T_11 = and(mem_cmd, store_signal) @[AllToAllController.scala 101:24]
    node _GEN_0 = mux(_T_11, UInt<3>("h5"), UInt<3>("h0")) @[AllToAllController.scala 101:40 AllToAllController.scala 102:13 AllToAllController.scala 104:13]
    node _GEN_1 = mux(_T_10, UInt<3>("h4"), _GEN_0) @[AllToAllController.scala 99:39 AllToAllController.scala 100:13]
    node _GEN_2 = mux(action_signal, UInt<3>("h1"), _GEN_1) @[AllToAllController.scala 97:24 AllToAllController.scala 98:13]
    node _T_12 = eq(state, UInt<3>("h4")) @[AllToAllController.scala 107:20]
    node _T_13 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 110:19]
    node _T_14 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 111:26]
    node _T_15 = and(_T_14, io_processor_cmd_valid) @[AllToAllController.scala 111:38]
    node _T_16 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 116:10]
    node _GEN_3 = mux(_T_16, io_processor_cmd_bits_inst_rd, rd_address) @[AllToAllController.scala 116:22 AllToAllController.scala 117:18 AllToAllController.scala 47:23]
    node _T_17 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 120:28]
    node _T_18 = and(action_signal, _T_17) @[AllToAllController.scala 120:25]
    node _T_19 = and(mem_cmd, load_signal) @[AllToAllController.scala 122:24]
    node _T_20 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 122:42]
    node _T_21 = and(_T_19, _T_20) @[AllToAllController.scala 122:39]
    node _T_22 = and(mem_cmd, store_signal) @[AllToAllController.scala 124:24]
    node _T_23 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 124:43]
    node _T_24 = and(_T_22, _T_23) @[AllToAllController.scala 124:40]
    node _GEN_4 = mux(stall_resp, UInt<3>("h7"), UInt<3>("h0")) @[AllToAllController.scala 126:27 AllToAllController.scala 127:13 AllToAllController.scala 129:13]
    node _GEN_5 = mux(_T_24, UInt<3>("h5"), _GEN_4) @[AllToAllController.scala 124:55 AllToAllController.scala 125:13]
    node _GEN_6 = mux(_T_21, UInt<3>("h4"), _GEN_5) @[AllToAllController.scala 122:54 AllToAllController.scala 123:13]
    node _GEN_7 = mux(_T_18, UInt<3>("h1"), _GEN_6) @[AllToAllController.scala 120:40 AllToAllController.scala 121:13]
    node _T_25 = eq(state, UInt<3>("h5")) @[AllToAllController.scala 132:20]
    node _T_26 = eq(state, UInt<3>("h6")) @[AllToAllController.scala 143:20]
    node _T_27 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 146:19]
    node _T_28 = and(io_processor_cmd_valid, io_processor_cmd_valid) @[AllToAllController.scala 147:37]
    node _T_29 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 152:10]
    node _GEN_8 = mux(_T_29, io_processor_cmd_bits_inst_rd, rd_address) @[AllToAllController.scala 152:22 AllToAllController.scala 153:18 AllToAllController.scala 47:23]
    node _T_30 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 156:28]
    node _T_31 = and(action_signal, _T_30) @[AllToAllController.scala 156:25]
    node _T_32 = and(mem_cmd, load_signal) @[AllToAllController.scala 158:24]
    node _T_33 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 158:42]
    node _T_34 = and(_T_32, _T_33) @[AllToAllController.scala 158:39]
    node _T_35 = and(mem_cmd, store_signal) @[AllToAllController.scala 160:24]
    node _T_36 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 160:43]
    node _T_37 = and(_T_35, _T_36) @[AllToAllController.scala 160:40]
    node _GEN_9 = mux(_T_37, UInt<3>("h5"), _GEN_4) @[AllToAllController.scala 160:55 AllToAllController.scala 161:13]
    node _GEN_10 = mux(_T_34, UInt<3>("h4"), _GEN_9) @[AllToAllController.scala 158:54 AllToAllController.scala 159:13]
    node _GEN_11 = mux(_T_31, UInt<3>("h1"), _GEN_10) @[AllToAllController.scala 156:40 AllToAllController.scala 157:13]
    node _T_38 = eq(state, UInt<3>("h7")) @[AllToAllController.scala 168:20]
    node _T_39 = eq(state, UInt<3>("h1")) @[AllToAllController.scala 183:20]
    node _T_40 = eq(state, UInt<3>("h2")) @[AllToAllController.scala 193:20]
    node _GEN_12 = mux(done_action_signal, UInt<3>("h3"), UInt<3>("h2")) @[AllToAllController.scala 201:30 AllToAllController.scala 202:13 AllToAllController.scala 204:13]
    node _T_41 = eq(state, UInt<3>("h3")) @[AllToAllController.scala 207:20]
    node _T_42 = eq(io_processor_resp_ready, UInt<1>("h0")) @[AllToAllController.scala 215:10]
    node _GEN_13 = mux(_T_42, UInt<3>("h3"), UInt<3>("h0")) @[AllToAllController.scala 215:23 AllToAllController.scala 216:13 AllToAllController.scala 218:12]
    node _GEN_14 = mux(_T_41, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllController.scala 207:36 AllToAllController.scala 209:23 AllToAllController.scala 223:23]
    node _GEN_15 = mux(_T_41, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllController.scala 207:36 AllToAllController.scala 210:16 AllToAllController.scala 224:16]
    node _GEN_16 = mux(_T_41, rd_address, rd_address) @[AllToAllController.scala 207:36 AllToAllController.scala 212:31 AllToAllController.scala 227:31]
    node _GEN_17 = mux(_T_41, _GEN_13, UInt<3>("h0")) @[AllToAllController.scala 207:36 AllToAllController.scala 229:11]
    node _GEN_18 = mux(_T_40, UInt<1>("h1"), _GEN_14) @[AllToAllController.scala 193:41 AllToAllController.scala 195:23]
    node _GEN_19 = mux(_T_40, UInt<1>("h0"), _GEN_15) @[AllToAllController.scala 193:41 AllToAllController.scala 196:16]
    node _GEN_20 = mux(_T_40, UInt<1>("h0"), _GEN_14) @[AllToAllController.scala 193:41 AllToAllController.scala 197:24]
    node _GEN_21 = mux(_T_40, rd_address, _GEN_16) @[AllToAllController.scala 193:41 AllToAllController.scala 198:31]
    node _GEN_22 = mux(_T_40, _GEN_12, _GEN_17) @[AllToAllController.scala 193:41]
    node _GEN_23 = mux(_T_39, UInt<1>("h1"), _GEN_18) @[AllToAllController.scala 183:31 AllToAllController.scala 185:23]
    node _GEN_24 = mux(_T_39, UInt<1>("h0"), _GEN_19) @[AllToAllController.scala 183:31 AllToAllController.scala 186:16]
    node _GEN_25 = mux(_T_39, UInt<1>("h0"), _GEN_20) @[AllToAllController.scala 183:31 AllToAllController.scala 187:24]
    node _GEN_26 = mux(_T_39, rd_address, _GEN_21) @[AllToAllController.scala 183:31 AllToAllController.scala 188:19]
    node _GEN_27 = mux(_T_39, UInt<3>("h2"), _GEN_22) @[AllToAllController.scala 183:31 AllToAllController.scala 191:11]
    node _GEN_28 = mux(_T_38, UInt<1>("h1"), _GEN_23) @[AllToAllController.scala 168:41 AllToAllController.scala 170:23]
    node _GEN_29 = mux(_T_38, UInt<1>("h0"), _GEN_24) @[AllToAllController.scala 168:41 AllToAllController.scala 171:16]
    node _GEN_30 = mux(_T_38, UInt<1>("h0"), io_processor_cmd_valid) @[AllToAllController.scala 168:41 AllToAllController.scala 172:23 AllToAllController.scala 82:21]
    node _GEN_31 = mux(_T_38, UInt<1>("h1"), _GEN_25) @[AllToAllController.scala 168:41 AllToAllController.scala 173:17]
    node _GEN_32 = mux(_T_38, io_processor_resp_ready, _GEN_25) @[AllToAllController.scala 168:41 AllToAllController.scala 174:24]
    node _GEN_33 = mux(_T_38, rd_address, _GEN_26) @[AllToAllController.scala 168:41 AllToAllController.scala 175:31]
    node _GEN_34 = mux(_T_38, _GEN_4, _GEN_27) @[AllToAllController.scala 168:41]
    node _GEN_35 = mux(_T_26, stall_resp, _GEN_28) @[AllToAllController.scala 143:35 AllToAllController.scala 145:23]
    node _GEN_36 = mux(_T_26, _T_27, _GEN_29) @[AllToAllController.scala 143:35 AllToAllController.scala 146:16]
    node _GEN_37 = mux(_T_26, _T_28, _GEN_30) @[AllToAllController.scala 143:35 AllToAllController.scala 147:23]
    node _GEN_38 = mux(_T_26, UInt<1>("h1"), _GEN_31) @[AllToAllController.scala 143:35 AllToAllController.scala 148:17]
    node _GEN_39 = mux(_T_26, io_processor_resp_ready, _GEN_32) @[AllToAllController.scala 143:35 AllToAllController.scala 149:24]
    node _GEN_40 = mux(_T_26, rd_address, _GEN_33) @[AllToAllController.scala 143:35 AllToAllController.scala 150:31]
    node _GEN_41 = mux(_T_26, _GEN_8, rd_address) @[AllToAllController.scala 143:35 AllToAllController.scala 47:23]
    node _GEN_42 = mux(_T_26, _GEN_11, _GEN_34) @[AllToAllController.scala 143:35]
    node _GEN_43 = mux(_T_25, UInt<1>("h1"), _GEN_35) @[AllToAllController.scala 132:36 AllToAllController.scala 134:23]
    node _GEN_44 = mux(_T_25, UInt<1>("h0"), _GEN_36) @[AllToAllController.scala 132:36 AllToAllController.scala 135:16]
    node _GEN_45 = mux(_T_25, UInt<1>("h0"), _GEN_37) @[AllToAllController.scala 132:36 AllToAllController.scala 136:23]
    node _GEN_46 = mux(_T_25, UInt<1>("h0"), _GEN_38) @[AllToAllController.scala 132:36 AllToAllController.scala 137:17]
    node _GEN_47 = mux(_T_25, UInt<1>("h0"), _GEN_39) @[AllToAllController.scala 132:36 AllToAllController.scala 138:24]
    node _GEN_48 = mux(_T_25, rd_address, _GEN_40) @[AllToAllController.scala 132:36 AllToAllController.scala 139:31]
    node _GEN_49 = mux(_T_25, UInt<3>("h6"), _GEN_42) @[AllToAllController.scala 132:36 AllToAllController.scala 141:11]
    node _GEN_50 = mux(_T_25, rd_address, _GEN_41) @[AllToAllController.scala 132:36 AllToAllController.scala 47:23]
    node _GEN_51 = mux(_T_12, stall_resp, _GEN_43) @[AllToAllController.scala 107:35 AllToAllController.scala 109:23]
    node _GEN_52 = mux(_T_12, _T_13, _GEN_44) @[AllToAllController.scala 107:35 AllToAllController.scala 110:16]
    node _GEN_53 = mux(_T_12, _T_15, _GEN_45) @[AllToAllController.scala 107:35 AllToAllController.scala 111:23]
    node _GEN_54 = mux(_T_12, UInt<1>("h1"), _GEN_46) @[AllToAllController.scala 107:35 AllToAllController.scala 112:17]
    node _GEN_55 = mux(_T_12, io_processor_resp_ready, _GEN_47) @[AllToAllController.scala 107:35 AllToAllController.scala 113:24]
    node _GEN_56 = mux(_T_12, rd_address, _GEN_48) @[AllToAllController.scala 107:35 AllToAllController.scala 114:31]
    node _GEN_57 = mux(_T_12, _GEN_3, _GEN_50) @[AllToAllController.scala 107:35]
    node _GEN_58 = mux(_T_12, _GEN_7, _GEN_49) @[AllToAllController.scala 107:35]
    node _GEN_59 = mux(_T_9, UInt<1>("h0"), _GEN_51) @[AllToAllController.scala 87:23 AllToAllController.scala 89:23]
    node _GEN_60 = mux(_T_9, UInt<1>("h1"), _GEN_52) @[AllToAllController.scala 87:23 AllToAllController.scala 90:16]
    node _GEN_61 = mux(_T_9, io_processor_cmd_valid, _GEN_53) @[AllToAllController.scala 87:23 AllToAllController.scala 91:23]
    node _GEN_62 = mux(_T_9, UInt<1>("h0"), _GEN_54) @[AllToAllController.scala 87:23 AllToAllController.scala 92:17]
    node _GEN_63 = mux(_T_9, UInt<1>("h0"), _GEN_55) @[AllToAllController.scala 87:23 AllToAllController.scala 93:24]
    node _GEN_64 = mux(_T_9, io_processor_cmd_bits_inst_rd, _GEN_56) @[AllToAllController.scala 87:23 AllToAllController.scala 94:31]
    node _GEN_65 = mux(_T_9, io_processor_cmd_bits_inst_rd, _GEN_57) @[AllToAllController.scala 87:23 AllToAllController.scala 95:16]
    node _GEN_66 = mux(_T_9, _GEN_2, _GEN_58) @[AllToAllController.scala 87:23]
    io_processor_cmd_ready <= _GEN_60
    io_processor_resp_valid <= _GEN_62
    io_processor_resp_bits_rd <= _GEN_64
    io_processor_resp_bits_data <= io_mesh_resp_bits_data @[AllToAllController.scala 63:19]
    io_processor_busy <= _GEN_59
    io_processor_interrupt <= UInt<1>("h0") @[AllToAllController.scala 56:26]
    io_mesh_cmd_valid <= _GEN_61
    io_mesh_cmd_bits_load <= _T_7 @[AllToAllController.scala 83:25]
    io_mesh_cmd_bits_store <= _T_8 @[AllToAllController.scala 84:26]
    io_mesh_cmd_bits_doAllToAll <= action_signal @[AllToAllController.scala 85:31]
    io_mesh_cmd_bits_rs1 <= io_processor_cmd_bits_rs1 @[AllToAllController.scala 59:24]
    io_mesh_cmd_bits_rs2 <= io_processor_cmd_bits_rs2 @[AllToAllController.scala 60:24]
    io_mesh_resp_ready <= _GEN_63
    state <= mux(reset, UInt<3>("h0"), _GEN_66) @[AllToAllController.scala 40:22 AllToAllController.scala 40:22]
    rd_address <= _GEN_65

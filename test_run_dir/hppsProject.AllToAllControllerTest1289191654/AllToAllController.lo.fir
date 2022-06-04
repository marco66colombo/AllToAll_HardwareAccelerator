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
    node _T_1 = eq(io_processor_cmd_bits_inst_opcode, UInt<6>("h2b")) @[AllToAllController.scala 70:60]
    node action_signal = and(io_processor_cmd_valid, _T_1) @[AllToAllController.scala 70:34]
    node done_action_signal = eq(io_mesh_busy, UInt<1>("h0")) @[AllToAllController.scala 71:28]
    node _T_2 = eq(io_processor_cmd_bits_inst_opcode, UInt<4>("hb")) @[AllToAllController.scala 74:54]
    node mem_cmd = and(io_processor_cmd_valid, _T_2) @[AllToAllController.scala 74:28]
    node load_signal = eq(io_processor_cmd_bits_inst_funct, UInt<1>("h1")) @[AllToAllController.scala 76:42]
    node store_signal = eq(io_processor_cmd_bits_inst_funct, UInt<2>("h2")) @[AllToAllController.scala 78:43]
    node _T_3 = and(mem_cmd, load_signal) @[AllToAllController.scala 82:36]
    node _T_4 = and(mem_cmd, store_signal) @[AllToAllController.scala 83:37]
    node _T_5 = eq(state, UInt<3>("h0")) @[AllToAllController.scala 86:14]
    node _T_6 = and(mem_cmd, load_signal) @[AllToAllController.scala 98:24]
    node _T_7 = and(mem_cmd, store_signal) @[AllToAllController.scala 100:24]
    node _GEN_0 = mux(_T_7, UInt<3>("h5"), UInt<3>("h0")) @[AllToAllController.scala 100:40 AllToAllController.scala 101:13 AllToAllController.scala 103:13]
    node _GEN_1 = mux(_T_6, UInt<3>("h4"), _GEN_0) @[AllToAllController.scala 98:39 AllToAllController.scala 99:13]
    node _GEN_2 = mux(action_signal, UInt<3>("h1"), _GEN_1) @[AllToAllController.scala 96:24 AllToAllController.scala 97:13]
    node _T_8 = eq(state, UInt<3>("h4")) @[AllToAllController.scala 106:20]
    node _T_9 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 109:19]
    node _T_10 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 110:26]
    node _T_11 = and(_T_10, io_processor_cmd_valid) @[AllToAllController.scala 110:38]
    node _T_12 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 115:10]
    node _GEN_3 = mux(_T_12, io_processor_cmd_bits_inst_rd, rd_address) @[AllToAllController.scala 115:22 AllToAllController.scala 116:18 AllToAllController.scala 47:23]
    node _T_13 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 119:28]
    node _T_14 = and(action_signal, _T_13) @[AllToAllController.scala 119:25]
    node _T_15 = and(mem_cmd, load_signal) @[AllToAllController.scala 121:24]
    node _T_16 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 121:42]
    node _T_17 = and(_T_15, _T_16) @[AllToAllController.scala 121:39]
    node _T_18 = and(mem_cmd, store_signal) @[AllToAllController.scala 123:24]
    node _T_19 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 123:43]
    node _T_20 = and(_T_18, _T_19) @[AllToAllController.scala 123:40]
    node _GEN_4 = mux(stall_resp, UInt<3>("h7"), UInt<3>("h0")) @[AllToAllController.scala 125:27 AllToAllController.scala 126:13 AllToAllController.scala 128:13]
    node _GEN_5 = mux(_T_20, UInt<3>("h5"), _GEN_4) @[AllToAllController.scala 123:55 AllToAllController.scala 124:13]
    node _GEN_6 = mux(_T_17, UInt<3>("h4"), _GEN_5) @[AllToAllController.scala 121:54 AllToAllController.scala 122:13]
    node _GEN_7 = mux(_T_14, UInt<3>("h1"), _GEN_6) @[AllToAllController.scala 119:40 AllToAllController.scala 120:13]
    node _T_21 = eq(state, UInt<3>("h5")) @[AllToAllController.scala 131:20]
    node _T_22 = eq(state, UInt<3>("h6")) @[AllToAllController.scala 142:20]
    node _T_23 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 145:19]
    node _T_24 = and(io_processor_cmd_valid, io_processor_cmd_valid) @[AllToAllController.scala 146:37]
    node _T_25 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 151:10]
    node _GEN_8 = mux(_T_25, io_processor_cmd_bits_inst_rd, rd_address) @[AllToAllController.scala 151:22 AllToAllController.scala 152:18 AllToAllController.scala 47:23]
    node _T_26 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 155:28]
    node _T_27 = and(action_signal, _T_26) @[AllToAllController.scala 155:25]
    node _T_28 = and(mem_cmd, load_signal) @[AllToAllController.scala 157:24]
    node _T_29 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 157:42]
    node _T_30 = and(_T_28, _T_29) @[AllToAllController.scala 157:39]
    node _T_31 = and(mem_cmd, store_signal) @[AllToAllController.scala 159:24]
    node _T_32 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 159:43]
    node _T_33 = and(_T_31, _T_32) @[AllToAllController.scala 159:40]
    node _GEN_9 = mux(_T_33, UInt<3>("h5"), _GEN_4) @[AllToAllController.scala 159:55 AllToAllController.scala 160:13]
    node _GEN_10 = mux(_T_30, UInt<3>("h4"), _GEN_9) @[AllToAllController.scala 157:54 AllToAllController.scala 158:13]
    node _GEN_11 = mux(_T_27, UInt<3>("h1"), _GEN_10) @[AllToAllController.scala 155:40 AllToAllController.scala 156:13]
    node _T_34 = eq(state, UInt<3>("h7")) @[AllToAllController.scala 167:20]
    node _T_35 = eq(state, UInt<3>("h1")) @[AllToAllController.scala 182:20]
    node _T_36 = eq(state, UInt<3>("h2")) @[AllToAllController.scala 192:20]
    node _GEN_12 = mux(done_action_signal, UInt<3>("h3"), UInt<3>("h2")) @[AllToAllController.scala 200:30 AllToAllController.scala 201:13 AllToAllController.scala 203:13]
    node _T_37 = eq(state, UInt<3>("h3")) @[AllToAllController.scala 206:20]
    node _T_38 = eq(io_processor_resp_ready, UInt<1>("h0")) @[AllToAllController.scala 214:10]
    node _GEN_13 = mux(_T_38, UInt<3>("h3"), UInt<3>("h0")) @[AllToAllController.scala 214:23 AllToAllController.scala 215:13 AllToAllController.scala 217:12]
    node _GEN_14 = mux(_T_37, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllController.scala 206:36 AllToAllController.scala 208:23 AllToAllController.scala 222:23]
    node _GEN_15 = mux(_T_37, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllController.scala 206:36 AllToAllController.scala 209:16 AllToAllController.scala 223:16]
    node _GEN_16 = mux(_T_37, rd_address, rd_address) @[AllToAllController.scala 206:36 AllToAllController.scala 211:31 AllToAllController.scala 226:31]
    node _GEN_17 = mux(_T_37, _GEN_13, UInt<3>("h0")) @[AllToAllController.scala 206:36 AllToAllController.scala 228:11]
    node _GEN_18 = mux(_T_36, UInt<1>("h1"), _GEN_14) @[AllToAllController.scala 192:41 AllToAllController.scala 194:23]
    node _GEN_19 = mux(_T_36, UInt<1>("h0"), _GEN_15) @[AllToAllController.scala 192:41 AllToAllController.scala 195:16]
    node _GEN_20 = mux(_T_36, UInt<1>("h0"), _GEN_14) @[AllToAllController.scala 192:41 AllToAllController.scala 196:24]
    node _GEN_21 = mux(_T_36, rd_address, _GEN_16) @[AllToAllController.scala 192:41 AllToAllController.scala 197:31]
    node _GEN_22 = mux(_T_36, _GEN_12, _GEN_17) @[AllToAllController.scala 192:41]
    node _GEN_23 = mux(_T_35, UInt<1>("h1"), _GEN_18) @[AllToAllController.scala 182:31 AllToAllController.scala 184:23]
    node _GEN_24 = mux(_T_35, UInt<1>("h0"), _GEN_19) @[AllToAllController.scala 182:31 AllToAllController.scala 185:16]
    node _GEN_25 = mux(_T_35, UInt<1>("h0"), _GEN_20) @[AllToAllController.scala 182:31 AllToAllController.scala 186:24]
    node _GEN_26 = mux(_T_35, rd_address, _GEN_21) @[AllToAllController.scala 182:31 AllToAllController.scala 187:19]
    node _GEN_27 = mux(_T_35, UInt<3>("h2"), _GEN_22) @[AllToAllController.scala 182:31 AllToAllController.scala 190:11]
    node _GEN_28 = mux(_T_34, UInt<1>("h1"), _GEN_23) @[AllToAllController.scala 167:41 AllToAllController.scala 169:23]
    node _GEN_29 = mux(_T_34, UInt<1>("h0"), _GEN_24) @[AllToAllController.scala 167:41 AllToAllController.scala 170:16]
    node _GEN_30 = mux(_T_34, UInt<1>("h0"), io_processor_cmd_valid) @[AllToAllController.scala 167:41 AllToAllController.scala 171:23 AllToAllController.scala 81:21]
    node _GEN_31 = mux(_T_34, UInt<1>("h1"), _GEN_25) @[AllToAllController.scala 167:41 AllToAllController.scala 172:17]
    node _GEN_32 = mux(_T_34, io_processor_resp_ready, _GEN_25) @[AllToAllController.scala 167:41 AllToAllController.scala 173:24]
    node _GEN_33 = mux(_T_34, rd_address, _GEN_26) @[AllToAllController.scala 167:41 AllToAllController.scala 174:31]
    node _GEN_34 = mux(_T_34, _GEN_4, _GEN_27) @[AllToAllController.scala 167:41]
    node _GEN_35 = mux(_T_22, stall_resp, _GEN_28) @[AllToAllController.scala 142:35 AllToAllController.scala 144:23]
    node _GEN_36 = mux(_T_22, _T_23, _GEN_29) @[AllToAllController.scala 142:35 AllToAllController.scala 145:16]
    node _GEN_37 = mux(_T_22, _T_24, _GEN_30) @[AllToAllController.scala 142:35 AllToAllController.scala 146:23]
    node _GEN_38 = mux(_T_22, UInt<1>("h1"), _GEN_31) @[AllToAllController.scala 142:35 AllToAllController.scala 147:17]
    node _GEN_39 = mux(_T_22, io_processor_resp_ready, _GEN_32) @[AllToAllController.scala 142:35 AllToAllController.scala 148:24]
    node _GEN_40 = mux(_T_22, rd_address, _GEN_33) @[AllToAllController.scala 142:35 AllToAllController.scala 149:31]
    node _GEN_41 = mux(_T_22, _GEN_8, rd_address) @[AllToAllController.scala 142:35 AllToAllController.scala 47:23]
    node _GEN_42 = mux(_T_22, _GEN_11, _GEN_34) @[AllToAllController.scala 142:35]
    node _GEN_43 = mux(_T_21, UInt<1>("h1"), _GEN_35) @[AllToAllController.scala 131:36 AllToAllController.scala 133:23]
    node _GEN_44 = mux(_T_21, UInt<1>("h0"), _GEN_36) @[AllToAllController.scala 131:36 AllToAllController.scala 134:16]
    node _GEN_45 = mux(_T_21, UInt<1>("h0"), _GEN_37) @[AllToAllController.scala 131:36 AllToAllController.scala 135:23]
    node _GEN_46 = mux(_T_21, UInt<1>("h0"), _GEN_38) @[AllToAllController.scala 131:36 AllToAllController.scala 136:17]
    node _GEN_47 = mux(_T_21, UInt<1>("h0"), _GEN_39) @[AllToAllController.scala 131:36 AllToAllController.scala 137:24]
    node _GEN_48 = mux(_T_21, rd_address, _GEN_40) @[AllToAllController.scala 131:36 AllToAllController.scala 138:31]
    node _GEN_49 = mux(_T_21, UInt<3>("h6"), _GEN_42) @[AllToAllController.scala 131:36 AllToAllController.scala 140:11]
    node _GEN_50 = mux(_T_21, rd_address, _GEN_41) @[AllToAllController.scala 131:36 AllToAllController.scala 47:23]
    node _GEN_51 = mux(_T_8, stall_resp, _GEN_43) @[AllToAllController.scala 106:35 AllToAllController.scala 108:23]
    node _GEN_52 = mux(_T_8, _T_9, _GEN_44) @[AllToAllController.scala 106:35 AllToAllController.scala 109:16]
    node _GEN_53 = mux(_T_8, _T_11, _GEN_45) @[AllToAllController.scala 106:35 AllToAllController.scala 110:23]
    node _GEN_54 = mux(_T_8, UInt<1>("h1"), _GEN_46) @[AllToAllController.scala 106:35 AllToAllController.scala 111:17]
    node _GEN_55 = mux(_T_8, io_processor_resp_ready, _GEN_47) @[AllToAllController.scala 106:35 AllToAllController.scala 112:24]
    node _GEN_56 = mux(_T_8, rd_address, _GEN_48) @[AllToAllController.scala 106:35 AllToAllController.scala 113:31]
    node _GEN_57 = mux(_T_8, _GEN_3, _GEN_50) @[AllToAllController.scala 106:35]
    node _GEN_58 = mux(_T_8, _GEN_7, _GEN_49) @[AllToAllController.scala 106:35]
    node _GEN_59 = mux(_T_5, UInt<1>("h0"), _GEN_51) @[AllToAllController.scala 86:23 AllToAllController.scala 88:23]
    node _GEN_60 = mux(_T_5, UInt<1>("h1"), _GEN_52) @[AllToAllController.scala 86:23 AllToAllController.scala 89:16]
    node _GEN_61 = mux(_T_5, io_processor_cmd_valid, _GEN_53) @[AllToAllController.scala 86:23 AllToAllController.scala 90:23]
    node _GEN_62 = mux(_T_5, UInt<1>("h0"), _GEN_54) @[AllToAllController.scala 86:23 AllToAllController.scala 91:17]
    node _GEN_63 = mux(_T_5, UInt<1>("h0"), _GEN_55) @[AllToAllController.scala 86:23 AllToAllController.scala 92:24]
    node _GEN_64 = mux(_T_5, io_processor_cmd_bits_inst_rd, _GEN_56) @[AllToAllController.scala 86:23 AllToAllController.scala 93:31]
    node _GEN_65 = mux(_T_5, io_processor_cmd_bits_inst_rd, _GEN_57) @[AllToAllController.scala 86:23 AllToAllController.scala 94:16]
    node _GEN_66 = mux(_T_5, _GEN_2, _GEN_58) @[AllToAllController.scala 86:23]
    io_processor_cmd_ready <= _GEN_60
    io_processor_resp_valid <= _GEN_62
    io_processor_resp_bits_rd <= _GEN_64
    io_processor_resp_bits_data <= io_mesh_resp_bits_data @[AllToAllController.scala 63:19]
    io_processor_busy <= _GEN_59
    io_processor_interrupt <= UInt<1>("h0") @[AllToAllController.scala 56:26]
    io_mesh_cmd_valid <= _GEN_61
    io_mesh_cmd_bits_load <= _T_3 @[AllToAllController.scala 82:25]
    io_mesh_cmd_bits_store <= _T_4 @[AllToAllController.scala 83:26]
    io_mesh_cmd_bits_doAllToAll <= action_signal @[AllToAllController.scala 84:31]
    io_mesh_cmd_bits_rs1 <= io_processor_cmd_bits_rs1 @[AllToAllController.scala 59:24]
    io_mesh_cmd_bits_rs2 <= io_processor_cmd_bits_rs2 @[AllToAllController.scala 60:24]
    io_mesh_resp_ready <= _GEN_63
    state <= mux(reset, UInt<3>("h0"), _GEN_66) @[AllToAllController.scala 40:22 AllToAllController.scala 40:22]
    rd_address <= _GEN_65

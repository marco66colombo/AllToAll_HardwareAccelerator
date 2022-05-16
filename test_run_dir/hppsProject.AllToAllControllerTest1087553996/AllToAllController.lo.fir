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
      reset => (UInt<1>("h0"), state) @[AllToAllController.scala 44:22]
    reg r : UInt<5>, clock with :
      reset => (UInt<1>("h0"), r) @[Reg.scala 15:16]
    node _GEN_0 = mux(UInt<1>("h1"), io_processor_cmd_bits_inst_rd, r) @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    reg rd_address_mem : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address_mem) @[Reg.scala 15:16]
    node _GEN_1 = mux(UInt<1>("h1"), r, rd_address_mem) @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    reg rd_address_mem_resp_stall : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address_mem_resp_stall) @[AllToAllController.scala 56:38]
    reg rd_address_action : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address_action) @[AllToAllController.scala 57:30]
    reg rd_address : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address) @[AllToAllController.scala 59:23]
    reg resp_signal : UInt<1>, clock with :
      reset => (UInt<1>("h0"), resp_signal) @[AllToAllController.scala 66:28]
    node _T = eq(io_processor_resp_ready, UInt<1>("h0")) @[AllToAllController.scala 68:20]
    node stall_resp = and(_T, resp_signal) @[AllToAllController.scala 68:33]
    node _T_1 = eq(io_processor_cmd_bits_inst_opcode, UInt<6>("h2b")) @[AllToAllController.scala 91:60]
    node action_signal = and(io_processor_cmd_valid, _T_1) @[AllToAllController.scala 91:34]
    node done_action_signal = eq(io_mesh_busy, UInt<1>("h0")) @[AllToAllController.scala 92:28]
    node _T_2 = eq(io_processor_cmd_bits_inst_opcode, UInt<4>("hb")) @[AllToAllController.scala 95:54]
    node mem_cmd = and(io_processor_cmd_valid, _T_2) @[AllToAllController.scala 95:28]
    node load_signal = eq(io_processor_cmd_bits_inst_funct, UInt<1>("h1")) @[AllToAllController.scala 97:42]
    node store_signal = eq(io_processor_cmd_bits_inst_funct, UInt<2>("h2")) @[AllToAllController.scala 99:43]
    node _T_3 = and(mem_cmd, load_signal) @[AllToAllController.scala 103:36]
    node _T_4 = and(mem_cmd, store_signal) @[AllToAllController.scala 104:37]
    node _T_5 = eq(state, UInt<3>("h0")) @[AllToAllController.scala 107:14]
    node _T_6 = and(mem_cmd, load_signal) @[AllToAllController.scala 127:24]
    node _T_7 = and(mem_cmd, store_signal) @[AllToAllController.scala 129:24]
    node _GEN_2 = mux(_T_7, UInt<3>("h5"), UInt<3>("h0")) @[AllToAllController.scala 129:40 AllToAllController.scala 130:13 AllToAllController.scala 132:13]
    node _GEN_3 = mux(_T_6, UInt<3>("h4"), _GEN_2) @[AllToAllController.scala 127:39 AllToAllController.scala 128:13]
    node _GEN_4 = mux(action_signal, UInt<3>("h1"), _GEN_3) @[AllToAllController.scala 125:24 AllToAllController.scala 126:13]
    node _T_8 = eq(state, UInt<3>("h4")) @[AllToAllController.scala 135:20]
    node _T_9 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 165:28]
    node _T_10 = and(action_signal, _T_9) @[AllToAllController.scala 165:25]
    node _T_11 = and(mem_cmd, load_signal) @[AllToAllController.scala 167:24]
    node _T_12 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 167:42]
    node _T_13 = and(_T_11, _T_12) @[AllToAllController.scala 167:39]
    node _T_14 = and(mem_cmd, store_signal) @[AllToAllController.scala 169:24]
    node _T_15 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 169:43]
    node _T_16 = and(_T_14, _T_15) @[AllToAllController.scala 169:40]
    node _GEN_5 = mux(stall_resp, UInt<3>("h7"), UInt<3>("h0")) @[AllToAllController.scala 171:27 AllToAllController.scala 172:13 AllToAllController.scala 174:13]
    node _GEN_6 = mux(_T_16, UInt<3>("h5"), _GEN_5) @[AllToAllController.scala 169:55 AllToAllController.scala 170:13]
    node _GEN_7 = mux(_T_13, UInt<3>("h4"), _GEN_6) @[AllToAllController.scala 167:54 AllToAllController.scala 168:13]
    node _GEN_8 = mux(_T_10, UInt<3>("h1"), _GEN_7) @[AllToAllController.scala 165:40 AllToAllController.scala 166:13]
    node _T_17 = eq(state, UInt<3>("h5")) @[AllToAllController.scala 177:20]
    node _T_18 = eq(state, UInt<3>("h6")) @[AllToAllController.scala 212:20]
    node _T_19 = or(UInt<1>("h0"), stall_resp) @[AllToAllController.scala 214:34]
    node _T_20 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 215:29]
    node _T_21 = and(UInt<1>("h1"), _T_20) @[AllToAllController.scala 215:26]
    node _T_22 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 217:40]
    node _T_23 = and(io_processor_cmd_valid, _T_22) @[AllToAllController.scala 217:37]
    node _T_24 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 241:28]
    node _T_25 = and(action_signal, _T_24) @[AllToAllController.scala 241:25]
    node _T_26 = and(mem_cmd, load_signal) @[AllToAllController.scala 243:24]
    node _T_27 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 243:42]
    node _T_28 = and(_T_26, _T_27) @[AllToAllController.scala 243:39]
    node _T_29 = and(mem_cmd, store_signal) @[AllToAllController.scala 245:24]
    node _T_30 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 245:43]
    node _T_31 = and(_T_29, _T_30) @[AllToAllController.scala 245:40]
    node _GEN_9 = mux(_T_31, UInt<3>("h5"), _GEN_5) @[AllToAllController.scala 245:55 AllToAllController.scala 246:13]
    node _GEN_10 = mux(_T_28, UInt<3>("h4"), _GEN_9) @[AllToAllController.scala 243:54 AllToAllController.scala 244:13]
    node _GEN_11 = mux(_T_25, UInt<3>("h1"), _GEN_10) @[AllToAllController.scala 241:40 AllToAllController.scala 242:13]
    node _T_32 = eq(state, UInt<3>("h7")) @[AllToAllController.scala 253:20]
    node _GEN_12 = mux(stall_resp, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllController.scala 266:21 AllToAllController.scala 268:19 AllToAllController.scala 273:19]
    node _T_33 = eq(state, UInt<3>("h1")) @[AllToAllController.scala 278:20]
    node _T_34 = eq(state, UInt<3>("h2")) @[AllToAllController.scala 294:20]
    node _GEN_13 = mux(done_action_signal, UInt<3>("h3"), UInt<3>("h2")) @[AllToAllController.scala 304:30 AllToAllController.scala 305:13 AllToAllController.scala 307:13]
    node _T_35 = eq(state, UInt<3>("h3")) @[AllToAllController.scala 310:20]
    node _GEN_14 = mux(_T_35, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllController.scala 310:36 AllToAllController.scala 312:23 AllToAllController.scala 325:23]
    node _GEN_15 = mux(_T_35, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllController.scala 310:36 AllToAllController.scala 313:16 AllToAllController.scala 326:16]
    node _GEN_16 = mux(_T_35, rd_address_action, rd_address_mem) @[AllToAllController.scala 310:36 AllToAllController.scala 319:31 AllToAllController.scala 331:31]
    node _GEN_17 = mux(_T_35, UInt<3>("h0"), UInt<3>("h0")) @[AllToAllController.scala 310:36 AllToAllController.scala 321:11 AllToAllController.scala 333:11]
    node _GEN_18 = mux(_T_34, UInt<1>("h1"), _GEN_14) @[AllToAllController.scala 294:41 AllToAllController.scala 296:23]
    node _GEN_19 = mux(_T_34, UInt<1>("h0"), _GEN_15) @[AllToAllController.scala 294:41 AllToAllController.scala 297:16]
    node _GEN_20 = mux(_T_34, UInt<1>("h0"), _GEN_14) @[AllToAllController.scala 294:41 AllToAllController.scala 300:24]
    node _GEN_21 = mux(_T_34, rd_address_action, _GEN_16) @[AllToAllController.scala 294:41 AllToAllController.scala 302:31]
    node _GEN_22 = mux(_T_34, _GEN_13, _GEN_17) @[AllToAllController.scala 294:41]
    node _GEN_23 = mux(_T_33, UInt<1>("h1"), _GEN_18) @[AllToAllController.scala 278:31 AllToAllController.scala 280:23]
    node _GEN_24 = mux(_T_33, UInt<1>("h0"), _GEN_19) @[AllToAllController.scala 278:31 AllToAllController.scala 281:16]
    node _GEN_25 = mux(_T_33, UInt<1>("h0"), resp_signal) @[AllToAllController.scala 278:31 AllToAllController.scala 283:17 AllToAllController.scala 66:28]
    node _GEN_26 = mux(_T_33, io_processor_cmd_bits_inst_rd, rd_address_action) @[AllToAllController.scala 278:31 AllToAllController.scala 285:23 AllToAllController.scala 57:30]
    node _GEN_27 = mux(_T_33, resp_signal, _GEN_20) @[AllToAllController.scala 278:31 AllToAllController.scala 288:24]
    node _GEN_28 = mux(_T_33, rd_address_mem, _GEN_21) @[AllToAllController.scala 278:31 AllToAllController.scala 290:31]
    node _GEN_29 = mux(_T_33, UInt<3>("h2"), _GEN_22) @[AllToAllController.scala 278:31 AllToAllController.scala 292:11]
    node _GEN_30 = mux(_T_32, UInt<1>("h1"), _GEN_23) @[AllToAllController.scala 253:41 AllToAllController.scala 257:23]
    node _GEN_31 = mux(_T_32, UInt<1>("h0"), _GEN_24) @[AllToAllController.scala 253:41 AllToAllController.scala 258:16]
    node _GEN_32 = mux(_T_32, UInt<1>("h0"), io_processor_cmd_valid) @[AllToAllController.scala 253:41 AllToAllController.scala 259:23 AllToAllController.scala 102:21]
    node _GEN_33 = mux(_T_32, io_processor_resp_ready, _GEN_27) @[AllToAllController.scala 253:41 AllToAllController.scala 262:24]
    node _GEN_34 = mux(_T_32, rd_address_mem_resp_stall, _GEN_28) @[AllToAllController.scala 253:41 AllToAllController.scala 264:31]
    node _GEN_35 = mux(_T_32, _GEN_12, _GEN_25) @[AllToAllController.scala 253:41]
    node _GEN_36 = mux(_T_32, _GEN_5, _GEN_29) @[AllToAllController.scala 253:41]
    node _GEN_37 = mux(_T_32, rd_address_action, _GEN_26) @[AllToAllController.scala 253:41 AllToAllController.scala 57:30]
    node _GEN_38 = mux(_T_18, _T_19, _GEN_30) @[AllToAllController.scala 212:35 AllToAllController.scala 214:23]
    node _GEN_39 = mux(_T_18, _T_21, _GEN_31) @[AllToAllController.scala 212:35 AllToAllController.scala 215:16]
    node _GEN_40 = mux(_T_18, _T_23, _GEN_32) @[AllToAllController.scala 212:35 AllToAllController.scala 217:23]
    node _GEN_41 = mux(_T_18, UInt<1>("h1"), resp_signal) @[AllToAllController.scala 212:35 AllToAllController.scala 223:17 AllToAllController.scala 84:15]
    node _GEN_42 = mux(_T_18, io_processor_resp_ready, _GEN_33) @[AllToAllController.scala 212:35 AllToAllController.scala 227:24]
    node _GEN_43 = mux(_T_18, rd_address_mem, _GEN_34) @[AllToAllController.scala 212:35 AllToAllController.scala 229:31]
    node _GEN_44 = mux(_T_18, _GEN_11, _GEN_36) @[AllToAllController.scala 212:35]
    node _GEN_45 = mux(_T_18, resp_signal, _GEN_35) @[AllToAllController.scala 212:35 AllToAllController.scala 66:28]
    node _GEN_46 = mux(_T_18, rd_address_action, _GEN_37) @[AllToAllController.scala 212:35 AllToAllController.scala 57:30]
    node _GEN_47 = mux(_T_17, UInt<1>("h1"), _GEN_38) @[AllToAllController.scala 177:36 AllToAllController.scala 180:23]
    node _GEN_48 = mux(_T_17, UInt<1>("h0"), _GEN_39) @[AllToAllController.scala 177:36 AllToAllController.scala 182:16]
    node _GEN_49 = mux(_T_17, UInt<1>("h0"), _GEN_40) @[AllToAllController.scala 177:36 AllToAllController.scala 184:23]
    node _GEN_50 = mux(_T_17, UInt<1>("h0"), _GEN_41) @[AllToAllController.scala 177:36 AllToAllController.scala 190:17]
    node _GEN_51 = mux(_T_17, UInt<1>("h0"), _GEN_42) @[AllToAllController.scala 177:36 AllToAllController.scala 194:24]
    node _GEN_52 = mux(_T_17, io_processor_cmd_bits_inst_rd, _GEN_43) @[AllToAllController.scala 177:36 AllToAllController.scala 196:31]
    node _GEN_53 = mux(_T_17, UInt<3>("h6"), _GEN_44) @[AllToAllController.scala 177:36 AllToAllController.scala 210:11]
    node _GEN_54 = mux(_T_17, resp_signal, _GEN_45) @[AllToAllController.scala 177:36 AllToAllController.scala 66:28]
    node _GEN_55 = mux(_T_17, rd_address_action, _GEN_46) @[AllToAllController.scala 177:36 AllToAllController.scala 57:30]
    node _GEN_56 = mux(_T_8, UInt<1>("h0"), _GEN_47) @[AllToAllController.scala 135:35 AllToAllController.scala 137:23]
    node _GEN_57 = mux(_T_8, UInt<1>("h1"), _GEN_48) @[AllToAllController.scala 135:35 AllToAllController.scala 138:16]
    node _GEN_58 = mux(_T_8, io_processor_cmd_valid, _GEN_49) @[AllToAllController.scala 135:35 AllToAllController.scala 140:23]
    node _GEN_59 = mux(_T_8, UInt<1>("h1"), _GEN_50) @[AllToAllController.scala 135:35 AllToAllController.scala 146:17]
    node _GEN_60 = mux(_T_8, UInt<6>("h20"), io_mesh_resp_bits_data) @[AllToAllController.scala 135:35 AllToAllController.scala 147:21 AllToAllController.scala 80:19]
    node _GEN_61 = mux(_T_8, io_processor_resp_ready, _GEN_51) @[AllToAllController.scala 135:35 AllToAllController.scala 151:24]
    node _GEN_62 = mux(_T_8, rd_address, _GEN_52) @[AllToAllController.scala 135:35 AllToAllController.scala 153:31]
    node _GEN_63 = mux(_T_8, _GEN_8, _GEN_53) @[AllToAllController.scala 135:35]
    node _GEN_64 = mux(_T_8, resp_signal, _GEN_54) @[AllToAllController.scala 135:35 AllToAllController.scala 66:28]
    node _GEN_65 = mux(_T_8, rd_address_action, _GEN_55) @[AllToAllController.scala 135:35 AllToAllController.scala 57:30]
    node _GEN_66 = mux(_T_5, UInt<1>("h0"), _GEN_56) @[AllToAllController.scala 107:23 AllToAllController.scala 109:23]
    node _GEN_67 = mux(_T_5, UInt<1>("h1"), _GEN_57) @[AllToAllController.scala 107:23 AllToAllController.scala 110:16]
    node _GEN_68 = mux(_T_5, io_processor_cmd_valid, _GEN_58) @[AllToAllController.scala 107:23 AllToAllController.scala 112:23]
    node _GEN_69 = mux(_T_5, UInt<1>("h0"), _GEN_61) @[AllToAllController.scala 107:23 AllToAllController.scala 119:24]
    node _GEN_70 = mux(_T_5, io_processor_cmd_bits_inst_rd, _GEN_62) @[AllToAllController.scala 107:23 AllToAllController.scala 121:31]
    node _GEN_71 = mux(_T_5, io_processor_cmd_bits_inst_rd, rd_address) @[AllToAllController.scala 107:23 AllToAllController.scala 123:16 AllToAllController.scala 59:23]
    node _GEN_72 = mux(_T_5, _GEN_4, _GEN_63) @[AllToAllController.scala 107:23]
    node _GEN_73 = mux(_T_5, resp_signal, _GEN_59) @[AllToAllController.scala 107:23 AllToAllController.scala 84:15]
    node _GEN_74 = mux(_T_5, io_mesh_resp_bits_data, _GEN_60) @[AllToAllController.scala 107:23 AllToAllController.scala 80:19]
    node _GEN_75 = mux(_T_5, resp_signal, _GEN_64) @[AllToAllController.scala 107:23 AllToAllController.scala 66:28]
    node _GEN_76 = mux(_T_5, rd_address_action, _GEN_65) @[AllToAllController.scala 107:23 AllToAllController.scala 57:30]
    io_processor_cmd_ready <= _GEN_67
    io_processor_resp_valid <= _GEN_73
    io_processor_resp_bits_rd <= _GEN_70
    io_processor_resp_bits_data <= _GEN_74
    io_processor_busy <= _GEN_66
    io_processor_interrupt <= UInt<1>("h0") @[AllToAllController.scala 72:26]
    io_mesh_cmd_valid <= _GEN_68
    io_mesh_cmd_bits_load <= _T_3 @[AllToAllController.scala 103:25]
    io_mesh_cmd_bits_store <= _T_4 @[AllToAllController.scala 104:26]
    io_mesh_cmd_bits_doAllToAll <= action_signal @[AllToAllController.scala 105:31]
    io_mesh_cmd_bits_rs1 <= io_processor_cmd_bits_rs1 @[AllToAllController.scala 75:24]
    io_mesh_cmd_bits_rs2 <= io_processor_cmd_bits_rs2 @[AllToAllController.scala 76:24]
    io_mesh_resp_ready <= _GEN_69
    state <= mux(reset, UInt<3>("h0"), _GEN_72) @[AllToAllController.scala 44:22 AllToAllController.scala 44:22]
    r <= _GEN_0
    rd_address_mem <= _GEN_1
    rd_address_mem_resp_stall <= rd_address_mem_resp_stall @[AllToAllController.scala 56:38]
    rd_address_action <= _GEN_76
    rd_address <= _GEN_71
    resp_signal <= mux(reset, UInt<1>("h0"), _GEN_75) @[AllToAllController.scala 66:28 AllToAllController.scala 66:28]

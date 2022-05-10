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
      reset => (UInt<1>("h0"), state) @[AllToAllController.scala 42:22]
    reg r : UInt<5>, clock with :
      reset => (UInt<1>("h0"), r) @[Reg.scala 15:16]
    node _GEN_0 = mux(UInt<1>("h1"), io_processor_cmd_bits_inst_rd, r) @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    reg rd_address_mem : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address_mem) @[Reg.scala 15:16]
    node _GEN_1 = mux(UInt<1>("h1"), r, rd_address_mem) @[Reg.scala 16:19 Reg.scala 16:23 Reg.scala 15:16]
    reg rd_address_mem_resp_stall : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address_mem_resp_stall) @[AllToAllController.scala 54:38]
    reg rd_address_action : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address_action) @[AllToAllController.scala 55:30]
    reg resp_signal : UInt<1>, clock with :
      reset => (UInt<1>("h0"), resp_signal) @[AllToAllController.scala 61:28]
    node _T = eq(io_processor_resp_ready, UInt<1>("h0")) @[AllToAllController.scala 63:20]
    node stall_resp = and(_T, resp_signal) @[AllToAllController.scala 63:33]
    node _T_1 = eq(io_processor_cmd_bits_inst_opcode, UInt<6>("h2b")) @[AllToAllController.scala 85:59]
    node goto_excange = and(io_processor_cmd_valid, _T_1) @[AllToAllController.scala 85:33]
    node goto_done_exchange = eq(io_mesh_busy, UInt<1>("h0")) @[AllToAllController.scala 86:28]
    node _T_2 = eq(io_processor_cmd_bits_inst_opcode, UInt<4>("hb")) @[AllToAllController.scala 89:54]
    node mem_cmd = and(io_processor_cmd_valid, _T_2) @[AllToAllController.scala 89:28]
    node loadSignal = eq(io_processor_cmd_bits_inst_funct, UInt<1>("h1")) @[AllToAllController.scala 91:41]
    node storeSignal = eq(io_processor_cmd_bits_inst_funct, UInt<2>("h2")) @[AllToAllController.scala 93:42]
    node _T_3 = and(mem_cmd, loadSignal) @[AllToAllController.scala 97:36]
    node _T_4 = and(mem_cmd, storeSignal) @[AllToAllController.scala 98:37]
    node _T_5 = eq(state, UInt<3>("h0")) @[AllToAllController.scala 103:14]
    node _T_6 = or(UInt<1>("h0"), stall_resp) @[AllToAllController.scala 105:34]
    node _T_7 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 106:29]
    node _T_8 = and(UInt<1>("h1"), _T_7) @[AllToAllController.scala 106:26]
    node _T_9 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 108:40]
    node _T_10 = and(io_processor_cmd_valid, _T_9) @[AllToAllController.scala 108:37]
    node _T_11 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 114:27]
    node _T_12 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 119:26]
    node _T_13 = and(goto_excange, _T_12) @[AllToAllController.scala 119:23]
    node _T_14 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 121:27]
    node _T_15 = and(mem_cmd, _T_14) @[AllToAllController.scala 121:24]
    node _GEN_2 = mux(stall_resp, UInt<3>("h5"), UInt<3>("h0")) @[AllToAllController.scala 123:27 AllToAllController.scala 124:13 AllToAllController.scala 126:13]
    node _GEN_3 = mux(_T_15, UInt<3>("h3"), _GEN_2) @[AllToAllController.scala 121:39 AllToAllController.scala 122:13]
    node _GEN_4 = mux(_T_13, UInt<3>("h1"), _GEN_3) @[AllToAllController.scala 119:38 AllToAllController.scala 120:13]
    node _T_16 = eq(state, UInt<3>("h3")) @[AllToAllController.scala 129:20]
    node _T_17 = or(UInt<1>("h0"), stall_resp) @[AllToAllController.scala 131:34]
    node _T_18 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 132:29]
    node _T_19 = and(UInt<1>("h1"), _T_18) @[AllToAllController.scala 132:26]
    node _T_20 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 134:40]
    node _T_21 = and(io_processor_cmd_valid, _T_20) @[AllToAllController.scala 134:37]
    node _T_22 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 141:27]
    node _T_23 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 154:26]
    node _T_24 = and(goto_excange, _T_23) @[AllToAllController.scala 154:23]
    node _T_25 = eq(stall_resp, UInt<1>("h0")) @[AllToAllController.scala 156:27]
    node _T_26 = and(mem_cmd, _T_25) @[AllToAllController.scala 156:24]
    node _GEN_5 = mux(_T_26, UInt<3>("h3"), _GEN_2) @[AllToAllController.scala 156:39 AllToAllController.scala 157:13]
    node _GEN_6 = mux(_T_24, UInt<3>("h1"), _GEN_5) @[AllToAllController.scala 154:38 AllToAllController.scala 155:13]
    node _T_27 = eq(state, UInt<3>("h5")) @[AllToAllController.scala 164:20]
    node _GEN_7 = mux(stall_resp, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllController.scala 177:21 AllToAllController.scala 179:19 AllToAllController.scala 184:19]
    node _T_28 = eq(state, UInt<3>("h1")) @[AllToAllController.scala 189:20]
    node _T_29 = eq(state, UInt<3>("h4")) @[AllToAllController.scala 205:20]
    node _GEN_8 = mux(goto_done_exchange, UInt<3>("h2"), UInt<3>("h4")) @[AllToAllController.scala 215:29 AllToAllController.scala 216:13 AllToAllController.scala 218:13]
    node _T_30 = eq(state, UInt<3>("h2")) @[AllToAllController.scala 221:20]
    node _GEN_9 = mux(_T_30, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllController.scala 221:36 AllToAllController.scala 223:23 AllToAllController.scala 236:23]
    node _GEN_10 = mux(_T_30, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllController.scala 221:36 AllToAllController.scala 224:16 AllToAllController.scala 237:16]
    node _GEN_11 = mux(_T_30, rd_address_action, rd_address_mem) @[AllToAllController.scala 221:36 AllToAllController.scala 230:31 AllToAllController.scala 242:31]
    node _GEN_12 = mux(_T_30, UInt<3>("h0"), UInt<3>("h0")) @[AllToAllController.scala 221:36 AllToAllController.scala 232:11 AllToAllController.scala 244:11]
    node _GEN_13 = mux(_T_29, UInt<1>("h1"), _GEN_9) @[AllToAllController.scala 205:41 AllToAllController.scala 207:23]
    node _GEN_14 = mux(_T_29, UInt<1>("h0"), _GEN_10) @[AllToAllController.scala 205:41 AllToAllController.scala 208:16]
    node _GEN_15 = mux(_T_29, UInt<1>("h0"), _GEN_9) @[AllToAllController.scala 205:41 AllToAllController.scala 211:24]
    node _GEN_16 = mux(_T_29, rd_address_action, _GEN_11) @[AllToAllController.scala 205:41 AllToAllController.scala 213:31]
    node _GEN_17 = mux(_T_29, _GEN_8, _GEN_12) @[AllToAllController.scala 205:41]
    node _GEN_18 = mux(_T_28, UInt<1>("h1"), _GEN_13) @[AllToAllController.scala 189:31 AllToAllController.scala 191:23]
    node _GEN_19 = mux(_T_28, UInt<1>("h0"), _GEN_14) @[AllToAllController.scala 189:31 AllToAllController.scala 192:16]
    node _GEN_20 = mux(_T_28, UInt<1>("h0"), resp_signal) @[AllToAllController.scala 189:31 AllToAllController.scala 194:17 AllToAllController.scala 61:28]
    node _GEN_21 = mux(_T_28, io_processor_cmd_bits_inst_rd, rd_address_action) @[AllToAllController.scala 189:31 AllToAllController.scala 196:23 AllToAllController.scala 55:30]
    node _GEN_22 = mux(_T_28, resp_signal, _GEN_15) @[AllToAllController.scala 189:31 AllToAllController.scala 199:24]
    node _GEN_23 = mux(_T_28, rd_address_mem, _GEN_16) @[AllToAllController.scala 189:31 AllToAllController.scala 201:31]
    node _GEN_24 = mux(_T_28, UInt<3>("h4"), _GEN_17) @[AllToAllController.scala 189:31 AllToAllController.scala 203:11]
    node _GEN_25 = mux(_T_27, UInt<1>("h1"), _GEN_18) @[AllToAllController.scala 164:36 AllToAllController.scala 168:23]
    node _GEN_26 = mux(_T_27, UInt<1>("h0"), _GEN_19) @[AllToAllController.scala 164:36 AllToAllController.scala 169:16]
    node _GEN_27 = mux(_T_27, UInt<1>("h0"), io_processor_cmd_valid) @[AllToAllController.scala 164:36 AllToAllController.scala 170:23 AllToAllController.scala 96:21]
    node _GEN_28 = mux(_T_27, io_processor_resp_ready, _GEN_22) @[AllToAllController.scala 164:36 AllToAllController.scala 173:24]
    node _GEN_29 = mux(_T_27, rd_address_mem_resp_stall, _GEN_23) @[AllToAllController.scala 164:36 AllToAllController.scala 175:31]
    node _GEN_30 = mux(_T_27, _GEN_7, _GEN_20) @[AllToAllController.scala 164:36]
    node _GEN_31 = mux(_T_27, _GEN_2, _GEN_24) @[AllToAllController.scala 164:36]
    node _GEN_32 = mux(_T_27, rd_address_action, _GEN_21) @[AllToAllController.scala 164:36 AllToAllController.scala 55:30]
    node _GEN_33 = mux(_T_16, _T_17, _GEN_25) @[AllToAllController.scala 129:38 AllToAllController.scala 131:23]
    node _GEN_34 = mux(_T_16, _T_19, _GEN_26) @[AllToAllController.scala 129:38 AllToAllController.scala 132:16]
    node _GEN_35 = mux(_T_16, _T_21, _GEN_27) @[AllToAllController.scala 129:38 AllToAllController.scala 134:23]
    node _GEN_36 = mux(_T_16, UInt<1>("h1"), _GEN_30) @[AllToAllController.scala 129:38 AllToAllController.scala 138:17]
    node _GEN_37 = mux(_T_16, _T_22, _GEN_28) @[AllToAllController.scala 129:38 AllToAllController.scala 141:24]
    node _GEN_38 = mux(_T_16, rd_address_mem, _GEN_29) @[AllToAllController.scala 129:38 AllToAllController.scala 143:31]
    node _GEN_39 = mux(_T_16, rd_address_mem, rd_address_mem_resp_stall) @[AllToAllController.scala 129:38 AllToAllController.scala 144:31 AllToAllController.scala 54:38]
    node _GEN_40 = mux(_T_16, _GEN_6, _GEN_31) @[AllToAllController.scala 129:38]
    node _GEN_41 = mux(_T_16, rd_address_action, _GEN_32) @[AllToAllController.scala 129:38 AllToAllController.scala 55:30]
    node _GEN_42 = mux(_T_5, _T_6, _GEN_33) @[AllToAllController.scala 103:23 AllToAllController.scala 105:23]
    node _GEN_43 = mux(_T_5, _T_8, _GEN_34) @[AllToAllController.scala 103:23 AllToAllController.scala 106:16]
    node _GEN_44 = mux(_T_5, _T_10, _GEN_35) @[AllToAllController.scala 103:23 AllToAllController.scala 108:23]
    node _GEN_45 = mux(_T_5, UInt<1>("h0"), _GEN_36) @[AllToAllController.scala 103:23 AllToAllController.scala 111:17]
    node _GEN_46 = mux(_T_5, _T_11, _GEN_37) @[AllToAllController.scala 103:23 AllToAllController.scala 114:24]
    node _GEN_47 = mux(_T_5, rd_address_mem, _GEN_38) @[AllToAllController.scala 103:23 AllToAllController.scala 116:31]
    node _GEN_48 = mux(_T_5, rd_address_mem, _GEN_39) @[AllToAllController.scala 103:23 AllToAllController.scala 117:31]
    node _GEN_49 = mux(_T_5, _GEN_4, _GEN_40) @[AllToAllController.scala 103:23]
    node _GEN_50 = mux(_T_5, rd_address_action, _GEN_41) @[AllToAllController.scala 103:23 AllToAllController.scala 55:30]
    io_processor_cmd_ready <= _GEN_43
    io_processor_resp_valid <= resp_signal @[AllToAllController.scala 78:15]
    io_processor_resp_bits_rd <= _GEN_47
    io_processor_resp_bits_data <= io_mesh_resp_bits_data @[AllToAllController.scala 74:19]
    io_processor_busy <= _GEN_42
    io_processor_interrupt <= UInt<1>("h0") @[AllToAllController.scala 67:26]
    io_mesh_cmd_valid <= _GEN_44
    io_mesh_cmd_bits_load <= _T_3 @[AllToAllController.scala 97:25]
    io_mesh_cmd_bits_store <= _T_4 @[AllToAllController.scala 98:26]
    io_mesh_cmd_bits_doAllToAll <= goto_excange @[AllToAllController.scala 99:31]
    io_mesh_cmd_bits_rs1 <= io_processor_cmd_bits_rs1 @[AllToAllController.scala 70:24]
    io_mesh_cmd_bits_rs2 <= io_processor_cmd_bits_rs2 @[AllToAllController.scala 71:24]
    io_mesh_resp_ready <= _GEN_46
    state <= mux(reset, UInt<3>("h0"), _GEN_49) @[AllToAllController.scala 42:22 AllToAllController.scala 42:22]
    r <= _GEN_0
    rd_address_mem <= _GEN_1
    rd_address_mem_resp_stall <= _GEN_48
    rd_address_action <= _GEN_50
    resp_signal <= mux(reset, UInt<1>("h0"), _GEN_45) @[AllToAllController.scala 61:28 AllToAllController.scala 61:28]

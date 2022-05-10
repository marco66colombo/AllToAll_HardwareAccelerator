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
    reg rd_address_action : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address_action) @[AllToAllController.scala 54:30]
    reg resp_signal : UInt<1>, clock with :
      reset => (UInt<1>("h0"), resp_signal) @[AllToAllController.scala 60:28]
    node _T = eq(io_processor_cmd_bits_inst_opcode, UInt<6>("h2b")) @[AllToAllController.scala 81:59]
    node goto_excange = and(io_processor_cmd_valid, _T) @[AllToAllController.scala 81:33]
    node goto_done_exchange = eq(io_mesh_busy, UInt<1>("h0")) @[AllToAllController.scala 82:28]
    node _T_1 = eq(io_processor_cmd_bits_inst_opcode, UInt<4>("hb")) @[AllToAllController.scala 85:54]
    node mem_cmd = and(io_processor_cmd_valid, _T_1) @[AllToAllController.scala 85:28]
    node loadSignal = eq(io_processor_cmd_bits_inst_funct, UInt<1>("h1")) @[AllToAllController.scala 87:41]
    node storeSignal = eq(io_processor_cmd_bits_inst_funct, UInt<2>("h2")) @[AllToAllController.scala 89:42]
    node _T_2 = and(mem_cmd, loadSignal) @[AllToAllController.scala 93:36]
    node _T_3 = and(mem_cmd, storeSignal) @[AllToAllController.scala 94:37]
    node _T_4 = eq(state, UInt<3>("h0")) @[AllToAllController.scala 99:14]
    node _GEN_2 = mux(mem_cmd, UInt<3>("h3"), UInt<3>("h0")) @[AllToAllController.scala 113:24 AllToAllController.scala 114:13 AllToAllController.scala 116:13]
    node _GEN_3 = mux(goto_excange, UInt<3>("h1"), _GEN_2) @[AllToAllController.scala 111:23 AllToAllController.scala 112:13]
    node _T_5 = eq(state, UInt<3>("h3")) @[AllToAllController.scala 119:20]
    node _T_6 = eq(state, UInt<3>("h1")) @[AllToAllController.scala 139:20]
    node _T_7 = eq(state, UInt<3>("h4")) @[AllToAllController.scala 155:20]
    node _GEN_4 = mux(goto_done_exchange, UInt<3>("h2"), UInt<3>("h4")) @[AllToAllController.scala 165:29 AllToAllController.scala 166:13 AllToAllController.scala 168:13]
    node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllController.scala 171:20]
    node _GEN_5 = mux(_T_8, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllController.scala 171:36 AllToAllController.scala 173:23 AllToAllController.scala 186:23]
    node _GEN_6 = mux(_T_8, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllController.scala 171:36 AllToAllController.scala 174:16 AllToAllController.scala 187:16]
    node _GEN_7 = mux(_T_8, rd_address_action, rd_address_mem) @[AllToAllController.scala 171:36 AllToAllController.scala 180:31 AllToAllController.scala 192:31]
    node _GEN_8 = mux(_T_8, UInt<3>("h0"), UInt<3>("h0")) @[AllToAllController.scala 171:36 AllToAllController.scala 182:11 AllToAllController.scala 194:11]
    node _GEN_9 = mux(_T_7, UInt<1>("h1"), _GEN_5) @[AllToAllController.scala 155:41 AllToAllController.scala 157:23]
    node _GEN_10 = mux(_T_7, UInt<1>("h0"), _GEN_6) @[AllToAllController.scala 155:41 AllToAllController.scala 158:16]
    node _GEN_11 = mux(_T_7, UInt<1>("h0"), _GEN_5) @[AllToAllController.scala 155:41 AllToAllController.scala 161:24]
    node _GEN_12 = mux(_T_7, rd_address_action, _GEN_7) @[AllToAllController.scala 155:41 AllToAllController.scala 163:31]
    node _GEN_13 = mux(_T_7, _GEN_4, _GEN_8) @[AllToAllController.scala 155:41]
    node _GEN_14 = mux(_T_6, UInt<1>("h1"), _GEN_9) @[AllToAllController.scala 139:31 AllToAllController.scala 141:23]
    node _GEN_15 = mux(_T_6, UInt<1>("h0"), _GEN_10) @[AllToAllController.scala 139:31 AllToAllController.scala 142:16]
    node _GEN_16 = mux(_T_6, UInt<1>("h0"), resp_signal) @[AllToAllController.scala 139:31 AllToAllController.scala 144:17 AllToAllController.scala 60:28]
    node _GEN_17 = mux(_T_6, io_processor_cmd_bits_inst_rd, rd_address_action) @[AllToAllController.scala 139:31 AllToAllController.scala 146:23 AllToAllController.scala 54:30]
    node _GEN_18 = mux(_T_6, resp_signal, _GEN_11) @[AllToAllController.scala 139:31 AllToAllController.scala 149:24]
    node _GEN_19 = mux(_T_6, rd_address_mem, _GEN_12) @[AllToAllController.scala 139:31 AllToAllController.scala 151:31]
    node _GEN_20 = mux(_T_6, UInt<3>("h4"), _GEN_13) @[AllToAllController.scala 139:31 AllToAllController.scala 153:11]
    node _GEN_21 = mux(_T_5, UInt<1>("h0"), _GEN_14) @[AllToAllController.scala 119:38 AllToAllController.scala 121:23]
    node _GEN_22 = mux(_T_5, UInt<1>("h1"), _GEN_15) @[AllToAllController.scala 119:38 AllToAllController.scala 122:16]
    node _GEN_23 = mux(_T_5, UInt<1>("h1"), _GEN_16) @[AllToAllController.scala 119:38 AllToAllController.scala 124:17]
    node _GEN_24 = mux(_T_5, resp_signal, _GEN_18) @[AllToAllController.scala 119:38 AllToAllController.scala 127:24]
    node _GEN_25 = mux(_T_5, rd_address_mem, _GEN_19) @[AllToAllController.scala 119:38 AllToAllController.scala 129:31]
    node _GEN_26 = mux(_T_5, _GEN_3, _GEN_20) @[AllToAllController.scala 119:38]
    node _GEN_27 = mux(_T_5, rd_address_action, _GEN_17) @[AllToAllController.scala 119:38 AllToAllController.scala 54:30]
    node _GEN_28 = mux(_T_4, UInt<1>("h0"), _GEN_21) @[AllToAllController.scala 99:23 AllToAllController.scala 101:23]
    node _GEN_29 = mux(_T_4, UInt<1>("h1"), _GEN_22) @[AllToAllController.scala 99:23 AllToAllController.scala 102:16]
    node _GEN_30 = mux(_T_4, UInt<1>("h0"), _GEN_23) @[AllToAllController.scala 99:23 AllToAllController.scala 104:17]
    node _GEN_31 = mux(_T_4, resp_signal, _GEN_24) @[AllToAllController.scala 99:23 AllToAllController.scala 107:24]
    node _GEN_32 = mux(_T_4, rd_address_mem, _GEN_25) @[AllToAllController.scala 99:23 AllToAllController.scala 109:31]
    node _GEN_33 = mux(_T_4, _GEN_3, _GEN_26) @[AllToAllController.scala 99:23]
    node _GEN_34 = mux(_T_4, rd_address_action, _GEN_27) @[AllToAllController.scala 99:23 AllToAllController.scala 54:30]
    io_processor_cmd_ready <= _GEN_29
    io_processor_resp_valid <= io_mesh_resp_ready @[AllToAllController.scala 74:15]
    io_processor_resp_bits_rd <= _GEN_32
    io_processor_resp_bits_data <= io_mesh_resp_bits_data @[AllToAllController.scala 71:19]
    io_processor_busy <= _GEN_28
    io_processor_interrupt <= UInt<1>("h0") @[AllToAllController.scala 64:26]
    io_mesh_cmd_valid <= io_processor_cmd_valid @[AllToAllController.scala 92:21]
    io_mesh_cmd_bits_load <= _T_2 @[AllToAllController.scala 93:25]
    io_mesh_cmd_bits_store <= _T_3 @[AllToAllController.scala 94:26]
    io_mesh_cmd_bits_doAllToAll <= goto_excange @[AllToAllController.scala 95:31]
    io_mesh_cmd_bits_rs1 <= io_processor_cmd_bits_rs1 @[AllToAllController.scala 67:24]
    io_mesh_cmd_bits_rs2 <= io_processor_cmd_bits_rs2 @[AllToAllController.scala 68:24]
    io_mesh_resp_ready <= _GEN_31
    state <= mux(reset, UInt<3>("h0"), _GEN_33) @[AllToAllController.scala 42:22 AllToAllController.scala 42:22]
    r <= _GEN_0
    rd_address_mem <= _GEN_1
    rd_address_action <= _GEN_34
    resp_signal <= mux(reset, UInt<1>("h0"), _GEN_30) @[AllToAllController.scala 60:28 AllToAllController.scala 60:28]

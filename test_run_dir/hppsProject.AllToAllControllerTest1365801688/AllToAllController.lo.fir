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
    reg rd_address_cmd : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address_cmd) @[AllToAllController.scala 49:27]
    reg rd_address_resp : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address_resp) @[AllToAllController.scala 51:28]
    reg resp_signal : UInt<1>, clock with :
      reset => (UInt<1>("h0"), resp_signal) @[AllToAllController.scala 57:28]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllController.scala 60:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllController.scala 61:16]
    node _T = eq(io_processor_cmd_bits_inst_opcode, UInt<6>("h2b")) @[AllToAllController.scala 88:59]
    node goto_excange = and(io_processor_cmd_valid, _T) @[AllToAllController.scala 88:33]
    node goto_done_exchange = eq(io_mesh_busy, UInt<1>("h0")) @[AllToAllController.scala 89:28]
    node _T_1 = eq(io_processor_cmd_bits_inst_opcode, UInt<4>("hb")) @[AllToAllController.scala 92:54]
    node mem_cmd = and(io_processor_cmd_valid, _T_1) @[AllToAllController.scala 92:28]
    node loadSignal = eq(io_processor_cmd_bits_inst_funct, UInt<1>("h1")) @[AllToAllController.scala 94:41]
    node storeSignal = eq(io_processor_cmd_bits_inst_funct, UInt<2>("h2")) @[AllToAllController.scala 96:42]
    node _T_2 = and(mem_cmd, loadSignal) @[AllToAllController.scala 100:36]
    node _T_3 = and(mem_cmd, storeSignal) @[AllToAllController.scala 101:37]
    node _T_4 = eq(state, UInt<3>("h0")) @[AllToAllController.scala 106:14]
    node _GEN_0 = mux(mem_cmd, UInt<3>("h3"), UInt<3>("h0")) @[AllToAllController.scala 125:24 AllToAllController.scala 126:13 AllToAllController.scala 128:13]
    node _GEN_1 = mux(goto_excange, UInt<3>("h1"), _GEN_0) @[AllToAllController.scala 123:23 AllToAllController.scala 124:13]
    node _T_5 = eq(state, UInt<3>("h3")) @[AllToAllController.scala 131:20]
    node _T_6 = eq(state, UInt<3>("h1")) @[AllToAllController.scala 168:20]
    node _T_7 = eq(state, UInt<3>("h4")) @[AllToAllController.scala 187:20]
    node _GEN_2 = mux(goto_done_exchange, UInt<3>("h2"), UInt<3>("h4")) @[AllToAllController.scala 202:29 AllToAllController.scala 203:13 AllToAllController.scala 205:13]
    node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllController.scala 208:20]
    node _GEN_3 = mux(_T_8, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllController.scala 208:36 AllToAllController.scala 210:23 AllToAllController.scala 225:23]
    node _GEN_4 = mux(_T_8, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllController.scala 208:36 AllToAllController.scala 211:16 AllToAllController.scala 226:16]
    node _GEN_5 = mux(_T_8, UInt<3>("h0"), UInt<3>("h0")) @[AllToAllController.scala 208:36 AllToAllController.scala 221:11 AllToAllController.scala 234:11]
    node _GEN_6 = mux(_T_7, UInt<1>("h1"), _GEN_3) @[AllToAllController.scala 187:41 AllToAllController.scala 189:23]
    node _GEN_7 = mux(_T_7, UInt<1>("h0"), _GEN_4) @[AllToAllController.scala 187:41 AllToAllController.scala 190:16]
    node _GEN_8 = mux(_T_7, rd_address_cmd, rd_address_resp) @[AllToAllController.scala 187:41 AllToAllController.scala 193:21 AllToAllController.scala 51:28]
    node _GEN_9 = mux(_T_7, UInt<1>("h0"), _GEN_3) @[AllToAllController.scala 187:41 AllToAllController.scala 199:24]
    node _GEN_10 = mux(_T_7, _GEN_2, _GEN_5) @[AllToAllController.scala 187:41]
    node _GEN_11 = mux(_T_6, UInt<1>("h1"), _GEN_6) @[AllToAllController.scala 168:31 AllToAllController.scala 170:23]
    node _GEN_12 = mux(_T_6, UInt<1>("h0"), _GEN_7) @[AllToAllController.scala 168:31 AllToAllController.scala 171:16]
    node _GEN_13 = mux(_T_6, UInt<1>("h0"), resp_signal) @[AllToAllController.scala 168:31 AllToAllController.scala 173:17 AllToAllController.scala 57:28]
    node _GEN_14 = mux(_T_6, io_processor_cmd_bits_inst_rd, rd_address_cmd) @[AllToAllController.scala 168:31 AllToAllController.scala 176:20 AllToAllController.scala 49:27]
    node _GEN_15 = mux(_T_6, resp_signal, _GEN_9) @[AllToAllController.scala 168:31 AllToAllController.scala 182:24]
    node _GEN_16 = mux(_T_6, UInt<3>("h4"), _GEN_10) @[AllToAllController.scala 168:31 AllToAllController.scala 185:11]
    node _GEN_17 = mux(_T_6, rd_address_resp, _GEN_8) @[AllToAllController.scala 168:31 AllToAllController.scala 51:28]
    node _GEN_18 = mux(_T_5, UInt<1>("h0"), _GEN_11) @[AllToAllController.scala 131:38 AllToAllController.scala 133:23]
    node _GEN_19 = mux(_T_5, UInt<1>("h1"), _GEN_12) @[AllToAllController.scala 131:38 AllToAllController.scala 134:16]
    node _GEN_20 = mux(_T_5, UInt<1>("h1"), _GEN_13) @[AllToAllController.scala 131:38 AllToAllController.scala 136:17]
    node _GEN_21 = mux(_T_5, io_processor_cmd_bits_inst_rd, _GEN_14) @[AllToAllController.scala 131:38 AllToAllController.scala 139:20]
    node _GEN_22 = mux(_T_5, rd_address_cmd, _GEN_17) @[AllToAllController.scala 131:38 AllToAllController.scala 141:21]
    node _GEN_23 = mux(_T_5, resp_signal, _GEN_15) @[AllToAllController.scala 131:38 AllToAllController.scala 145:24]
    node _GEN_24 = mux(_T_5, _GEN_1, _GEN_16) @[AllToAllController.scala 131:38]
    node _GEN_25 = mux(_T_4, UInt<1>("h0"), _GEN_18) @[AllToAllController.scala 106:23 AllToAllController.scala 108:23]
    node _GEN_26 = mux(_T_4, UInt<1>("h1"), _GEN_19) @[AllToAllController.scala 106:23 AllToAllController.scala 109:16]
    node _GEN_27 = mux(_T_4, UInt<1>("h0"), _GEN_20) @[AllToAllController.scala 106:23 AllToAllController.scala 111:17]
    node _GEN_28 = mux(_T_4, UInt<1>("h0"), _GEN_21) @[AllToAllController.scala 106:23 AllToAllController.scala 113:20]
    node _GEN_29 = mux(_T_4, rd_address_cmd, _GEN_22) @[AllToAllController.scala 106:23 AllToAllController.scala 114:21]
    node _GEN_30 = mux(_T_4, resp_signal, _GEN_23) @[AllToAllController.scala 106:23 AllToAllController.scala 120:24]
    node _GEN_31 = mux(_T_4, _GEN_1, _GEN_24) @[AllToAllController.scala 106:23]
    io_processor_cmd_ready <= _GEN_26
    io_processor_resp_valid <= io_mesh_resp_ready @[AllToAllController.scala 81:15]
    io_processor_resp_bits_rd <= rd_address_resp @[AllToAllController.scala 54:29]
    io_processor_resp_bits_data <= io_mesh_resp_bits_data @[AllToAllController.scala 78:19]
    io_processor_busy <= _GEN_25
    io_processor_interrupt <= UInt<1>("h0") @[AllToAllController.scala 68:26]
    io_mesh_cmd_valid <= io_processor_cmd_valid @[AllToAllController.scala 99:21]
    io_mesh_cmd_bits_load <= _T_2 @[AllToAllController.scala 100:25]
    io_mesh_cmd_bits_store <= _T_3 @[AllToAllController.scala 101:26]
    io_mesh_cmd_bits_doAllToAll <= goto_excange @[AllToAllController.scala 102:31]
    io_mesh_cmd_bits_rs1 <= rs1 @[AllToAllController.scala 74:24]
    io_mesh_cmd_bits_rs2 <= rs2 @[AllToAllController.scala 75:24]
    io_mesh_resp_ready <= _GEN_30
    state <= mux(reset, UInt<3>("h0"), _GEN_31) @[AllToAllController.scala 42:22 AllToAllController.scala 42:22]
    rd_address_cmd <= _GEN_28
    rd_address_resp <= _GEN_29
    resp_signal <= mux(reset, UInt<1>("h0"), _GEN_27) @[AllToAllController.scala 57:28 AllToAllController.scala 57:28]
    rs1 <= io_processor_cmd_bits_rs1 @[AllToAllController.scala 63:7]
    rs2 <= io_processor_cmd_bits_rs2 @[AllToAllController.scala 64:7]

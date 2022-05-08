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
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllController.scala 99:14]
    node _GEN_0 = mux(mem_cmd, UInt<3>("h3"), UInt<3>("h0")) @[AllToAllController.scala 117:24 AllToAllController.scala 118:13 AllToAllController.scala 120:13]
    node _GEN_1 = mux(goto_excange, UInt<3>("h1"), _GEN_0) @[AllToAllController.scala 115:23 AllToAllController.scala 116:13]
    node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllController.scala 123:20]
    node _GEN_2 = mux(storeSignal, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllController.scala 143:28 AllToAllController.scala 144:29 AllToAllController.scala 147:29]
    node _GEN_3 = mux(storeSignal, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllController.scala 143:28 AllToAllController.scala 145:30 AllToAllController.scala 148:30]
    node _GEN_4 = mux(loadSignal, UInt<1>("h1"), _GEN_2) @[AllToAllController.scala 140:21 AllToAllController.scala 141:29]
    node _GEN_5 = mux(loadSignal, UInt<1>("h0"), _GEN_3) @[AllToAllController.scala 140:21 AllToAllController.scala 142:30]
    node _T_4 = eq(state, UInt<3>("h1")) @[AllToAllController.scala 159:20]
    node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllController.scala 178:20]
    node _GEN_6 = mux(goto_done_exchange, UInt<3>("h2"), UInt<3>("h4")) @[AllToAllController.scala 193:29 AllToAllController.scala 194:13 AllToAllController.scala 196:13]
    node _T_6 = eq(state, UInt<3>("h2")) @[AllToAllController.scala 199:20]
    node _GEN_7 = mux(_T_6, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllController.scala 199:36 AllToAllController.scala 201:23 AllToAllController.scala 216:23]
    node _GEN_8 = mux(_T_6, UInt<1>("h0"), UInt<1>("h0")) @[AllToAllController.scala 199:36 AllToAllController.scala 202:16 AllToAllController.scala 217:16]
    node _GEN_9 = mux(_T_6, UInt<3>("h0"), UInt<3>("h0")) @[AllToAllController.scala 199:36 AllToAllController.scala 212:11 AllToAllController.scala 225:11]
    node _GEN_10 = mux(_T_5, UInt<1>("h1"), _GEN_7) @[AllToAllController.scala 178:41 AllToAllController.scala 180:23]
    node _GEN_11 = mux(_T_5, UInt<1>("h0"), _GEN_8) @[AllToAllController.scala 178:41 AllToAllController.scala 181:16]
    node _GEN_12 = mux(_T_5, rd_address_cmd, rd_address_resp) @[AllToAllController.scala 178:41 AllToAllController.scala 184:21 AllToAllController.scala 51:28]
    node _GEN_13 = mux(_T_5, UInt<1>("h0"), _GEN_7) @[AllToAllController.scala 178:41 AllToAllController.scala 190:24]
    node _GEN_14 = mux(_T_5, _GEN_6, _GEN_9) @[AllToAllController.scala 178:41]
    node _GEN_15 = mux(_T_4, UInt<1>("h1"), _GEN_10) @[AllToAllController.scala 159:31 AllToAllController.scala 161:23]
    node _GEN_16 = mux(_T_4, UInt<1>("h0"), _GEN_11) @[AllToAllController.scala 159:31 AllToAllController.scala 162:16]
    node _GEN_17 = mux(_T_4, UInt<1>("h0"), resp_signal) @[AllToAllController.scala 159:31 AllToAllController.scala 164:17 AllToAllController.scala 57:28]
    node _GEN_18 = mux(_T_4, io_processor_cmd_bits_inst_rd, rd_address_cmd) @[AllToAllController.scala 159:31 AllToAllController.scala 167:20 AllToAllController.scala 49:27]
    node _GEN_19 = mux(_T_4, UInt<1>("h1"), _GEN_11) @[AllToAllController.scala 159:31 AllToAllController.scala 172:33]
    node _GEN_20 = mux(_T_4, resp_signal, _GEN_13) @[AllToAllController.scala 159:31 AllToAllController.scala 173:24]
    node _GEN_21 = mux(_T_4, UInt<3>("h4"), _GEN_14) @[AllToAllController.scala 159:31 AllToAllController.scala 176:11]
    node _GEN_22 = mux(_T_4, rd_address_resp, _GEN_12) @[AllToAllController.scala 159:31 AllToAllController.scala 51:28]
    node _GEN_23 = mux(_T_3, UInt<1>("h0"), _GEN_15) @[AllToAllController.scala 123:38 AllToAllController.scala 125:23]
    node _GEN_24 = mux(_T_3, UInt<1>("h1"), _GEN_16) @[AllToAllController.scala 123:38 AllToAllController.scala 126:16]
    node _GEN_25 = mux(_T_3, UInt<1>("h1"), _GEN_17) @[AllToAllController.scala 123:38 AllToAllController.scala 128:17]
    node _GEN_26 = mux(_T_3, io_processor_cmd_bits_inst_rd, _GEN_18) @[AllToAllController.scala 123:38 AllToAllController.scala 131:20]
    node _GEN_27 = mux(_T_3, rd_address_cmd, _GEN_22) @[AllToAllController.scala 123:38 AllToAllController.scala 133:21]
    node _GEN_28 = mux(_T_3, UInt<1>("h0"), _GEN_19) @[AllToAllController.scala 123:38 AllToAllController.scala 136:33]
    node _GEN_29 = mux(_T_3, resp_signal, _GEN_20) @[AllToAllController.scala 123:38 AllToAllController.scala 137:24]
    node _GEN_30 = mux(_T_3, _GEN_4, _GEN_16) @[AllToAllController.scala 123:38]
    node _GEN_31 = mux(_T_3, _GEN_5, _GEN_16) @[AllToAllController.scala 123:38]
    node _GEN_32 = mux(_T_3, _GEN_1, _GEN_21) @[AllToAllController.scala 123:38]
    node _GEN_33 = mux(_T_2, UInt<1>("h0"), _GEN_23) @[AllToAllController.scala 99:23 AllToAllController.scala 101:23]
    node _GEN_34 = mux(_T_2, UInt<1>("h1"), _GEN_24) @[AllToAllController.scala 99:23 AllToAllController.scala 102:16]
    node _GEN_35 = mux(_T_2, UInt<1>("h0"), _GEN_25) @[AllToAllController.scala 99:23 AllToAllController.scala 104:17]
    node _GEN_36 = mux(_T_2, io_processor_cmd_bits_inst_rd, _GEN_26) @[AllToAllController.scala 99:23 AllToAllController.scala 106:20]
    node _GEN_37 = mux(_T_2, UInt<1>("h0"), _GEN_30) @[AllToAllController.scala 99:23 AllToAllController.scala 109:27]
    node _GEN_38 = mux(_T_2, UInt<1>("h0"), _GEN_31) @[AllToAllController.scala 99:23 AllToAllController.scala 110:28]
    node _GEN_39 = mux(_T_2, UInt<1>("h0"), _GEN_28) @[AllToAllController.scala 99:23 AllToAllController.scala 111:33]
    node _GEN_40 = mux(_T_2, resp_signal, _GEN_29) @[AllToAllController.scala 99:23 AllToAllController.scala 112:24]
    node _GEN_41 = mux(_T_2, _GEN_1, _GEN_32) @[AllToAllController.scala 99:23]
    node _GEN_42 = mux(_T_2, rd_address_resp, _GEN_27) @[AllToAllController.scala 99:23 AllToAllController.scala 51:28]
    io_processor_cmd_ready <= _GEN_34
    io_processor_resp_valid <= io_mesh_resp_ready @[AllToAllController.scala 81:15]
    io_processor_resp_bits_rd <= rd_address_resp @[AllToAllController.scala 54:29]
    io_processor_resp_bits_data <= io_mesh_resp_bits_data @[AllToAllController.scala 78:19]
    io_processor_busy <= _GEN_33
    io_processor_interrupt <= UInt<1>("h0") @[AllToAllController.scala 68:26]
    io_mesh_cmd_valid <= io_processor_cmd_valid @[AllToAllController.scala 71:21]
    io_mesh_cmd_bits_load <= _GEN_37
    io_mesh_cmd_bits_store <= _GEN_38
    io_mesh_cmd_bits_doAllToAll <= _GEN_39
    io_mesh_cmd_bits_rs1 <= rs1 @[AllToAllController.scala 74:24]
    io_mesh_cmd_bits_rs2 <= rs2 @[AllToAllController.scala 75:24]
    io_mesh_resp_ready <= _GEN_40
    state <= mux(reset, UInt<3>("h0"), _GEN_41) @[AllToAllController.scala 42:22 AllToAllController.scala 42:22]
    rd_address_cmd <= _GEN_36
    rd_address_resp <= _GEN_42
    resp_signal <= mux(reset, UInt<1>("h0"), _GEN_35) @[AllToAllController.scala 57:28 AllToAllController.scala 57:28]
    rs1 <= io_processor_cmd_bits_rs1 @[AllToAllController.scala 63:7]
    rs2 <= io_processor_cmd_bits_rs2 @[AllToAllController.scala 64:7]

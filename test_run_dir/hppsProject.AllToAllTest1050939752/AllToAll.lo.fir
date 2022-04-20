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

    reg state : UInt<2>, clock with :
      reset => (UInt<1>("h0"), state) @[AllToAllController.scala 41:22]
    reg rd_address : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address) @[AllToAllController.scala 42:23]
    node _T = eq(state, UInt<2>("h0")) @[AllToAllController.scala 49:43]
    node _T_1 = mux(_T, io_processor_cmd_bits_inst_rd, rd_address) @[AllToAllController.scala 49:35]
    node _T_2 = eq(state, UInt<2>("h0")) @[AllToAllController.scala 51:14]
    node _GEN_0 = mux(_T_2, io_processor_cmd_bits_inst_rd, rd_address) @[AllToAllController.scala 51:23 AllToAllController.scala 52:16 AllToAllController.scala 42:23]
    node _T_3 = eq(state, UInt<2>("h0")) @[AllToAllController.scala 55:36]
    node _T_4 = eq(state, UInt<2>("h0")) @[AllToAllController.scala 68:14]
    node _GEN_1 = mux(io_processor_cmd_valid, UInt<2>("h1"), UInt<2>("h0")) @[AllToAllController.scala 76:23 AllToAllController.scala 77:13 AllToAllController.scala 79:13]
    node _T_5 = eq(state, UInt<2>("h1")) @[AllToAllController.scala 81:20]
    node _GEN_2 = mux(UInt<1>("h1"), UInt<2>("h2"), UInt<2>("h1")) @[AllToAllController.scala 89:29 AllToAllController.scala 90:15 AllToAllController.scala 92:15]
    node _T_6 = eq(state, UInt<2>("h2")) @[AllToAllController.scala 94:20]
    node _GEN_3 = mux(_T_6, UInt<1>("h1"), UInt<1>("h0")) @[AllToAllController.scala 94:38 AllToAllController.scala 96:23 AllToAllController.scala 108:23]
    node _GEN_4 = mux(_T_6, UInt<1>("h0"), UInt<1>("h1")) @[AllToAllController.scala 94:38 AllToAllController.scala 98:16 AllToAllController.scala 109:16]
    node _GEN_5 = mux(_T_6, UInt<2>("h0"), UInt<2>("h0")) @[AllToAllController.scala 94:38 AllToAllController.scala 103:11 AllToAllController.scala 111:11]
    node _GEN_6 = mux(_T_5, UInt<1>("h1"), _GEN_3) @[AllToAllController.scala 81:33 AllToAllController.scala 83:23]
    node _GEN_7 = mux(_T_5, UInt<1>("h0"), _GEN_4) @[AllToAllController.scala 81:33 AllToAllController.scala 85:16]
    node _GEN_8 = mux(_T_5, UInt<1>("h0"), _GEN_3) @[AllToAllController.scala 81:33 AllToAllController.scala 87:17]
    node _GEN_9 = mux(_T_5, _GEN_2, _GEN_5) @[AllToAllController.scala 81:33]
    node _GEN_10 = mux(_T_4, UInt<1>("h0"), _GEN_6) @[AllToAllController.scala 68:23 AllToAllController.scala 70:23]
    node _GEN_11 = mux(_T_4, UInt<1>("h1"), _GEN_7) @[AllToAllController.scala 68:23 AllToAllController.scala 72:16]
    node _GEN_12 = mux(_T_4, UInt<1>("h0"), _GEN_8) @[AllToAllController.scala 68:23 AllToAllController.scala 74:17]
    node _GEN_13 = mux(_T_4, _GEN_1, _GEN_9) @[AllToAllController.scala 68:23]
    io_processor_cmd_ready <= _GEN_11
    io_processor_resp_valid <= _GEN_12
    io_processor_resp_bits_rd <= _T_1 @[AllToAllController.scala 49:29]
    io_processor_resp_bits_data <= UInt<64>("h0") @[AllToAllController.scala 58:31]
    io_processor_busy <= _GEN_10
    io_processor_interrupt <= UInt<1>("h0") @[AllToAllController.scala 57:26]
    state <= mux(reset, UInt<2>("h0"), _GEN_13) @[AllToAllController.scala 41:22 AllToAllController.scala 41:22]
    rd_address <= _GEN_0

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

    inst controller of AllToAllController @[AllToAllAccelerator.scala 74:26]
    io_cmd_ready <= controller.io_processor_cmd_ready @[AllToAllAccelerator.scala 84:16]
    io_resp_valid <= controller.io_processor_resp_valid @[AllToAllAccelerator.scala 83:6]
    io_resp_bits_rd <= controller.io_processor_resp_bits_rd @[AllToAllAccelerator.scala 83:6]
    io_resp_bits_data <= controller.io_processor_resp_bits_data @[AllToAllAccelerator.scala 83:6]
    io_busy <= controller.io_processor_busy @[AllToAllAccelerator.scala 83:6]
    io_interrupt <= controller.io_processor_interrupt @[AllToAllAccelerator.scala 83:6]
    controller.clock <= clock
    controller.reset <= reset
    controller.io_processor_cmd_valid <= io_cmd_valid @[AllToAllAccelerator.scala 83:6]
    controller.io_processor_cmd_bits_inst_funct <= io_cmd_bits_inst_funct @[AllToAllAccelerator.scala 83:6]
    controller.io_processor_cmd_bits_inst_rs2 <= io_cmd_bits_inst_rs2 @[AllToAllAccelerator.scala 83:6]
    controller.io_processor_cmd_bits_inst_rs1 <= io_cmd_bits_inst_rs1 @[AllToAllAccelerator.scala 83:6]
    controller.io_processor_cmd_bits_inst_xd <= io_cmd_bits_inst_xd @[AllToAllAccelerator.scala 83:6]
    controller.io_processor_cmd_bits_inst_xs1 <= io_cmd_bits_inst_xs1 @[AllToAllAccelerator.scala 83:6]
    controller.io_processor_cmd_bits_inst_xs2 <= io_cmd_bits_inst_xs2 @[AllToAllAccelerator.scala 83:6]
    controller.io_processor_cmd_bits_inst_rd <= io_cmd_bits_inst_rd @[AllToAllAccelerator.scala 83:6]
    controller.io_processor_cmd_bits_inst_opcode <= io_cmd_bits_inst_opcode @[AllToAllAccelerator.scala 83:6]
    controller.io_processor_cmd_bits_rs1 <= io_cmd_bits_rs1 @[AllToAllAccelerator.scala 83:6]
    controller.io_processor_cmd_bits_rs2 <= io_cmd_bits_rs2 @[AllToAllAccelerator.scala 83:6]
    controller.io_processor_resp_ready <= io_resp_ready @[AllToAllAccelerator.scala 83:6]
    controller.io_processor_exception <= io_exception @[AllToAllAccelerator.scala 83:6]

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

    inst aTaModule of AllToAllModule @[AllToAllTest.scala 12:25]
    io_cmd_ready <= aTaModule.io_cmd_ready @[AllToAllTest.scala 30:16]
    io_resp_valid <= aTaModule.io_resp_valid @[AllToAllTest.scala 31:17]
    io_resp_bits_rd <= aTaModule.io_resp_bits_rd @[AllToAllTest.scala 32:19]
    io_resp_bits_data <= aTaModule.io_resp_bits_data @[AllToAllTest.scala 33:21]
    io_busy <= aTaModule.io_busy @[AllToAllTest.scala 37:11]
    io_interrupt <= aTaModule.io_interrupt @[AllToAllTest.scala 36:16]
    aTaModule.clock <= clock
    aTaModule.reset <= reset
    aTaModule.io_cmd_valid <= io_cmd_valid @[AllToAllTest.scala 15:26]
    aTaModule.io_cmd_bits_inst_funct <= io_cmd_bits_inst_funct @[AllToAllTest.scala 16:36]
    aTaModule.io_cmd_bits_inst_rs2 <= io_cmd_bits_inst_rs2 @[AllToAllTest.scala 17:34]
    aTaModule.io_cmd_bits_inst_rs1 <= io_cmd_bits_inst_rs1 @[AllToAllTest.scala 18:34]
    aTaModule.io_cmd_bits_inst_xd <= io_cmd_bits_inst_xd @[AllToAllTest.scala 19:33]
    aTaModule.io_cmd_bits_inst_xs1 <= io_cmd_bits_inst_xs1 @[AllToAllTest.scala 20:34]
    aTaModule.io_cmd_bits_inst_xs2 <= io_cmd_bits_inst_xs2 @[AllToAllTest.scala 21:34]
    aTaModule.io_cmd_bits_inst_rd <= io_cmd_bits_inst_rd @[AllToAllTest.scala 22:33]
    aTaModule.io_cmd_bits_inst_opcode <= io_cmd_bits_inst_opcode @[AllToAllTest.scala 23:37]
    aTaModule.io_cmd_bits_rs1 <= io_cmd_bits_rs1 @[AllToAllTest.scala 24:29]
    aTaModule.io_cmd_bits_rs2 <= io_cmd_bits_rs2 @[AllToAllTest.scala 25:29]
    aTaModule.io_resp_ready <= io_resp_ready @[AllToAllTest.scala 26:27]
    aTaModule.io_exception <= io_exception @[AllToAllTest.scala 40:26]

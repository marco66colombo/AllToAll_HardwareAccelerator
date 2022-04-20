circuit AllToAll :
  module AllToAllController :
    input clock : Clock
    input reset : Reset
    output io : { processor : { flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { inst : { funct : UInt<7>, rs2 : UInt<5>, rs1 : UInt<5>, xd : UInt<1>, xs1 : UInt<1>, xs2 : UInt<1>, rd : UInt<5>, opcode : UInt<7>}, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { rd : UInt<5>, data : UInt<64>}}, busy : UInt<1>, interrupt : UInt<1>, flip exception : UInt<1>}}

    reg state : UInt<2>, clock with :
      reset => (reset, UInt<2>("h0")) @[AllToAllController.scala 41:22]
    reg rd_address : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address) @[AllToAllController.scala 42:23]
    node _T = eq(state, UInt<2>("h0")) @[AllToAllController.scala 49:43]
    node _T_1 = mux(_T, io.processor.cmd.bits.inst.rd, rd_address) @[AllToAllController.scala 49:35]
    io.processor.resp.bits.rd <= _T_1 @[AllToAllController.scala 49:29]
    node _T_2 = eq(state, UInt<2>("h0")) @[AllToAllController.scala 51:14]
    when _T_2 : @[AllToAllController.scala 51:23]
      rd_address <= io.processor.cmd.bits.inst.rd @[AllToAllController.scala 52:16]
    node _T_3 = eq(state, UInt<2>("h0")) @[AllToAllController.scala 55:36]
    io.processor.cmd.ready <= _T_3 @[AllToAllController.scala 55:26]
    io.processor.interrupt <= UInt<1>("h0") @[AllToAllController.scala 57:26]
    io.processor.resp.bits.data <= UInt<64>("h0") @[AllToAllController.scala 58:31]
    node _T_4 = eq(state, UInt<2>("h0")) @[AllToAllController.scala 68:14]
    when _T_4 : @[AllToAllController.scala 68:23]
      io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 70:23]
      io.processor.cmd.ready <= UInt<1>("h1") @[AllToAllController.scala 72:16]
      io.processor.resp.valid <= UInt<1>("h0") @[AllToAllController.scala 74:17]
      when io.processor.cmd.valid : @[AllToAllController.scala 76:23]
        state <= UInt<2>("h1") @[AllToAllController.scala 77:13]
      else :
        state <= UInt<2>("h0") @[AllToAllController.scala 79:13]
    else :
      node _T_5 = eq(state, UInt<2>("h1")) @[AllToAllController.scala 81:20]
      when _T_5 : @[AllToAllController.scala 81:33]
        io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 83:23]
        io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 85:16]
        io.processor.resp.valid <= UInt<1>("h0") @[AllToAllController.scala 87:17]
        when UInt<1>("h1") : @[AllToAllController.scala 89:29]
          state <= UInt<2>("h2") @[AllToAllController.scala 90:15]
        else :
          state <= UInt<2>("h1") @[AllToAllController.scala 92:15]
      else :
        node _T_6 = eq(state, UInt<2>("h2")) @[AllToAllController.scala 94:20]
        when _T_6 : @[AllToAllController.scala 94:38]
          io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 96:23]
          io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 98:16]
          io.processor.resp.valid <= UInt<1>("h1") @[AllToAllController.scala 100:17]
          state <= UInt<2>("h0") @[AllToAllController.scala 103:11]
        else :
          io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 108:23]
          io.processor.cmd.ready <= UInt<1>("h1") @[AllToAllController.scala 109:16]
          io.processor.resp.valid <= UInt<1>("h0") @[AllToAllController.scala 110:17]
          state <= UInt<2>("h0") @[AllToAllController.scala 111:11]

  module AllToAllModule :
    input clock : Clock
    input reset : Reset
    output io : { flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { inst : { funct : UInt<7>, rs2 : UInt<5>, rs1 : UInt<5>, xd : UInt<1>, xs1 : UInt<1>, xs2 : UInt<1>, rd : UInt<5>, opcode : UInt<7>}, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { rd : UInt<5>, data : UInt<64>}}, busy : UInt<1>, interrupt : UInt<1>, flip exception : UInt<1>}

    inst controller of AllToAllController @[AllToAllAccelerator.scala 74:26]
    controller.clock <= clock
    controller.reset <= reset
    controller.io.processor.exception <= io.exception @[AllToAllAccelerator.scala 83:6]
    io.interrupt <= controller.io.processor.interrupt @[AllToAllAccelerator.scala 83:6]
    io.busy <= controller.io.processor.busy @[AllToAllAccelerator.scala 83:6]
    io.resp.bits.data <= controller.io.processor.resp.bits.data @[AllToAllAccelerator.scala 83:6]
    io.resp.bits.rd <= controller.io.processor.resp.bits.rd @[AllToAllAccelerator.scala 83:6]
    io.resp.valid <= controller.io.processor.resp.valid @[AllToAllAccelerator.scala 83:6]
    controller.io.processor.resp.ready <= io.resp.ready @[AllToAllAccelerator.scala 83:6]
    controller.io.processor.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllAccelerator.scala 83:6]
    controller.io.processor.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllAccelerator.scala 83:6]
    controller.io.processor.cmd.bits.inst.opcode <= io.cmd.bits.inst.opcode @[AllToAllAccelerator.scala 83:6]
    controller.io.processor.cmd.bits.inst.rd <= io.cmd.bits.inst.rd @[AllToAllAccelerator.scala 83:6]
    controller.io.processor.cmd.bits.inst.xs2 <= io.cmd.bits.inst.xs2 @[AllToAllAccelerator.scala 83:6]
    controller.io.processor.cmd.bits.inst.xs1 <= io.cmd.bits.inst.xs1 @[AllToAllAccelerator.scala 83:6]
    controller.io.processor.cmd.bits.inst.xd <= io.cmd.bits.inst.xd @[AllToAllAccelerator.scala 83:6]
    controller.io.processor.cmd.bits.inst.rs1 <= io.cmd.bits.inst.rs1 @[AllToAllAccelerator.scala 83:6]
    controller.io.processor.cmd.bits.inst.rs2 <= io.cmd.bits.inst.rs2 @[AllToAllAccelerator.scala 83:6]
    controller.io.processor.cmd.bits.inst.funct <= io.cmd.bits.inst.funct @[AllToAllAccelerator.scala 83:6]
    controller.io.processor.cmd.valid <= io.cmd.valid @[AllToAllAccelerator.scala 83:6]
    io.cmd.ready <= controller.io.processor.cmd.ready @[AllToAllAccelerator.scala 83:6]

  module AllToAll :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { inst : { funct : UInt<7>, rs2 : UInt<5>, rs1 : UInt<5>, xd : UInt<1>, xs1 : UInt<1>, xs2 : UInt<1>, rd : UInt<5>, opcode : UInt<7>}, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { rd : UInt<5>, data : UInt<64>}}, busy : UInt<1>, interrupt : UInt<1>, flip exception : UInt<1>}

    inst aTaModule of AllToAllModule @[AllToAllTest.scala 12:25]
    aTaModule.clock <= clock
    aTaModule.reset <= reset
    aTaModule.io.cmd.valid <= io.cmd.valid @[AllToAllTest.scala 15:26]
    aTaModule.io.cmd.bits.inst.funct <= io.cmd.bits.inst.funct @[AllToAllTest.scala 16:36]
    aTaModule.io.cmd.bits.inst.rs2 <= io.cmd.bits.inst.rs2 @[AllToAllTest.scala 17:34]
    aTaModule.io.cmd.bits.inst.rs1 <= io.cmd.bits.inst.rs1 @[AllToAllTest.scala 18:34]
    aTaModule.io.cmd.bits.inst.xd <= io.cmd.bits.inst.xd @[AllToAllTest.scala 19:33]
    aTaModule.io.cmd.bits.inst.xs1 <= io.cmd.bits.inst.xs1 @[AllToAllTest.scala 20:34]
    aTaModule.io.cmd.bits.inst.xs2 <= io.cmd.bits.inst.xs2 @[AllToAllTest.scala 21:34]
    aTaModule.io.cmd.bits.inst.rd <= io.cmd.bits.inst.rd @[AllToAllTest.scala 22:33]
    aTaModule.io.cmd.bits.inst.opcode <= io.cmd.bits.inst.opcode @[AllToAllTest.scala 23:37]
    aTaModule.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllTest.scala 24:29]
    aTaModule.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllTest.scala 25:29]
    aTaModule.io.resp.ready <= io.resp.ready @[AllToAllTest.scala 26:27]
    io.cmd.ready <= aTaModule.io.cmd.ready @[AllToAllTest.scala 30:16]
    io.resp.valid <= aTaModule.io.resp.valid @[AllToAllTest.scala 31:17]
    io.resp.bits.rd <= aTaModule.io.resp.bits.rd @[AllToAllTest.scala 32:19]
    io.resp.bits.data <= aTaModule.io.resp.bits.data @[AllToAllTest.scala 33:21]
    io.interrupt <= aTaModule.io.interrupt @[AllToAllTest.scala 36:16]
    io.busy <= aTaModule.io.busy @[AllToAllTest.scala 37:11]
    aTaModule.io.exception <= io.exception @[AllToAllTest.scala 40:26]


circuit AllToAllController :
  module AllToAllController :
    input clock : Clock
    input reset : UInt<1>
    output io : { processor : { flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { inst : { funct : UInt<7>, rs2 : UInt<5>, rs1 : UInt<5>, xd : UInt<1>, xs1 : UInt<1>, xs2 : UInt<1>, rd : UInt<5>, opcode : UInt<7>}, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { rd : UInt<5>, data : UInt<64>}}, busy : UInt<1>, interrupt : UInt<1>, flip exception : UInt<1>}, flip mesh : { flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, busy : UInt<1>}}

    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllController.scala 42:22]
    reg r : UInt<5>, clock with :
      reset => (UInt<1>("h0"), r) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      r <= io.processor.cmd.bits.inst.rd @[Reg.scala 16:23]
    reg rd_address_mem : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address_mem) @[Reg.scala 15:16]
    when UInt<1>("h1") : @[Reg.scala 16:19]
      rd_address_mem <= r @[Reg.scala 16:23]
    reg rd_address_action : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address_action) @[AllToAllController.scala 54:30]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllController.scala 60:28]
    io.processor.interrupt <= UInt<1>("h0") @[AllToAllController.scala 64:26]
    io.mesh.cmd.bits.rs1 <= io.processor.cmd.bits.rs1 @[AllToAllController.scala 67:24]
    io.mesh.cmd.bits.rs2 <= io.processor.cmd.bits.rs2 @[AllToAllController.scala 68:24]
    io.processor.resp.bits.data <= io.mesh.resp.bits.data @[AllToAllController.scala 71:19]
    io.processor.resp.valid <= io.mesh.resp.ready @[AllToAllController.scala 74:15]
    node _T = eq(io.processor.cmd.bits.inst.opcode, UInt<6>("h2b")) @[AllToAllController.scala 81:59]
    node goto_excange = and(io.processor.cmd.valid, _T) @[AllToAllController.scala 81:33]
    node goto_done_exchange = eq(io.mesh.busy, UInt<1>("h0")) @[AllToAllController.scala 82:28]
    node _T_1 = eq(io.processor.cmd.bits.inst.opcode, UInt<4>("hb")) @[AllToAllController.scala 85:54]
    node mem_cmd = and(io.processor.cmd.valid, _T_1) @[AllToAllController.scala 85:28]
    node loadSignal = eq(io.processor.cmd.bits.inst.funct, UInt<1>("h1")) @[AllToAllController.scala 87:41]
    node storeSignal = eq(io.processor.cmd.bits.inst.funct, UInt<2>("h2")) @[AllToAllController.scala 89:42]
    io.mesh.cmd.valid <= io.processor.cmd.valid @[AllToAllController.scala 92:21]
    node _T_2 = and(mem_cmd, loadSignal) @[AllToAllController.scala 93:36]
    io.mesh.cmd.bits.load <= _T_2 @[AllToAllController.scala 93:25]
    node _T_3 = and(mem_cmd, storeSignal) @[AllToAllController.scala 94:37]
    io.mesh.cmd.bits.store <= _T_3 @[AllToAllController.scala 94:26]
    io.mesh.cmd.bits.doAllToAll <= goto_excange @[AllToAllController.scala 95:31]
    node _T_4 = eq(state, UInt<3>("h0")) @[AllToAllController.scala 99:14]
    when _T_4 : @[AllToAllController.scala 99:23]
      io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 101:23]
      io.processor.cmd.ready <= UInt<1>("h1") @[AllToAllController.scala 102:16]
      resp_signal <= UInt<1>("h0") @[AllToAllController.scala 104:17]
      io.mesh.resp.ready <= resp_signal @[AllToAllController.scala 107:24]
      io.processor.resp.bits.rd <= rd_address_mem @[AllToAllController.scala 109:31]
      when goto_excange : @[AllToAllController.scala 111:23]
        state <= UInt<3>("h1") @[AllToAllController.scala 112:13]
      else :
        when mem_cmd : @[AllToAllController.scala 113:24]
          state <= UInt<3>("h3") @[AllToAllController.scala 114:13]
        else :
          state <= UInt<3>("h0") @[AllToAllController.scala 116:13]
    else :
      node _T_5 = eq(state, UInt<3>("h3")) @[AllToAllController.scala 119:20]
      when _T_5 : @[AllToAllController.scala 119:38]
        io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 121:23]
        io.processor.cmd.ready <= UInt<1>("h1") @[AllToAllController.scala 122:16]
        resp_signal <= UInt<1>("h1") @[AllToAllController.scala 124:17]
        io.mesh.resp.ready <= resp_signal @[AllToAllController.scala 127:24]
        io.processor.resp.bits.rd <= rd_address_mem @[AllToAllController.scala 129:31]
        when goto_excange : @[AllToAllController.scala 131:23]
          state <= UInt<3>("h1") @[AllToAllController.scala 132:13]
        else :
          when mem_cmd : @[AllToAllController.scala 133:24]
            state <= UInt<3>("h3") @[AllToAllController.scala 134:13]
          else :
            state <= UInt<3>("h0") @[AllToAllController.scala 136:13]
      else :
        node _T_6 = eq(state, UInt<3>("h1")) @[AllToAllController.scala 139:20]
        when _T_6 : @[AllToAllController.scala 139:31]
          io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 141:23]
          io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 142:16]
          resp_signal <= UInt<1>("h0") @[AllToAllController.scala 144:17]
          rd_address_action <= io.processor.cmd.bits.inst.rd @[AllToAllController.scala 146:23]
          io.mesh.resp.ready <= resp_signal @[AllToAllController.scala 149:24]
          io.processor.resp.bits.rd <= rd_address_mem @[AllToAllController.scala 151:31]
          state <= UInt<3>("h4") @[AllToAllController.scala 153:11]
        else :
          node _T_7 = eq(state, UInt<3>("h4")) @[AllToAllController.scala 155:20]
          when _T_7 : @[AllToAllController.scala 155:41]
            io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 157:23]
            io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 158:16]
            io.mesh.resp.ready <= UInt<1>("h0") @[AllToAllController.scala 161:24]
            io.processor.resp.bits.rd <= rd_address_action @[AllToAllController.scala 163:31]
            when goto_done_exchange : @[AllToAllController.scala 165:29]
              state <= UInt<3>("h2") @[AllToAllController.scala 166:13]
            else :
              state <= UInt<3>("h4") @[AllToAllController.scala 168:13]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllController.scala 171:20]
            when _T_8 : @[AllToAllController.scala 171:36]
              io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 173:23]
              io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 174:16]
              io.mesh.resp.ready <= UInt<1>("h1") @[AllToAllController.scala 178:24]
              io.processor.resp.bits.rd <= rd_address_action @[AllToAllController.scala 180:31]
              state <= UInt<3>("h0") @[AllToAllController.scala 182:11]
            else :
              io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 186:23]
              io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 187:16]
              io.mesh.resp.ready <= UInt<1>("h0") @[AllToAllController.scala 190:24]
              io.processor.resp.bits.rd <= rd_address_mem @[AllToAllController.scala 192:31]
              state <= UInt<3>("h0") @[AllToAllController.scala 194:11]


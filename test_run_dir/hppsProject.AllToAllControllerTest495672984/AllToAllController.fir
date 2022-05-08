circuit AllToAllController :
  module AllToAllController :
    input clock : Clock
    input reset : UInt<1>
    output io : { processor : { flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { inst : { funct : UInt<7>, rs2 : UInt<5>, rs1 : UInt<5>, xd : UInt<1>, xs1 : UInt<1>, xs2 : UInt<1>, rd : UInt<5>, opcode : UInt<7>}, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { rd : UInt<5>, data : UInt<64>}}, busy : UInt<1>, interrupt : UInt<1>, flip exception : UInt<1>}, flip mesh : { flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, busy : UInt<1>}}

    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllController.scala 42:22]
    reg rd_address_mem : UInt, clock with :
      reset => (UInt<1>("h0"), rd_address_mem) @[AllToAllController.scala 53:31]
    rd_address_mem <= io.processor.cmd.bits.inst.rd @[AllToAllController.scala 53:31]
    reg rd_address_action : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address_action) @[AllToAllController.scala 54:30]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllController.scala 60:28]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllController.scala 63:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllController.scala 64:16]
    rs1 <= io.processor.cmd.bits.rs1 @[AllToAllController.scala 66:7]
    rs2 <= io.processor.cmd.bits.rs2 @[AllToAllController.scala 67:7]
    io.processor.interrupt <= UInt<1>("h0") @[AllToAllController.scala 71:26]
    io.mesh.cmd.bits.rs1 <= rs1 @[AllToAllController.scala 74:24]
    io.mesh.cmd.bits.rs2 <= rs2 @[AllToAllController.scala 75:24]
    io.processor.resp.bits.data <= io.mesh.resp.bits.data @[AllToAllController.scala 78:19]
    io.processor.resp.valid <= io.mesh.resp.ready @[AllToAllController.scala 81:15]
    node _T = eq(io.processor.cmd.bits.inst.opcode, UInt<6>("h2b")) @[AllToAllController.scala 88:59]
    node goto_excange = and(io.processor.cmd.valid, _T) @[AllToAllController.scala 88:33]
    node goto_done_exchange = eq(io.mesh.busy, UInt<1>("h0")) @[AllToAllController.scala 89:28]
    node _T_1 = eq(io.processor.cmd.bits.inst.opcode, UInt<4>("hb")) @[AllToAllController.scala 92:54]
    node mem_cmd = and(io.processor.cmd.valid, _T_1) @[AllToAllController.scala 92:28]
    node loadSignal = eq(io.processor.cmd.bits.inst.funct, UInt<1>("h1")) @[AllToAllController.scala 94:41]
    node storeSignal = eq(io.processor.cmd.bits.inst.funct, UInt<2>("h2")) @[AllToAllController.scala 96:42]
    io.mesh.cmd.valid <= io.processor.cmd.valid @[AllToAllController.scala 99:21]
    node _T_2 = and(mem_cmd, loadSignal) @[AllToAllController.scala 100:36]
    io.mesh.cmd.bits.load <= _T_2 @[AllToAllController.scala 100:25]
    node _T_3 = and(mem_cmd, storeSignal) @[AllToAllController.scala 101:37]
    io.mesh.cmd.bits.store <= _T_3 @[AllToAllController.scala 101:26]
    io.mesh.cmd.bits.doAllToAll <= goto_excange @[AllToAllController.scala 102:31]
    node _T_4 = eq(state, UInt<3>("h0")) @[AllToAllController.scala 106:14]
    when _T_4 : @[AllToAllController.scala 106:23]
      io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 108:23]
      io.processor.cmd.ready <= UInt<1>("h1") @[AllToAllController.scala 109:16]
      resp_signal <= UInt<1>("h0") @[AllToAllController.scala 111:17]
      io.mesh.resp.ready <= resp_signal @[AllToAllController.scala 117:24]
      io.processor.resp.bits.rd <= rd_address_mem @[AllToAllController.scala 119:31]
      when goto_excange : @[AllToAllController.scala 121:23]
        state <= UInt<3>("h1") @[AllToAllController.scala 122:13]
      else :
        when mem_cmd : @[AllToAllController.scala 123:24]
          state <= UInt<3>("h3") @[AllToAllController.scala 124:13]
        else :
          state <= UInt<3>("h0") @[AllToAllController.scala 126:13]
    else :
      node _T_5 = eq(state, UInt<3>("h3")) @[AllToAllController.scala 129:20]
      when _T_5 : @[AllToAllController.scala 129:38]
        io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 131:23]
        io.processor.cmd.ready <= UInt<1>("h1") @[AllToAllController.scala 132:16]
        resp_signal <= UInt<1>("h1") @[AllToAllController.scala 134:17]
        io.mesh.resp.ready <= resp_signal @[AllToAllController.scala 142:24]
        io.processor.resp.bits.rd <= rd_address_mem @[AllToAllController.scala 144:31]
        when goto_excange : @[AllToAllController.scala 146:23]
          state <= UInt<3>("h1") @[AllToAllController.scala 147:13]
        else :
          when mem_cmd : @[AllToAllController.scala 148:24]
            state <= UInt<3>("h3") @[AllToAllController.scala 149:13]
          else :
            state <= UInt<3>("h0") @[AllToAllController.scala 151:13]
      else :
        node _T_6 = eq(state, UInt<3>("h1")) @[AllToAllController.scala 154:20]
        when _T_6 : @[AllToAllController.scala 154:31]
          io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 156:23]
          io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 157:16]
          resp_signal <= UInt<1>("h0") @[AllToAllController.scala 159:17]
          rd_address_action <= io.processor.cmd.bits.inst.rd @[AllToAllController.scala 164:23]
          io.mesh.resp.ready <= resp_signal @[AllToAllController.scala 167:24]
          io.processor.resp.bits.rd <= rd_address_mem @[AllToAllController.scala 169:31]
          state <= UInt<3>("h4") @[AllToAllController.scala 171:11]
        else :
          node _T_7 = eq(state, UInt<3>("h4")) @[AllToAllController.scala 173:20]
          when _T_7 : @[AllToAllController.scala 173:41]
            io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 175:23]
            io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 176:16]
            io.mesh.resp.ready <= UInt<1>("h0") @[AllToAllController.scala 182:24]
            io.processor.resp.bits.rd <= rd_address_action @[AllToAllController.scala 184:31]
            when goto_done_exchange : @[AllToAllController.scala 186:29]
              state <= UInt<3>("h2") @[AllToAllController.scala 187:13]
            else :
              state <= UInt<3>("h4") @[AllToAllController.scala 189:13]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllController.scala 192:20]
            when _T_8 : @[AllToAllController.scala 192:36]
              io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 194:23]
              io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 195:16]
              io.mesh.resp.ready <= UInt<1>("h1") @[AllToAllController.scala 199:24]
              io.processor.resp.bits.rd <= rd_address_action @[AllToAllController.scala 201:31]
              state <= UInt<3>("h0") @[AllToAllController.scala 203:11]
            else :
              io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 207:23]
              io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 208:16]
              io.mesh.resp.ready <= UInt<1>("h0") @[AllToAllController.scala 211:24]
              io.processor.resp.bits.rd <= rd_address_mem @[AllToAllController.scala 213:31]
              state <= UInt<3>("h0") @[AllToAllController.scala 215:11]


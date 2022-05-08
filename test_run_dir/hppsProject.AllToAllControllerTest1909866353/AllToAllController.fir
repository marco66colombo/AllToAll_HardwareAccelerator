circuit AllToAllController :
  module AllToAllController :
    input clock : Clock
    input reset : UInt<1>
    output io : { processor : { flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { inst : { funct : UInt<7>, rs2 : UInt<5>, rs1 : UInt<5>, xd : UInt<1>, xs1 : UInt<1>, xs2 : UInt<1>, rd : UInt<5>, opcode : UInt<7>}, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { rd : UInt<5>, data : UInt<64>}}, busy : UInt<1>, interrupt : UInt<1>, flip exception : UInt<1>}, flip mesh : { flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, busy : UInt<1>}}

    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllController.scala 42:22]
    reg rd_address_cmd : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address_cmd) @[AllToAllController.scala 49:27]
    reg rd_address_resp : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address_resp) @[AllToAllController.scala 51:28]
    io.processor.resp.bits.rd <= rd_address_resp @[AllToAllController.scala 54:29]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllController.scala 57:28]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllController.scala 60:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllController.scala 61:16]
    rs1 <= io.processor.cmd.bits.rs1 @[AllToAllController.scala 63:7]
    rs2 <= io.processor.cmd.bits.rs2 @[AllToAllController.scala 64:7]
    io.processor.interrupt <= UInt<1>("h0") @[AllToAllController.scala 68:26]
    io.mesh.cmd.valid <= io.processor.cmd.valid @[AllToAllController.scala 71:21]
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
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllController.scala 99:14]
    when _T_2 : @[AllToAllController.scala 99:23]
      io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 101:23]
      io.processor.cmd.ready <= UInt<1>("h1") @[AllToAllController.scala 102:16]
      resp_signal <= UInt<1>("h0") @[AllToAllController.scala 104:17]
      rd_address_cmd <= io.processor.cmd.bits.inst.rd @[AllToAllController.scala 106:20]
      io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 109:27]
      io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 110:28]
      io.mesh.cmd.bits.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 111:33]
      io.mesh.resp.ready <= resp_signal @[AllToAllController.scala 112:24]
      when goto_excange : @[AllToAllController.scala 115:23]
        state <= UInt<3>("h1") @[AllToAllController.scala 116:13]
      else :
        when mem_cmd : @[AllToAllController.scala 117:24]
          state <= UInt<3>("h3") @[AllToAllController.scala 118:13]
        else :
          state <= UInt<3>("h0") @[AllToAllController.scala 120:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllController.scala 123:20]
      when _T_3 : @[AllToAllController.scala 123:38]
        io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 125:23]
        io.processor.cmd.ready <= UInt<1>("h1") @[AllToAllController.scala 126:16]
        resp_signal <= UInt<1>("h1") @[AllToAllController.scala 128:17]
        rd_address_cmd <= io.processor.cmd.bits.inst.rd @[AllToAllController.scala 131:20]
        rd_address_resp <= rd_address_cmd @[AllToAllController.scala 133:21]
        io.mesh.cmd.bits.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 136:33]
        io.mesh.resp.ready <= resp_signal @[AllToAllController.scala 137:24]
        when loadSignal : @[AllToAllController.scala 140:21]
          io.mesh.cmd.bits.load <= UInt<1>("h1") @[AllToAllController.scala 141:29]
          io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 142:30]
        else :
          when storeSignal : @[AllToAllController.scala 143:28]
            io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 144:29]
            io.mesh.cmd.bits.store <= UInt<1>("h1") @[AllToAllController.scala 145:30]
          else :
            io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 147:29]
            io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 148:30]
        when goto_excange : @[AllToAllController.scala 151:23]
          state <= UInt<3>("h1") @[AllToAllController.scala 152:13]
        else :
          when mem_cmd : @[AllToAllController.scala 153:24]
            state <= UInt<3>("h3") @[AllToAllController.scala 154:13]
          else :
            state <= UInt<3>("h0") @[AllToAllController.scala 156:13]
      else :
        node _T_4 = eq(state, UInt<3>("h1")) @[AllToAllController.scala 159:20]
        when _T_4 : @[AllToAllController.scala 159:31]
          io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 161:23]
          io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 162:16]
          resp_signal <= UInt<1>("h0") @[AllToAllController.scala 164:17]
          rd_address_cmd <= io.processor.cmd.bits.inst.rd @[AllToAllController.scala 167:20]
          io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 170:27]
          io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 171:28]
          io.mesh.cmd.bits.doAllToAll <= UInt<1>("h1") @[AllToAllController.scala 172:33]
          io.mesh.resp.ready <= resp_signal @[AllToAllController.scala 173:24]
          state <= UInt<3>("h4") @[AllToAllController.scala 176:11]
        else :
          node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllController.scala 178:20]
          when _T_5 : @[AllToAllController.scala 178:41]
            io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 180:23]
            io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 181:16]
            rd_address_resp <= rd_address_cmd @[AllToAllController.scala 184:21]
            io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 187:27]
            io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 188:28]
            io.mesh.cmd.bits.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 189:33]
            io.mesh.resp.ready <= UInt<1>("h0") @[AllToAllController.scala 190:24]
            when goto_done_exchange : @[AllToAllController.scala 193:29]
              state <= UInt<3>("h2") @[AllToAllController.scala 194:13]
            else :
              state <= UInt<3>("h4") @[AllToAllController.scala 196:13]
          else :
            node _T_6 = eq(state, UInt<3>("h2")) @[AllToAllController.scala 199:20]
            when _T_6 : @[AllToAllController.scala 199:36]
              io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 201:23]
              io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 202:16]
              io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 205:27]
              io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 206:28]
              io.mesh.cmd.bits.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 207:33]
              io.mesh.resp.ready <= UInt<1>("h1") @[AllToAllController.scala 210:24]
              state <= UInt<3>("h0") @[AllToAllController.scala 212:11]
            else :
              io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 216:23]
              io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 217:16]
              io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 220:27]
              io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 221:28]
              io.mesh.cmd.bits.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 222:33]
              io.mesh.resp.ready <= UInt<1>("h0") @[AllToAllController.scala 223:24]
              state <= UInt<3>("h0") @[AllToAllController.scala 225:11]


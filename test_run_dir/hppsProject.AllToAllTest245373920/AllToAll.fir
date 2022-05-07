circuit AllToAll :
  module AllToAllController :
    input clock : Clock
    input reset : Reset
    output io : { processor : { flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { inst : { funct : UInt<7>, rs2 : UInt<5>, rs1 : UInt<5>, xd : UInt<1>, xs1 : UInt<1>, xs2 : UInt<1>, rd : UInt<5>, opcode : UInt<7>}, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { rd : UInt<5>, data : UInt<64>}}, busy : UInt<1>, interrupt : UInt<1>, flip exception : UInt<1>}, flip mesh : { flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, busy : UInt<1>}}

    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllController.scala 45:22]
    reg rd_address : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address) @[AllToAllController.scala 46:23]
    node _T = eq(state, UInt<3>("h0")) @[AllToAllController.scala 53:43]
    node _T_1 = mux(_T, io.processor.cmd.bits.inst.rd, rd_address) @[AllToAllController.scala 53:35]
    io.processor.resp.bits.rd <= _T_1 @[AllToAllController.scala 53:29]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllController.scala 55:14]
    when _T_2 : @[AllToAllController.scala 55:23]
      rd_address <= io.processor.cmd.bits.inst.rd @[AllToAllController.scala 56:16]
    io.processor.interrupt <= UInt<1>("h0") @[AllToAllController.scala 64:26]
    io.processor.resp.bits.data <= io.mesh.resp.bits.data @[AllToAllController.scala 65:19]
    io.mesh.cmd.valid <= io.processor.cmd.valid @[AllToAllController.scala 66:21]
    io.mesh.cmd.bits.rs1 <= io.processor.cmd.bits.rs1 @[AllToAllController.scala 67:24]
    io.mesh.cmd.bits.rs2 <= io.processor.cmd.bits.rs2 @[AllToAllController.scala 68:24]
    io.processor.resp.valid <= io.mesh.resp.ready @[AllToAllController.scala 70:15]
    node _T_3 = eq(io.processor.cmd.bits.inst.opcode, UInt<6>("h2b")) @[AllToAllController.scala 78:71]
    node goto_excange = and(io.processor.cmd.valid, _T_3) @[AllToAllController.scala 78:33]
    node goto_done_exchange = eq(io.mesh.busy, UInt<1>("h0")) @[AllToAllController.scala 81:28]
    node loadSignal = eq(io.processor.cmd.bits.inst.funct, UInt<1>("h1")) @[AllToAllController.scala 82:53]
    node storeSignal = eq(io.processor.cmd.bits.inst.funct, UInt<2>("h2")) @[AllToAllController.scala 83:54]
    node _T_4 = eq(io.processor.cmd.bits.inst.opcode, UInt<4>("hb")) @[AllToAllController.scala 84:66]
    node mem_cmd = and(io.processor.cmd.valid, _T_4) @[AllToAllController.scala 84:28]
    node _T_5 = eq(state, UInt<3>("h0")) @[AllToAllController.scala 86:14]
    when _T_5 : @[AllToAllController.scala 86:23]
      io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 88:23]
      io.processor.cmd.ready <= UInt<1>("h1") @[AllToAllController.scala 90:16]
      io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 94:27]
      io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 95:28]
      io.mesh.cmd.bits.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 96:33]
      io.mesh.resp.ready <= UInt<1>("h0") @[AllToAllController.scala 98:24]
      when goto_excange : @[AllToAllController.scala 101:23]
        state <= UInt<3>("h1") @[AllToAllController.scala 102:13]
      else :
        when mem_cmd : @[AllToAllController.scala 103:24]
          state <= UInt<3>("h3") @[AllToAllController.scala 104:13]
        else :
          state <= UInt<3>("h0") @[AllToAllController.scala 106:13]
    else :
      node _T_6 = eq(state, UInt<3>("h3")) @[AllToAllController.scala 108:20]
      when _T_6 : @[AllToAllController.scala 108:38]
        io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 111:23]
        io.processor.cmd.ready <= UInt<1>("h1") @[AllToAllController.scala 113:16]
        io.mesh.cmd.bits.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 115:33]
        io.mesh.resp.ready <= UInt<1>("h0") @[AllToAllController.scala 116:24]
        when loadSignal : @[AllToAllController.scala 118:21]
          io.mesh.cmd.bits.load <= UInt<1>("h1") @[AllToAllController.scala 119:29]
          io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 120:30]
        else :
          when storeSignal : @[AllToAllController.scala 121:28]
            io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 122:29]
            io.mesh.cmd.bits.store <= UInt<1>("h1") @[AllToAllController.scala 123:30]
          else :
            io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 125:29]
            io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 126:30]
        when goto_excange : @[AllToAllController.scala 129:23]
          state <= UInt<3>("h6") @[AllToAllController.scala 130:13]
        else :
          when mem_cmd : @[AllToAllController.scala 131:24]
            state <= UInt<3>("h4") @[AllToAllController.scala 132:13]
          else :
            state <= UInt<3>("h5") @[AllToAllController.scala 134:13]
      else :
        node _T_7 = eq(state, UInt<3>("h5")) @[AllToAllController.scala 137:20]
        when _T_7 : @[AllToAllController.scala 137:38]
          io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 139:23]
          io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 141:16]
          io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 144:27]
          io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 145:28]
          io.mesh.cmd.bits.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 146:33]
          io.mesh.resp.ready <= UInt<1>("h1") @[AllToAllController.scala 147:24]
          state <= UInt<3>("h0") @[AllToAllController.scala 149:11]
        else :
          node _T_8 = eq(state, UInt<3>("h4")) @[AllToAllController.scala 151:20]
          when _T_8 : @[AllToAllController.scala 151:41]
            io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 153:23]
            io.processor.cmd.ready <= UInt<1>("h1") @[AllToAllController.scala 155:16]
            io.mesh.cmd.bits.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 157:33]
            io.mesh.resp.ready <= UInt<1>("h1") @[AllToAllController.scala 158:24]
            when loadSignal : @[AllToAllController.scala 160:21]
              io.mesh.cmd.bits.load <= UInt<1>("h1") @[AllToAllController.scala 161:29]
              io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 162:30]
            else :
              when storeSignal : @[AllToAllController.scala 163:28]
                io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 164:29]
                io.mesh.cmd.bits.store <= UInt<1>("h1") @[AllToAllController.scala 165:30]
              else :
                io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 167:29]
                io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 168:30]
            when goto_excange : @[AllToAllController.scala 171:23]
              state <= UInt<3>("h6") @[AllToAllController.scala 172:13]
            else :
              when mem_cmd : @[AllToAllController.scala 173:24]
                state <= UInt<3>("h4") @[AllToAllController.scala 174:13]
              else :
                state <= UInt<3>("h5") @[AllToAllController.scala 176:13]
          else :
            node _T_9 = eq(state, UInt<3>("h6")) @[AllToAllController.scala 179:20]
            when _T_9 : @[AllToAllController.scala 179:44]
              io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 181:23]
              io.processor.cmd.ready <= UInt<1>("h1") @[AllToAllController.scala 183:16]
              io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 186:27]
              io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 187:28]
              io.mesh.cmd.bits.doAllToAll <= UInt<1>("h1") @[AllToAllController.scala 188:33]
              io.mesh.resp.ready <= UInt<1>("h1") @[AllToAllController.scala 189:24]
              state <= UInt<3>("h7") @[AllToAllController.scala 192:11]
            else :
              node _T_10 = eq(state, UInt<3>("h1")) @[AllToAllController.scala 193:20]
              when _T_10 : @[AllToAllController.scala 193:31]
                io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 195:23]
                io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 197:16]
                io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 200:27]
                io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 201:28]
                io.mesh.cmd.bits.doAllToAll <= UInt<1>("h1") @[AllToAllController.scala 202:33]
                io.mesh.resp.ready <= UInt<1>("h0") @[AllToAllController.scala 203:24]
                state <= UInt<3>("h7") @[AllToAllController.scala 206:11]
              else :
                node _T_11 = eq(state, UInt<3>("h7")) @[AllToAllController.scala 207:20]
                when _T_11 : @[AllToAllController.scala 207:41]
                  io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 209:23]
                  io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 211:16]
                  io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 214:27]
                  io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 215:28]
                  io.mesh.cmd.bits.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 216:33]
                  io.mesh.resp.ready <= UInt<1>("h0") @[AllToAllController.scala 217:24]
                  when goto_done_exchange : @[AllToAllController.scala 220:29]
                    state <= UInt<3>("h2") @[AllToAllController.scala 221:13]
                  else :
                    state <= UInt<3>("h7") @[AllToAllController.scala 223:13]
                else :
                  node _T_12 = eq(state, UInt<3>("h2")) @[AllToAllController.scala 225:20]
                  when _T_12 : @[AllToAllController.scala 225:36]
                    io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 226:23]
                    io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 228:16]
                    io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 231:27]
                    io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 232:28]
                    io.mesh.cmd.bits.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 233:33]
                    io.mesh.resp.ready <= UInt<1>("h1") @[AllToAllController.scala 234:24]
                  else :
                    io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 238:23]
                    io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 240:16]
                    io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 244:27]
                    io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 245:28]
                    io.mesh.cmd.bits.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 246:33]
                    io.mesh.resp.ready <= UInt<1>("h0") @[AllToAllController.scala 248:24]

  module AllToAllPEupLeftCorner :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<32>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 133:20]
    reg y_coord : UInt<32>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 134:20]
    x_coord <= UInt<32>("h0") @[AllToAllPE.scala 135:11]
    y_coord <= UInt<32>("h2") @[AllToAllPE.scala 136:11]
    io.busy <= UInt<1>("h0") @[AllToAllPE.scala 138:11]
    io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 139:16]
    io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 140:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 200:15]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 202:13]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 204:16]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 205:17]
    io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 207:21]

  module AllToAllPEup :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<32>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 133:20]
    reg y_coord : UInt<32>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 134:20]
    x_coord <= UInt<32>("h1") @[AllToAllPE.scala 135:11]
    y_coord <= UInt<32>("h2") @[AllToAllPE.scala 136:11]
    io.busy <= UInt<1>("h0") @[AllToAllPE.scala 138:11]
    io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 139:16]
    io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 140:17]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 256:13]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 258:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 259:16]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 260:17]
    io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 262:21]

  module AllToAllPEupRightCorner :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<32>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 133:20]
    reg y_coord : UInt<32>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 134:20]
    x_coord <= UInt<32>("h2") @[AllToAllPE.scala 135:11]
    y_coord <= UInt<32>("h2") @[AllToAllPE.scala 136:11]
    io.busy <= UInt<1>("h0") @[AllToAllPE.scala 138:11]
    io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 139:16]
    io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 140:17]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 214:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 216:13]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 218:15]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 219:17]
    io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 221:21]

  module AllToAllPEleft :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<32>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 133:20]
    reg y_coord : UInt<32>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 134:20]
    x_coord <= UInt<32>("h0") @[AllToAllPE.scala 135:11]
    y_coord <= UInt<32>("h1") @[AllToAllPE.scala 136:11]
    io.busy <= UInt<1>("h0") @[AllToAllPE.scala 138:11]
    io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 139:16]
    io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 140:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 280:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 282:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 283:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 284:17]
    io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 286:21]

  module AllToAllPEmiddle :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<32>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 133:20]
    reg y_coord : UInt<32>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 134:20]
    x_coord <= UInt<32>("h1") @[AllToAllPE.scala 135:11]
    y_coord <= UInt<32>("h1") @[AllToAllPE.scala 136:11]
    io.busy <= UInt<1>("h0") @[AllToAllPE.scala 138:11]
    io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 139:16]
    io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 140:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 303:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 304:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 305:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 306:17]
    io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 308:21]

  module AllToAllPEright :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<32>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 133:20]
    reg y_coord : UInt<32>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 134:20]
    x_coord <= UInt<32>("h2") @[AllToAllPE.scala 135:11]
    y_coord <= UInt<32>("h1") @[AllToAllPE.scala 136:11]
    io.busy <= UInt<1>("h0") @[AllToAllPE.scala 138:11]
    io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 139:16]
    io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 140:17]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 292:16]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 294:15]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 295:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 296:17]
    io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 298:21]

  module AllToAllPEbottomLeftCorner :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<32>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 133:20]
    reg y_coord : UInt<32>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 134:20]
    x_coord <= UInt<32>("h0") @[AllToAllPE.scala 135:11]
    y_coord <= UInt<32>("h0") @[AllToAllPE.scala 136:11]
    io.busy <= UInt<1>("h0") @[AllToAllPE.scala 138:11]
    io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 139:16]
    io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 140:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 228:15]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 230:17]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 233:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 234:13]
    io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 236:21]

  module AllToAllPEbottom :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<32>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 133:20]
    reg y_coord : UInt<32>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 134:20]
    x_coord <= UInt<32>("h1") @[AllToAllPE.scala 135:11]
    y_coord <= UInt<32>("h0") @[AllToAllPE.scala 136:11]
    io.busy <= UInt<1>("h0") @[AllToAllPE.scala 138:11]
    io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 139:16]
    io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 140:17]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 267:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 269:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 270:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 271:13]
    io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 273:21]

  module AllToAllPEbottomRightCorner :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<32>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 133:20]
    reg y_coord : UInt<32>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 134:20]
    x_coord <= UInt<32>("h2") @[AllToAllPE.scala 135:11]
    y_coord <= UInt<32>("h0") @[AllToAllPE.scala 136:11]
    io.busy <= UInt<1>("h0") @[AllToAllPE.scala 138:11]
    io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 139:16]
    io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 140:17]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 242:16]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 244:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 246:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 247:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 248:13]
    io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 250:21]

  module AllToAllMesh :
    input clock : Clock
    input reset : Reset
    output io : { flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, busy : UInt<1>}

    inst vector_0 of AllToAllPEupLeftCorner @[AllToAllMesh.scala 95:41]
    vector_0.clock <= clock
    vector_0.reset <= reset
    inst vector_1 of AllToAllPEup @[AllToAllMesh.scala 106:41]
    vector_1.clock <= clock
    vector_1.reset <= reset
    inst vector_2 of AllToAllPEupRightCorner @[AllToAllMesh.scala 98:41]
    vector_2.clock <= clock
    vector_2.reset <= reset
    inst vector_3 of AllToAllPEleft @[AllToAllMesh.scala 112:41]
    vector_3.clock <= clock
    vector_3.reset <= reset
    inst vector_4 of AllToAllPEmiddle @[AllToAllMesh.scala 118:41]
    vector_4.clock <= clock
    vector_4.reset <= reset
    inst vector_5 of AllToAllPEright @[AllToAllMesh.scala 115:41]
    vector_5.clock <= clock
    vector_5.reset <= reset
    inst vector_6 of AllToAllPEbottomLeftCorner @[AllToAllMesh.scala 101:41]
    vector_6.clock <= clock
    vector_6.reset <= reset
    inst vector_7 of AllToAllPEbottom @[AllToAllMesh.scala 109:41]
    vector_7.clock <= clock
    vector_7.reset <= reset
    inst vector_8 of AllToAllPEbottomRightCorner @[AllToAllMesh.scala 104:41]
    vector_8.clock <= clock
    vector_8.reset <= reset
    vector_0.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 133:32]
    vector_0.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 134:36]
    vector_0.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 135:37]
    vector_0.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 136:42]
    vector_0.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 138:35]
    vector_0.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 139:35]
    vector_0.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 141:33]
    vector_1.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 133:32]
    vector_1.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 134:36]
    vector_1.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 135:37]
    vector_1.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 136:42]
    vector_1.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 138:35]
    vector_1.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 139:35]
    vector_1.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 141:33]
    vector_2.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 133:32]
    vector_2.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 134:36]
    vector_2.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 135:37]
    vector_2.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 136:42]
    vector_2.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 138:35]
    vector_2.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 139:35]
    vector_2.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 141:33]
    vector_3.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 133:32]
    vector_3.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 134:36]
    vector_3.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 135:37]
    vector_3.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 136:42]
    vector_3.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 138:35]
    vector_3.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 139:35]
    vector_3.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 141:33]
    vector_4.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 133:32]
    vector_4.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 134:36]
    vector_4.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 135:37]
    vector_4.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 136:42]
    vector_4.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 138:35]
    vector_4.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 139:35]
    vector_4.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 141:33]
    vector_5.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 133:32]
    vector_5.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 134:36]
    vector_5.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 135:37]
    vector_5.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 136:42]
    vector_5.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 138:35]
    vector_5.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 139:35]
    vector_5.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 141:33]
    vector_6.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 133:32]
    vector_6.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 134:36]
    vector_6.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 135:37]
    vector_6.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 136:42]
    vector_6.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 138:35]
    vector_6.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 139:35]
    vector_6.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 141:33]
    vector_7.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 133:32]
    vector_7.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 134:36]
    vector_7.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 135:37]
    vector_7.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 136:42]
    vector_7.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 138:35]
    vector_7.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 139:35]
    vector_7.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 141:33]
    vector_8.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 133:32]
    vector_8.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 134:36]
    vector_8.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 135:37]
    vector_8.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 136:42]
    vector_8.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 138:35]
    vector_8.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 139:35]
    vector_8.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 141:33]
    node _T = bits(io.cmd.bits.rs2, 15, 0) @[AllToAllMesh.scala 152:18]
    node _T_1 = bits(io.cmd.bits.rs2, 31, 16) @[AllToAllMesh.scala 153:18]
    node _T_2 = sub(UInt<2>("h3"), UInt<1>("h1")) @[AllToAllMesh.scala 154:14]
    node _T_3 = tail(_T_2, 1) @[AllToAllMesh.scala 154:14]
    node _T_4 = sub(_T_3, _T_1) @[AllToAllMesh.scala 154:18]
    node _T_5 = tail(_T_4, 1) @[AllToAllMesh.scala 154:18]
    node _T_6 = mul(_T_5, UInt<2>("h3")) @[AllToAllMesh.scala 154:21]
    node _T_7 = add(_T_6, _T) @[AllToAllMesh.scala 154:25]
    node nPE = tail(_T_7, 1) @[AllToAllMesh.scala 154:25]
    node _T_8 = eq(nPE, UInt<1>("h0")) @[AllToAllMesh.scala 160:27]
    node _T_9 = eq(nPE, UInt<1>("h1")) @[AllToAllMesh.scala 163:25]
    node _T_10 = eq(nPE, UInt<2>("h2")) @[AllToAllMesh.scala 163:25]
    node _T_11 = eq(nPE, UInt<2>("h3")) @[AllToAllMesh.scala 163:25]
    node _T_12 = eq(nPE, UInt<3>("h4")) @[AllToAllMesh.scala 163:25]
    node _T_13 = eq(nPE, UInt<3>("h5")) @[AllToAllMesh.scala 163:25]
    node _T_14 = eq(nPE, UInt<3>("h6")) @[AllToAllMesh.scala 163:25]
    node _T_15 = eq(nPE, UInt<3>("h7")) @[AllToAllMesh.scala 163:25]
    node _T_16 = eq(nPE, UInt<4>("h8")) @[AllToAllMesh.scala 163:25]
    io.resp.bits.data <= vector_0.io.resp.bits.data @[AllToAllMesh.scala 168:23]
    node _T_17 = or(vector_0.io.busy, vector_1.io.busy) @[AllToAllMesh.scala 173:47]
    node _T_18 = or(_T_17, vector_2.io.busy) @[AllToAllMesh.scala 173:47]
    node _T_19 = or(_T_18, vector_3.io.busy) @[AllToAllMesh.scala 173:47]
    node _T_20 = or(_T_19, vector_4.io.busy) @[AllToAllMesh.scala 173:47]
    node _T_21 = or(_T_20, vector_5.io.busy) @[AllToAllMesh.scala 173:47]
    node _T_22 = or(_T_21, vector_6.io.busy) @[AllToAllMesh.scala 173:47]
    node _T_23 = or(_T_22, vector_7.io.busy) @[AllToAllMesh.scala 173:47]
    node _T_24 = or(_T_23, vector_8.io.busy) @[AllToAllMesh.scala 173:47]
    io.busy <= _T_24 @[AllToAllMesh.scala 173:13]
    node _T_25 = and(vector_0.io.cmd.ready, vector_1.io.cmd.ready) @[AllToAllMesh.scala 174:57]
    node _T_26 = and(_T_25, vector_2.io.cmd.ready) @[AllToAllMesh.scala 174:57]
    node _T_27 = and(_T_26, vector_3.io.cmd.ready) @[AllToAllMesh.scala 174:57]
    node _T_28 = and(_T_27, vector_4.io.cmd.ready) @[AllToAllMesh.scala 174:57]
    node _T_29 = and(_T_28, vector_5.io.cmd.ready) @[AllToAllMesh.scala 174:57]
    node _T_30 = and(_T_29, vector_6.io.cmd.ready) @[AllToAllMesh.scala 174:57]
    node _T_31 = and(_T_30, vector_7.io.cmd.ready) @[AllToAllMesh.scala 174:57]
    node _T_32 = and(_T_31, vector_8.io.cmd.ready) @[AllToAllMesh.scala 174:57]
    io.cmd.ready <= _T_32 @[AllToAllMesh.scala 174:18]
    node _T_33 = and(vector_0.io.resp.valid, vector_1.io.resp.valid) @[AllToAllMesh.scala 175:59]
    node _T_34 = and(_T_33, vector_2.io.resp.valid) @[AllToAllMesh.scala 175:59]
    node _T_35 = and(_T_34, vector_3.io.resp.valid) @[AllToAllMesh.scala 175:59]
    node _T_36 = and(_T_35, vector_4.io.resp.valid) @[AllToAllMesh.scala 175:59]
    node _T_37 = and(_T_36, vector_5.io.resp.valid) @[AllToAllMesh.scala 175:59]
    node _T_38 = and(_T_37, vector_6.io.resp.valid) @[AllToAllMesh.scala 175:59]
    node _T_39 = and(_T_38, vector_7.io.resp.valid) @[AllToAllMesh.scala 175:59]
    node _T_40 = and(_T_39, vector_8.io.resp.valid) @[AllToAllMesh.scala 175:59]
    io.resp.valid <= _T_40 @[AllToAllMesh.scala 175:19]
    vector_0.io.left.in <= UInt<64>("h0") @[AllToAllMesh.scala 183:34]
    vector_0.io.up.in <= UInt<64>("h0") @[AllToAllMesh.scala 185:32]
    vector_0.io.right.in <= vector_1.io.left.out @[AllToAllMesh.scala 189:35]
    vector_0.io.bottom.in <= vector_3.io.up.out @[AllToAllMesh.scala 191:36]
    vector_1.io.up.in <= UInt<64>("h0") @[AllToAllMesh.scala 235:32]
    vector_1.io.left.in <= vector_0.io.right.out @[AllToAllMesh.scala 238:34]
    vector_1.io.right.in <= vector_2.io.left.out @[AllToAllMesh.scala 240:35]
    vector_1.io.bottom.in <= vector_4.io.up.out @[AllToAllMesh.scala 242:36]
    vector_2.io.right.in <= UInt<64>("h0") @[AllToAllMesh.scala 197:35]
    vector_2.io.up.in <= UInt<64>("h0") @[AllToAllMesh.scala 199:32]
    vector_2.io.left.in <= vector_1.io.right.out @[AllToAllMesh.scala 203:34]
    vector_2.io.bottom.in <= vector_5.io.up.out @[AllToAllMesh.scala 205:36]
    vector_3.io.left.in <= UInt<64>("h0") @[AllToAllMesh.scala 257:34]
    vector_3.io.right.in <= vector_4.io.left.out @[AllToAllMesh.scala 260:35]
    vector_3.io.up.in <= vector_0.io.bottom.out @[AllToAllMesh.scala 262:32]
    vector_3.io.bottom.in <= vector_6.io.up.out @[AllToAllMesh.scala 264:36]
    vector_4.io.left.in <= vector_3.io.right.out @[AllToAllMesh.scala 280:34]
    vector_4.io.right.in <= vector_5.io.left.out @[AllToAllMesh.scala 282:35]
    vector_4.io.up.in <= vector_1.io.bottom.out @[AllToAllMesh.scala 284:32]
    vector_4.io.bottom.in <= vector_7.io.up.out @[AllToAllMesh.scala 286:36]
    vector_5.io.right.in <= UInt<64>("h0") @[AllToAllMesh.scala 268:35]
    vector_5.io.left.in <= vector_4.io.right.out @[AllToAllMesh.scala 271:34]
    vector_5.io.up.in <= vector_2.io.bottom.out @[AllToAllMesh.scala 273:32]
    vector_5.io.bottom.in <= vector_8.io.up.out @[AllToAllMesh.scala 275:36]
    vector_6.io.left.in <= UInt<64>("h0") @[AllToAllMesh.scala 210:34]
    vector_6.io.bottom.in <= UInt<64>("h0") @[AllToAllMesh.scala 212:36]
    vector_6.io.right.in <= vector_7.io.left.out @[AllToAllMesh.scala 216:35]
    vector_6.io.up.in <= vector_3.io.bottom.out @[AllToAllMesh.scala 218:32]
    vector_7.io.bottom.in <= UInt<64>("h0") @[AllToAllMesh.scala 246:36]
    vector_7.io.left.in <= vector_6.io.right.out @[AllToAllMesh.scala 249:34]
    vector_7.io.right.in <= vector_8.io.left.out @[AllToAllMesh.scala 251:35]
    vector_7.io.up.in <= vector_4.io.bottom.out @[AllToAllMesh.scala 253:32]
    vector_8.io.right.in <= UInt<64>("h0") @[AllToAllMesh.scala 223:35]
    vector_8.io.bottom.in <= UInt<64>("h0") @[AllToAllMesh.scala 225:36]
    vector_8.io.left.in <= vector_7.io.right.out @[AllToAllMesh.scala 229:34]
    vector_8.io.up.in <= vector_5.io.bottom.out @[AllToAllMesh.scala 231:32]

  module AllToAllModule :
    input clock : Clock
    input reset : Reset
    output io : { flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { inst : { funct : UInt<7>, rs2 : UInt<5>, rs1 : UInt<5>, xd : UInt<1>, xs1 : UInt<1>, xs2 : UInt<1>, rd : UInt<5>, opcode : UInt<7>}, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { rd : UInt<5>, data : UInt<64>}}, busy : UInt<1>, interrupt : UInt<1>, flip exception : UInt<1>}

    inst controller of AllToAllController @[AllToAllAccelerator.scala 71:26]
    controller.clock <= clock
    controller.reset <= reset
    inst mesh of AllToAllMesh @[AllToAllAccelerator.scala 72:20]
    mesh.clock <= clock
    mesh.reset <= reset
    controller.io.processor.exception <= io.exception @[AllToAllAccelerator.scala 78:6]
    io.interrupt <= controller.io.processor.interrupt @[AllToAllAccelerator.scala 78:6]
    io.busy <= controller.io.processor.busy @[AllToAllAccelerator.scala 78:6]
    io.resp.bits.data <= controller.io.processor.resp.bits.data @[AllToAllAccelerator.scala 78:6]
    io.resp.bits.rd <= controller.io.processor.resp.bits.rd @[AllToAllAccelerator.scala 78:6]
    io.resp.valid <= controller.io.processor.resp.valid @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.resp.ready <= io.resp.ready @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.bits.inst.opcode <= io.cmd.bits.inst.opcode @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.bits.inst.rd <= io.cmd.bits.inst.rd @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.bits.inst.xs2 <= io.cmd.bits.inst.xs2 @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.bits.inst.xs1 <= io.cmd.bits.inst.xs1 @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.bits.inst.xd <= io.cmd.bits.inst.xd @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.bits.inst.rs1 <= io.cmd.bits.inst.rs1 @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.bits.inst.rs2 <= io.cmd.bits.inst.rs2 @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.bits.inst.funct <= io.cmd.bits.inst.funct @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.valid <= io.cmd.valid @[AllToAllAccelerator.scala 78:6]
    io.cmd.ready <= controller.io.processor.cmd.ready @[AllToAllAccelerator.scala 78:6]
    mesh.io.cmd.valid <= controller.io.mesh.cmd.valid @[AllToAllAccelerator.scala 83:21]
    mesh.io.cmd.bits.load <= controller.io.mesh.cmd.bits.load @[AllToAllAccelerator.scala 84:25]
    mesh.io.cmd.bits.store <= controller.io.mesh.cmd.bits.store @[AllToAllAccelerator.scala 85:26]
    mesh.io.cmd.bits.doAllToAll <= controller.io.mesh.cmd.bits.doAllToAll @[AllToAllAccelerator.scala 86:31]
    mesh.io.cmd.bits.rs1 <= controller.io.mesh.cmd.bits.rs1 @[AllToAllAccelerator.scala 87:24]
    mesh.io.cmd.bits.rs2 <= controller.io.mesh.cmd.bits.rs2 @[AllToAllAccelerator.scala 88:24]
    mesh.io.resp.ready <= controller.io.mesh.resp.ready @[AllToAllAccelerator.scala 89:22]
    controller.io.mesh.cmd.ready <= mesh.io.cmd.ready @[AllToAllAccelerator.scala 92:32]
    controller.io.mesh.resp.valid <= mesh.io.resp.valid @[AllToAllAccelerator.scala 93:33]
    controller.io.mesh.resp.bits.data <= mesh.io.resp.bits.data @[AllToAllAccelerator.scala 94:37]
    controller.io.mesh.busy <= mesh.io.busy @[AllToAllAccelerator.scala 95:27]

  module AllToAll :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { inst : { funct : UInt<7>, rs2 : UInt<5>, rs1 : UInt<5>, xd : UInt<1>, xs1 : UInt<1>, xs2 : UInt<1>, rd : UInt<5>, opcode : UInt<7>}, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { rd : UInt<5>, data : UInt<64>}}, busy : UInt<1>, interrupt : UInt<1>, flip exception : UInt<1>}

    inst aTaModule of AllToAllModule @[AllToAllTest.scala 13:25]
    aTaModule.clock <= clock
    aTaModule.reset <= reset
    aTaModule.io.cmd.valid <= io.cmd.valid @[AllToAllTest.scala 16:26]
    aTaModule.io.cmd.bits.inst.funct <= io.cmd.bits.inst.funct @[AllToAllTest.scala 17:36]
    aTaModule.io.cmd.bits.inst.rs2 <= io.cmd.bits.inst.rs2 @[AllToAllTest.scala 18:34]
    aTaModule.io.cmd.bits.inst.rs1 <= io.cmd.bits.inst.rs1 @[AllToAllTest.scala 19:34]
    aTaModule.io.cmd.bits.inst.xd <= io.cmd.bits.inst.xd @[AllToAllTest.scala 20:33]
    aTaModule.io.cmd.bits.inst.xs1 <= io.cmd.bits.inst.xs1 @[AllToAllTest.scala 21:34]
    aTaModule.io.cmd.bits.inst.xs2 <= io.cmd.bits.inst.xs2 @[AllToAllTest.scala 22:34]
    aTaModule.io.cmd.bits.inst.rd <= io.cmd.bits.inst.rd @[AllToAllTest.scala 23:33]
    aTaModule.io.cmd.bits.inst.opcode <= io.cmd.bits.inst.opcode @[AllToAllTest.scala 24:37]
    aTaModule.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllTest.scala 25:29]
    aTaModule.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllTest.scala 26:29]
    aTaModule.io.resp.ready <= io.resp.ready @[AllToAllTest.scala 27:27]
    io.cmd.ready <= aTaModule.io.cmd.ready @[AllToAllTest.scala 31:16]
    io.resp.valid <= aTaModule.io.resp.valid @[AllToAllTest.scala 32:17]
    io.resp.bits.rd <= aTaModule.io.resp.bits.rd @[AllToAllTest.scala 33:19]
    io.resp.bits.data <= aTaModule.io.resp.bits.data @[AllToAllTest.scala 34:21]
    io.interrupt <= aTaModule.io.interrupt @[AllToAllTest.scala 37:16]
    io.busy <= aTaModule.io.busy @[AllToAllTest.scala 38:11]
    aTaModule.io.exception <= io.exception @[AllToAllTest.scala 41:26]


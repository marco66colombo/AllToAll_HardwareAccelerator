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
    io.mesh.cmd.valid <= io.processor.cmd.valid @[AllToAllController.scala 66:21]
    io.mesh.cmd.bits.rs1 <= io.processor.cmd.bits.rs1 @[AllToAllController.scala 67:24]
    io.mesh.cmd.bits.rs2 <= io.processor.cmd.bits.rs2 @[AllToAllController.scala 68:24]
    io.processor.resp.bits.data <= io.mesh.resp.bits.data @[AllToAllController.scala 70:19]
    io.processor.resp.valid <= io.mesh.resp.ready @[AllToAllController.scala 72:15]
    node _T_3 = eq(io.processor.cmd.bits.inst.opcode, UInt<6>("h2b")) @[AllToAllController.scala 80:59]
    node goto_excange = and(io.processor.cmd.valid, _T_3) @[AllToAllController.scala 80:33]
    node goto_done_exchange = eq(io.mesh.busy, UInt<1>("h0")) @[AllToAllController.scala 83:28]
    node loadSignal = eq(io.processor.cmd.bits.inst.funct, UInt<1>("h1")) @[AllToAllController.scala 84:41]
    node storeSignal = eq(io.processor.cmd.bits.inst.funct, UInt<2>("h2")) @[AllToAllController.scala 85:42]
    node _T_4 = eq(io.processor.cmd.bits.inst.opcode, UInt<4>("hb")) @[AllToAllController.scala 86:54]
    node mem_cmd = and(io.processor.cmd.valid, _T_4) @[AllToAllController.scala 86:28]
    node _T_5 = eq(state, UInt<3>("h0")) @[AllToAllController.scala 88:14]
    when _T_5 : @[AllToAllController.scala 88:23]
      io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 90:23]
      io.processor.cmd.ready <= UInt<1>("h1") @[AllToAllController.scala 92:16]
      io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 96:27]
      io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 97:28]
      io.mesh.cmd.bits.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 98:33]
      io.mesh.resp.ready <= UInt<1>("h0") @[AllToAllController.scala 100:24]
      when goto_excange : @[AllToAllController.scala 103:23]
        state <= UInt<3>("h1") @[AllToAllController.scala 104:13]
      else :
        when mem_cmd : @[AllToAllController.scala 105:24]
          state <= UInt<3>("h3") @[AllToAllController.scala 106:13]
        else :
          state <= UInt<3>("h0") @[AllToAllController.scala 108:13]
    else :
      node _T_6 = eq(state, UInt<3>("h3")) @[AllToAllController.scala 110:20]
      when _T_6 : @[AllToAllController.scala 110:38]
        io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 113:23]
        io.processor.cmd.ready <= UInt<1>("h1") @[AllToAllController.scala 115:16]
        io.mesh.cmd.bits.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 117:33]
        io.mesh.resp.ready <= UInt<1>("h0") @[AllToAllController.scala 118:24]
        when loadSignal : @[AllToAllController.scala 120:21]
          io.mesh.cmd.bits.load <= UInt<1>("h1") @[AllToAllController.scala 121:29]
          io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 122:30]
        else :
          when storeSignal : @[AllToAllController.scala 123:28]
            io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 124:29]
            io.mesh.cmd.bits.store <= UInt<1>("h1") @[AllToAllController.scala 125:30]
          else :
            io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 127:29]
            io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 128:30]
        when goto_excange : @[AllToAllController.scala 131:23]
          state <= UInt<3>("h6") @[AllToAllController.scala 132:13]
        else :
          when mem_cmd : @[AllToAllController.scala 133:24]
            state <= UInt<3>("h4") @[AllToAllController.scala 134:13]
          else :
            state <= UInt<3>("h5") @[AllToAllController.scala 136:13]
      else :
        node _T_7 = eq(state, UInt<3>("h5")) @[AllToAllController.scala 139:20]
        when _T_7 : @[AllToAllController.scala 139:38]
          io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 141:23]
          io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 143:16]
          io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 146:27]
          io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 147:28]
          io.mesh.cmd.bits.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 148:33]
          io.mesh.resp.ready <= UInt<1>("h1") @[AllToAllController.scala 149:24]
          state <= UInt<3>("h0") @[AllToAllController.scala 151:11]
        else :
          node _T_8 = eq(state, UInt<3>("h4")) @[AllToAllController.scala 153:20]
          when _T_8 : @[AllToAllController.scala 153:41]
            io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 155:23]
            io.processor.cmd.ready <= UInt<1>("h1") @[AllToAllController.scala 157:16]
            io.mesh.cmd.bits.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 159:33]
            io.mesh.resp.ready <= UInt<1>("h1") @[AllToAllController.scala 160:24]
            when loadSignal : @[AllToAllController.scala 162:21]
              io.mesh.cmd.bits.load <= UInt<1>("h1") @[AllToAllController.scala 163:29]
              io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 164:30]
            else :
              when storeSignal : @[AllToAllController.scala 165:28]
                io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 166:29]
                io.mesh.cmd.bits.store <= UInt<1>("h1") @[AllToAllController.scala 167:30]
              else :
                io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 169:29]
                io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 170:30]
            when goto_excange : @[AllToAllController.scala 173:23]
              state <= UInt<3>("h6") @[AllToAllController.scala 174:13]
            else :
              when mem_cmd : @[AllToAllController.scala 175:24]
                state <= UInt<3>("h4") @[AllToAllController.scala 176:13]
              else :
                state <= UInt<3>("h5") @[AllToAllController.scala 178:13]
          else :
            node _T_9 = eq(state, UInt<3>("h6")) @[AllToAllController.scala 181:20]
            when _T_9 : @[AllToAllController.scala 181:44]
              io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 183:23]
              io.processor.cmd.ready <= UInt<1>("h1") @[AllToAllController.scala 185:16]
              io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 188:27]
              io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 189:28]
              io.mesh.cmd.bits.doAllToAll <= UInt<1>("h1") @[AllToAllController.scala 190:33]
              io.mesh.resp.ready <= UInt<1>("h1") @[AllToAllController.scala 191:24]
              state <= UInt<3>("h7") @[AllToAllController.scala 194:11]
            else :
              node _T_10 = eq(state, UInt<3>("h1")) @[AllToAllController.scala 195:20]
              when _T_10 : @[AllToAllController.scala 195:31]
                io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 197:23]
                io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 199:16]
                io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 202:27]
                io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 203:28]
                io.mesh.cmd.bits.doAllToAll <= UInt<1>("h1") @[AllToAllController.scala 204:33]
                io.mesh.resp.ready <= UInt<1>("h0") @[AllToAllController.scala 205:24]
                state <= UInt<3>("h7") @[AllToAllController.scala 208:11]
              else :
                node _T_11 = eq(state, UInt<3>("h7")) @[AllToAllController.scala 209:20]
                when _T_11 : @[AllToAllController.scala 209:41]
                  io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 211:23]
                  io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 213:16]
                  io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 216:27]
                  io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 217:28]
                  io.mesh.cmd.bits.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 218:33]
                  io.mesh.resp.ready <= UInt<1>("h0") @[AllToAllController.scala 219:24]
                  when goto_done_exchange : @[AllToAllController.scala 222:29]
                    state <= UInt<3>("h2") @[AllToAllController.scala 223:13]
                  else :
                    state <= UInt<3>("h7") @[AllToAllController.scala 225:13]
                else :
                  node _T_12 = eq(state, UInt<3>("h2")) @[AllToAllController.scala 227:20]
                  when _T_12 : @[AllToAllController.scala 227:36]
                    io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 228:23]
                    io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 230:16]
                    io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 233:27]
                    io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 234:28]
                    io.mesh.cmd.bits.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 235:33]
                    io.mesh.resp.ready <= UInt<1>("h1") @[AllToAllController.scala 236:24]
                  else :
                    io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 240:23]
                    io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 242:16]
                    io.mesh.cmd.bits.load <= UInt<1>("h0") @[AllToAllController.scala 246:27]
                    io.mesh.cmd.bits.store <= UInt<1>("h0") @[AllToAllController.scala 247:28]
                    io.mesh.cmd.bits.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 248:33]
                    io.mesh.resp.ready <= UInt<1>("h0") @[AllToAllController.scala 250:24]

  module AllToAllPEupLeftCorner :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:20]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:20]
    x_coord <= UInt<16>("h0") @[AllToAllPE.scala 134:11]
    y_coord <= UInt<16>("h2") @[AllToAllPE.scala 135:11]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 144:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 145:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 146:23]
    node x_value = bits(io.cmd.bits.rs2, 15, 0) @[AllToAllPE.scala 147:32]
    node y_value = bits(io.cmd.bits.rs2, 31, 16) @[AllToAllPE.scala 148:32]
    node memIndex = bits(io.cmd.bits.rs2, 63, 32) @[AllToAllPE.scala 149:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 152:28]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 152:51]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 152:40]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 153:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 154:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 155:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 157:14]
    when _T_2 : @[AllToAllPE.scala 157:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 158:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 159:18]
      io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 160:19]
      io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 161:23]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 162:17]
      when load_signal : @[AllToAllPE.scala 164:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 165:13]
      else :
        when store_signal : @[AllToAllPE.scala 166:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 167:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 168:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 169:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 171:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 174:20]
      when _T_3 : @[AllToAllPE.scala 174:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 175:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 176:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 177:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 178:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 179:17]
        when is_this_PE : @[AllToAllPE.scala 181:21]
          node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 182:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 182:12]
          MPORT <= io.cmd.bits.rs1 @[AllToAllPE.scala 182:23]
        resp_value <= UInt<64>("h0") @[AllToAllPE.scala 184:16]
        when load_signal : @[AllToAllPE.scala 186:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 187:13]
        else :
          when store_signal : @[AllToAllPE.scala 188:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 189:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 190:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 191:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 193:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 196:20]
        when _T_5 : @[AllToAllPE.scala 196:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 198:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 199:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 200:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 201:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 202:17]
          when is_this_PE : @[AllToAllPE.scala 204:21]
            node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 205:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 205:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 205:18]
          when load_signal : @[AllToAllPE.scala 208:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 209:13]
          else :
            when store_signal : @[AllToAllPE.scala 210:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 211:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 212:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 213:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 215:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 218:20]
          when _T_7 : @[AllToAllPE.scala 218:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 219:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 220:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 221:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 222:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 224:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 226:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 227:20]
            when _T_8 : @[AllToAllPE.scala 227:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 228:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 229:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 230:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 231:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 233:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 235:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 237:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 238:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 239:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 240:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 300:15]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 302:13]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 304:16]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 305:17]
    io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 307:21]

  module AllToAllPEup :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:20]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:20]
    x_coord <= UInt<16>("h1") @[AllToAllPE.scala 134:11]
    y_coord <= UInt<16>("h2") @[AllToAllPE.scala 135:11]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 144:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 145:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 146:23]
    node x_value = bits(io.cmd.bits.rs2, 15, 0) @[AllToAllPE.scala 147:32]
    node y_value = bits(io.cmd.bits.rs2, 31, 16) @[AllToAllPE.scala 148:32]
    node memIndex = bits(io.cmd.bits.rs2, 63, 32) @[AllToAllPE.scala 149:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 152:28]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 152:51]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 152:40]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 153:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 154:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 155:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 157:14]
    when _T_2 : @[AllToAllPE.scala 157:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 158:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 159:18]
      io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 160:19]
      io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 161:23]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 162:17]
      when load_signal : @[AllToAllPE.scala 164:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 165:13]
      else :
        when store_signal : @[AllToAllPE.scala 166:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 167:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 168:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 169:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 171:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 174:20]
      when _T_3 : @[AllToAllPE.scala 174:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 175:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 176:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 177:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 178:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 179:17]
        when is_this_PE : @[AllToAllPE.scala 181:21]
          node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 182:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 182:12]
          MPORT <= io.cmd.bits.rs1 @[AllToAllPE.scala 182:23]
        resp_value <= UInt<64>("h0") @[AllToAllPE.scala 184:16]
        when load_signal : @[AllToAllPE.scala 186:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 187:13]
        else :
          when store_signal : @[AllToAllPE.scala 188:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 189:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 190:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 191:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 193:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 196:20]
        when _T_5 : @[AllToAllPE.scala 196:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 198:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 199:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 200:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 201:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 202:17]
          when is_this_PE : @[AllToAllPE.scala 204:21]
            node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 205:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 205:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 205:18]
          when load_signal : @[AllToAllPE.scala 208:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 209:13]
          else :
            when store_signal : @[AllToAllPE.scala 210:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 211:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 212:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 213:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 215:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 218:20]
          when _T_7 : @[AllToAllPE.scala 218:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 219:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 220:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 221:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 222:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 224:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 226:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 227:20]
            when _T_8 : @[AllToAllPE.scala 227:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 228:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 229:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 230:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 231:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 233:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 235:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 237:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 238:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 239:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 240:23]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 356:13]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 358:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 359:16]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 360:17]
    io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 362:21]

  module AllToAllPEupRightCorner :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:20]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:20]
    x_coord <= UInt<16>("h2") @[AllToAllPE.scala 134:11]
    y_coord <= UInt<16>("h2") @[AllToAllPE.scala 135:11]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 144:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 145:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 146:23]
    node x_value = bits(io.cmd.bits.rs2, 15, 0) @[AllToAllPE.scala 147:32]
    node y_value = bits(io.cmd.bits.rs2, 31, 16) @[AllToAllPE.scala 148:32]
    node memIndex = bits(io.cmd.bits.rs2, 63, 32) @[AllToAllPE.scala 149:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 152:28]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 152:51]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 152:40]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 153:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 154:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 155:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 157:14]
    when _T_2 : @[AllToAllPE.scala 157:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 158:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 159:18]
      io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 160:19]
      io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 161:23]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 162:17]
      when load_signal : @[AllToAllPE.scala 164:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 165:13]
      else :
        when store_signal : @[AllToAllPE.scala 166:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 167:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 168:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 169:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 171:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 174:20]
      when _T_3 : @[AllToAllPE.scala 174:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 175:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 176:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 177:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 178:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 179:17]
        when is_this_PE : @[AllToAllPE.scala 181:21]
          node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 182:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 182:12]
          MPORT <= io.cmd.bits.rs1 @[AllToAllPE.scala 182:23]
        resp_value <= UInt<64>("h0") @[AllToAllPE.scala 184:16]
        when load_signal : @[AllToAllPE.scala 186:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 187:13]
        else :
          when store_signal : @[AllToAllPE.scala 188:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 189:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 190:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 191:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 193:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 196:20]
        when _T_5 : @[AllToAllPE.scala 196:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 198:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 199:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 200:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 201:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 202:17]
          when is_this_PE : @[AllToAllPE.scala 204:21]
            node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 205:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 205:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 205:18]
          when load_signal : @[AllToAllPE.scala 208:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 209:13]
          else :
            when store_signal : @[AllToAllPE.scala 210:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 211:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 212:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 213:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 215:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 218:20]
          when _T_7 : @[AllToAllPE.scala 218:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 219:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 220:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 221:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 222:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 224:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 226:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 227:20]
            when _T_8 : @[AllToAllPE.scala 227:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 228:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 229:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 230:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 231:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 233:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 235:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 237:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 238:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 239:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 240:23]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 314:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 316:13]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 318:15]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 319:17]
    io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 321:21]

  module AllToAllPEleft :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:20]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:20]
    x_coord <= UInt<16>("h0") @[AllToAllPE.scala 134:11]
    y_coord <= UInt<16>("h1") @[AllToAllPE.scala 135:11]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 144:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 145:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 146:23]
    node x_value = bits(io.cmd.bits.rs2, 15, 0) @[AllToAllPE.scala 147:32]
    node y_value = bits(io.cmd.bits.rs2, 31, 16) @[AllToAllPE.scala 148:32]
    node memIndex = bits(io.cmd.bits.rs2, 63, 32) @[AllToAllPE.scala 149:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 152:28]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 152:51]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 152:40]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 153:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 154:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 155:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 157:14]
    when _T_2 : @[AllToAllPE.scala 157:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 158:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 159:18]
      io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 160:19]
      io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 161:23]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 162:17]
      when load_signal : @[AllToAllPE.scala 164:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 165:13]
      else :
        when store_signal : @[AllToAllPE.scala 166:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 167:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 168:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 169:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 171:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 174:20]
      when _T_3 : @[AllToAllPE.scala 174:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 175:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 176:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 177:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 178:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 179:17]
        when is_this_PE : @[AllToAllPE.scala 181:21]
          node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 182:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 182:12]
          MPORT <= io.cmd.bits.rs1 @[AllToAllPE.scala 182:23]
        resp_value <= UInt<64>("h0") @[AllToAllPE.scala 184:16]
        when load_signal : @[AllToAllPE.scala 186:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 187:13]
        else :
          when store_signal : @[AllToAllPE.scala 188:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 189:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 190:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 191:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 193:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 196:20]
        when _T_5 : @[AllToAllPE.scala 196:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 198:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 199:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 200:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 201:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 202:17]
          when is_this_PE : @[AllToAllPE.scala 204:21]
            node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 205:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 205:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 205:18]
          when load_signal : @[AllToAllPE.scala 208:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 209:13]
          else :
            when store_signal : @[AllToAllPE.scala 210:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 211:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 212:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 213:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 215:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 218:20]
          when _T_7 : @[AllToAllPE.scala 218:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 219:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 220:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 221:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 222:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 224:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 226:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 227:20]
            when _T_8 : @[AllToAllPE.scala 227:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 228:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 229:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 230:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 231:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 233:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 235:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 237:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 238:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 239:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 240:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 380:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 382:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 383:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 384:17]
    io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 386:21]

  module AllToAllPEmiddle :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:20]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:20]
    x_coord <= UInt<16>("h1") @[AllToAllPE.scala 134:11]
    y_coord <= UInt<16>("h1") @[AllToAllPE.scala 135:11]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 144:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 145:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 146:23]
    node x_value = bits(io.cmd.bits.rs2, 15, 0) @[AllToAllPE.scala 147:32]
    node y_value = bits(io.cmd.bits.rs2, 31, 16) @[AllToAllPE.scala 148:32]
    node memIndex = bits(io.cmd.bits.rs2, 63, 32) @[AllToAllPE.scala 149:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 152:28]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 152:51]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 152:40]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 153:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 154:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 155:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 157:14]
    when _T_2 : @[AllToAllPE.scala 157:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 158:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 159:18]
      io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 160:19]
      io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 161:23]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 162:17]
      when load_signal : @[AllToAllPE.scala 164:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 165:13]
      else :
        when store_signal : @[AllToAllPE.scala 166:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 167:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 168:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 169:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 171:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 174:20]
      when _T_3 : @[AllToAllPE.scala 174:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 175:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 176:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 177:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 178:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 179:17]
        when is_this_PE : @[AllToAllPE.scala 181:21]
          node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 182:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 182:12]
          MPORT <= io.cmd.bits.rs1 @[AllToAllPE.scala 182:23]
        resp_value <= UInt<64>("h0") @[AllToAllPE.scala 184:16]
        when load_signal : @[AllToAllPE.scala 186:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 187:13]
        else :
          when store_signal : @[AllToAllPE.scala 188:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 189:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 190:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 191:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 193:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 196:20]
        when _T_5 : @[AllToAllPE.scala 196:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 198:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 199:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 200:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 201:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 202:17]
          when is_this_PE : @[AllToAllPE.scala 204:21]
            node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 205:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 205:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 205:18]
          when load_signal : @[AllToAllPE.scala 208:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 209:13]
          else :
            when store_signal : @[AllToAllPE.scala 210:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 211:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 212:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 213:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 215:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 218:20]
          when _T_7 : @[AllToAllPE.scala 218:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 219:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 220:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 221:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 222:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 224:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 226:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 227:20]
            when _T_8 : @[AllToAllPE.scala 227:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 228:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 229:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 230:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 231:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 233:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 235:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 237:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 238:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 239:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 240:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 403:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 404:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 405:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 406:17]
    io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 408:21]

  module AllToAllPEright :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:20]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:20]
    x_coord <= UInt<16>("h2") @[AllToAllPE.scala 134:11]
    y_coord <= UInt<16>("h1") @[AllToAllPE.scala 135:11]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 144:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 145:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 146:23]
    node x_value = bits(io.cmd.bits.rs2, 15, 0) @[AllToAllPE.scala 147:32]
    node y_value = bits(io.cmd.bits.rs2, 31, 16) @[AllToAllPE.scala 148:32]
    node memIndex = bits(io.cmd.bits.rs2, 63, 32) @[AllToAllPE.scala 149:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 152:28]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 152:51]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 152:40]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 153:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 154:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 155:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 157:14]
    when _T_2 : @[AllToAllPE.scala 157:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 158:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 159:18]
      io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 160:19]
      io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 161:23]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 162:17]
      when load_signal : @[AllToAllPE.scala 164:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 165:13]
      else :
        when store_signal : @[AllToAllPE.scala 166:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 167:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 168:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 169:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 171:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 174:20]
      when _T_3 : @[AllToAllPE.scala 174:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 175:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 176:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 177:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 178:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 179:17]
        when is_this_PE : @[AllToAllPE.scala 181:21]
          node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 182:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 182:12]
          MPORT <= io.cmd.bits.rs1 @[AllToAllPE.scala 182:23]
        resp_value <= UInt<64>("h0") @[AllToAllPE.scala 184:16]
        when load_signal : @[AllToAllPE.scala 186:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 187:13]
        else :
          when store_signal : @[AllToAllPE.scala 188:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 189:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 190:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 191:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 193:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 196:20]
        when _T_5 : @[AllToAllPE.scala 196:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 198:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 199:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 200:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 201:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 202:17]
          when is_this_PE : @[AllToAllPE.scala 204:21]
            node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 205:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 205:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 205:18]
          when load_signal : @[AllToAllPE.scala 208:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 209:13]
          else :
            when store_signal : @[AllToAllPE.scala 210:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 211:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 212:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 213:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 215:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 218:20]
          when _T_7 : @[AllToAllPE.scala 218:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 219:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 220:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 221:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 222:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 224:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 226:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 227:20]
            when _T_8 : @[AllToAllPE.scala 227:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 228:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 229:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 230:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 231:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 233:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 235:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 237:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 238:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 239:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 240:23]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 392:16]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 394:15]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 395:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 396:17]
    io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 398:21]

  module AllToAllPEbottomLeftCorner :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:20]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:20]
    x_coord <= UInt<16>("h0") @[AllToAllPE.scala 134:11]
    y_coord <= UInt<16>("h0") @[AllToAllPE.scala 135:11]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 144:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 145:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 146:23]
    node x_value = bits(io.cmd.bits.rs2, 15, 0) @[AllToAllPE.scala 147:32]
    node y_value = bits(io.cmd.bits.rs2, 31, 16) @[AllToAllPE.scala 148:32]
    node memIndex = bits(io.cmd.bits.rs2, 63, 32) @[AllToAllPE.scala 149:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 152:28]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 152:51]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 152:40]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 153:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 154:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 155:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 157:14]
    when _T_2 : @[AllToAllPE.scala 157:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 158:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 159:18]
      io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 160:19]
      io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 161:23]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 162:17]
      when load_signal : @[AllToAllPE.scala 164:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 165:13]
      else :
        when store_signal : @[AllToAllPE.scala 166:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 167:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 168:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 169:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 171:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 174:20]
      when _T_3 : @[AllToAllPE.scala 174:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 175:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 176:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 177:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 178:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 179:17]
        when is_this_PE : @[AllToAllPE.scala 181:21]
          node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 182:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 182:12]
          MPORT <= io.cmd.bits.rs1 @[AllToAllPE.scala 182:23]
        resp_value <= UInt<64>("h0") @[AllToAllPE.scala 184:16]
        when load_signal : @[AllToAllPE.scala 186:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 187:13]
        else :
          when store_signal : @[AllToAllPE.scala 188:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 189:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 190:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 191:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 193:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 196:20]
        when _T_5 : @[AllToAllPE.scala 196:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 198:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 199:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 200:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 201:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 202:17]
          when is_this_PE : @[AllToAllPE.scala 204:21]
            node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 205:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 205:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 205:18]
          when load_signal : @[AllToAllPE.scala 208:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 209:13]
          else :
            when store_signal : @[AllToAllPE.scala 210:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 211:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 212:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 213:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 215:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 218:20]
          when _T_7 : @[AllToAllPE.scala 218:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 219:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 220:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 221:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 222:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 224:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 226:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 227:20]
            when _T_8 : @[AllToAllPE.scala 227:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 228:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 229:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 230:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 231:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 233:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 235:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 237:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 238:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 239:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 240:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 328:15]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 330:17]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 333:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 334:13]
    io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 336:21]

  module AllToAllPEbottom :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:20]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:20]
    x_coord <= UInt<16>("h1") @[AllToAllPE.scala 134:11]
    y_coord <= UInt<16>("h0") @[AllToAllPE.scala 135:11]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 144:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 145:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 146:23]
    node x_value = bits(io.cmd.bits.rs2, 15, 0) @[AllToAllPE.scala 147:32]
    node y_value = bits(io.cmd.bits.rs2, 31, 16) @[AllToAllPE.scala 148:32]
    node memIndex = bits(io.cmd.bits.rs2, 63, 32) @[AllToAllPE.scala 149:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 152:28]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 152:51]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 152:40]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 153:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 154:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 155:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 157:14]
    when _T_2 : @[AllToAllPE.scala 157:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 158:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 159:18]
      io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 160:19]
      io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 161:23]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 162:17]
      when load_signal : @[AllToAllPE.scala 164:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 165:13]
      else :
        when store_signal : @[AllToAllPE.scala 166:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 167:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 168:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 169:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 171:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 174:20]
      when _T_3 : @[AllToAllPE.scala 174:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 175:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 176:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 177:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 178:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 179:17]
        when is_this_PE : @[AllToAllPE.scala 181:21]
          node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 182:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 182:12]
          MPORT <= io.cmd.bits.rs1 @[AllToAllPE.scala 182:23]
        resp_value <= UInt<64>("h0") @[AllToAllPE.scala 184:16]
        when load_signal : @[AllToAllPE.scala 186:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 187:13]
        else :
          when store_signal : @[AllToAllPE.scala 188:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 189:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 190:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 191:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 193:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 196:20]
        when _T_5 : @[AllToAllPE.scala 196:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 198:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 199:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 200:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 201:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 202:17]
          when is_this_PE : @[AllToAllPE.scala 204:21]
            node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 205:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 205:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 205:18]
          when load_signal : @[AllToAllPE.scala 208:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 209:13]
          else :
            when store_signal : @[AllToAllPE.scala 210:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 211:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 212:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 213:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 215:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 218:20]
          when _T_7 : @[AllToAllPE.scala 218:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 219:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 220:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 221:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 222:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 224:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 226:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 227:20]
            when _T_8 : @[AllToAllPE.scala 227:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 228:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 229:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 230:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 231:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 233:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 235:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 237:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 238:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 239:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 240:23]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 367:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 369:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 370:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 371:13]
    io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 373:21]

  module AllToAllPEbottomRightCorner :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:20]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:20]
    x_coord <= UInt<16>("h2") @[AllToAllPE.scala 134:11]
    y_coord <= UInt<16>("h0") @[AllToAllPE.scala 135:11]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 144:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 145:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 146:23]
    node x_value = bits(io.cmd.bits.rs2, 15, 0) @[AllToAllPE.scala 147:32]
    node y_value = bits(io.cmd.bits.rs2, 31, 16) @[AllToAllPE.scala 148:32]
    node memIndex = bits(io.cmd.bits.rs2, 63, 32) @[AllToAllPE.scala 149:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 152:28]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 152:51]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 152:40]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 153:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 154:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 155:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 157:14]
    when _T_2 : @[AllToAllPE.scala 157:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 158:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 159:18]
      io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 160:19]
      io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 161:23]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 162:17]
      when load_signal : @[AllToAllPE.scala 164:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 165:13]
      else :
        when store_signal : @[AllToAllPE.scala 166:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 167:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 168:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 169:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 171:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 174:20]
      when _T_3 : @[AllToAllPE.scala 174:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 175:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 176:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 177:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 178:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 179:17]
        when is_this_PE : @[AllToAllPE.scala 181:21]
          node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 182:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 182:12]
          MPORT <= io.cmd.bits.rs1 @[AllToAllPE.scala 182:23]
        resp_value <= UInt<64>("h0") @[AllToAllPE.scala 184:16]
        when load_signal : @[AllToAllPE.scala 186:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 187:13]
        else :
          when store_signal : @[AllToAllPE.scala 188:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 189:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 190:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 191:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 193:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 196:20]
        when _T_5 : @[AllToAllPE.scala 196:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 198:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 199:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 200:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 201:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 202:17]
          when is_this_PE : @[AllToAllPE.scala 204:21]
            node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 205:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 205:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 205:18]
          when load_signal : @[AllToAllPE.scala 208:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 209:13]
          else :
            when store_signal : @[AllToAllPE.scala 210:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 211:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 212:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 213:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 215:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 218:20]
          when _T_7 : @[AllToAllPE.scala 218:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 219:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 220:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 221:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 222:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 224:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 226:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 227:20]
            when _T_8 : @[AllToAllPE.scala 227:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 228:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 229:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 230:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 231:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 233:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 235:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 237:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 238:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 239:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 240:23]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 342:16]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 344:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 346:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 347:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 348:13]
    io.resp.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 350:21]

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
    vector_0.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 130:32]
    vector_0.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 131:36]
    vector_0.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 132:37]
    vector_0.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 133:42]
    vector_0.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 135:35]
    vector_0.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 136:35]
    vector_0.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 138:33]
    vector_1.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 130:32]
    vector_1.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 131:36]
    vector_1.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 132:37]
    vector_1.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 133:42]
    vector_1.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 135:35]
    vector_1.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 136:35]
    vector_1.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 138:33]
    vector_2.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 130:32]
    vector_2.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 131:36]
    vector_2.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 132:37]
    vector_2.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 133:42]
    vector_2.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 135:35]
    vector_2.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 136:35]
    vector_2.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 138:33]
    vector_3.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 130:32]
    vector_3.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 131:36]
    vector_3.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 132:37]
    vector_3.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 133:42]
    vector_3.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 135:35]
    vector_3.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 136:35]
    vector_3.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 138:33]
    vector_4.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 130:32]
    vector_4.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 131:36]
    vector_4.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 132:37]
    vector_4.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 133:42]
    vector_4.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 135:35]
    vector_4.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 136:35]
    vector_4.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 138:33]
    vector_5.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 130:32]
    vector_5.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 131:36]
    vector_5.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 132:37]
    vector_5.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 133:42]
    vector_5.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 135:35]
    vector_5.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 136:35]
    vector_5.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 138:33]
    vector_6.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 130:32]
    vector_6.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 131:36]
    vector_6.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 132:37]
    vector_6.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 133:42]
    vector_6.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 135:35]
    vector_6.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 136:35]
    vector_6.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 138:33]
    vector_7.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 130:32]
    vector_7.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 131:36]
    vector_7.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 132:37]
    vector_7.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 133:42]
    vector_7.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 135:35]
    vector_7.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 136:35]
    vector_7.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 138:33]
    vector_8.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 130:32]
    vector_8.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 131:36]
    vector_8.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 132:37]
    vector_8.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 133:42]
    vector_8.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 135:35]
    vector_8.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 136:35]
    vector_8.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 138:33]
    node _T = or(vector_0.io.busy, vector_1.io.busy) @[AllToAllMesh.scala 143:47]
    node _T_1 = or(_T, vector_2.io.busy) @[AllToAllMesh.scala 143:47]
    node _T_2 = or(_T_1, vector_3.io.busy) @[AllToAllMesh.scala 143:47]
    node _T_3 = or(_T_2, vector_4.io.busy) @[AllToAllMesh.scala 143:47]
    node _T_4 = or(_T_3, vector_5.io.busy) @[AllToAllMesh.scala 143:47]
    node _T_5 = or(_T_4, vector_6.io.busy) @[AllToAllMesh.scala 143:47]
    node _T_6 = or(_T_5, vector_7.io.busy) @[AllToAllMesh.scala 143:47]
    node _T_7 = or(_T_6, vector_8.io.busy) @[AllToAllMesh.scala 143:47]
    io.busy <= _T_7 @[AllToAllMesh.scala 143:13]
    node _T_8 = and(vector_0.io.cmd.ready, vector_1.io.cmd.ready) @[AllToAllMesh.scala 144:57]
    node _T_9 = and(_T_8, vector_2.io.cmd.ready) @[AllToAllMesh.scala 144:57]
    node _T_10 = and(_T_9, vector_3.io.cmd.ready) @[AllToAllMesh.scala 144:57]
    node _T_11 = and(_T_10, vector_4.io.cmd.ready) @[AllToAllMesh.scala 144:57]
    node _T_12 = and(_T_11, vector_5.io.cmd.ready) @[AllToAllMesh.scala 144:57]
    node _T_13 = and(_T_12, vector_6.io.cmd.ready) @[AllToAllMesh.scala 144:57]
    node _T_14 = and(_T_13, vector_7.io.cmd.ready) @[AllToAllMesh.scala 144:57]
    node _T_15 = and(_T_14, vector_8.io.cmd.ready) @[AllToAllMesh.scala 144:57]
    io.cmd.ready <= _T_15 @[AllToAllMesh.scala 144:18]
    node _T_16 = and(vector_0.io.resp.valid, vector_1.io.resp.valid) @[AllToAllMesh.scala 145:59]
    node _T_17 = and(_T_16, vector_2.io.resp.valid) @[AllToAllMesh.scala 145:59]
    node _T_18 = and(_T_17, vector_3.io.resp.valid) @[AllToAllMesh.scala 145:59]
    node _T_19 = and(_T_18, vector_4.io.resp.valid) @[AllToAllMesh.scala 145:59]
    node _T_20 = and(_T_19, vector_5.io.resp.valid) @[AllToAllMesh.scala 145:59]
    node _T_21 = and(_T_20, vector_6.io.resp.valid) @[AllToAllMesh.scala 145:59]
    node _T_22 = and(_T_21, vector_7.io.resp.valid) @[AllToAllMesh.scala 145:59]
    node _T_23 = and(_T_22, vector_8.io.resp.valid) @[AllToAllMesh.scala 145:59]
    io.resp.valid <= _T_23 @[AllToAllMesh.scala 145:19]
    node _T_24 = bits(io.cmd.bits.rs2, 15, 0) @[AllToAllMesh.scala 150:18]
    node _T_25 = bits(io.cmd.bits.rs2, 31, 16) @[AllToAllMesh.scala 151:18]
    node _T_26 = sub(UInt<2>("h3"), UInt<1>("h1")) @[AllToAllMesh.scala 152:14]
    node _T_27 = tail(_T_26, 1) @[AllToAllMesh.scala 152:14]
    node _T_28 = sub(_T_27, _T_25) @[AllToAllMesh.scala 152:18]
    node _T_29 = tail(_T_28, 1) @[AllToAllMesh.scala 152:18]
    node _T_30 = mul(_T_29, UInt<2>("h3")) @[AllToAllMesh.scala 152:21]
    node _T_31 = add(_T_30, _T_24) @[AllToAllMesh.scala 152:25]
    node nPE = tail(_T_31, 1) @[AllToAllMesh.scala 152:25]
    node _T_32 = eq(nPE, UInt<1>("h0")) @[AllToAllMesh.scala 159:27]
    node _T_33 = eq(nPE, UInt<1>("h1")) @[AllToAllMesh.scala 162:25]
    node _T_34 = eq(nPE, UInt<2>("h2")) @[AllToAllMesh.scala 162:25]
    node _T_35 = eq(nPE, UInt<2>("h3")) @[AllToAllMesh.scala 162:25]
    node _T_36 = eq(nPE, UInt<3>("h4")) @[AllToAllMesh.scala 162:25]
    node _T_37 = eq(nPE, UInt<3>("h5")) @[AllToAllMesh.scala 162:25]
    node _T_38 = eq(nPE, UInt<3>("h6")) @[AllToAllMesh.scala 162:25]
    node _T_39 = eq(nPE, UInt<3>("h7")) @[AllToAllMesh.scala 162:25]
    node _T_40 = eq(nPE, UInt<4>("h8")) @[AllToAllMesh.scala 162:25]
    io.resp.bits.data <= vector_0.io.resp.bits.data @[AllToAllMesh.scala 168:23]
    vector_0.io.left.in <= UInt<64>("h0") @[AllToAllMesh.scala 177:34]
    vector_0.io.up.in <= UInt<64>("h0") @[AllToAllMesh.scala 179:32]
    vector_0.io.right.in <= vector_1.io.left.out @[AllToAllMesh.scala 183:35]
    vector_0.io.bottom.in <= vector_3.io.up.out @[AllToAllMesh.scala 185:36]
    vector_1.io.up.in <= UInt<64>("h0") @[AllToAllMesh.scala 229:32]
    vector_1.io.left.in <= vector_0.io.right.out @[AllToAllMesh.scala 232:34]
    vector_1.io.right.in <= vector_2.io.left.out @[AllToAllMesh.scala 234:35]
    vector_1.io.bottom.in <= vector_4.io.up.out @[AllToAllMesh.scala 236:36]
    vector_2.io.right.in <= UInt<64>("h0") @[AllToAllMesh.scala 191:35]
    vector_2.io.up.in <= UInt<64>("h0") @[AllToAllMesh.scala 193:32]
    vector_2.io.left.in <= vector_1.io.right.out @[AllToAllMesh.scala 197:34]
    vector_2.io.bottom.in <= vector_5.io.up.out @[AllToAllMesh.scala 199:36]
    vector_3.io.left.in <= UInt<64>("h0") @[AllToAllMesh.scala 251:34]
    vector_3.io.right.in <= vector_4.io.left.out @[AllToAllMesh.scala 254:35]
    vector_3.io.up.in <= vector_0.io.bottom.out @[AllToAllMesh.scala 256:32]
    vector_3.io.bottom.in <= vector_6.io.up.out @[AllToAllMesh.scala 258:36]
    vector_4.io.left.in <= vector_3.io.right.out @[AllToAllMesh.scala 274:34]
    vector_4.io.right.in <= vector_5.io.left.out @[AllToAllMesh.scala 276:35]
    vector_4.io.up.in <= vector_1.io.bottom.out @[AllToAllMesh.scala 278:32]
    vector_4.io.bottom.in <= vector_7.io.up.out @[AllToAllMesh.scala 280:36]
    vector_5.io.right.in <= UInt<64>("h0") @[AllToAllMesh.scala 262:35]
    vector_5.io.left.in <= vector_4.io.right.out @[AllToAllMesh.scala 265:34]
    vector_5.io.up.in <= vector_2.io.bottom.out @[AllToAllMesh.scala 267:32]
    vector_5.io.bottom.in <= vector_8.io.up.out @[AllToAllMesh.scala 269:36]
    vector_6.io.left.in <= UInt<64>("h0") @[AllToAllMesh.scala 204:34]
    vector_6.io.bottom.in <= UInt<64>("h0") @[AllToAllMesh.scala 206:36]
    vector_6.io.right.in <= vector_7.io.left.out @[AllToAllMesh.scala 210:35]
    vector_6.io.up.in <= vector_3.io.bottom.out @[AllToAllMesh.scala 212:32]
    vector_7.io.bottom.in <= UInt<64>("h0") @[AllToAllMesh.scala 240:36]
    vector_7.io.left.in <= vector_6.io.right.out @[AllToAllMesh.scala 243:34]
    vector_7.io.right.in <= vector_8.io.left.out @[AllToAllMesh.scala 245:35]
    vector_7.io.up.in <= vector_4.io.bottom.out @[AllToAllMesh.scala 247:32]
    vector_8.io.right.in <= UInt<64>("h0") @[AllToAllMesh.scala 217:35]
    vector_8.io.bottom.in <= UInt<64>("h0") @[AllToAllMesh.scala 219:36]
    vector_8.io.left.in <= vector_7.io.right.out @[AllToAllMesh.scala 223:34]
    vector_8.io.up.in <= vector_5.io.bottom.out @[AllToAllMesh.scala 225:32]

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


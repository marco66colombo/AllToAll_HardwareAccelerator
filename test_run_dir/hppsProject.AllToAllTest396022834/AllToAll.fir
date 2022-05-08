circuit AllToAll :
  module AllToAllController :
    input clock : Clock
    input reset : Reset
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

  module AllToAllPEupLeftCorner :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, write_enable : UInt<1>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 133:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 136:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<2>("h2")) @[AllToAllPE.scala 137:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 140:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 141:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 143:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 144:7]
    reg w_en : UInt<1>, clock with :
      reset => (UInt<1>("h0"), w_en) @[AllToAllPE.scala 147:17]
    io.resp.bits.write_enable <= w_en @[AllToAllPE.scala 148:29]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 153:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 154:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 155:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 157:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 158:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 159:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 165:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 165:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 165:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 166:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 167:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 168:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 170:14]
    when _T_2 : @[AllToAllPE.scala 170:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 171:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 172:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 173:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 174:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 175:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 176:17]
      w_en <= UInt<1>("h0") @[AllToAllPE.scala 177:10]
      when load_signal : @[AllToAllPE.scala 179:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 180:13]
      else :
        when store_signal : @[AllToAllPE.scala 181:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 182:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 183:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 184:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 186:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 189:20]
      when _T_3 : @[AllToAllPE.scala 189:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 190:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 191:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 192:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 193:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 194:17]
        when is_this_PE : @[AllToAllPE.scala 196:21]
          node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 197:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 197:12]
          MPORT <= rs1 @[AllToAllPE.scala 197:23]
          w_en <= UInt<1>("h1") @[AllToAllPE.scala 198:12]
        else :
          w_en <= UInt<1>("h0") @[AllToAllPE.scala 200:12]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 202:16]
        when load_signal : @[AllToAllPE.scala 204:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 205:13]
        else :
          when store_signal : @[AllToAllPE.scala 206:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 207:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 208:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 209:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 211:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 214:20]
        when _T_5 : @[AllToAllPE.scala 214:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 216:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 217:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 218:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 219:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 220:17]
          when is_this_PE : @[AllToAllPE.scala 222:21]
            node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 223:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 223:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 223:18]
            w_en <= UInt<1>("h1") @[AllToAllPE.scala 224:12]
          else :
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 226:12]
          when load_signal : @[AllToAllPE.scala 229:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 230:13]
          else :
            when store_signal : @[AllToAllPE.scala 231:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 232:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 233:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 234:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 236:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 239:20]
          when _T_7 : @[AllToAllPE.scala 239:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 240:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 241:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 242:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 243:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 246:17]
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 248:10]
            state <= UInt<3>("h2") @[AllToAllPE.scala 250:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 251:20]
            when _T_8 : @[AllToAllPE.scala 251:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 252:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 253:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 254:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 255:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 257:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 259:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 261:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 262:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 263:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 264:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 267:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 268:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 269:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 270:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 308:15]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 310:13]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 312:16]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 313:17]

  module AllToAllPEup :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, write_enable : UInt<1>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 133:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h1")) @[AllToAllPE.scala 136:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<2>("h2")) @[AllToAllPE.scala 137:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 140:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 141:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 143:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 144:7]
    reg w_en : UInt<1>, clock with :
      reset => (UInt<1>("h0"), w_en) @[AllToAllPE.scala 147:17]
    io.resp.bits.write_enable <= w_en @[AllToAllPE.scala 148:29]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 153:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 154:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 155:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 157:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 158:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 159:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 165:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 165:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 165:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 166:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 167:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 168:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 170:14]
    when _T_2 : @[AllToAllPE.scala 170:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 171:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 172:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 173:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 174:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 175:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 176:17]
      w_en <= UInt<1>("h0") @[AllToAllPE.scala 177:10]
      when load_signal : @[AllToAllPE.scala 179:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 180:13]
      else :
        when store_signal : @[AllToAllPE.scala 181:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 182:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 183:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 184:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 186:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 189:20]
      when _T_3 : @[AllToAllPE.scala 189:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 190:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 191:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 192:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 193:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 194:17]
        when is_this_PE : @[AllToAllPE.scala 196:21]
          node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 197:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 197:12]
          MPORT <= rs1 @[AllToAllPE.scala 197:23]
          w_en <= UInt<1>("h1") @[AllToAllPE.scala 198:12]
        else :
          w_en <= UInt<1>("h0") @[AllToAllPE.scala 200:12]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 202:16]
        when load_signal : @[AllToAllPE.scala 204:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 205:13]
        else :
          when store_signal : @[AllToAllPE.scala 206:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 207:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 208:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 209:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 211:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 214:20]
        when _T_5 : @[AllToAllPE.scala 214:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 216:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 217:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 218:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 219:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 220:17]
          when is_this_PE : @[AllToAllPE.scala 222:21]
            node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 223:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 223:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 223:18]
            w_en <= UInt<1>("h1") @[AllToAllPE.scala 224:12]
          else :
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 226:12]
          when load_signal : @[AllToAllPE.scala 229:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 230:13]
          else :
            when store_signal : @[AllToAllPE.scala 231:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 232:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 233:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 234:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 236:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 239:20]
          when _T_7 : @[AllToAllPE.scala 239:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 240:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 241:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 242:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 243:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 246:17]
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 248:10]
            state <= UInt<3>("h2") @[AllToAllPE.scala 250:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 251:20]
            when _T_8 : @[AllToAllPE.scala 251:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 252:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 253:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 254:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 255:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 257:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 259:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 261:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 262:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 263:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 264:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 267:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 268:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 269:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 270:17]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 358:13]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 360:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 361:16]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 362:17]

  module AllToAllPEupRightCorner :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, write_enable : UInt<1>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 133:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<2>("h2")) @[AllToAllPE.scala 136:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<2>("h2")) @[AllToAllPE.scala 137:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 140:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 141:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 143:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 144:7]
    reg w_en : UInt<1>, clock with :
      reset => (UInt<1>("h0"), w_en) @[AllToAllPE.scala 147:17]
    io.resp.bits.write_enable <= w_en @[AllToAllPE.scala 148:29]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 153:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 154:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 155:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 157:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 158:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 159:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 165:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 165:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 165:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 166:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 167:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 168:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 170:14]
    when _T_2 : @[AllToAllPE.scala 170:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 171:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 172:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 173:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 174:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 175:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 176:17]
      w_en <= UInt<1>("h0") @[AllToAllPE.scala 177:10]
      when load_signal : @[AllToAllPE.scala 179:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 180:13]
      else :
        when store_signal : @[AllToAllPE.scala 181:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 182:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 183:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 184:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 186:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 189:20]
      when _T_3 : @[AllToAllPE.scala 189:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 190:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 191:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 192:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 193:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 194:17]
        when is_this_PE : @[AllToAllPE.scala 196:21]
          node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 197:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 197:12]
          MPORT <= rs1 @[AllToAllPE.scala 197:23]
          w_en <= UInt<1>("h1") @[AllToAllPE.scala 198:12]
        else :
          w_en <= UInt<1>("h0") @[AllToAllPE.scala 200:12]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 202:16]
        when load_signal : @[AllToAllPE.scala 204:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 205:13]
        else :
          when store_signal : @[AllToAllPE.scala 206:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 207:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 208:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 209:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 211:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 214:20]
        when _T_5 : @[AllToAllPE.scala 214:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 216:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 217:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 218:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 219:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 220:17]
          when is_this_PE : @[AllToAllPE.scala 222:21]
            node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 223:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 223:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 223:18]
            w_en <= UInt<1>("h1") @[AllToAllPE.scala 224:12]
          else :
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 226:12]
          when load_signal : @[AllToAllPE.scala 229:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 230:13]
          else :
            when store_signal : @[AllToAllPE.scala 231:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 232:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 233:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 234:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 236:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 239:20]
          when _T_7 : @[AllToAllPE.scala 239:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 240:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 241:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 242:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 243:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 246:17]
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 248:10]
            state <= UInt<3>("h2") @[AllToAllPE.scala 250:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 251:20]
            when _T_8 : @[AllToAllPE.scala 251:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 252:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 253:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 254:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 255:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 257:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 259:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 261:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 262:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 263:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 264:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 267:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 268:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 269:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 270:17]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 320:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 322:13]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 324:15]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 325:17]

  module AllToAllPEleft :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, write_enable : UInt<1>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 133:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 136:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h1")) @[AllToAllPE.scala 137:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 140:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 141:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 143:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 144:7]
    reg w_en : UInt<1>, clock with :
      reset => (UInt<1>("h0"), w_en) @[AllToAllPE.scala 147:17]
    io.resp.bits.write_enable <= w_en @[AllToAllPE.scala 148:29]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 153:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 154:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 155:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 157:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 158:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 159:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 165:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 165:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 165:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 166:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 167:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 168:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 170:14]
    when _T_2 : @[AllToAllPE.scala 170:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 171:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 172:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 173:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 174:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 175:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 176:17]
      w_en <= UInt<1>("h0") @[AllToAllPE.scala 177:10]
      when load_signal : @[AllToAllPE.scala 179:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 180:13]
      else :
        when store_signal : @[AllToAllPE.scala 181:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 182:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 183:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 184:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 186:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 189:20]
      when _T_3 : @[AllToAllPE.scala 189:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 190:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 191:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 192:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 193:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 194:17]
        when is_this_PE : @[AllToAllPE.scala 196:21]
          node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 197:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 197:12]
          MPORT <= rs1 @[AllToAllPE.scala 197:23]
          w_en <= UInt<1>("h1") @[AllToAllPE.scala 198:12]
        else :
          w_en <= UInt<1>("h0") @[AllToAllPE.scala 200:12]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 202:16]
        when load_signal : @[AllToAllPE.scala 204:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 205:13]
        else :
          when store_signal : @[AllToAllPE.scala 206:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 207:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 208:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 209:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 211:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 214:20]
        when _T_5 : @[AllToAllPE.scala 214:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 216:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 217:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 218:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 219:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 220:17]
          when is_this_PE : @[AllToAllPE.scala 222:21]
            node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 223:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 223:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 223:18]
            w_en <= UInt<1>("h1") @[AllToAllPE.scala 224:12]
          else :
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 226:12]
          when load_signal : @[AllToAllPE.scala 229:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 230:13]
          else :
            when store_signal : @[AllToAllPE.scala 231:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 232:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 233:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 234:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 236:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 239:20]
          when _T_7 : @[AllToAllPE.scala 239:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 240:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 241:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 242:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 243:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 246:17]
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 248:10]
            state <= UInt<3>("h2") @[AllToAllPE.scala 250:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 251:20]
            when _T_8 : @[AllToAllPE.scala 251:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 252:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 253:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 254:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 255:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 257:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 259:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 261:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 262:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 263:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 264:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 267:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 268:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 269:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 270:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 380:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 382:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 383:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 384:17]

  module AllToAllPEmiddle :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, write_enable : UInt<1>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 133:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h1")) @[AllToAllPE.scala 136:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h1")) @[AllToAllPE.scala 137:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 140:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 141:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 143:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 144:7]
    reg w_en : UInt<1>, clock with :
      reset => (UInt<1>("h0"), w_en) @[AllToAllPE.scala 147:17]
    io.resp.bits.write_enable <= w_en @[AllToAllPE.scala 148:29]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 153:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 154:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 155:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 157:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 158:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 159:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 165:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 165:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 165:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 166:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 167:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 168:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 170:14]
    when _T_2 : @[AllToAllPE.scala 170:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 171:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 172:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 173:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 174:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 175:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 176:17]
      w_en <= UInt<1>("h0") @[AllToAllPE.scala 177:10]
      when load_signal : @[AllToAllPE.scala 179:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 180:13]
      else :
        when store_signal : @[AllToAllPE.scala 181:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 182:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 183:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 184:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 186:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 189:20]
      when _T_3 : @[AllToAllPE.scala 189:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 190:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 191:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 192:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 193:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 194:17]
        when is_this_PE : @[AllToAllPE.scala 196:21]
          node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 197:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 197:12]
          MPORT <= rs1 @[AllToAllPE.scala 197:23]
          w_en <= UInt<1>("h1") @[AllToAllPE.scala 198:12]
        else :
          w_en <= UInt<1>("h0") @[AllToAllPE.scala 200:12]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 202:16]
        when load_signal : @[AllToAllPE.scala 204:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 205:13]
        else :
          when store_signal : @[AllToAllPE.scala 206:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 207:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 208:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 209:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 211:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 214:20]
        when _T_5 : @[AllToAllPE.scala 214:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 216:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 217:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 218:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 219:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 220:17]
          when is_this_PE : @[AllToAllPE.scala 222:21]
            node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 223:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 223:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 223:18]
            w_en <= UInt<1>("h1") @[AllToAllPE.scala 224:12]
          else :
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 226:12]
          when load_signal : @[AllToAllPE.scala 229:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 230:13]
          else :
            when store_signal : @[AllToAllPE.scala 231:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 232:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 233:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 234:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 236:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 239:20]
          when _T_7 : @[AllToAllPE.scala 239:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 240:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 241:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 242:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 243:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 246:17]
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 248:10]
            state <= UInt<3>("h2") @[AllToAllPE.scala 250:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 251:20]
            when _T_8 : @[AllToAllPE.scala 251:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 252:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 253:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 254:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 255:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 257:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 259:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 261:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 262:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 263:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 264:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 267:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 268:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 269:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 270:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 401:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 402:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 403:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 404:17]

  module AllToAllPEright :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, write_enable : UInt<1>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 133:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<2>("h2")) @[AllToAllPE.scala 136:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h1")) @[AllToAllPE.scala 137:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 140:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 141:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 143:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 144:7]
    reg w_en : UInt<1>, clock with :
      reset => (UInt<1>("h0"), w_en) @[AllToAllPE.scala 147:17]
    io.resp.bits.write_enable <= w_en @[AllToAllPE.scala 148:29]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 153:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 154:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 155:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 157:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 158:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 159:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 165:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 165:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 165:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 166:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 167:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 168:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 170:14]
    when _T_2 : @[AllToAllPE.scala 170:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 171:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 172:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 173:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 174:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 175:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 176:17]
      w_en <= UInt<1>("h0") @[AllToAllPE.scala 177:10]
      when load_signal : @[AllToAllPE.scala 179:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 180:13]
      else :
        when store_signal : @[AllToAllPE.scala 181:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 182:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 183:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 184:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 186:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 189:20]
      when _T_3 : @[AllToAllPE.scala 189:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 190:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 191:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 192:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 193:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 194:17]
        when is_this_PE : @[AllToAllPE.scala 196:21]
          node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 197:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 197:12]
          MPORT <= rs1 @[AllToAllPE.scala 197:23]
          w_en <= UInt<1>("h1") @[AllToAllPE.scala 198:12]
        else :
          w_en <= UInt<1>("h0") @[AllToAllPE.scala 200:12]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 202:16]
        when load_signal : @[AllToAllPE.scala 204:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 205:13]
        else :
          when store_signal : @[AllToAllPE.scala 206:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 207:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 208:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 209:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 211:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 214:20]
        when _T_5 : @[AllToAllPE.scala 214:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 216:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 217:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 218:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 219:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 220:17]
          when is_this_PE : @[AllToAllPE.scala 222:21]
            node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 223:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 223:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 223:18]
            w_en <= UInt<1>("h1") @[AllToAllPE.scala 224:12]
          else :
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 226:12]
          when load_signal : @[AllToAllPE.scala 229:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 230:13]
          else :
            when store_signal : @[AllToAllPE.scala 231:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 232:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 233:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 234:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 236:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 239:20]
          when _T_7 : @[AllToAllPE.scala 239:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 240:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 241:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 242:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 243:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 246:17]
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 248:10]
            state <= UInt<3>("h2") @[AllToAllPE.scala 250:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 251:20]
            when _T_8 : @[AllToAllPE.scala 251:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 252:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 253:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 254:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 255:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 257:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 259:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 261:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 262:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 263:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 264:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 267:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 268:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 269:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 270:17]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 391:16]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 393:15]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 394:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 395:17]

  module AllToAllPEbottomLeftCorner :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, write_enable : UInt<1>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 133:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 136:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 137:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 140:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 141:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 143:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 144:7]
    reg w_en : UInt<1>, clock with :
      reset => (UInt<1>("h0"), w_en) @[AllToAllPE.scala 147:17]
    io.resp.bits.write_enable <= w_en @[AllToAllPE.scala 148:29]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 153:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 154:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 155:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 157:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 158:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 159:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 165:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 165:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 165:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 166:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 167:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 168:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 170:14]
    when _T_2 : @[AllToAllPE.scala 170:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 171:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 172:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 173:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 174:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 175:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 176:17]
      w_en <= UInt<1>("h0") @[AllToAllPE.scala 177:10]
      when load_signal : @[AllToAllPE.scala 179:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 180:13]
      else :
        when store_signal : @[AllToAllPE.scala 181:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 182:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 183:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 184:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 186:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 189:20]
      when _T_3 : @[AllToAllPE.scala 189:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 190:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 191:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 192:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 193:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 194:17]
        when is_this_PE : @[AllToAllPE.scala 196:21]
          node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 197:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 197:12]
          MPORT <= rs1 @[AllToAllPE.scala 197:23]
          w_en <= UInt<1>("h1") @[AllToAllPE.scala 198:12]
        else :
          w_en <= UInt<1>("h0") @[AllToAllPE.scala 200:12]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 202:16]
        when load_signal : @[AllToAllPE.scala 204:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 205:13]
        else :
          when store_signal : @[AllToAllPE.scala 206:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 207:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 208:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 209:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 211:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 214:20]
        when _T_5 : @[AllToAllPE.scala 214:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 216:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 217:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 218:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 219:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 220:17]
          when is_this_PE : @[AllToAllPE.scala 222:21]
            node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 223:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 223:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 223:18]
            w_en <= UInt<1>("h1") @[AllToAllPE.scala 224:12]
          else :
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 226:12]
          when load_signal : @[AllToAllPE.scala 229:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 230:13]
          else :
            when store_signal : @[AllToAllPE.scala 231:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 232:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 233:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 234:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 236:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 239:20]
          when _T_7 : @[AllToAllPE.scala 239:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 240:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 241:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 242:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 243:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 246:17]
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 248:10]
            state <= UInt<3>("h2") @[AllToAllPE.scala 250:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 251:20]
            when _T_8 : @[AllToAllPE.scala 251:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 252:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 253:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 254:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 255:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 257:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 259:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 261:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 262:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 263:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 264:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 267:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 268:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 269:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 270:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 332:15]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 334:17]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 337:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 338:13]

  module AllToAllPEbottom :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, write_enable : UInt<1>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 133:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h1")) @[AllToAllPE.scala 136:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 137:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 140:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 141:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 143:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 144:7]
    reg w_en : UInt<1>, clock with :
      reset => (UInt<1>("h0"), w_en) @[AllToAllPE.scala 147:17]
    io.resp.bits.write_enable <= w_en @[AllToAllPE.scala 148:29]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 153:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 154:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 155:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 157:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 158:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 159:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 165:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 165:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 165:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 166:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 167:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 168:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 170:14]
    when _T_2 : @[AllToAllPE.scala 170:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 171:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 172:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 173:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 174:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 175:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 176:17]
      w_en <= UInt<1>("h0") @[AllToAllPE.scala 177:10]
      when load_signal : @[AllToAllPE.scala 179:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 180:13]
      else :
        when store_signal : @[AllToAllPE.scala 181:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 182:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 183:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 184:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 186:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 189:20]
      when _T_3 : @[AllToAllPE.scala 189:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 190:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 191:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 192:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 193:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 194:17]
        when is_this_PE : @[AllToAllPE.scala 196:21]
          node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 197:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 197:12]
          MPORT <= rs1 @[AllToAllPE.scala 197:23]
          w_en <= UInt<1>("h1") @[AllToAllPE.scala 198:12]
        else :
          w_en <= UInt<1>("h0") @[AllToAllPE.scala 200:12]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 202:16]
        when load_signal : @[AllToAllPE.scala 204:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 205:13]
        else :
          when store_signal : @[AllToAllPE.scala 206:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 207:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 208:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 209:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 211:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 214:20]
        when _T_5 : @[AllToAllPE.scala 214:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 216:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 217:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 218:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 219:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 220:17]
          when is_this_PE : @[AllToAllPE.scala 222:21]
            node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 223:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 223:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 223:18]
            w_en <= UInt<1>("h1") @[AllToAllPE.scala 224:12]
          else :
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 226:12]
          when load_signal : @[AllToAllPE.scala 229:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 230:13]
          else :
            when store_signal : @[AllToAllPE.scala 231:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 232:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 233:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 234:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 236:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 239:20]
          when _T_7 : @[AllToAllPE.scala 239:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 240:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 241:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 242:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 243:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 246:17]
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 248:10]
            state <= UInt<3>("h2") @[AllToAllPE.scala 250:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 251:20]
            when _T_8 : @[AllToAllPE.scala 251:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 252:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 253:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 254:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 255:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 257:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 259:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 261:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 262:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 263:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 264:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 267:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 268:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 269:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 270:17]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 368:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 370:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 371:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 372:13]

  module AllToAllPEbottomRightCorner :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, write_enable : UInt<1>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 133:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<2>("h2")) @[AllToAllPE.scala 136:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 137:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 140:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 141:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 143:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 144:7]
    reg w_en : UInt<1>, clock with :
      reset => (UInt<1>("h0"), w_en) @[AllToAllPE.scala 147:17]
    io.resp.bits.write_enable <= w_en @[AllToAllPE.scala 148:29]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 153:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 154:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 155:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 157:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 158:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 159:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 165:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 165:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 165:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 166:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 167:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 168:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 170:14]
    when _T_2 : @[AllToAllPE.scala 170:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 171:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 172:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 173:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 174:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 175:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 176:17]
      w_en <= UInt<1>("h0") @[AllToAllPE.scala 177:10]
      when load_signal : @[AllToAllPE.scala 179:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 180:13]
      else :
        when store_signal : @[AllToAllPE.scala 181:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 182:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 183:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 184:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 186:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 189:20]
      when _T_3 : @[AllToAllPE.scala 189:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 190:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 191:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 192:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 193:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 194:17]
        when is_this_PE : @[AllToAllPE.scala 196:21]
          node _T_4 = bits(memIndex, 3, 0) @[AllToAllPE.scala 197:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 197:12]
          MPORT <= rs1 @[AllToAllPE.scala 197:23]
          w_en <= UInt<1>("h1") @[AllToAllPE.scala 198:12]
        else :
          w_en <= UInt<1>("h0") @[AllToAllPE.scala 200:12]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 202:16]
        when load_signal : @[AllToAllPE.scala 204:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 205:13]
        else :
          when store_signal : @[AllToAllPE.scala 206:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 207:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 208:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 209:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 211:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 214:20]
        when _T_5 : @[AllToAllPE.scala 214:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 216:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 217:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 218:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 219:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 220:17]
          when is_this_PE : @[AllToAllPE.scala 222:21]
            node _T_6 = bits(memIndex, 3, 0) @[AllToAllPE.scala 223:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 223:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 223:18]
            w_en <= UInt<1>("h1") @[AllToAllPE.scala 224:12]
          else :
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 226:12]
          when load_signal : @[AllToAllPE.scala 229:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 230:13]
          else :
            when store_signal : @[AllToAllPE.scala 231:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 232:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 233:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 234:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 236:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 239:20]
          when _T_7 : @[AllToAllPE.scala 239:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 240:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 241:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 242:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 243:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 246:17]
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 248:10]
            state <= UInt<3>("h2") @[AllToAllPE.scala 250:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 251:20]
            when _T_8 : @[AllToAllPE.scala 251:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 252:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 253:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 254:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 255:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 257:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 259:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 261:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 262:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 263:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 264:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 267:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 268:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 269:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 270:17]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 345:16]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 347:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 349:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 350:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 351:13]

  module AllToAllMesh :
    input clock : Clock
    input reset : Reset
    output io : { flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, busy : UInt<1>}

    inst vector_0 of AllToAllPEupLeftCorner @[AllToAllMesh.scala 94:41]
    vector_0.clock <= clock
    vector_0.reset <= reset
    inst vector_1 of AllToAllPEup @[AllToAllMesh.scala 105:41]
    vector_1.clock <= clock
    vector_1.reset <= reset
    inst vector_2 of AllToAllPEupRightCorner @[AllToAllMesh.scala 97:41]
    vector_2.clock <= clock
    vector_2.reset <= reset
    inst vector_3 of AllToAllPEleft @[AllToAllMesh.scala 111:41]
    vector_3.clock <= clock
    vector_3.reset <= reset
    inst vector_4 of AllToAllPEmiddle @[AllToAllMesh.scala 117:41]
    vector_4.clock <= clock
    vector_4.reset <= reset
    inst vector_5 of AllToAllPEright @[AllToAllMesh.scala 114:41]
    vector_5.clock <= clock
    vector_5.reset <= reset
    inst vector_6 of AllToAllPEbottomLeftCorner @[AllToAllMesh.scala 100:41]
    vector_6.clock <= clock
    vector_6.reset <= reset
    inst vector_7 of AllToAllPEbottom @[AllToAllMesh.scala 108:41]
    vector_7.clock <= clock
    vector_7.reset <= reset
    inst vector_8 of AllToAllPEbottomRightCorner @[AllToAllMesh.scala 103:41]
    vector_8.clock <= clock
    vector_8.reset <= reset
    vector_0.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 129:32]
    vector_0.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 130:36]
    vector_0.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 131:37]
    vector_0.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 132:42]
    vector_0.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 134:35]
    vector_0.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 135:35]
    vector_0.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 137:33]
    vector_1.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 129:32]
    vector_1.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 130:36]
    vector_1.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 131:37]
    vector_1.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 132:42]
    vector_1.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 134:35]
    vector_1.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 135:35]
    vector_1.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 137:33]
    vector_2.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 129:32]
    vector_2.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 130:36]
    vector_2.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 131:37]
    vector_2.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 132:42]
    vector_2.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 134:35]
    vector_2.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 135:35]
    vector_2.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 137:33]
    vector_3.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 129:32]
    vector_3.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 130:36]
    vector_3.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 131:37]
    vector_3.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 132:42]
    vector_3.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 134:35]
    vector_3.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 135:35]
    vector_3.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 137:33]
    vector_4.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 129:32]
    vector_4.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 130:36]
    vector_4.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 131:37]
    vector_4.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 132:42]
    vector_4.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 134:35]
    vector_4.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 135:35]
    vector_4.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 137:33]
    vector_5.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 129:32]
    vector_5.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 130:36]
    vector_5.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 131:37]
    vector_5.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 132:42]
    vector_5.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 134:35]
    vector_5.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 135:35]
    vector_5.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 137:33]
    vector_6.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 129:32]
    vector_6.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 130:36]
    vector_6.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 131:37]
    vector_6.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 132:42]
    vector_6.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 134:35]
    vector_6.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 135:35]
    vector_6.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 137:33]
    vector_7.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 129:32]
    vector_7.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 130:36]
    vector_7.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 131:37]
    vector_7.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 132:42]
    vector_7.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 134:35]
    vector_7.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 135:35]
    vector_7.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 137:33]
    vector_8.io.cmd.valid <= io.cmd.valid @[AllToAllMesh.scala 129:32]
    vector_8.io.cmd.bits.load <= io.cmd.bits.load @[AllToAllMesh.scala 130:36]
    vector_8.io.cmd.bits.store <= io.cmd.bits.store @[AllToAllMesh.scala 131:37]
    vector_8.io.cmd.bits.doAllToAll <= io.cmd.bits.doAllToAll @[AllToAllMesh.scala 132:42]
    vector_8.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllMesh.scala 134:35]
    vector_8.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllMesh.scala 135:35]
    vector_8.io.resp.ready <= io.resp.ready @[AllToAllMesh.scala 137:33]
    node _T = or(vector_0.io.busy, vector_1.io.busy) @[AllToAllMesh.scala 142:47]
    node _T_1 = or(_T, vector_2.io.busy) @[AllToAllMesh.scala 142:47]
    node _T_2 = or(_T_1, vector_3.io.busy) @[AllToAllMesh.scala 142:47]
    node _T_3 = or(_T_2, vector_4.io.busy) @[AllToAllMesh.scala 142:47]
    node _T_4 = or(_T_3, vector_5.io.busy) @[AllToAllMesh.scala 142:47]
    node _T_5 = or(_T_4, vector_6.io.busy) @[AllToAllMesh.scala 142:47]
    node _T_6 = or(_T_5, vector_7.io.busy) @[AllToAllMesh.scala 142:47]
    node _T_7 = or(_T_6, vector_8.io.busy) @[AllToAllMesh.scala 142:47]
    io.busy <= _T_7 @[AllToAllMesh.scala 142:13]
    node _T_8 = and(vector_0.io.cmd.ready, vector_1.io.cmd.ready) @[AllToAllMesh.scala 143:57]
    node _T_9 = and(_T_8, vector_2.io.cmd.ready) @[AllToAllMesh.scala 143:57]
    node _T_10 = and(_T_9, vector_3.io.cmd.ready) @[AllToAllMesh.scala 143:57]
    node _T_11 = and(_T_10, vector_4.io.cmd.ready) @[AllToAllMesh.scala 143:57]
    node _T_12 = and(_T_11, vector_5.io.cmd.ready) @[AllToAllMesh.scala 143:57]
    node _T_13 = and(_T_12, vector_6.io.cmd.ready) @[AllToAllMesh.scala 143:57]
    node _T_14 = and(_T_13, vector_7.io.cmd.ready) @[AllToAllMesh.scala 143:57]
    node _T_15 = and(_T_14, vector_8.io.cmd.ready) @[AllToAllMesh.scala 143:57]
    io.cmd.ready <= _T_15 @[AllToAllMesh.scala 143:18]
    node _T_16 = and(vector_0.io.resp.valid, vector_1.io.resp.valid) @[AllToAllMesh.scala 144:59]
    node _T_17 = and(_T_16, vector_2.io.resp.valid) @[AllToAllMesh.scala 144:59]
    node _T_18 = and(_T_17, vector_3.io.resp.valid) @[AllToAllMesh.scala 144:59]
    node _T_19 = and(_T_18, vector_4.io.resp.valid) @[AllToAllMesh.scala 144:59]
    node _T_20 = and(_T_19, vector_5.io.resp.valid) @[AllToAllMesh.scala 144:59]
    node _T_21 = and(_T_20, vector_6.io.resp.valid) @[AllToAllMesh.scala 144:59]
    node _T_22 = and(_T_21, vector_7.io.resp.valid) @[AllToAllMesh.scala 144:59]
    node _T_23 = and(_T_22, vector_8.io.resp.valid) @[AllToAllMesh.scala 144:59]
    io.resp.valid <= _T_23 @[AllToAllMesh.scala 144:19]
    node _T_24 = eq(vector_0.io.resp.bits.write_enable, UInt<1>("h1")) @[AllToAllMesh.scala 173:59]
    node _T_25 = eq(vector_1.io.resp.bits.write_enable, UInt<1>("h1")) @[AllToAllMesh.scala 175:57]
    node _T_26 = eq(vector_2.io.resp.bits.write_enable, UInt<1>("h1")) @[AllToAllMesh.scala 175:57]
    node _T_27 = eq(vector_3.io.resp.bits.write_enable, UInt<1>("h1")) @[AllToAllMesh.scala 175:57]
    node _T_28 = eq(vector_4.io.resp.bits.write_enable, UInt<1>("h1")) @[AllToAllMesh.scala 175:57]
    node _T_29 = eq(vector_5.io.resp.bits.write_enable, UInt<1>("h1")) @[AllToAllMesh.scala 175:57]
    node _T_30 = eq(vector_6.io.resp.bits.write_enable, UInt<1>("h1")) @[AllToAllMesh.scala 175:57]
    node _T_31 = eq(vector_7.io.resp.bits.write_enable, UInt<1>("h1")) @[AllToAllMesh.scala 175:57]
    node _T_32 = eq(vector_8.io.resp.bits.write_enable, UInt<1>("h1")) @[AllToAllMesh.scala 175:57]
    io.resp.bits.data <= vector_0.io.resp.bits.data @[AllToAllMesh.scala 179:23]
    vector_0.io.left.in <= UInt<64>("h0") @[AllToAllMesh.scala 186:34]
    vector_0.io.up.in <= UInt<64>("h0") @[AllToAllMesh.scala 187:32]
    vector_0.io.right.in <= vector_1.io.left.out @[AllToAllMesh.scala 189:35]
    vector_0.io.bottom.in <= vector_3.io.up.out @[AllToAllMesh.scala 190:36]
    vector_1.io.up.in <= UInt<64>("h0") @[AllToAllMesh.scala 218:32]
    vector_1.io.left.in <= vector_0.io.right.out @[AllToAllMesh.scala 220:34]
    vector_1.io.right.in <= vector_2.io.left.out @[AllToAllMesh.scala 221:35]
    vector_1.io.bottom.in <= vector_4.io.up.out @[AllToAllMesh.scala 222:36]
    vector_2.io.right.in <= UInt<64>("h0") @[AllToAllMesh.scala 194:35]
    vector_2.io.up.in <= UInt<64>("h0") @[AllToAllMesh.scala 195:32]
    vector_2.io.left.in <= vector_1.io.right.out @[AllToAllMesh.scala 197:34]
    vector_2.io.bottom.in <= vector_5.io.up.out @[AllToAllMesh.scala 198:36]
    vector_3.io.left.in <= UInt<64>("h0") @[AllToAllMesh.scala 234:34]
    vector_3.io.right.in <= vector_4.io.left.out @[AllToAllMesh.scala 236:35]
    vector_3.io.up.in <= vector_0.io.bottom.out @[AllToAllMesh.scala 237:32]
    vector_3.io.bottom.in <= vector_6.io.up.out @[AllToAllMesh.scala 238:36]
    vector_4.io.left.in <= vector_3.io.right.out @[AllToAllMesh.scala 250:34]
    vector_4.io.right.in <= vector_5.io.left.out @[AllToAllMesh.scala 251:35]
    vector_4.io.up.in <= vector_1.io.bottom.out @[AllToAllMesh.scala 252:32]
    vector_4.io.bottom.in <= vector_7.io.up.out @[AllToAllMesh.scala 253:36]
    vector_5.io.right.in <= UInt<64>("h0") @[AllToAllMesh.scala 242:35]
    vector_5.io.left.in <= vector_4.io.right.out @[AllToAllMesh.scala 244:34]
    vector_5.io.up.in <= vector_2.io.bottom.out @[AllToAllMesh.scala 245:32]
    vector_5.io.bottom.in <= vector_8.io.up.out @[AllToAllMesh.scala 246:36]
    vector_6.io.left.in <= UInt<64>("h0") @[AllToAllMesh.scala 202:34]
    vector_6.io.bottom.in <= UInt<64>("h0") @[AllToAllMesh.scala 203:36]
    vector_6.io.right.in <= vector_7.io.left.out @[AllToAllMesh.scala 205:35]
    vector_6.io.up.in <= vector_3.io.bottom.out @[AllToAllMesh.scala 206:32]
    vector_7.io.bottom.in <= UInt<64>("h0") @[AllToAllMesh.scala 226:36]
    vector_7.io.left.in <= vector_6.io.right.out @[AllToAllMesh.scala 228:34]
    vector_7.io.right.in <= vector_8.io.left.out @[AllToAllMesh.scala 229:35]
    vector_7.io.up.in <= vector_4.io.bottom.out @[AllToAllMesh.scala 230:32]
    vector_8.io.right.in <= UInt<64>("h0") @[AllToAllMesh.scala 210:35]
    vector_8.io.bottom.in <= UInt<64>("h0") @[AllToAllMesh.scala 211:36]
    vector_8.io.left.in <= vector_7.io.right.out @[AllToAllMesh.scala 213:34]
    vector_8.io.up.in <= vector_5.io.bottom.out @[AllToAllMesh.scala 214:32]

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


circuit AllToAllPE :
  module AllToAllPE :
    input clock : Clock
    input reset : UInt<1>
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, write_enable : UInt<1>}}, left : { out : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}, flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}}, right : { out : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}, flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}}, up : { out : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}, flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}}, bottom : { out : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}, flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}}}

    cmem memPE : UInt<64> [1024] @[AllToAllPE.scala 141:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<2>("h2")) @[AllToAllPE.scala 144:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h1")) @[AllToAllPE.scala 145:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 148:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 149:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 151:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 152:7]
    reg w_en : UInt<1>, clock with :
      reset => (UInt<1>("h0"), w_en) @[AllToAllPE.scala 155:17]
    io.resp.bits.write_enable <= w_en @[AllToAllPE.scala 156:29]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 161:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 162:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 163:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 165:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 166:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 167:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 173:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 173:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 173:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 174:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 175:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 176:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 178:14]
    when _T_2 : @[AllToAllPE.scala 178:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 179:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 180:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 181:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 182:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 183:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 184:17]
      w_en <= UInt<1>("h0") @[AllToAllPE.scala 185:10]
      when load_signal : @[AllToAllPE.scala 187:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 188:13]
      else :
        when store_signal : @[AllToAllPE.scala 189:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 190:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 191:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 192:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 194:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 197:20]
      when _T_3 : @[AllToAllPE.scala 197:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 198:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 199:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 200:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 201:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 202:17]
        when is_this_PE : @[AllToAllPE.scala 204:21]
          node _T_4 = bits(memIndex, 9, 0) @[AllToAllPE.scala 205:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 205:12]
          MPORT <= rs1 @[AllToAllPE.scala 205:23]
          w_en <= UInt<1>("h1") @[AllToAllPE.scala 206:12]
        else :
          w_en <= UInt<1>("h0") @[AllToAllPE.scala 208:12]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 210:16]
        when load_signal : @[AllToAllPE.scala 212:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 213:13]
        else :
          when store_signal : @[AllToAllPE.scala 214:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 215:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 216:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 217:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 219:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 222:20]
        when _T_5 : @[AllToAllPE.scala 222:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 224:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 225:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 226:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 227:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 228:17]
          when is_this_PE : @[AllToAllPE.scala 230:21]
            node _T_6 = bits(memIndex, 9, 0) @[AllToAllPE.scala 231:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 231:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 231:18]
            w_en <= UInt<1>("h1") @[AllToAllPE.scala 232:12]
          else :
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 234:12]
          when load_signal : @[AllToAllPE.scala 237:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 238:13]
          else :
            when store_signal : @[AllToAllPE.scala 239:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 240:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 241:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 242:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 244:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 247:20]
          when _T_7 : @[AllToAllPE.scala 247:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 248:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 249:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 250:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 251:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 254:17]
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 256:10]
            state <= UInt<3>("h2") @[AllToAllPE.scala 258:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 259:20]
            when _T_8 : @[AllToAllPE.scala 259:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 260:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 261:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 262:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 263:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 265:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 267:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 269:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 270:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 271:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 272:23]
    io.left.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 277:25]
    io.left.out.bits.x_0 <= UInt<16>("h0") @[AllToAllPE.scala 278:24]
    io.left.out.bits.y_0 <= UInt<16>("h0") @[AllToAllPE.scala 279:24]
    io.left.out.bits.x_dest <= UInt<16>("h0") @[AllToAllPE.scala 280:27]
    io.left.out.bits.y_dest <= UInt<16>("h0") @[AllToAllPE.scala 281:27]
    io.left.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 282:21]
    io.left.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 283:20]
    io.right.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 285:26]
    io.right.out.bits.x_0 <= UInt<16>("h0") @[AllToAllPE.scala 286:25]
    io.right.out.bits.y_0 <= UInt<16>("h0") @[AllToAllPE.scala 287:25]
    io.right.out.bits.x_dest <= UInt<16>("h0") @[AllToAllPE.scala 288:28]
    io.right.out.bits.y_dest <= UInt<16>("h0") @[AllToAllPE.scala 289:28]
    io.right.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 290:22]
    io.right.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 291:21]
    io.up.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 293:23]
    io.up.out.bits.x_0 <= UInt<16>("h0") @[AllToAllPE.scala 294:22]
    io.up.out.bits.y_0 <= UInt<16>("h0") @[AllToAllPE.scala 295:22]
    io.up.out.bits.x_dest <= UInt<16>("h0") @[AllToAllPE.scala 296:25]
    io.up.out.bits.y_dest <= UInt<16>("h0") @[AllToAllPE.scala 297:25]
    io.up.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 298:19]
    io.up.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 299:18]
    io.bottom.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 301:27]
    io.bottom.out.bits.x_0 <= UInt<16>("h0") @[AllToAllPE.scala 302:26]
    io.bottom.out.bits.y_0 <= UInt<16>("h0") @[AllToAllPE.scala 303:26]
    io.bottom.out.bits.x_dest <= UInt<16>("h0") @[AllToAllPE.scala 304:29]
    io.bottom.out.bits.y_dest <= UInt<16>("h0") @[AllToAllPE.scala 305:29]
    io.bottom.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 306:23]
    io.bottom.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 307:22]


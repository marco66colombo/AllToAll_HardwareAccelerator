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
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 175:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 175:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 175:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 176:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 177:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 178:38]
    node _T_2 = eq(io.resp.ready, UInt<1>("h0")) @[AllToAllPE.scala 180:20]
    node stall_resp = and(_T_2, resp_signal) @[AllToAllPE.scala 180:35]
    node _T_3 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 182:14]
    when _T_3 : @[AllToAllPE.scala 182:23]
      io.busy <= stall_resp @[AllToAllPE.scala 183:13]
      node _T_4 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 184:21]
      io.cmd.ready <= _T_4 @[AllToAllPE.scala 184:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 185:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 186:23]
      w_en <= UInt<1>("h0") @[AllToAllPE.scala 189:10]
      when stall_resp : @[AllToAllPE.scala 191:21]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 193:19]
      else :
        resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 197:19]
        resp_value <= UInt<1>("h0") @[AllToAllPE.scala 198:18]
      when load_signal : @[AllToAllPE.scala 201:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 202:13]
      else :
        when store_signal : @[AllToAllPE.scala 203:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 204:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 205:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 206:13]
          else :
            when stall_resp : @[AllToAllPE.scala 207:27]
              state <= UInt<3>("h5") @[AllToAllPE.scala 208:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 210:13]
    else :
      node _T_5 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 213:20]
      when _T_5 : @[AllToAllPE.scala 213:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 214:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 215:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 216:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 217:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 218:17]
        when is_this_PE : @[AllToAllPE.scala 221:21]
          node _T_6 = bits(memIndex, 9, 0) @[AllToAllPE.scala 222:12]
          infer mport MPORT = memPE[_T_6], clock @[AllToAllPE.scala 222:12]
          MPORT <= rs1 @[AllToAllPE.scala 222:23]
          w_en <= UInt<1>("h1") @[AllToAllPE.scala 223:12]
        else :
          w_en <= UInt<1>("h0") @[AllToAllPE.scala 225:12]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 227:16]
        when load_signal : @[AllToAllPE.scala 229:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 230:13]
        else :
          when store_signal : @[AllToAllPE.scala 231:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 232:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 233:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 234:13]
            else :
              when stall_resp : @[AllToAllPE.scala 235:27]
                state <= UInt<3>("h5") @[AllToAllPE.scala 236:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 238:13]
      else :
        node _T_7 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 241:20]
        when _T_7 : @[AllToAllPE.scala 241:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 243:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 244:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 245:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 246:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 247:17]
          when is_this_PE : @[AllToAllPE.scala 249:21]
            node _T_8 = bits(memIndex, 9, 0) @[AllToAllPE.scala 250:26]
            infer mport MPORT_1 = memPE[_T_8], clock @[AllToAllPE.scala 250:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 250:18]
            w_en <= UInt<1>("h1") @[AllToAllPE.scala 251:12]
          else :
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 253:12]
          when load_signal : @[AllToAllPE.scala 256:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 257:13]
          else :
            when store_signal : @[AllToAllPE.scala 258:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 259:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 260:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 261:13]
              else :
                when stall_resp : @[AllToAllPE.scala 262:27]
                  state <= UInt<3>("h5") @[AllToAllPE.scala 263:13]
                else :
                  state <= UInt<3>("h0") @[AllToAllPE.scala 265:13]
        else :
          node _T_9 = eq(state, UInt<3>("h5")) @[AllToAllPE.scala 268:20]
          when _T_9 : @[AllToAllPE.scala 268:36]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 270:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 271:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 272:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 273:23]
            when stall_resp : @[AllToAllPE.scala 275:21]
              resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 277:19]
              state <= UInt<3>("h5") @[AllToAllPE.scala 278:13]
            else :
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 282:19]
              state <= UInt<3>("h0") @[AllToAllPE.scala 283:13]
          else :
            node _T_10 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 286:20]
            when _T_10 : @[AllToAllPE.scala 286:31]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 287:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 288:18]
              io.resp.valid <= resp_signal @[AllToAllPE.scala 289:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 290:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 293:17]
              w_en <= UInt<1>("h0") @[AllToAllPE.scala 295:10]
              state <= UInt<3>("h2") @[AllToAllPE.scala 297:11]
            else :
              node _T_11 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 298:20]
              when _T_11 : @[AllToAllPE.scala 298:36]
                io.busy <= UInt<1>("h1") @[AllToAllPE.scala 299:13]
                io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 300:18]
                io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 301:19]
                io.resp.bits.data <= resp_value @[AllToAllPE.scala 302:23]
                resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 304:17]
                state <= UInt<3>("h0") @[AllToAllPE.scala 306:11]
              else :
                io.busy <= UInt<1>("h0") @[AllToAllPE.scala 308:13]
                io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 309:18]
                io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 310:19]
                io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 311:23]
    io.left.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 316:25]
    io.left.out.bits.x_0 <= UInt<16>("h0") @[AllToAllPE.scala 317:24]
    io.left.out.bits.y_0 <= UInt<16>("h0") @[AllToAllPE.scala 318:24]
    io.left.out.bits.x_dest <= UInt<16>("h0") @[AllToAllPE.scala 319:27]
    io.left.out.bits.y_dest <= UInt<16>("h0") @[AllToAllPE.scala 320:27]
    io.left.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 321:21]
    io.left.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 322:20]
    io.right.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 324:26]
    io.right.out.bits.x_0 <= UInt<16>("h0") @[AllToAllPE.scala 325:25]
    io.right.out.bits.y_0 <= UInt<16>("h0") @[AllToAllPE.scala 326:25]
    io.right.out.bits.x_dest <= UInt<16>("h0") @[AllToAllPE.scala 327:28]
    io.right.out.bits.y_dest <= UInt<16>("h0") @[AllToAllPE.scala 328:28]
    io.right.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 329:22]
    io.right.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 330:21]
    io.up.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 332:23]
    io.up.out.bits.x_0 <= UInt<16>("h0") @[AllToAllPE.scala 333:22]
    io.up.out.bits.y_0 <= UInt<16>("h0") @[AllToAllPE.scala 334:22]
    io.up.out.bits.x_dest <= UInt<16>("h0") @[AllToAllPE.scala 335:25]
    io.up.out.bits.y_dest <= UInt<16>("h0") @[AllToAllPE.scala 336:25]
    io.up.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 337:19]
    io.up.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 338:18]
    io.bottom.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 340:27]
    io.bottom.out.bits.x_0 <= UInt<16>("h0") @[AllToAllPE.scala 341:26]
    io.bottom.out.bits.y_0 <= UInt<16>("h0") @[AllToAllPE.scala 342:26]
    io.bottom.out.bits.x_dest <= UInt<16>("h0") @[AllToAllPE.scala 343:29]
    io.bottom.out.bits.y_dest <= UInt<16>("h0") @[AllToAllPE.scala 344:29]
    io.bottom.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 345:23]
    io.bottom.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 346:22]


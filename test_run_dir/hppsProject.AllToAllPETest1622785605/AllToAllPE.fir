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
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 152:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 153:7]
    reg w_en : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 157:21]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 167:22]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 169:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 171:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 172:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 173:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 181:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 181:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 181:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 182:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 183:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 184:38]
    node _T_2 = eq(io.resp.ready, UInt<1>("h0")) @[AllToAllPE.scala 186:20]
    node stall_resp = and(_T_2, io.resp.valid) @[AllToAllPE.scala 186:35]
    node _T_3 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 188:14]
    when _T_3 : @[AllToAllPE.scala 188:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 189:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 190:18]
      io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 191:19]
      io.resp.bits.data <= UInt<1>("h0") @[AllToAllPE.scala 192:23]
      io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 195:31]
      w_en <= UInt<1>("h0") @[AllToAllPE.scala 196:10]
      when load_signal : @[AllToAllPE.scala 210:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 211:13]
      else :
        when store_signal : @[AllToAllPE.scala 212:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 213:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 214:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 215:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 217:13]
    else :
      node _T_4 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 220:20]
      when _T_4 : @[AllToAllPE.scala 220:32]
        io.busy <= stall_resp @[AllToAllPE.scala 221:13]
        node _T_5 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 222:21]
        io.cmd.ready <= _T_5 @[AllToAllPE.scala 222:18]
        io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 223:19]
        io.resp.bits.data <= UInt<6>("h20") @[AllToAllPE.scala 224:23]
        resp_value <= UInt<6>("h20") @[AllToAllPE.scala 225:16]
        when is_this_PE : @[AllToAllPE.scala 237:21]
          node _T_6 = bits(memIndex, 9, 0) @[AllToAllPE.scala 238:12]
          infer mport MPORT = memPE[_T_6], clock @[AllToAllPE.scala 238:12]
          MPORT <= rs1 @[AllToAllPE.scala 238:23]
          io.resp.bits.write_enable <= UInt<1>("h1") @[AllToAllPE.scala 239:33]
          w_en <= UInt<1>("h1") @[AllToAllPE.scala 240:12]
        else :
          io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 242:33]
          w_en <= UInt<1>("h0") @[AllToAllPE.scala 243:12]
        node _T_7 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 247:25]
        node _T_8 = and(load_signal, _T_7) @[AllToAllPE.scala 247:22]
        when _T_8 : @[AllToAllPE.scala 247:37]
          state <= UInt<3>("h3") @[AllToAllPE.scala 248:13]
        else :
          node _T_9 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 249:32]
          node _T_10 = and(store_signal, _T_9) @[AllToAllPE.scala 249:29]
          when _T_10 : @[AllToAllPE.scala 249:44]
            state <= UInt<3>("h4") @[AllToAllPE.scala 250:13]
          else :
            node _T_11 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 251:35]
            node _T_12 = and(allToAll_signal, _T_11) @[AllToAllPE.scala 251:32]
            when _T_12 : @[AllToAllPE.scala 251:47]
              state <= UInt<3>("h1") @[AllToAllPE.scala 252:13]
            else :
              when stall_resp : @[AllToAllPE.scala 253:27]
                state <= UInt<3>("h6") @[AllToAllPE.scala 254:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 256:13]
      else :
        node _T_13 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 259:20]
        when _T_13 : @[AllToAllPE.scala 259:33]
          io.busy <= UInt<1>("h1") @[AllToAllPE.scala 261:13]
          io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 262:18]
          io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 263:19]
          io.resp.bits.data <= UInt<6>("h21") @[AllToAllPE.scala 264:23]
          when is_this_PE : @[AllToAllPE.scala 274:21]
            node _T_14 = bits(memIndex, 9, 0) @[AllToAllPE.scala 275:26]
            infer mport MPORT_1 = memPE[_T_14], clock @[AllToAllPE.scala 275:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 275:18]
            w_en <= UInt<1>("h1") @[AllToAllPE.scala 276:12]
          else :
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 278:12]
          io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 281:31]
          state <= UInt<3>("h5") @[AllToAllPE.scala 283:11]
        else :
          node _T_15 = eq(state, UInt<3>("h5")) @[AllToAllPE.scala 285:20]
          when _T_15 : @[AllToAllPE.scala 285:35]
            io.busy <= stall_resp @[AllToAllPE.scala 287:13]
            node _T_16 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 288:21]
            io.cmd.ready <= _T_16 @[AllToAllPE.scala 288:18]
            io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 289:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 290:23]
            io.resp.bits.write_enable <= w_en @[AllToAllPE.scala 291:31]
            node _T_17 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 302:25]
            node _T_18 = and(load_signal, _T_17) @[AllToAllPE.scala 302:22]
            when _T_18 : @[AllToAllPE.scala 302:37]
              state <= UInt<3>("h3") @[AllToAllPE.scala 303:13]
            else :
              node _T_19 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 304:32]
              node _T_20 = and(store_signal, _T_19) @[AllToAllPE.scala 304:29]
              when _T_20 : @[AllToAllPE.scala 304:44]
                state <= UInt<3>("h4") @[AllToAllPE.scala 305:13]
              else :
                node _T_21 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 306:35]
                node _T_22 = and(allToAll_signal, _T_21) @[AllToAllPE.scala 306:32]
                when _T_22 : @[AllToAllPE.scala 306:47]
                  state <= UInt<3>("h1") @[AllToAllPE.scala 307:13]
                else :
                  when stall_resp : @[AllToAllPE.scala 308:27]
                    state <= UInt<3>("h6") @[AllToAllPE.scala 309:13]
                  else :
                    state <= UInt<3>("h0") @[AllToAllPE.scala 311:13]
          else :
            node _T_23 = eq(state, UInt<3>("h6")) @[AllToAllPE.scala 314:20]
            when _T_23 : @[AllToAllPE.scala 314:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 316:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 317:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 318:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 319:23]
              io.resp.bits.write_enable <= w_en @[AllToAllPE.scala 321:31]
              when stall_resp : @[AllToAllPE.scala 323:21]
                state <= UInt<3>("h6") @[AllToAllPE.scala 324:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 326:13]
            else :
              node _T_24 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 329:20]
              when _T_24 : @[AllToAllPE.scala 329:31]
                io.busy <= UInt<1>("h1") @[AllToAllPE.scala 330:13]
                io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 331:18]
                io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 332:19]
                io.resp.bits.data <= resp_value @[AllToAllPE.scala 333:23]
                w_en <= UInt<1>("h0") @[AllToAllPE.scala 338:10]
                io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 339:31]
                state <= UInt<3>("h2") @[AllToAllPE.scala 341:11]
              else :
                node _T_25 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 342:20]
                when _T_25 : @[AllToAllPE.scala 342:36]
                  io.busy <= UInt<1>("h1") @[AllToAllPE.scala 343:13]
                  io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 344:18]
                  io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 345:19]
                  io.resp.bits.data <= resp_value @[AllToAllPE.scala 346:23]
                  io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 347:31]
                  state <= UInt<3>("h0") @[AllToAllPE.scala 351:11]
                else :
                  io.busy <= UInt<1>("h0") @[AllToAllPE.scala 353:13]
                  io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 354:18]
                  io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 355:19]
                  io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 356:23]
                  io.resp.bits.write_enable <= UInt<1>("h1") @[AllToAllPE.scala 357:31]
    io.left.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 362:25]
    io.left.out.bits.x_0 <= UInt<16>("h0") @[AllToAllPE.scala 363:24]
    io.left.out.bits.y_0 <= UInt<16>("h0") @[AllToAllPE.scala 364:24]
    io.left.out.bits.x_dest <= UInt<16>("h0") @[AllToAllPE.scala 365:27]
    io.left.out.bits.y_dest <= UInt<16>("h0") @[AllToAllPE.scala 366:27]
    io.left.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 367:21]
    io.left.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 368:20]
    io.right.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 370:26]
    io.right.out.bits.x_0 <= UInt<16>("h0") @[AllToAllPE.scala 371:25]
    io.right.out.bits.y_0 <= UInt<16>("h0") @[AllToAllPE.scala 372:25]
    io.right.out.bits.x_dest <= UInt<16>("h0") @[AllToAllPE.scala 373:28]
    io.right.out.bits.y_dest <= UInt<16>("h0") @[AllToAllPE.scala 374:28]
    io.right.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 375:22]
    io.right.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 376:21]
    io.up.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 378:23]
    io.up.out.bits.x_0 <= UInt<16>("h0") @[AllToAllPE.scala 379:22]
    io.up.out.bits.y_0 <= UInt<16>("h0") @[AllToAllPE.scala 380:22]
    io.up.out.bits.x_dest <= UInt<16>("h0") @[AllToAllPE.scala 381:25]
    io.up.out.bits.y_dest <= UInt<16>("h0") @[AllToAllPE.scala 382:25]
    io.up.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 383:19]
    io.up.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 384:18]
    io.bottom.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 386:27]
    io.bottom.out.bits.x_0 <= UInt<16>("h0") @[AllToAllPE.scala 387:26]
    io.bottom.out.bits.y_0 <= UInt<16>("h0") @[AllToAllPE.scala 388:26]
    io.bottom.out.bits.x_dest <= UInt<16>("h0") @[AllToAllPE.scala 389:29]
    io.bottom.out.bits.y_dest <= UInt<16>("h0") @[AllToAllPE.scala 390:29]
    io.bottom.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 391:23]
    io.bottom.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 392:22]


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
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 183:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 184:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 185:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 186:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 187:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 188:17]
      w_en <= UInt<1>("h0") @[AllToAllPE.scala 189:10]
      when load_signal : @[AllToAllPE.scala 191:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 192:13]
      else :
        when store_signal : @[AllToAllPE.scala 193:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 194:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 195:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 196:13]
          else :
            when stall_resp : @[AllToAllPE.scala 197:27]
              state <= UInt<3>("h5") @[AllToAllPE.scala 198:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 200:13]
    else :
      node _T_4 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 203:20]
      when _T_4 : @[AllToAllPE.scala 203:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 204:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 205:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 206:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 207:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 208:17]
        when is_this_PE : @[AllToAllPE.scala 210:21]
          node _T_5 = bits(memIndex, 9, 0) @[AllToAllPE.scala 211:12]
          infer mport MPORT = memPE[_T_5], clock @[AllToAllPE.scala 211:12]
          MPORT <= rs1 @[AllToAllPE.scala 211:23]
          w_en <= UInt<1>("h1") @[AllToAllPE.scala 212:12]
        else :
          w_en <= UInt<1>("h0") @[AllToAllPE.scala 214:12]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 216:16]
        when load_signal : @[AllToAllPE.scala 218:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 219:13]
        else :
          when store_signal : @[AllToAllPE.scala 220:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 221:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 222:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 223:13]
            else :
              when stall_resp : @[AllToAllPE.scala 224:27]
                state <= UInt<3>("h5") @[AllToAllPE.scala 225:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 227:13]
      else :
        node _T_6 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 230:20]
        when _T_6 : @[AllToAllPE.scala 230:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 232:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 233:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 234:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 235:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 236:17]
          when is_this_PE : @[AllToAllPE.scala 238:21]
            node _T_7 = bits(memIndex, 9, 0) @[AllToAllPE.scala 239:26]
            infer mport MPORT_1 = memPE[_T_7], clock @[AllToAllPE.scala 239:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 239:18]
            w_en <= UInt<1>("h1") @[AllToAllPE.scala 240:12]
          else :
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 242:12]
          when load_signal : @[AllToAllPE.scala 245:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 246:13]
          else :
            when store_signal : @[AllToAllPE.scala 247:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 248:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 249:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 250:13]
              else :
                when stall_resp : @[AllToAllPE.scala 251:27]
                  state <= UInt<3>("h5") @[AllToAllPE.scala 252:13]
                else :
                  state <= UInt<3>("h0") @[AllToAllPE.scala 254:13]
        else :
          node _T_8 = eq(state, UInt<3>("h5")) @[AllToAllPE.scala 257:20]
          when _T_8 : @[AllToAllPE.scala 257:36]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 259:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 260:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 261:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 262:23]
            when stall_resp : @[AllToAllPE.scala 264:21]
              resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 266:19]
              state <= UInt<3>("h5") @[AllToAllPE.scala 267:13]
            else :
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 271:19]
              state <= UInt<3>("h0") @[AllToAllPE.scala 272:13]
          else :
            node _T_9 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 275:20]
            when _T_9 : @[AllToAllPE.scala 275:31]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 276:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 277:18]
              io.resp.valid <= resp_signal @[AllToAllPE.scala 278:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 279:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 282:17]
              w_en <= UInt<1>("h0") @[AllToAllPE.scala 284:10]
              state <= UInt<3>("h2") @[AllToAllPE.scala 286:11]
            else :
              node _T_10 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 287:20]
              when _T_10 : @[AllToAllPE.scala 287:36]
                io.busy <= UInt<1>("h1") @[AllToAllPE.scala 288:13]
                io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 289:18]
                io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 290:19]
                io.resp.bits.data <= resp_value @[AllToAllPE.scala 291:23]
                resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 293:17]
                state <= UInt<3>("h0") @[AllToAllPE.scala 295:11]
              else :
                io.busy <= UInt<1>("h0") @[AllToAllPE.scala 297:13]
                io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 298:18]
                io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 299:19]
                io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 300:23]
    io.left.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 305:25]
    io.left.out.bits.x_0 <= UInt<16>("h0") @[AllToAllPE.scala 306:24]
    io.left.out.bits.y_0 <= UInt<16>("h0") @[AllToAllPE.scala 307:24]
    io.left.out.bits.x_dest <= UInt<16>("h0") @[AllToAllPE.scala 308:27]
    io.left.out.bits.y_dest <= UInt<16>("h0") @[AllToAllPE.scala 309:27]
    io.left.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 310:21]
    io.left.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 311:20]
    io.right.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 313:26]
    io.right.out.bits.x_0 <= UInt<16>("h0") @[AllToAllPE.scala 314:25]
    io.right.out.bits.y_0 <= UInt<16>("h0") @[AllToAllPE.scala 315:25]
    io.right.out.bits.x_dest <= UInt<16>("h0") @[AllToAllPE.scala 316:28]
    io.right.out.bits.y_dest <= UInt<16>("h0") @[AllToAllPE.scala 317:28]
    io.right.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 318:22]
    io.right.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 319:21]
    io.up.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 321:23]
    io.up.out.bits.x_0 <= UInt<16>("h0") @[AllToAllPE.scala 322:22]
    io.up.out.bits.y_0 <= UInt<16>("h0") @[AllToAllPE.scala 323:22]
    io.up.out.bits.x_dest <= UInt<16>("h0") @[AllToAllPE.scala 324:25]
    io.up.out.bits.y_dest <= UInt<16>("h0") @[AllToAllPE.scala 325:25]
    io.up.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 326:19]
    io.up.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 327:18]
    io.bottom.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 329:27]
    io.bottom.out.bits.x_0 <= UInt<16>("h0") @[AllToAllPE.scala 330:26]
    io.bottom.out.bits.y_0 <= UInt<16>("h0") @[AllToAllPE.scala 331:26]
    io.bottom.out.bits.x_dest <= UInt<16>("h0") @[AllToAllPE.scala 332:29]
    io.bottom.out.bits.y_dest <= UInt<16>("h0") @[AllToAllPE.scala 333:29]
    io.bottom.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 334:23]
    io.bottom.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 335:22]


circuit AllToAllPE :
  module AllToAllPE :
    input clock : Clock
    input reset : UInt<1>
    output io : { busy : UInt<1>, flip end_AllToAll : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, write_enable : UInt<1>}}, left : { out : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<2>, y_0 : UInt<2>, x_dest : UInt<2>, y_dest : UInt<2>}}, flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<2>, y_0 : UInt<2>, x_dest : UInt<2>, y_dest : UInt<2>}}}, right : { out : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<2>, y_0 : UInt<2>, x_dest : UInt<2>, y_dest : UInt<2>}}, flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<2>, y_0 : UInt<2>, x_dest : UInt<2>, y_dest : UInt<2>}}}, up : { out : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<2>, y_0 : UInt<2>, x_dest : UInt<2>, y_dest : UInt<2>}}, flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<2>, y_0 : UInt<2>, x_dest : UInt<2>, y_dest : UInt<2>}}}, bottom : { out : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<2>, y_0 : UInt<2>, x_dest : UInt<2>, y_dest : UInt<2>}}, flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<2>, y_0 : UInt<2>, x_dest : UInt<2>, y_dest : UInt<2>}}}}

    cmem memPE : UInt<64> [1024] @[AllToAllPE.scala 72:18]
    reg x_coord : UInt<2>, clock with :
      reset => (reset, UInt<2>("h2")) @[AllToAllPE.scala 75:24]
    reg y_coord : UInt<2>, clock with :
      reset => (reset, UInt<1>("h1")) @[AllToAllPE.scala 76:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 79:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 80:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 82:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 83:7]
    reg w_en : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 92:21]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 97:22]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 98:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 100:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 101:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 102:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 110:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 110:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 110:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 111:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 112:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 113:38]
    node _T_2 = eq(io.resp.ready, UInt<1>("h0")) @[AllToAllPE.scala 115:20]
    node stall_resp = and(_T_2, io.resp.valid) @[AllToAllPE.scala 115:35]
    node start_AllToAll = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 116:30]
    wire leftBusy : UInt<1> @[AllToAllPE.scala 118:22]
    wire rightBusy : UInt<1> @[AllToAllPE.scala 119:23]
    wire upBusy : UInt<1> @[AllToAllPE.scala 120:20]
    wire bottomBusy : UInt<1> @[AllToAllPE.scala 121:24]
    leftBusy <= UInt<1>("h0") @[AllToAllPE.scala 123:12]
    rightBusy <= UInt<1>("h0") @[AllToAllPE.scala 124:13]
    rightBusy <= UInt<1>("h0") @[AllToAllPE.scala 125:13]
    upBusy <= UInt<1>("h0") @[AllToAllPE.scala 126:10]
    bottomBusy <= UInt<1>("h0") @[AllToAllPE.scala 127:14]
    node _T_3 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 129:14]
    when _T_3 : @[AllToAllPE.scala 129:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 130:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 131:18]
      io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 132:19]
      io.resp.bits.data <= UInt<1>("h0") @[AllToAllPE.scala 133:23]
      io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 135:31]
      w_en <= UInt<1>("h0") @[AllToAllPE.scala 136:10]
      when load_signal : @[AllToAllPE.scala 138:22]
        state <= UInt<3>("h4") @[AllToAllPE.scala 139:13]
      else :
        when store_signal : @[AllToAllPE.scala 140:29]
          state <= UInt<3>("h5") @[AllToAllPE.scala 141:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 142:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 143:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 145:13]
    else :
      node _T_4 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 148:20]
      when _T_4 : @[AllToAllPE.scala 148:32]
        io.busy <= stall_resp @[AllToAllPE.scala 149:13]
        node _T_5 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 150:21]
        io.cmd.ready <= _T_5 @[AllToAllPE.scala 150:18]
        io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 151:19]
        io.resp.bits.data <= UInt<6>("h20") @[AllToAllPE.scala 152:23]
        resp_value <= UInt<6>("h20") @[AllToAllPE.scala 153:16]
        when is_this_PE : @[AllToAllPE.scala 155:21]
          node _T_6 = bits(memIndex, 9, 0) @[AllToAllPE.scala 156:12]
          infer mport MPORT = memPE[_T_6], clock @[AllToAllPE.scala 156:12]
          MPORT <= rs1 @[AllToAllPE.scala 156:23]
          io.resp.bits.write_enable <= UInt<1>("h1") @[AllToAllPE.scala 157:33]
          w_en <= UInt<1>("h1") @[AllToAllPE.scala 158:12]
        else :
          io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 160:33]
          w_en <= UInt<1>("h0") @[AllToAllPE.scala 161:12]
        node _T_7 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 164:25]
        node _T_8 = and(load_signal, _T_7) @[AllToAllPE.scala 164:22]
        when _T_8 : @[AllToAllPE.scala 164:37]
          state <= UInt<3>("h4") @[AllToAllPE.scala 165:13]
        else :
          node _T_9 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 166:32]
          node _T_10 = and(store_signal, _T_9) @[AllToAllPE.scala 166:29]
          when _T_10 : @[AllToAllPE.scala 166:44]
            state <= UInt<3>("h5") @[AllToAllPE.scala 167:13]
          else :
            node _T_11 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 168:35]
            node _T_12 = and(allToAll_signal, _T_11) @[AllToAllPE.scala 168:32]
            when _T_12 : @[AllToAllPE.scala 168:47]
              state <= UInt<3>("h1") @[AllToAllPE.scala 169:13]
            else :
              when stall_resp : @[AllToAllPE.scala 170:27]
                state <= UInt<3>("h7") @[AllToAllPE.scala 171:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 173:13]
      else :
        node _T_13 = eq(state, UInt<3>("h5")) @[AllToAllPE.scala 176:20]
        when _T_13 : @[AllToAllPE.scala 176:33]
          io.busy <= UInt<1>("h1") @[AllToAllPE.scala 178:13]
          io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 179:18]
          io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 180:19]
          io.resp.bits.data <= UInt<6>("h21") @[AllToAllPE.scala 181:23]
          when is_this_PE : @[AllToAllPE.scala 183:21]
            node _T_14 = bits(memIndex, 9, 0) @[AllToAllPE.scala 184:26]
            infer mport MPORT_1 = memPE[_T_14], clock @[AllToAllPE.scala 184:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 184:18]
            w_en <= UInt<1>("h1") @[AllToAllPE.scala 185:12]
          else :
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 187:12]
          io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 190:31]
          state <= UInt<3>("h6") @[AllToAllPE.scala 192:11]
        else :
          node _T_15 = eq(state, UInt<3>("h6")) @[AllToAllPE.scala 194:20]
          when _T_15 : @[AllToAllPE.scala 194:35]
            io.busy <= stall_resp @[AllToAllPE.scala 196:13]
            node _T_16 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 197:21]
            io.cmd.ready <= _T_16 @[AllToAllPE.scala 197:18]
            io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 198:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 199:23]
            io.resp.bits.write_enable <= w_en @[AllToAllPE.scala 200:31]
            node _T_17 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 202:25]
            node _T_18 = and(load_signal, _T_17) @[AllToAllPE.scala 202:22]
            when _T_18 : @[AllToAllPE.scala 202:37]
              state <= UInt<3>("h4") @[AllToAllPE.scala 203:13]
            else :
              node _T_19 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 204:32]
              node _T_20 = and(store_signal, _T_19) @[AllToAllPE.scala 204:29]
              when _T_20 : @[AllToAllPE.scala 204:44]
                state <= UInt<3>("h5") @[AllToAllPE.scala 205:13]
              else :
                node _T_21 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 206:35]
                node _T_22 = and(allToAll_signal, _T_21) @[AllToAllPE.scala 206:32]
                when _T_22 : @[AllToAllPE.scala 206:47]
                  state <= UInt<3>("h1") @[AllToAllPE.scala 207:13]
                else :
                  when stall_resp : @[AllToAllPE.scala 208:27]
                    state <= UInt<3>("h7") @[AllToAllPE.scala 209:13]
                  else :
                    state <= UInt<3>("h0") @[AllToAllPE.scala 211:13]
          else :
            node _T_23 = eq(state, UInt<3>("h7")) @[AllToAllPE.scala 214:20]
            when _T_23 : @[AllToAllPE.scala 214:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 216:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 217:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 218:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 219:23]
              io.resp.bits.write_enable <= w_en @[AllToAllPE.scala 221:31]
              when stall_resp : @[AllToAllPE.scala 223:21]
                state <= UInt<3>("h7") @[AllToAllPE.scala 224:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 226:13]
            else :
              node _T_24 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 229:20]
              when _T_24 : @[AllToAllPE.scala 229:31]
                io.busy <= UInt<1>("h1") @[AllToAllPE.scala 230:13]
                io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 231:18]
                io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 232:19]
                io.resp.bits.data <= resp_value @[AllToAllPE.scala 233:23]
                w_en <= UInt<1>("h0") @[AllToAllPE.scala 235:10]
                io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 236:31]
                io.left.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 239:22]
                io.right.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 240:23]
                io.up.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 241:20]
                io.bottom.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 242:24]
                state <= UInt<3>("h3") @[AllToAllPE.scala 244:11]
              else :
                node _T_25 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 246:20]
                when _T_25 : @[AllToAllPE.scala 246:41]
                  node _T_26 = or(leftBusy, rightBusy) @[AllToAllPE.scala 248:25]
                  node _T_27 = or(_T_26, upBusy) @[AllToAllPE.scala 248:38]
                  node _T_28 = or(_T_27, bottomBusy) @[AllToAllPE.scala 248:48]
                  io.busy <= _T_28 @[AllToAllPE.scala 248:13]
                  io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 249:18]
                  io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 250:19]
                  io.resp.bits.data <= resp_value @[AllToAllPE.scala 251:23]
                  io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 252:31]
                  io.left.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 255:22]
                  io.right.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 256:23]
                  io.up.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 257:20]
                  io.bottom.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 258:24]
                  when io.end_AllToAll : @[AllToAllPE.scala 260:27]
                    state <= UInt<3>("h3") @[AllToAllPE.scala 261:13]
                  else :
                    state <= UInt<3>("h2") @[AllToAllPE.scala 263:13]
                else :
                  node _T_29 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 266:20]
                  when _T_29 : @[AllToAllPE.scala 266:36]
                    io.busy <= UInt<1>("h0") @[AllToAllPE.scala 267:13]
                    io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 268:18]
                    io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 269:19]
                    io.resp.bits.data <= UInt<1>("h0") @[AllToAllPE.scala 270:23]
                    io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 271:31]
                    state <= UInt<3>("h0") @[AllToAllPE.scala 273:11]
                  else :
                    io.busy <= UInt<1>("h0") @[AllToAllPE.scala 277:13]
                    io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 278:18]
                    io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 279:19]
                    io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 280:23]
                    io.resp.bits.write_enable <= UInt<1>("h1") @[AllToAllPE.scala 281:31]
    reg stateAction : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 290:28]
    node _T_30 = eq(stateAction, UInt<3>("h0")) @[AllToAllPE.scala 294:20]
    when _T_30 : @[AllToAllPE.scala 294:29]
      io.left.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 296:22]
      io.right.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 297:23]
      io.up.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 298:20]
      io.bottom.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 299:24]
      when start_AllToAll : @[AllToAllPE.scala 301:25]
        stateAction <= UInt<3>("h1") @[AllToAllPE.scala 302:19]
      else :
        stateAction <= UInt<3>("h0") @[AllToAllPE.scala 304:19]
    else :
      node _T_31 = eq(stateAction, UInt<3>("h1")) @[AllToAllPE.scala 306:26]
      when _T_31 : @[AllToAllPE.scala 306:37]
        io.left.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 308:22]
        io.right.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 309:23]
        io.up.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 310:20]
        io.bottom.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 311:24]
        when io.end_AllToAll : @[AllToAllPE.scala 314:26]
          stateAction <= UInt<3>("h0") @[AllToAllPE.scala 315:19]
        else :
          stateAction <= UInt<3>("h1") @[AllToAllPE.scala 317:19]
      else :
        skip
    io.left.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 342:25]
    io.left.out.bits.x_0 <= UInt<1>("h0") @[AllToAllPE.scala 343:24]
    io.left.out.bits.y_0 <= UInt<1>("h0") @[AllToAllPE.scala 344:24]
    io.left.out.bits.x_dest <= UInt<1>("h0") @[AllToAllPE.scala 345:27]
    io.left.out.bits.y_dest <= UInt<1>("h0") @[AllToAllPE.scala 346:27]
    io.left.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 347:21]
    io.left.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 348:20]
    io.right.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 350:26]
    io.right.out.bits.x_0 <= UInt<1>("h0") @[AllToAllPE.scala 351:25]
    io.right.out.bits.y_0 <= UInt<1>("h0") @[AllToAllPE.scala 352:25]
    io.right.out.bits.x_dest <= UInt<1>("h0") @[AllToAllPE.scala 353:28]
    io.right.out.bits.y_dest <= UInt<1>("h0") @[AllToAllPE.scala 354:28]
    io.right.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 355:22]
    io.right.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 356:21]
    io.up.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 358:23]
    io.up.out.bits.x_0 <= UInt<1>("h0") @[AllToAllPE.scala 359:22]
    io.up.out.bits.y_0 <= UInt<1>("h0") @[AllToAllPE.scala 360:22]
    io.up.out.bits.x_dest <= UInt<1>("h0") @[AllToAllPE.scala 361:25]
    io.up.out.bits.y_dest <= UInt<1>("h0") @[AllToAllPE.scala 362:25]
    io.up.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 363:19]
    io.up.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 364:18]
    io.bottom.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 366:27]
    io.bottom.out.bits.x_0 <= UInt<1>("h0") @[AllToAllPE.scala 367:26]
    io.bottom.out.bits.y_0 <= UInt<1>("h0") @[AllToAllPE.scala 368:26]
    io.bottom.out.bits.x_dest <= UInt<1>("h0") @[AllToAllPE.scala 369:29]
    io.bottom.out.bits.y_dest <= UInt<1>("h0") @[AllToAllPE.scala 370:29]
    io.bottom.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 371:23]
    io.bottom.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 372:22]


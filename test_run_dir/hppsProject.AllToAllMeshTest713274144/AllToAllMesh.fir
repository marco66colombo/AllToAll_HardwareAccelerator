circuit AllToAllMesh :
  module AllToAllPEupLeftCorner :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [256] @[AllToAllPE.scala 132:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 135:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<2>("h2")) @[AllToAllPE.scala 136:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 139:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 140:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 142:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 143:7]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 148:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 149:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 150:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 152:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 153:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 154:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 160:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 160:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 160:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 161:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 162:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 163:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 165:14]
    when _T_2 : @[AllToAllPE.scala 165:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 166:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 167:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 168:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 169:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 170:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 171:17]
      when load_signal : @[AllToAllPE.scala 173:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 174:13]
      else :
        when store_signal : @[AllToAllPE.scala 175:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 176:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 177:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 178:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 180:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 183:20]
      when _T_3 : @[AllToAllPE.scala 183:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 184:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 185:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 186:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 187:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 188:17]
        when is_this_PE : @[AllToAllPE.scala 190:21]
          node _T_4 = bits(memIndex, 7, 0) @[AllToAllPE.scala 191:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 191:12]
          MPORT <= rs1 @[AllToAllPE.scala 191:23]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 193:16]
        when load_signal : @[AllToAllPE.scala 195:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 196:13]
        else :
          when store_signal : @[AllToAllPE.scala 197:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 198:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 199:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 200:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 202:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 205:20]
        when _T_5 : @[AllToAllPE.scala 205:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 207:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 208:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 209:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 210:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 211:17]
          when is_this_PE : @[AllToAllPE.scala 213:21]
            node _T_6 = bits(memIndex, 7, 0) @[AllToAllPE.scala 214:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 214:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 214:18]
          when load_signal : @[AllToAllPE.scala 217:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 218:13]
          else :
            when store_signal : @[AllToAllPE.scala 219:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 220:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 221:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 222:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 224:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 227:20]
          when _T_7 : @[AllToAllPE.scala 227:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 228:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 229:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 230:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 231:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 233:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 235:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 236:20]
            when _T_8 : @[AllToAllPE.scala 236:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 237:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 238:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 239:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 240:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 242:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 244:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 246:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 247:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 248:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 249:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 252:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 253:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 254:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 255:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 293:15]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 295:13]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 297:16]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 298:17]

  module AllToAllPEup :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [256] @[AllToAllPE.scala 132:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h1")) @[AllToAllPE.scala 135:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<2>("h2")) @[AllToAllPE.scala 136:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 139:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 140:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 142:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 143:7]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 148:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 149:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 150:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 152:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 153:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 154:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 160:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 160:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 160:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 161:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 162:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 163:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 165:14]
    when _T_2 : @[AllToAllPE.scala 165:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 166:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 167:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 168:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 169:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 170:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 171:17]
      when load_signal : @[AllToAllPE.scala 173:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 174:13]
      else :
        when store_signal : @[AllToAllPE.scala 175:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 176:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 177:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 178:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 180:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 183:20]
      when _T_3 : @[AllToAllPE.scala 183:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 184:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 185:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 186:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 187:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 188:17]
        when is_this_PE : @[AllToAllPE.scala 190:21]
          node _T_4 = bits(memIndex, 7, 0) @[AllToAllPE.scala 191:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 191:12]
          MPORT <= rs1 @[AllToAllPE.scala 191:23]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 193:16]
        when load_signal : @[AllToAllPE.scala 195:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 196:13]
        else :
          when store_signal : @[AllToAllPE.scala 197:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 198:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 199:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 200:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 202:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 205:20]
        when _T_5 : @[AllToAllPE.scala 205:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 207:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 208:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 209:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 210:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 211:17]
          when is_this_PE : @[AllToAllPE.scala 213:21]
            node _T_6 = bits(memIndex, 7, 0) @[AllToAllPE.scala 214:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 214:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 214:18]
          when load_signal : @[AllToAllPE.scala 217:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 218:13]
          else :
            when store_signal : @[AllToAllPE.scala 219:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 220:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 221:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 222:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 224:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 227:20]
          when _T_7 : @[AllToAllPE.scala 227:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 228:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 229:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 230:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 231:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 233:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 235:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 236:20]
            when _T_8 : @[AllToAllPE.scala 236:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 237:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 238:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 239:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 240:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 242:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 244:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 246:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 247:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 248:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 249:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 252:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 253:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 254:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 255:17]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 343:13]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 345:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 346:16]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 347:17]

  module AllToAllPEupRightCorner :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [256] @[AllToAllPE.scala 132:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<2>("h2")) @[AllToAllPE.scala 135:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<2>("h2")) @[AllToAllPE.scala 136:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 139:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 140:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 142:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 143:7]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 148:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 149:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 150:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 152:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 153:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 154:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 160:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 160:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 160:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 161:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 162:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 163:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 165:14]
    when _T_2 : @[AllToAllPE.scala 165:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 166:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 167:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 168:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 169:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 170:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 171:17]
      when load_signal : @[AllToAllPE.scala 173:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 174:13]
      else :
        when store_signal : @[AllToAllPE.scala 175:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 176:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 177:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 178:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 180:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 183:20]
      when _T_3 : @[AllToAllPE.scala 183:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 184:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 185:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 186:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 187:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 188:17]
        when is_this_PE : @[AllToAllPE.scala 190:21]
          node _T_4 = bits(memIndex, 7, 0) @[AllToAllPE.scala 191:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 191:12]
          MPORT <= rs1 @[AllToAllPE.scala 191:23]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 193:16]
        when load_signal : @[AllToAllPE.scala 195:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 196:13]
        else :
          when store_signal : @[AllToAllPE.scala 197:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 198:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 199:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 200:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 202:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 205:20]
        when _T_5 : @[AllToAllPE.scala 205:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 207:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 208:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 209:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 210:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 211:17]
          when is_this_PE : @[AllToAllPE.scala 213:21]
            node _T_6 = bits(memIndex, 7, 0) @[AllToAllPE.scala 214:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 214:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 214:18]
          when load_signal : @[AllToAllPE.scala 217:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 218:13]
          else :
            when store_signal : @[AllToAllPE.scala 219:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 220:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 221:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 222:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 224:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 227:20]
          when _T_7 : @[AllToAllPE.scala 227:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 228:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 229:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 230:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 231:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 233:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 235:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 236:20]
            when _T_8 : @[AllToAllPE.scala 236:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 237:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 238:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 239:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 240:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 242:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 244:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 246:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 247:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 248:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 249:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 252:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 253:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 254:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 255:17]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 305:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 307:13]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 309:15]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 310:17]

  module AllToAllPEleft :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [256] @[AllToAllPE.scala 132:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 135:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h1")) @[AllToAllPE.scala 136:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 139:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 140:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 142:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 143:7]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 148:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 149:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 150:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 152:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 153:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 154:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 160:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 160:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 160:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 161:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 162:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 163:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 165:14]
    when _T_2 : @[AllToAllPE.scala 165:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 166:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 167:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 168:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 169:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 170:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 171:17]
      when load_signal : @[AllToAllPE.scala 173:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 174:13]
      else :
        when store_signal : @[AllToAllPE.scala 175:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 176:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 177:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 178:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 180:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 183:20]
      when _T_3 : @[AllToAllPE.scala 183:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 184:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 185:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 186:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 187:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 188:17]
        when is_this_PE : @[AllToAllPE.scala 190:21]
          node _T_4 = bits(memIndex, 7, 0) @[AllToAllPE.scala 191:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 191:12]
          MPORT <= rs1 @[AllToAllPE.scala 191:23]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 193:16]
        when load_signal : @[AllToAllPE.scala 195:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 196:13]
        else :
          when store_signal : @[AllToAllPE.scala 197:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 198:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 199:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 200:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 202:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 205:20]
        when _T_5 : @[AllToAllPE.scala 205:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 207:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 208:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 209:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 210:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 211:17]
          when is_this_PE : @[AllToAllPE.scala 213:21]
            node _T_6 = bits(memIndex, 7, 0) @[AllToAllPE.scala 214:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 214:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 214:18]
          when load_signal : @[AllToAllPE.scala 217:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 218:13]
          else :
            when store_signal : @[AllToAllPE.scala 219:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 220:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 221:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 222:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 224:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 227:20]
          when _T_7 : @[AllToAllPE.scala 227:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 228:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 229:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 230:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 231:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 233:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 235:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 236:20]
            when _T_8 : @[AllToAllPE.scala 236:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 237:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 238:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 239:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 240:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 242:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 244:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 246:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 247:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 248:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 249:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 252:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 253:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 254:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 255:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 365:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 367:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 368:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 369:17]

  module AllToAllPEmiddle :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [256] @[AllToAllPE.scala 132:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h1")) @[AllToAllPE.scala 135:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h1")) @[AllToAllPE.scala 136:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 139:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 140:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 142:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 143:7]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 148:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 149:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 150:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 152:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 153:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 154:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 160:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 160:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 160:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 161:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 162:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 163:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 165:14]
    when _T_2 : @[AllToAllPE.scala 165:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 166:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 167:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 168:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 169:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 170:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 171:17]
      when load_signal : @[AllToAllPE.scala 173:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 174:13]
      else :
        when store_signal : @[AllToAllPE.scala 175:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 176:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 177:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 178:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 180:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 183:20]
      when _T_3 : @[AllToAllPE.scala 183:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 184:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 185:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 186:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 187:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 188:17]
        when is_this_PE : @[AllToAllPE.scala 190:21]
          node _T_4 = bits(memIndex, 7, 0) @[AllToAllPE.scala 191:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 191:12]
          MPORT <= rs1 @[AllToAllPE.scala 191:23]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 193:16]
        when load_signal : @[AllToAllPE.scala 195:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 196:13]
        else :
          when store_signal : @[AllToAllPE.scala 197:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 198:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 199:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 200:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 202:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 205:20]
        when _T_5 : @[AllToAllPE.scala 205:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 207:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 208:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 209:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 210:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 211:17]
          when is_this_PE : @[AllToAllPE.scala 213:21]
            node _T_6 = bits(memIndex, 7, 0) @[AllToAllPE.scala 214:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 214:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 214:18]
          when load_signal : @[AllToAllPE.scala 217:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 218:13]
          else :
            when store_signal : @[AllToAllPE.scala 219:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 220:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 221:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 222:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 224:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 227:20]
          when _T_7 : @[AllToAllPE.scala 227:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 228:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 229:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 230:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 231:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 233:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 235:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 236:20]
            when _T_8 : @[AllToAllPE.scala 236:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 237:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 238:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 239:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 240:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 242:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 244:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 246:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 247:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 248:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 249:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 252:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 253:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 254:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 255:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 386:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 387:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 388:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 389:17]

  module AllToAllPEright :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [256] @[AllToAllPE.scala 132:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<2>("h2")) @[AllToAllPE.scala 135:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h1")) @[AllToAllPE.scala 136:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 139:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 140:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 142:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 143:7]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 148:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 149:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 150:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 152:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 153:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 154:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 160:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 160:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 160:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 161:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 162:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 163:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 165:14]
    when _T_2 : @[AllToAllPE.scala 165:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 166:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 167:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 168:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 169:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 170:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 171:17]
      when load_signal : @[AllToAllPE.scala 173:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 174:13]
      else :
        when store_signal : @[AllToAllPE.scala 175:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 176:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 177:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 178:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 180:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 183:20]
      when _T_3 : @[AllToAllPE.scala 183:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 184:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 185:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 186:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 187:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 188:17]
        when is_this_PE : @[AllToAllPE.scala 190:21]
          node _T_4 = bits(memIndex, 7, 0) @[AllToAllPE.scala 191:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 191:12]
          MPORT <= rs1 @[AllToAllPE.scala 191:23]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 193:16]
        when load_signal : @[AllToAllPE.scala 195:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 196:13]
        else :
          when store_signal : @[AllToAllPE.scala 197:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 198:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 199:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 200:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 202:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 205:20]
        when _T_5 : @[AllToAllPE.scala 205:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 207:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 208:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 209:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 210:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 211:17]
          when is_this_PE : @[AllToAllPE.scala 213:21]
            node _T_6 = bits(memIndex, 7, 0) @[AllToAllPE.scala 214:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 214:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 214:18]
          when load_signal : @[AllToAllPE.scala 217:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 218:13]
          else :
            when store_signal : @[AllToAllPE.scala 219:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 220:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 221:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 222:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 224:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 227:20]
          when _T_7 : @[AllToAllPE.scala 227:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 228:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 229:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 230:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 231:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 233:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 235:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 236:20]
            when _T_8 : @[AllToAllPE.scala 236:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 237:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 238:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 239:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 240:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 242:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 244:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 246:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 247:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 248:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 249:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 252:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 253:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 254:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 255:17]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 376:16]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 378:15]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 379:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 380:17]

  module AllToAllPEbottomLeftCorner :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [256] @[AllToAllPE.scala 132:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 135:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 136:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 139:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 140:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 142:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 143:7]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 148:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 149:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 150:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 152:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 153:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 154:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 160:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 160:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 160:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 161:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 162:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 163:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 165:14]
    when _T_2 : @[AllToAllPE.scala 165:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 166:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 167:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 168:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 169:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 170:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 171:17]
      when load_signal : @[AllToAllPE.scala 173:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 174:13]
      else :
        when store_signal : @[AllToAllPE.scala 175:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 176:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 177:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 178:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 180:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 183:20]
      when _T_3 : @[AllToAllPE.scala 183:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 184:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 185:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 186:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 187:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 188:17]
        when is_this_PE : @[AllToAllPE.scala 190:21]
          node _T_4 = bits(memIndex, 7, 0) @[AllToAllPE.scala 191:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 191:12]
          MPORT <= rs1 @[AllToAllPE.scala 191:23]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 193:16]
        when load_signal : @[AllToAllPE.scala 195:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 196:13]
        else :
          when store_signal : @[AllToAllPE.scala 197:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 198:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 199:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 200:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 202:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 205:20]
        when _T_5 : @[AllToAllPE.scala 205:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 207:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 208:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 209:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 210:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 211:17]
          when is_this_PE : @[AllToAllPE.scala 213:21]
            node _T_6 = bits(memIndex, 7, 0) @[AllToAllPE.scala 214:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 214:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 214:18]
          when load_signal : @[AllToAllPE.scala 217:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 218:13]
          else :
            when store_signal : @[AllToAllPE.scala 219:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 220:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 221:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 222:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 224:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 227:20]
          when _T_7 : @[AllToAllPE.scala 227:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 228:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 229:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 230:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 231:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 233:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 235:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 236:20]
            when _T_8 : @[AllToAllPE.scala 236:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 237:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 238:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 239:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 240:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 242:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 244:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 246:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 247:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 248:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 249:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 252:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 253:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 254:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 255:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 317:15]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 319:17]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 322:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 323:13]

  module AllToAllPEbottom :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [256] @[AllToAllPE.scala 132:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h1")) @[AllToAllPE.scala 135:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 136:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 139:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 140:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 142:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 143:7]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 148:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 149:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 150:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 152:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 153:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 154:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 160:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 160:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 160:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 161:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 162:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 163:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 165:14]
    when _T_2 : @[AllToAllPE.scala 165:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 166:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 167:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 168:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 169:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 170:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 171:17]
      when load_signal : @[AllToAllPE.scala 173:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 174:13]
      else :
        when store_signal : @[AllToAllPE.scala 175:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 176:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 177:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 178:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 180:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 183:20]
      when _T_3 : @[AllToAllPE.scala 183:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 184:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 185:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 186:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 187:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 188:17]
        when is_this_PE : @[AllToAllPE.scala 190:21]
          node _T_4 = bits(memIndex, 7, 0) @[AllToAllPE.scala 191:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 191:12]
          MPORT <= rs1 @[AllToAllPE.scala 191:23]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 193:16]
        when load_signal : @[AllToAllPE.scala 195:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 196:13]
        else :
          when store_signal : @[AllToAllPE.scala 197:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 198:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 199:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 200:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 202:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 205:20]
        when _T_5 : @[AllToAllPE.scala 205:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 207:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 208:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 209:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 210:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 211:17]
          when is_this_PE : @[AllToAllPE.scala 213:21]
            node _T_6 = bits(memIndex, 7, 0) @[AllToAllPE.scala 214:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 214:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 214:18]
          when load_signal : @[AllToAllPE.scala 217:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 218:13]
          else :
            when store_signal : @[AllToAllPE.scala 219:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 220:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 221:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 222:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 224:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 227:20]
          when _T_7 : @[AllToAllPE.scala 227:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 228:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 229:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 230:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 231:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 233:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 235:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 236:20]
            when _T_8 : @[AllToAllPE.scala 236:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 237:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 238:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 239:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 240:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 242:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 244:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 246:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 247:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 248:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 249:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 252:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 253:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 254:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 255:17]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 353:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 355:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 356:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 357:13]

  module AllToAllPEbottomRightCorner :
    input clock : Clock
    input reset : Reset
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [256] @[AllToAllPE.scala 132:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<2>("h2")) @[AllToAllPE.scala 135:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 136:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 139:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 140:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 142:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 143:7]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 148:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 149:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 150:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 152:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 153:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 154:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 160:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 160:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 160:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 161:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 162:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 163:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 165:14]
    when _T_2 : @[AllToAllPE.scala 165:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 166:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 167:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 168:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 169:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 170:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 171:17]
      when load_signal : @[AllToAllPE.scala 173:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 174:13]
      else :
        when store_signal : @[AllToAllPE.scala 175:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 176:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 177:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 178:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 180:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 183:20]
      when _T_3 : @[AllToAllPE.scala 183:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 184:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 185:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 186:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 187:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 188:17]
        when is_this_PE : @[AllToAllPE.scala 190:21]
          node _T_4 = bits(memIndex, 7, 0) @[AllToAllPE.scala 191:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 191:12]
          MPORT <= rs1 @[AllToAllPE.scala 191:23]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 193:16]
        when load_signal : @[AllToAllPE.scala 195:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 196:13]
        else :
          when store_signal : @[AllToAllPE.scala 197:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 198:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 199:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 200:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 202:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 205:20]
        when _T_5 : @[AllToAllPE.scala 205:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 207:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 208:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 209:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 210:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 211:17]
          when is_this_PE : @[AllToAllPE.scala 213:21]
            node _T_6 = bits(memIndex, 7, 0) @[AllToAllPE.scala 214:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 214:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 214:18]
          when load_signal : @[AllToAllPE.scala 217:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 218:13]
          else :
            when store_signal : @[AllToAllPE.scala 219:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 220:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 221:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 222:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 224:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 227:20]
          when _T_7 : @[AllToAllPE.scala 227:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 228:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 229:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 230:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 231:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 233:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 235:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 236:20]
            when _T_8 : @[AllToAllPE.scala 236:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 237:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 238:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 239:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 240:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 242:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 244:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 246:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 247:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 248:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 249:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 252:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 253:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 254:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 255:17]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 330:16]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 332:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 334:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 335:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 336:13]

  module AllToAllMesh :
    input clock : Clock
    input reset : UInt<1>
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
    node _T_24 = bits(io.cmd.bits.rs2, 15, 0) @[AllToAllMesh.scala 152:18]
    node _T_25 = bits(io.cmd.bits.rs2, 31, 16) @[AllToAllMesh.scala 153:18]
    node _T_26 = sub(UInt<2>("h3"), UInt<1>("h1")) @[AllToAllMesh.scala 154:14]
    node _T_27 = tail(_T_26, 1) @[AllToAllMesh.scala 154:14]
    node _T_28 = sub(_T_27, _T_25) @[AllToAllMesh.scala 154:18]
    node _T_29 = tail(_T_28, 1) @[AllToAllMesh.scala 154:18]
    node _T_30 = mul(_T_29, UInt<2>("h3")) @[AllToAllMesh.scala 154:21]
    node _T_31 = add(_T_30, _T_24) @[AllToAllMesh.scala 154:25]
    node nPE = tail(_T_31, 1) @[AllToAllMesh.scala 154:25]
    node _T_32 = eq(nPE, UInt<1>("h0")) @[AllToAllMesh.scala 160:27]
    node _T_33 = eq(nPE, UInt<1>("h1")) @[AllToAllMesh.scala 163:25]
    node _T_34 = eq(nPE, UInt<2>("h2")) @[AllToAllMesh.scala 163:25]
    node _T_35 = eq(nPE, UInt<2>("h3")) @[AllToAllMesh.scala 163:25]
    node _T_36 = eq(nPE, UInt<3>("h4")) @[AllToAllMesh.scala 163:25]
    node _T_37 = eq(nPE, UInt<3>("h5")) @[AllToAllMesh.scala 163:25]
    node _T_38 = eq(nPE, UInt<3>("h6")) @[AllToAllMesh.scala 163:25]
    node _T_39 = eq(nPE, UInt<3>("h7")) @[AllToAllMesh.scala 163:25]
    node _T_40 = eq(nPE, UInt<4>("h8")) @[AllToAllMesh.scala 163:25]
    io.resp.bits.data <= vector_0.io.resp.bits.data @[AllToAllMesh.scala 169:23]
    vector_0.io.left.in <= UInt<64>("h0") @[AllToAllMesh.scala 178:34]
    vector_0.io.up.in <= UInt<64>("h0") @[AllToAllMesh.scala 179:32]
    vector_0.io.right.in <= vector_1.io.left.out @[AllToAllMesh.scala 181:35]
    vector_0.io.bottom.in <= vector_3.io.up.out @[AllToAllMesh.scala 182:36]
    vector_1.io.up.in <= UInt<64>("h0") @[AllToAllMesh.scala 210:32]
    vector_1.io.left.in <= vector_0.io.right.out @[AllToAllMesh.scala 212:34]
    vector_1.io.right.in <= vector_2.io.left.out @[AllToAllMesh.scala 213:35]
    vector_1.io.bottom.in <= vector_4.io.up.out @[AllToAllMesh.scala 214:36]
    vector_2.io.right.in <= UInt<64>("h0") @[AllToAllMesh.scala 186:35]
    vector_2.io.up.in <= UInt<64>("h0") @[AllToAllMesh.scala 187:32]
    vector_2.io.left.in <= vector_1.io.right.out @[AllToAllMesh.scala 189:34]
    vector_2.io.bottom.in <= vector_5.io.up.out @[AllToAllMesh.scala 190:36]
    vector_3.io.left.in <= UInt<64>("h0") @[AllToAllMesh.scala 226:34]
    vector_3.io.right.in <= vector_4.io.left.out @[AllToAllMesh.scala 228:35]
    vector_3.io.up.in <= vector_0.io.bottom.out @[AllToAllMesh.scala 229:32]
    vector_3.io.bottom.in <= vector_6.io.up.out @[AllToAllMesh.scala 230:36]
    vector_4.io.left.in <= vector_3.io.right.out @[AllToAllMesh.scala 242:34]
    vector_4.io.right.in <= vector_5.io.left.out @[AllToAllMesh.scala 243:35]
    vector_4.io.up.in <= vector_1.io.bottom.out @[AllToAllMesh.scala 244:32]
    vector_4.io.bottom.in <= vector_7.io.up.out @[AllToAllMesh.scala 245:36]
    vector_5.io.right.in <= UInt<64>("h0") @[AllToAllMesh.scala 234:35]
    vector_5.io.left.in <= vector_4.io.right.out @[AllToAllMesh.scala 236:34]
    vector_5.io.up.in <= vector_2.io.bottom.out @[AllToAllMesh.scala 237:32]
    vector_5.io.bottom.in <= vector_8.io.up.out @[AllToAllMesh.scala 238:36]
    vector_6.io.left.in <= UInt<64>("h0") @[AllToAllMesh.scala 194:34]
    vector_6.io.bottom.in <= UInt<64>("h0") @[AllToAllMesh.scala 195:36]
    vector_6.io.right.in <= vector_7.io.left.out @[AllToAllMesh.scala 197:35]
    vector_6.io.up.in <= vector_3.io.bottom.out @[AllToAllMesh.scala 198:32]
    vector_7.io.bottom.in <= UInt<64>("h0") @[AllToAllMesh.scala 218:36]
    vector_7.io.left.in <= vector_6.io.right.out @[AllToAllMesh.scala 220:34]
    vector_7.io.right.in <= vector_8.io.left.out @[AllToAllMesh.scala 221:35]
    vector_7.io.up.in <= vector_4.io.bottom.out @[AllToAllMesh.scala 222:32]
    vector_8.io.right.in <= UInt<64>("h0") @[AllToAllMesh.scala 202:35]
    vector_8.io.bottom.in <= UInt<64>("h0") @[AllToAllMesh.scala 203:36]
    vector_8.io.left.in <= vector_7.io.right.out @[AllToAllMesh.scala 205:34]
    vector_8.io.up.in <= vector_5.io.bottom.out @[AllToAllMesh.scala 206:32]


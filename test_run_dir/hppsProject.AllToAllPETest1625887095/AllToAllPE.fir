circuit AllToAllPE :
  module AllToAllPE :
    input clock : Clock
    input reset : UInt<1>
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, write_enable : UInt<1>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [1024] @[AllToAllPE.scala 133:18]
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
          node _T_4 = bits(memIndex, 9, 0) @[AllToAllPE.scala 197:12]
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
            node _T_6 = bits(memIndex, 9, 0) @[AllToAllPE.scala 223:26]
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


circuit AllToAllPE :
  module AllToAllPE :
    input clock : Clock
    input reset : UInt<1>
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [1024] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<2>("h2")) @[AllToAllPE.scala 132:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h1")) @[AllToAllPE.scala 133:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 143:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 144:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 146:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 147:7]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 150:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 151:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 152:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 156:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 157:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 158:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 161:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 161:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 161:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 162:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 163:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 164:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 166:14]
    when _T_2 : @[AllToAllPE.scala 166:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 167:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 168:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 169:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 170:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 171:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 172:17]
      when load_signal : @[AllToAllPE.scala 174:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 175:13]
      else :
        when store_signal : @[AllToAllPE.scala 176:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 177:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 178:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 179:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 181:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 184:20]
      when _T_3 : @[AllToAllPE.scala 184:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 185:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 186:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 187:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 188:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 189:17]
        when is_this_PE : @[AllToAllPE.scala 191:21]
          node _T_4 = bits(memIndex, 9, 0) @[AllToAllPE.scala 193:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 193:12]
          MPORT <= rs1 @[AllToAllPE.scala 193:23]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 195:16]
        when load_signal : @[AllToAllPE.scala 197:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 198:13]
        else :
          when store_signal : @[AllToAllPE.scala 199:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 200:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 201:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 202:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 204:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 207:20]
        when _T_5 : @[AllToAllPE.scala 207:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 209:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 210:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 211:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 212:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 213:17]
          when is_this_PE : @[AllToAllPE.scala 215:21]
            node _T_6 = bits(memIndex, 9, 0) @[AllToAllPE.scala 216:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 216:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 216:18]
          when load_signal : @[AllToAllPE.scala 219:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 220:13]
          else :
            when store_signal : @[AllToAllPE.scala 221:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 222:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 223:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 224:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 226:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 229:20]
          when _T_7 : @[AllToAllPE.scala 229:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 230:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 231:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 232:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 233:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 235:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 237:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 238:20]
            when _T_8 : @[AllToAllPE.scala 238:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 239:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 240:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 241:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 242:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 244:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 246:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 248:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 249:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 250:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 251:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 254:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 255:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 256:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 257:17]


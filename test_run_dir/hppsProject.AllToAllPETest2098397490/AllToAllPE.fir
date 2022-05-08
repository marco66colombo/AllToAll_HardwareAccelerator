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
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 144:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 145:28]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 146:27]
    node x_value = bits(io.cmd.bits.rs2, 15, 0) @[AllToAllPE.scala 147:32]
    node y_value = bits(io.cmd.bits.rs2, 31, 16) @[AllToAllPE.scala 148:32]
    node memIndex = bits(io.cmd.bits.rs2, 63, 32) @[AllToAllPE.scala 149:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 152:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 152:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 152:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 153:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 154:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 155:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 157:14]
    when _T_2 : @[AllToAllPE.scala 157:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 158:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 159:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 160:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 161:23]
      resp_value <= UInt<1>("h0") @[AllToAllPE.scala 162:16]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 163:17]
      when load_signal : @[AllToAllPE.scala 165:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 166:13]
      else :
        when store_signal : @[AllToAllPE.scala 167:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 168:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 169:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 170:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 172:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 175:20]
      when _T_3 : @[AllToAllPE.scala 175:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 176:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 177:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 178:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 179:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 180:17]
        when is_this_PE : @[AllToAllPE.scala 182:21]
          node _T_4 = bits(memIndex, 9, 0) @[AllToAllPE.scala 183:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 183:12]
          MPORT <= io.cmd.bits.rs1 @[AllToAllPE.scala 183:23]
        resp_value <= UInt<64>("h20") @[AllToAllPE.scala 185:16]
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
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 197:20]
        when _T_5 : @[AllToAllPE.scala 197:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 199:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 200:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 201:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 202:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 203:17]
          when is_this_PE : @[AllToAllPE.scala 205:21]
            node _T_6 = bits(memIndex, 9, 0) @[AllToAllPE.scala 206:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 206:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 206:18]
          when load_signal : @[AllToAllPE.scala 209:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 210:13]
          else :
            when store_signal : @[AllToAllPE.scala 211:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 212:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 213:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 214:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 216:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 219:20]
          when _T_7 : @[AllToAllPE.scala 219:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 220:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 221:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 222:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 223:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 225:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 227:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 228:20]
            when _T_8 : @[AllToAllPE.scala 228:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 229:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 230:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 231:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 232:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 234:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 236:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 238:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 239:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 240:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 241:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 244:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 245:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 246:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 247:17]


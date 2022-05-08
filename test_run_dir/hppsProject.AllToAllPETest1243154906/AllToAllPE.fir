circuit AllToAllPE :
  module AllToAllPE :
    input clock : Clock
    input reset : UInt<1>
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [1024] @[AllToAllPE.scala 132:18]
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
          node _T_4 = bits(memIndex, 9, 0) @[AllToAllPE.scala 191:12]
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
            node _T_6 = bits(memIndex, 9, 0) @[AllToAllPE.scala 214:26]
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


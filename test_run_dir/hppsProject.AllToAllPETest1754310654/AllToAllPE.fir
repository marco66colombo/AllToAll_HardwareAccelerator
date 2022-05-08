circuit AllToAllPE :
  module AllToAllPE :
    input clock : Clock
    input reset : UInt<1>
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>}}, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [1024] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), x_coord) @[AllToAllPE.scala 132:20]
    reg y_coord : UInt<16>, clock with :
      reset => (UInt<1>("h0"), y_coord) @[AllToAllPE.scala 133:20]
    x_coord <= UInt<16>("h2") @[AllToAllPE.scala 134:11]
    y_coord <= UInt<16>("h1") @[AllToAllPE.scala 135:11]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 144:22]
    reg resp_signal : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 145:28]
    reg resp_value : UInt<64>, clock with :
      reset => (UInt<1>("h0"), resp_value) @[AllToAllPE.scala 146:23]
    node x_value = bits(io.cmd.bits.rs2, 15, 0) @[AllToAllPE.scala 147:32]
    node y_value = bits(io.cmd.bits.rs2, 31, 16) @[AllToAllPE.scala 148:32]
    node memIndex = bits(io.cmd.bits.rs2, 63, 32) @[AllToAllPE.scala 149:33]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 152:28]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 152:51]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 152:40]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 153:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 154:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 155:38]
    node _T_2 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 157:14]
    when _T_2 : @[AllToAllPE.scala 157:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 158:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 159:18]
      io.resp.valid <= resp_signal @[AllToAllPE.scala 160:19]
      io.resp.bits.data <= resp_value @[AllToAllPE.scala 161:23]
      resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 162:17]
      when load_signal : @[AllToAllPE.scala 164:22]
        state <= UInt<3>("h3") @[AllToAllPE.scala 165:13]
      else :
        when store_signal : @[AllToAllPE.scala 166:29]
          state <= UInt<3>("h4") @[AllToAllPE.scala 167:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 168:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 169:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 171:13]
    else :
      node _T_3 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 174:20]
      when _T_3 : @[AllToAllPE.scala 174:32]
        io.busy <= UInt<1>("h0") @[AllToAllPE.scala 175:13]
        io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 176:18]
        io.resp.valid <= resp_signal @[AllToAllPE.scala 177:19]
        io.resp.bits.data <= resp_value @[AllToAllPE.scala 178:23]
        resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 179:17]
        when is_this_PE : @[AllToAllPE.scala 181:21]
          node _T_4 = bits(memIndex, 9, 0) @[AllToAllPE.scala 182:12]
          infer mport MPORT = memPE[_T_4], clock @[AllToAllPE.scala 182:12]
          MPORT <= io.cmd.bits.rs1 @[AllToAllPE.scala 182:23]
        resp_value <= UInt<64>("h0") @[AllToAllPE.scala 184:16]
        when load_signal : @[AllToAllPE.scala 186:22]
          state <= UInt<3>("h3") @[AllToAllPE.scala 187:13]
        else :
          when store_signal : @[AllToAllPE.scala 188:29]
            state <= UInt<3>("h4") @[AllToAllPE.scala 189:13]
          else :
            when allToAll_signal : @[AllToAllPE.scala 190:32]
              state <= UInt<3>("h1") @[AllToAllPE.scala 191:13]
            else :
              state <= UInt<3>("h0") @[AllToAllPE.scala 193:13]
      else :
        node _T_5 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 196:20]
        when _T_5 : @[AllToAllPE.scala 196:33]
          io.busy <= UInt<1>("h0") @[AllToAllPE.scala 198:13]
          io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 199:18]
          io.resp.valid <= resp_signal @[AllToAllPE.scala 200:19]
          io.resp.bits.data <= resp_value @[AllToAllPE.scala 201:23]
          resp_signal <= UInt<1>("h1") @[AllToAllPE.scala 202:17]
          when is_this_PE : @[AllToAllPE.scala 204:21]
            node _T_6 = bits(memIndex, 9, 0) @[AllToAllPE.scala 205:26]
            infer mport MPORT_1 = memPE[_T_6], clock @[AllToAllPE.scala 205:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 205:18]
          when load_signal : @[AllToAllPE.scala 208:22]
            state <= UInt<3>("h3") @[AllToAllPE.scala 209:13]
          else :
            when store_signal : @[AllToAllPE.scala 210:29]
              state <= UInt<3>("h4") @[AllToAllPE.scala 211:13]
            else :
              when allToAll_signal : @[AllToAllPE.scala 212:32]
                state <= UInt<3>("h1") @[AllToAllPE.scala 213:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 215:13]
        else :
          node _T_7 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 218:20]
          when _T_7 : @[AllToAllPE.scala 218:31]
            io.busy <= UInt<1>("h1") @[AllToAllPE.scala 219:13]
            io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 220:18]
            io.resp.valid <= resp_signal @[AllToAllPE.scala 221:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 222:23]
            resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 224:17]
            state <= UInt<3>("h2") @[AllToAllPE.scala 226:11]
          else :
            node _T_8 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 227:20]
            when _T_8 : @[AllToAllPE.scala 227:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 228:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 229:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 230:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 231:23]
              resp_signal <= UInt<1>("h0") @[AllToAllPE.scala 233:17]
              state <= UInt<3>("h0") @[AllToAllPE.scala 235:11]
            else :
              io.busy <= UInt<1>("h0") @[AllToAllPE.scala 237:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 238:18]
              io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 239:19]
              io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 240:23]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 243:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 244:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 245:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 246:17]


circuit AllToAllPE :
  module Queue :
    input clock : Clock
    input reset : Reset
    output io : { flip enq : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}, deq : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}, count : UInt<2>}

    cmem ram : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>} [2] @[Decoupled.scala 218:16]
    reg value : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Counter.scala 60:40]
    reg value_1 : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Counter.scala 60:40]
    reg maybe_full : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Decoupled.scala 221:27]
    node ptr_match = eq(value, value_1) @[Decoupled.scala 223:33]
    node _empty_T = eq(maybe_full, UInt<1>("h0")) @[Decoupled.scala 224:28]
    node empty = and(ptr_match, _empty_T) @[Decoupled.scala 224:25]
    node full = and(ptr_match, maybe_full) @[Decoupled.scala 225:24]
    node _do_enq_T = and(io.enq.ready, io.enq.valid) @[Decoupled.scala 40:37]
    wire do_enq : UInt<1>
    do_enq <= _do_enq_T
    node _do_deq_T = and(io.deq.ready, io.deq.valid) @[Decoupled.scala 40:37]
    wire do_deq : UInt<1>
    do_deq <= _do_deq_T
    when do_enq : @[Decoupled.scala 229:17]
      infer mport MPORT = ram[value], clock @[Decoupled.scala 230:8]
      MPORT.y_dest <= io.enq.bits.y_dest @[Decoupled.scala 230:24]
      MPORT.x_dest <= io.enq.bits.x_dest @[Decoupled.scala 230:24]
      MPORT.y_0 <= io.enq.bits.y_0 @[Decoupled.scala 230:24]
      MPORT.x_0 <= io.enq.bits.x_0 @[Decoupled.scala 230:24]
      MPORT.data <= io.enq.bits.data @[Decoupled.scala 230:24]
      node wrap = eq(value, UInt<1>("h1")) @[Counter.scala 72:24]
      node _value_T = add(value, UInt<1>("h1")) @[Counter.scala 76:24]
      node _value_T_1 = tail(_value_T, 1) @[Counter.scala 76:24]
      value <= _value_T_1 @[Counter.scala 76:15]
    when do_deq : @[Decoupled.scala 233:17]
      node wrap_1 = eq(value_1, UInt<1>("h1")) @[Counter.scala 72:24]
      node _value_T_2 = add(value_1, UInt<1>("h1")) @[Counter.scala 76:24]
      node _value_T_3 = tail(_value_T_2, 1) @[Counter.scala 76:24]
      value_1 <= _value_T_3 @[Counter.scala 76:15]
    node _T = neq(do_enq, do_deq) @[Decoupled.scala 236:16]
    when _T : @[Decoupled.scala 236:28]
      maybe_full <= do_enq @[Decoupled.scala 237:16]
    node _io_deq_valid_T = eq(empty, UInt<1>("h0")) @[Decoupled.scala 240:19]
    io.deq.valid <= _io_deq_valid_T @[Decoupled.scala 240:16]
    node _io_enq_ready_T = eq(full, UInt<1>("h0")) @[Decoupled.scala 241:19]
    io.enq.ready <= _io_enq_ready_T @[Decoupled.scala 241:16]
    infer mport io_deq_bits_MPORT = ram[value_1], clock @[Decoupled.scala 242:21]
    io.deq.bits.y_dest <= io_deq_bits_MPORT.y_dest @[Decoupled.scala 242:15]
    io.deq.bits.x_dest <= io_deq_bits_MPORT.x_dest @[Decoupled.scala 242:15]
    io.deq.bits.y_0 <= io_deq_bits_MPORT.y_0 @[Decoupled.scala 242:15]
    io.deq.bits.x_0 <= io_deq_bits_MPORT.x_0 @[Decoupled.scala 242:15]
    io.deq.bits.data <= io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    node _ptr_diff_T = sub(value, value_1) @[Decoupled.scala 257:32]
    node ptr_diff = tail(_ptr_diff_T, 1) @[Decoupled.scala 257:32]
    node _io_count_T = and(maybe_full, ptr_match) @[Decoupled.scala 259:32]
    node _io_count_T_1 = mux(_io_count_T, UInt<2>("h2"), UInt<1>("h0")) @[Decoupled.scala 259:20]
    node _io_count_T_2 = or(_io_count_T_1, ptr_diff) @[Decoupled.scala 259:62]
    io.count <= _io_count_T_2 @[Decoupled.scala 259:14]

  module Queue_1 :
    input clock : Clock
    input reset : Reset
    output io : { flip enq : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}, deq : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}, count : UInt<2>}

    cmem ram : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>} [2] @[Decoupled.scala 218:16]
    reg value : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Counter.scala 60:40]
    reg value_1 : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Counter.scala 60:40]
    reg maybe_full : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Decoupled.scala 221:27]
    node ptr_match = eq(value, value_1) @[Decoupled.scala 223:33]
    node _empty_T = eq(maybe_full, UInt<1>("h0")) @[Decoupled.scala 224:28]
    node empty = and(ptr_match, _empty_T) @[Decoupled.scala 224:25]
    node full = and(ptr_match, maybe_full) @[Decoupled.scala 225:24]
    node _do_enq_T = and(io.enq.ready, io.enq.valid) @[Decoupled.scala 40:37]
    wire do_enq : UInt<1>
    do_enq <= _do_enq_T
    node _do_deq_T = and(io.deq.ready, io.deq.valid) @[Decoupled.scala 40:37]
    wire do_deq : UInt<1>
    do_deq <= _do_deq_T
    when do_enq : @[Decoupled.scala 229:17]
      infer mport MPORT = ram[value], clock @[Decoupled.scala 230:8]
      MPORT.y_dest <= io.enq.bits.y_dest @[Decoupled.scala 230:24]
      MPORT.x_dest <= io.enq.bits.x_dest @[Decoupled.scala 230:24]
      MPORT.y_0 <= io.enq.bits.y_0 @[Decoupled.scala 230:24]
      MPORT.x_0 <= io.enq.bits.x_0 @[Decoupled.scala 230:24]
      MPORT.data <= io.enq.bits.data @[Decoupled.scala 230:24]
      node wrap = eq(value, UInt<1>("h1")) @[Counter.scala 72:24]
      node _value_T = add(value, UInt<1>("h1")) @[Counter.scala 76:24]
      node _value_T_1 = tail(_value_T, 1) @[Counter.scala 76:24]
      value <= _value_T_1 @[Counter.scala 76:15]
    when do_deq : @[Decoupled.scala 233:17]
      node wrap_1 = eq(value_1, UInt<1>("h1")) @[Counter.scala 72:24]
      node _value_T_2 = add(value_1, UInt<1>("h1")) @[Counter.scala 76:24]
      node _value_T_3 = tail(_value_T_2, 1) @[Counter.scala 76:24]
      value_1 <= _value_T_3 @[Counter.scala 76:15]
    node _T = neq(do_enq, do_deq) @[Decoupled.scala 236:16]
    when _T : @[Decoupled.scala 236:28]
      maybe_full <= do_enq @[Decoupled.scala 237:16]
    node _io_deq_valid_T = eq(empty, UInt<1>("h0")) @[Decoupled.scala 240:19]
    io.deq.valid <= _io_deq_valid_T @[Decoupled.scala 240:16]
    node _io_enq_ready_T = eq(full, UInt<1>("h0")) @[Decoupled.scala 241:19]
    io.enq.ready <= _io_enq_ready_T @[Decoupled.scala 241:16]
    infer mport io_deq_bits_MPORT = ram[value_1], clock @[Decoupled.scala 242:21]
    io.deq.bits.y_dest <= io_deq_bits_MPORT.y_dest @[Decoupled.scala 242:15]
    io.deq.bits.x_dest <= io_deq_bits_MPORT.x_dest @[Decoupled.scala 242:15]
    io.deq.bits.y_0 <= io_deq_bits_MPORT.y_0 @[Decoupled.scala 242:15]
    io.deq.bits.x_0 <= io_deq_bits_MPORT.x_0 @[Decoupled.scala 242:15]
    io.deq.bits.data <= io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    node _ptr_diff_T = sub(value, value_1) @[Decoupled.scala 257:32]
    node ptr_diff = tail(_ptr_diff_T, 1) @[Decoupled.scala 257:32]
    node _io_count_T = and(maybe_full, ptr_match) @[Decoupled.scala 259:32]
    node _io_count_T_1 = mux(_io_count_T, UInt<2>("h2"), UInt<1>("h0")) @[Decoupled.scala 259:20]
    node _io_count_T_2 = or(_io_count_T_1, ptr_diff) @[Decoupled.scala 259:62]
    io.count <= _io_count_T_2 @[Decoupled.scala 259:14]

  module Queue_2 :
    input clock : Clock
    input reset : Reset
    output io : { flip enq : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}, deq : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}, count : UInt<2>}

    cmem ram : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>} [2] @[Decoupled.scala 218:16]
    reg value : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Counter.scala 60:40]
    reg value_1 : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Counter.scala 60:40]
    reg maybe_full : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Decoupled.scala 221:27]
    node ptr_match = eq(value, value_1) @[Decoupled.scala 223:33]
    node _empty_T = eq(maybe_full, UInt<1>("h0")) @[Decoupled.scala 224:28]
    node empty = and(ptr_match, _empty_T) @[Decoupled.scala 224:25]
    node full = and(ptr_match, maybe_full) @[Decoupled.scala 225:24]
    node _do_enq_T = and(io.enq.ready, io.enq.valid) @[Decoupled.scala 40:37]
    wire do_enq : UInt<1>
    do_enq <= _do_enq_T
    node _do_deq_T = and(io.deq.ready, io.deq.valid) @[Decoupled.scala 40:37]
    wire do_deq : UInt<1>
    do_deq <= _do_deq_T
    when do_enq : @[Decoupled.scala 229:17]
      infer mport MPORT = ram[value], clock @[Decoupled.scala 230:8]
      MPORT.y_dest <= io.enq.bits.y_dest @[Decoupled.scala 230:24]
      MPORT.x_dest <= io.enq.bits.x_dest @[Decoupled.scala 230:24]
      MPORT.y_0 <= io.enq.bits.y_0 @[Decoupled.scala 230:24]
      MPORT.x_0 <= io.enq.bits.x_0 @[Decoupled.scala 230:24]
      MPORT.data <= io.enq.bits.data @[Decoupled.scala 230:24]
      node wrap = eq(value, UInt<1>("h1")) @[Counter.scala 72:24]
      node _value_T = add(value, UInt<1>("h1")) @[Counter.scala 76:24]
      node _value_T_1 = tail(_value_T, 1) @[Counter.scala 76:24]
      value <= _value_T_1 @[Counter.scala 76:15]
    when do_deq : @[Decoupled.scala 233:17]
      node wrap_1 = eq(value_1, UInt<1>("h1")) @[Counter.scala 72:24]
      node _value_T_2 = add(value_1, UInt<1>("h1")) @[Counter.scala 76:24]
      node _value_T_3 = tail(_value_T_2, 1) @[Counter.scala 76:24]
      value_1 <= _value_T_3 @[Counter.scala 76:15]
    node _T = neq(do_enq, do_deq) @[Decoupled.scala 236:16]
    when _T : @[Decoupled.scala 236:28]
      maybe_full <= do_enq @[Decoupled.scala 237:16]
    node _io_deq_valid_T = eq(empty, UInt<1>("h0")) @[Decoupled.scala 240:19]
    io.deq.valid <= _io_deq_valid_T @[Decoupled.scala 240:16]
    node _io_enq_ready_T = eq(full, UInt<1>("h0")) @[Decoupled.scala 241:19]
    io.enq.ready <= _io_enq_ready_T @[Decoupled.scala 241:16]
    infer mport io_deq_bits_MPORT = ram[value_1], clock @[Decoupled.scala 242:21]
    io.deq.bits.y_dest <= io_deq_bits_MPORT.y_dest @[Decoupled.scala 242:15]
    io.deq.bits.x_dest <= io_deq_bits_MPORT.x_dest @[Decoupled.scala 242:15]
    io.deq.bits.y_0 <= io_deq_bits_MPORT.y_0 @[Decoupled.scala 242:15]
    io.deq.bits.x_0 <= io_deq_bits_MPORT.x_0 @[Decoupled.scala 242:15]
    io.deq.bits.data <= io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    node _ptr_diff_T = sub(value, value_1) @[Decoupled.scala 257:32]
    node ptr_diff = tail(_ptr_diff_T, 1) @[Decoupled.scala 257:32]
    node _io_count_T = and(maybe_full, ptr_match) @[Decoupled.scala 259:32]
    node _io_count_T_1 = mux(_io_count_T, UInt<2>("h2"), UInt<1>("h0")) @[Decoupled.scala 259:20]
    node _io_count_T_2 = or(_io_count_T_1, ptr_diff) @[Decoupled.scala 259:62]
    io.count <= _io_count_T_2 @[Decoupled.scala 259:14]

  module Queue_3 :
    input clock : Clock
    input reset : Reset
    output io : { flip enq : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}, deq : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}, count : UInt<2>}

    cmem ram : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>} [2] @[Decoupled.scala 218:16]
    reg value : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Counter.scala 60:40]
    reg value_1 : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Counter.scala 60:40]
    reg maybe_full : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[Decoupled.scala 221:27]
    node ptr_match = eq(value, value_1) @[Decoupled.scala 223:33]
    node _empty_T = eq(maybe_full, UInt<1>("h0")) @[Decoupled.scala 224:28]
    node empty = and(ptr_match, _empty_T) @[Decoupled.scala 224:25]
    node full = and(ptr_match, maybe_full) @[Decoupled.scala 225:24]
    node _do_enq_T = and(io.enq.ready, io.enq.valid) @[Decoupled.scala 40:37]
    wire do_enq : UInt<1>
    do_enq <= _do_enq_T
    node _do_deq_T = and(io.deq.ready, io.deq.valid) @[Decoupled.scala 40:37]
    wire do_deq : UInt<1>
    do_deq <= _do_deq_T
    when do_enq : @[Decoupled.scala 229:17]
      infer mport MPORT = ram[value], clock @[Decoupled.scala 230:8]
      MPORT.y_dest <= io.enq.bits.y_dest @[Decoupled.scala 230:24]
      MPORT.x_dest <= io.enq.bits.x_dest @[Decoupled.scala 230:24]
      MPORT.y_0 <= io.enq.bits.y_0 @[Decoupled.scala 230:24]
      MPORT.x_0 <= io.enq.bits.x_0 @[Decoupled.scala 230:24]
      MPORT.data <= io.enq.bits.data @[Decoupled.scala 230:24]
      node wrap = eq(value, UInt<1>("h1")) @[Counter.scala 72:24]
      node _value_T = add(value, UInt<1>("h1")) @[Counter.scala 76:24]
      node _value_T_1 = tail(_value_T, 1) @[Counter.scala 76:24]
      value <= _value_T_1 @[Counter.scala 76:15]
    when do_deq : @[Decoupled.scala 233:17]
      node wrap_1 = eq(value_1, UInt<1>("h1")) @[Counter.scala 72:24]
      node _value_T_2 = add(value_1, UInt<1>("h1")) @[Counter.scala 76:24]
      node _value_T_3 = tail(_value_T_2, 1) @[Counter.scala 76:24]
      value_1 <= _value_T_3 @[Counter.scala 76:15]
    node _T = neq(do_enq, do_deq) @[Decoupled.scala 236:16]
    when _T : @[Decoupled.scala 236:28]
      maybe_full <= do_enq @[Decoupled.scala 237:16]
    node _io_deq_valid_T = eq(empty, UInt<1>("h0")) @[Decoupled.scala 240:19]
    io.deq.valid <= _io_deq_valid_T @[Decoupled.scala 240:16]
    node _io_enq_ready_T = eq(full, UInt<1>("h0")) @[Decoupled.scala 241:19]
    io.enq.ready <= _io_enq_ready_T @[Decoupled.scala 241:16]
    infer mport io_deq_bits_MPORT = ram[value_1], clock @[Decoupled.scala 242:21]
    io.deq.bits.y_dest <= io_deq_bits_MPORT.y_dest @[Decoupled.scala 242:15]
    io.deq.bits.x_dest <= io_deq_bits_MPORT.x_dest @[Decoupled.scala 242:15]
    io.deq.bits.y_0 <= io_deq_bits_MPORT.y_0 @[Decoupled.scala 242:15]
    io.deq.bits.x_0 <= io_deq_bits_MPORT.x_0 @[Decoupled.scala 242:15]
    io.deq.bits.data <= io_deq_bits_MPORT.data @[Decoupled.scala 242:15]
    node _ptr_diff_T = sub(value, value_1) @[Decoupled.scala 257:32]
    node ptr_diff = tail(_ptr_diff_T, 1) @[Decoupled.scala 257:32]
    node _io_count_T = and(maybe_full, ptr_match) @[Decoupled.scala 259:32]
    node _io_count_T_1 = mux(_io_count_T, UInt<2>("h2"), UInt<1>("h0")) @[Decoupled.scala 259:20]
    node _io_count_T_2 = or(_io_count_T_1, ptr_diff) @[Decoupled.scala 259:62]
    io.count <= _io_count_T_2 @[Decoupled.scala 259:14]

  module AllToAllPE :
    input clock : Clock
    input reset : UInt<1>
    output io : { busy : UInt<1>, flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { load : UInt<1>, store : UInt<1>, doAllToAll : UInt<1>, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, write_enable : UInt<1>}}, left : { out : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}, flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}}, right : { out : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}, flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}}, up : { out : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}, flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}}, bottom : { out : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}, flip in : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<16>, y_0 : UInt<16>, x_dest : UInt<16>, y_dest : UInt<16>}}}}

    cmem memPE : UInt<64> [1024] @[AllToAllPE.scala 129:18]
    reg x_coord : UInt<16>, clock with :
      reset => (reset, UInt<2>("h2")) @[AllToAllPE.scala 132:24]
    reg y_coord : UInt<16>, clock with :
      reset => (reset, UInt<1>("h1")) @[AllToAllPE.scala 133:24]
    reg rs1 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs1) @[AllToAllPE.scala 136:16]
    reg rs2 : UInt<64>, clock with :
      reset => (UInt<1>("h0"), rs2) @[AllToAllPE.scala 137:16]
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 140:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 141:7]
    reg w_en : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 145:21]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 150:22]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 151:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 153:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 154:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 155:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 163:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 163:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 163:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 164:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 165:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 166:38]
    node _T_2 = eq(io.resp.ready, UInt<1>("h0")) @[AllToAllPE.scala 168:20]
    node stall_resp = and(_T_2, io.resp.valid) @[AllToAllPE.scala 168:35]
    node _T_3 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 170:14]
    when _T_3 : @[AllToAllPE.scala 170:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 171:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 172:18]
      io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 173:19]
      io.resp.bits.data <= UInt<1>("h0") @[AllToAllPE.scala 174:23]
      io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 176:31]
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
      node _T_4 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 189:20]
      when _T_4 : @[AllToAllPE.scala 189:32]
        io.busy <= stall_resp @[AllToAllPE.scala 190:13]
        node _T_5 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 191:21]
        io.cmd.ready <= _T_5 @[AllToAllPE.scala 191:18]
        io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 192:19]
        io.resp.bits.data <= UInt<6>("h20") @[AllToAllPE.scala 193:23]
        resp_value <= UInt<6>("h20") @[AllToAllPE.scala 194:16]
        when is_this_PE : @[AllToAllPE.scala 196:21]
          node _T_6 = bits(memIndex, 9, 0) @[AllToAllPE.scala 197:12]
          infer mport MPORT = memPE[_T_6], clock @[AllToAllPE.scala 197:12]
          MPORT <= rs1 @[AllToAllPE.scala 197:23]
          io.resp.bits.write_enable <= UInt<1>("h1") @[AllToAllPE.scala 198:33]
          w_en <= UInt<1>("h1") @[AllToAllPE.scala 199:12]
        else :
          io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 201:33]
          w_en <= UInt<1>("h0") @[AllToAllPE.scala 202:12]
        node _T_7 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 205:25]
        node _T_8 = and(load_signal, _T_7) @[AllToAllPE.scala 205:22]
        when _T_8 : @[AllToAllPE.scala 205:37]
          state <= UInt<3>("h3") @[AllToAllPE.scala 206:13]
        else :
          node _T_9 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 207:32]
          node _T_10 = and(store_signal, _T_9) @[AllToAllPE.scala 207:29]
          when _T_10 : @[AllToAllPE.scala 207:44]
            state <= UInt<3>("h4") @[AllToAllPE.scala 208:13]
          else :
            node _T_11 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 209:35]
            node _T_12 = and(allToAll_signal, _T_11) @[AllToAllPE.scala 209:32]
            when _T_12 : @[AllToAllPE.scala 209:47]
              state <= UInt<3>("h1") @[AllToAllPE.scala 210:13]
            else :
              when stall_resp : @[AllToAllPE.scala 211:27]
                state <= UInt<3>("h6") @[AllToAllPE.scala 212:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 214:13]
      else :
        node _T_13 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 217:20]
        when _T_13 : @[AllToAllPE.scala 217:33]
          io.busy <= UInt<1>("h1") @[AllToAllPE.scala 219:13]
          io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 220:18]
          io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 221:19]
          io.resp.bits.data <= UInt<6>("h21") @[AllToAllPE.scala 222:23]
          when is_this_PE : @[AllToAllPE.scala 224:21]
            node _T_14 = bits(memIndex, 9, 0) @[AllToAllPE.scala 225:26]
            infer mport MPORT_1 = memPE[_T_14], clock @[AllToAllPE.scala 225:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 225:18]
            w_en <= UInt<1>("h1") @[AllToAllPE.scala 226:12]
          else :
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 228:12]
          io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 231:31]
          state <= UInt<3>("h5") @[AllToAllPE.scala 233:11]
        else :
          node _T_15 = eq(state, UInt<3>("h5")) @[AllToAllPE.scala 235:20]
          when _T_15 : @[AllToAllPE.scala 235:35]
            io.busy <= stall_resp @[AllToAllPE.scala 237:13]
            node _T_16 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 238:21]
            io.cmd.ready <= _T_16 @[AllToAllPE.scala 238:18]
            io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 239:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 240:23]
            io.resp.bits.write_enable <= w_en @[AllToAllPE.scala 241:31]
            node _T_17 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 243:25]
            node _T_18 = and(load_signal, _T_17) @[AllToAllPE.scala 243:22]
            when _T_18 : @[AllToAllPE.scala 243:37]
              state <= UInt<3>("h3") @[AllToAllPE.scala 244:13]
            else :
              node _T_19 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 245:32]
              node _T_20 = and(store_signal, _T_19) @[AllToAllPE.scala 245:29]
              when _T_20 : @[AllToAllPE.scala 245:44]
                state <= UInt<3>("h4") @[AllToAllPE.scala 246:13]
              else :
                node _T_21 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 247:35]
                node _T_22 = and(allToAll_signal, _T_21) @[AllToAllPE.scala 247:32]
                when _T_22 : @[AllToAllPE.scala 247:47]
                  state <= UInt<3>("h1") @[AllToAllPE.scala 248:13]
                else :
                  when stall_resp : @[AllToAllPE.scala 249:27]
                    state <= UInt<3>("h6") @[AllToAllPE.scala 250:13]
                  else :
                    state <= UInt<3>("h0") @[AllToAllPE.scala 252:13]
          else :
            node _T_23 = eq(state, UInt<3>("h6")) @[AllToAllPE.scala 255:20]
            when _T_23 : @[AllToAllPE.scala 255:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 257:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 258:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 259:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 260:23]
              io.resp.bits.write_enable <= w_en @[AllToAllPE.scala 262:31]
              when stall_resp : @[AllToAllPE.scala 264:21]
                state <= UInt<3>("h6") @[AllToAllPE.scala 265:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 267:13]
            else :
              node _T_24 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 270:20]
              when _T_24 : @[AllToAllPE.scala 270:31]
                io.busy <= UInt<1>("h1") @[AllToAllPE.scala 271:13]
                io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 272:18]
                io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 273:19]
                io.resp.bits.data <= resp_value @[AllToAllPE.scala 274:23]
                w_en <= UInt<1>("h0") @[AllToAllPE.scala 276:10]
                io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 277:31]
                state <= UInt<3>("h2") @[AllToAllPE.scala 279:11]
              else :
                node _T_25 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 281:20]
                when _T_25 : @[AllToAllPE.scala 281:36]
                  io.busy <= UInt<1>("h1") @[AllToAllPE.scala 282:13]
                  io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 283:18]
                  io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 284:19]
                  io.resp.bits.data <= resp_value @[AllToAllPE.scala 285:23]
                  io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 286:31]
                  state <= UInt<3>("h0") @[AllToAllPE.scala 288:11]
                else :
                  io.busy <= UInt<1>("h0") @[AllToAllPE.scala 292:13]
                  io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 293:18]
                  io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 294:19]
                  io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 295:23]
                  io.resp.bits.write_enable <= UInt<1>("h1") @[AllToAllPE.scala 296:31]
    io.left.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 301:25]
    io.left.out.bits.x_0 <= UInt<16>("h0") @[AllToAllPE.scala 302:24]
    io.left.out.bits.y_0 <= UInt<16>("h0") @[AllToAllPE.scala 303:24]
    io.left.out.bits.x_dest <= UInt<16>("h0") @[AllToAllPE.scala 304:27]
    io.left.out.bits.y_dest <= UInt<16>("h0") @[AllToAllPE.scala 305:27]
    io.left.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 306:21]
    io.left.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 307:20]
    io.right.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 309:26]
    io.right.out.bits.x_0 <= UInt<16>("h0") @[AllToAllPE.scala 310:25]
    io.right.out.bits.y_0 <= UInt<16>("h0") @[AllToAllPE.scala 311:25]
    io.right.out.bits.x_dest <= UInt<16>("h0") @[AllToAllPE.scala 312:28]
    io.right.out.bits.y_dest <= UInt<16>("h0") @[AllToAllPE.scala 313:28]
    io.right.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 314:22]
    io.right.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 315:21]
    io.up.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 317:23]
    io.up.out.bits.x_0 <= UInt<16>("h0") @[AllToAllPE.scala 318:22]
    io.up.out.bits.y_0 <= UInt<16>("h0") @[AllToAllPE.scala 319:22]
    io.up.out.bits.x_dest <= UInt<16>("h0") @[AllToAllPE.scala 320:25]
    io.up.out.bits.y_dest <= UInt<16>("h0") @[AllToAllPE.scala 321:25]
    io.up.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 322:19]
    io.up.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 323:18]
    io.bottom.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 325:27]
    io.bottom.out.bits.x_0 <= UInt<16>("h0") @[AllToAllPE.scala 326:26]
    io.bottom.out.bits.y_0 <= UInt<16>("h0") @[AllToAllPE.scala 327:26]
    io.bottom.out.bits.x_dest <= UInt<16>("h0") @[AllToAllPE.scala 328:29]
    io.bottom.out.bits.y_dest <= UInt<16>("h0") @[AllToAllPE.scala 329:29]
    io.bottom.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 330:23]
    io.bottom.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 331:22]
    inst left_in of Queue @[Decoupled.scala 296:21]
    left_in.clock <= clock
    left_in.reset <= reset
    left_in.io.enq.valid <= io.left.in.valid @[Decoupled.scala 297:22]
    left_in.io.enq.bits.y_dest <= io.left.in.bits.y_dest @[Decoupled.scala 298:21]
    left_in.io.enq.bits.x_dest <= io.left.in.bits.x_dest @[Decoupled.scala 298:21]
    left_in.io.enq.bits.y_0 <= io.left.in.bits.y_0 @[Decoupled.scala 298:21]
    left_in.io.enq.bits.x_0 <= io.left.in.bits.x_0 @[Decoupled.scala 298:21]
    left_in.io.enq.bits.data <= io.left.in.bits.data @[Decoupled.scala 298:21]
    io.left.in.ready <= left_in.io.enq.ready @[Decoupled.scala 299:17]
    inst right_in of Queue_1 @[Decoupled.scala 296:21]
    right_in.clock <= clock
    right_in.reset <= reset
    right_in.io.enq.valid <= io.right.in.valid @[Decoupled.scala 297:22]
    right_in.io.enq.bits.y_dest <= io.right.in.bits.y_dest @[Decoupled.scala 298:21]
    right_in.io.enq.bits.x_dest <= io.right.in.bits.x_dest @[Decoupled.scala 298:21]
    right_in.io.enq.bits.y_0 <= io.right.in.bits.y_0 @[Decoupled.scala 298:21]
    right_in.io.enq.bits.x_0 <= io.right.in.bits.x_0 @[Decoupled.scala 298:21]
    right_in.io.enq.bits.data <= io.right.in.bits.data @[Decoupled.scala 298:21]
    io.right.in.ready <= right_in.io.enq.ready @[Decoupled.scala 299:17]
    inst up_in of Queue_2 @[Decoupled.scala 296:21]
    up_in.clock <= clock
    up_in.reset <= reset
    up_in.io.enq.valid <= io.up.in.valid @[Decoupled.scala 297:22]
    up_in.io.enq.bits.y_dest <= io.up.in.bits.y_dest @[Decoupled.scala 298:21]
    up_in.io.enq.bits.x_dest <= io.up.in.bits.x_dest @[Decoupled.scala 298:21]
    up_in.io.enq.bits.y_0 <= io.up.in.bits.y_0 @[Decoupled.scala 298:21]
    up_in.io.enq.bits.x_0 <= io.up.in.bits.x_0 @[Decoupled.scala 298:21]
    up_in.io.enq.bits.data <= io.up.in.bits.data @[Decoupled.scala 298:21]
    io.up.in.ready <= up_in.io.enq.ready @[Decoupled.scala 299:17]
    inst bottom_in of Queue_3 @[Decoupled.scala 296:21]
    bottom_in.clock <= clock
    bottom_in.reset <= reset
    bottom_in.io.enq.valid <= io.bottom.in.valid @[Decoupled.scala 297:22]
    bottom_in.io.enq.bits.y_dest <= io.bottom.in.bits.y_dest @[Decoupled.scala 298:21]
    bottom_in.io.enq.bits.x_dest <= io.bottom.in.bits.x_dest @[Decoupled.scala 298:21]
    bottom_in.io.enq.bits.y_0 <= io.bottom.in.bits.y_0 @[Decoupled.scala 298:21]
    bottom_in.io.enq.bits.x_0 <= io.bottom.in.bits.x_0 @[Decoupled.scala 298:21]
    bottom_in.io.enq.bits.data <= io.bottom.in.bits.data @[Decoupled.scala 298:21]
    io.bottom.in.ready <= bottom_in.io.enq.ready @[Decoupled.scala 299:17]
    left_in.io.deq.ready <= UInt<1>("h0") @[AllToAllPE.scala 346:17]
    right_in.io.deq.ready <= UInt<1>("h0") @[AllToAllPE.scala 347:18]
    up_in.io.deq.ready <= UInt<1>("h0") @[AllToAllPE.scala 348:15]
    bottom_in.io.deq.ready <= UInt<1>("h0") @[AllToAllPE.scala 349:19]


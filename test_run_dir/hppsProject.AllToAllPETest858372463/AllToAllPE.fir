circuit AllToAllPE :
  module Queue :
    input clock : Clock
    input reset : Reset
    output io : { flip enq : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<2>, y_0 : UInt<2>, x_dest : UInt<2>, y_dest : UInt<2>}}, deq : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<2>, y_0 : UInt<2>, x_dest : UInt<2>, y_dest : UInt<2>}}, count : UInt<7>}

    cmem ram : { data : UInt<64>, x_0 : UInt<2>, y_0 : UInt<2>, x_dest : UInt<2>, y_dest : UInt<2>} [81] @[Decoupled.scala 218:16]
    reg value : UInt<7>, clock with :
      reset => (reset, UInt<7>("h0")) @[Counter.scala 60:40]
    reg value_1 : UInt<7>, clock with :
      reset => (reset, UInt<7>("h0")) @[Counter.scala 60:40]
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
      node wrap = eq(value, UInt<7>("h50")) @[Counter.scala 72:24]
      node _value_T = add(value, UInt<1>("h1")) @[Counter.scala 76:24]
      node _value_T_1 = tail(_value_T, 1) @[Counter.scala 76:24]
      value <= _value_T_1 @[Counter.scala 76:15]
      when wrap : @[Counter.scala 86:20]
        value <= UInt<1>("h0") @[Counter.scala 86:28]
    when do_deq : @[Decoupled.scala 233:17]
      node wrap_1 = eq(value_1, UInt<7>("h50")) @[Counter.scala 72:24]
      node _value_T_2 = add(value_1, UInt<1>("h1")) @[Counter.scala 76:24]
      node _value_T_3 = tail(_value_T_2, 1) @[Counter.scala 76:24]
      value_1 <= _value_T_3 @[Counter.scala 76:15]
      when wrap_1 : @[Counter.scala 86:20]
        value_1 <= UInt<1>("h0") @[Counter.scala 86:28]
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
    node _io_count_T = mux(maybe_full, UInt<7>("h51"), UInt<1>("h0")) @[Decoupled.scala 262:24]
    node _io_count_T_1 = gt(value_1, value) @[Decoupled.scala 264:39]
    node _io_count_T_2 = add(UInt<7>("h51"), ptr_diff) @[Decoupled.scala 265:38]
    node _io_count_T_3 = tail(_io_count_T_2, 1) @[Decoupled.scala 265:38]
    node _io_count_T_4 = mux(_io_count_T_1, _io_count_T_3, ptr_diff) @[Decoupled.scala 264:24]
    node _io_count_T_5 = mux(ptr_match, _io_count_T, _io_count_T_4) @[Decoupled.scala 261:20]
    io.count <= _io_count_T_5 @[Decoupled.scala 261:14]

  module Queue_1 :
    input clock : Clock
    input reset : Reset
    output io : { flip enq : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<2>, y_0 : UInt<2>, x_dest : UInt<2>, y_dest : UInt<2>}}, deq : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<2>, y_0 : UInt<2>, x_dest : UInt<2>, y_dest : UInt<2>}}, count : UInt<7>}

    cmem ram : { data : UInt<64>, x_0 : UInt<2>, y_0 : UInt<2>, x_dest : UInt<2>, y_dest : UInt<2>} [81] @[Decoupled.scala 218:16]
    reg value : UInt<7>, clock with :
      reset => (reset, UInt<7>("h0")) @[Counter.scala 60:40]
    reg value_1 : UInt<7>, clock with :
      reset => (reset, UInt<7>("h0")) @[Counter.scala 60:40]
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
      node wrap = eq(value, UInt<7>("h50")) @[Counter.scala 72:24]
      node _value_T = add(value, UInt<1>("h1")) @[Counter.scala 76:24]
      node _value_T_1 = tail(_value_T, 1) @[Counter.scala 76:24]
      value <= _value_T_1 @[Counter.scala 76:15]
      when wrap : @[Counter.scala 86:20]
        value <= UInt<1>("h0") @[Counter.scala 86:28]
    when do_deq : @[Decoupled.scala 233:17]
      node wrap_1 = eq(value_1, UInt<7>("h50")) @[Counter.scala 72:24]
      node _value_T_2 = add(value_1, UInt<1>("h1")) @[Counter.scala 76:24]
      node _value_T_3 = tail(_value_T_2, 1) @[Counter.scala 76:24]
      value_1 <= _value_T_3 @[Counter.scala 76:15]
      when wrap_1 : @[Counter.scala 86:20]
        value_1 <= UInt<1>("h0") @[Counter.scala 86:28]
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
    node _io_count_T = mux(maybe_full, UInt<7>("h51"), UInt<1>("h0")) @[Decoupled.scala 262:24]
    node _io_count_T_1 = gt(value_1, value) @[Decoupled.scala 264:39]
    node _io_count_T_2 = add(UInt<7>("h51"), ptr_diff) @[Decoupled.scala 265:38]
    node _io_count_T_3 = tail(_io_count_T_2, 1) @[Decoupled.scala 265:38]
    node _io_count_T_4 = mux(_io_count_T_1, _io_count_T_3, ptr_diff) @[Decoupled.scala 264:24]
    node _io_count_T_5 = mux(ptr_match, _io_count_T, _io_count_T_4) @[Decoupled.scala 261:20]
    io.count <= _io_count_T_5 @[Decoupled.scala 261:14]

  module Queue_2 :
    input clock : Clock
    input reset : Reset
    output io : { flip enq : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<2>, y_0 : UInt<2>, x_dest : UInt<2>, y_dest : UInt<2>}}, deq : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<2>, y_0 : UInt<2>, x_dest : UInt<2>, y_dest : UInt<2>}}, count : UInt<7>}

    cmem ram : { data : UInt<64>, x_0 : UInt<2>, y_0 : UInt<2>, x_dest : UInt<2>, y_dest : UInt<2>} [81] @[Decoupled.scala 218:16]
    reg value : UInt<7>, clock with :
      reset => (reset, UInt<7>("h0")) @[Counter.scala 60:40]
    reg value_1 : UInt<7>, clock with :
      reset => (reset, UInt<7>("h0")) @[Counter.scala 60:40]
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
      node wrap = eq(value, UInt<7>("h50")) @[Counter.scala 72:24]
      node _value_T = add(value, UInt<1>("h1")) @[Counter.scala 76:24]
      node _value_T_1 = tail(_value_T, 1) @[Counter.scala 76:24]
      value <= _value_T_1 @[Counter.scala 76:15]
      when wrap : @[Counter.scala 86:20]
        value <= UInt<1>("h0") @[Counter.scala 86:28]
    when do_deq : @[Decoupled.scala 233:17]
      node wrap_1 = eq(value_1, UInt<7>("h50")) @[Counter.scala 72:24]
      node _value_T_2 = add(value_1, UInt<1>("h1")) @[Counter.scala 76:24]
      node _value_T_3 = tail(_value_T_2, 1) @[Counter.scala 76:24]
      value_1 <= _value_T_3 @[Counter.scala 76:15]
      when wrap_1 : @[Counter.scala 86:20]
        value_1 <= UInt<1>("h0") @[Counter.scala 86:28]
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
    node _io_count_T = mux(maybe_full, UInt<7>("h51"), UInt<1>("h0")) @[Decoupled.scala 262:24]
    node _io_count_T_1 = gt(value_1, value) @[Decoupled.scala 264:39]
    node _io_count_T_2 = add(UInt<7>("h51"), ptr_diff) @[Decoupled.scala 265:38]
    node _io_count_T_3 = tail(_io_count_T_2, 1) @[Decoupled.scala 265:38]
    node _io_count_T_4 = mux(_io_count_T_1, _io_count_T_3, ptr_diff) @[Decoupled.scala 264:24]
    node _io_count_T_5 = mux(ptr_match, _io_count_T, _io_count_T_4) @[Decoupled.scala 261:20]
    io.count <= _io_count_T_5 @[Decoupled.scala 261:14]

  module Queue_3 :
    input clock : Clock
    input reset : Reset
    output io : { flip enq : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<2>, y_0 : UInt<2>, x_dest : UInt<2>, y_dest : UInt<2>}}, deq : { flip ready : UInt<1>, valid : UInt<1>, bits : { data : UInt<64>, x_0 : UInt<2>, y_0 : UInt<2>, x_dest : UInt<2>, y_dest : UInt<2>}}, count : UInt<7>}

    cmem ram : { data : UInt<64>, x_0 : UInt<2>, y_0 : UInt<2>, x_dest : UInt<2>, y_dest : UInt<2>} [81] @[Decoupled.scala 218:16]
    reg value : UInt<7>, clock with :
      reset => (reset, UInt<7>("h0")) @[Counter.scala 60:40]
    reg value_1 : UInt<7>, clock with :
      reset => (reset, UInt<7>("h0")) @[Counter.scala 60:40]
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
      node wrap = eq(value, UInt<7>("h50")) @[Counter.scala 72:24]
      node _value_T = add(value, UInt<1>("h1")) @[Counter.scala 76:24]
      node _value_T_1 = tail(_value_T, 1) @[Counter.scala 76:24]
      value <= _value_T_1 @[Counter.scala 76:15]
      when wrap : @[Counter.scala 86:20]
        value <= UInt<1>("h0") @[Counter.scala 86:28]
    when do_deq : @[Decoupled.scala 233:17]
      node wrap_1 = eq(value_1, UInt<7>("h50")) @[Counter.scala 72:24]
      node _value_T_2 = add(value_1, UInt<1>("h1")) @[Counter.scala 76:24]
      node _value_T_3 = tail(_value_T_2, 1) @[Counter.scala 76:24]
      value_1 <= _value_T_3 @[Counter.scala 76:15]
      when wrap_1 : @[Counter.scala 86:20]
        value_1 <= UInt<1>("h0") @[Counter.scala 86:28]
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
    node _io_count_T = mux(maybe_full, UInt<7>("h51"), UInt<1>("h0")) @[Decoupled.scala 262:24]
    node _io_count_T_1 = gt(value_1, value) @[Decoupled.scala 264:39]
    node _io_count_T_2 = add(UInt<7>("h51"), ptr_diff) @[Decoupled.scala 265:38]
    node _io_count_T_3 = tail(_io_count_T_2, 1) @[Decoupled.scala 265:38]
    node _io_count_T_4 = mux(_io_count_T_1, _io_count_T_3, ptr_diff) @[Decoupled.scala 264:24]
    node _io_count_T_5 = mux(ptr_match, _io_count_T, _io_count_T_4) @[Decoupled.scala 261:20]
    io.count <= _io_count_T_5 @[Decoupled.scala 261:14]

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
    rs1 <= io.cmd.bits.rs1 @[AllToAllPE.scala 86:7]
    rs2 <= io.cmd.bits.rs2 @[AllToAllPE.scala 87:7]
    reg w_en : UInt<1>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 91:21]
    reg state : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 96:22]
    reg resp_value : UInt<64>, clock with :
      reset => (reset, UInt<1>("h0")) @[AllToAllPE.scala 97:27]
    node x_value = bits(rs2, 15, 0) @[AllToAllPE.scala 99:20]
    node y_value = bits(rs2, 31, 16) @[AllToAllPE.scala 100:20]
    node memIndex = bits(rs2, 63, 32) @[AllToAllPE.scala 101:21]
    node _T = eq(x_value, x_coord) @[AllToAllPE.scala 109:29]
    node _T_1 = eq(y_value, y_coord) @[AllToAllPE.scala 109:54]
    node is_this_PE = and(_T, _T_1) @[AllToAllPE.scala 109:42]
    node load_signal = and(io.cmd.valid, io.cmd.bits.load) @[AllToAllPE.scala 110:34]
    node store_signal = and(io.cmd.valid, io.cmd.bits.store) @[AllToAllPE.scala 111:35]
    node allToAll_signal = and(io.cmd.valid, io.cmd.bits.doAllToAll) @[AllToAllPE.scala 112:38]
    node _T_2 = eq(io.resp.ready, UInt<1>("h0")) @[AllToAllPE.scala 114:20]
    node stall_resp = and(_T_2, io.resp.valid) @[AllToAllPE.scala 114:35]
    node start_AllToAll = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 115:30]
    wire leftBusy : UInt<1> @[AllToAllPE.scala 117:22]
    wire rightBusy : UInt<1> @[AllToAllPE.scala 118:23]
    wire upBusy : UInt<1> @[AllToAllPE.scala 119:20]
    wire bottomBusy : UInt<1> @[AllToAllPE.scala 120:24]
    leftBusy <= UInt<1>("h0") @[AllToAllPE.scala 122:12]
    rightBusy <= UInt<1>("h0") @[AllToAllPE.scala 123:13]
    rightBusy <= UInt<1>("h0") @[AllToAllPE.scala 124:13]
    upBusy <= UInt<1>("h0") @[AllToAllPE.scala 125:10]
    bottomBusy <= UInt<1>("h0") @[AllToAllPE.scala 126:14]
    node _T_3 = eq(state, UInt<3>("h0")) @[AllToAllPE.scala 128:14]
    when _T_3 : @[AllToAllPE.scala 128:23]
      io.busy <= UInt<1>("h0") @[AllToAllPE.scala 129:13]
      io.cmd.ready <= UInt<1>("h1") @[AllToAllPE.scala 130:18]
      io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 131:19]
      io.resp.bits.data <= UInt<1>("h0") @[AllToAllPE.scala 132:23]
      io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 134:31]
      w_en <= UInt<1>("h0") @[AllToAllPE.scala 135:10]
      when load_signal : @[AllToAllPE.scala 137:22]
        state <= UInt<3>("h4") @[AllToAllPE.scala 138:13]
      else :
        when store_signal : @[AllToAllPE.scala 139:29]
          state <= UInt<3>("h5") @[AllToAllPE.scala 140:13]
        else :
          when allToAll_signal : @[AllToAllPE.scala 141:32]
            state <= UInt<3>("h1") @[AllToAllPE.scala 142:13]
          else :
            state <= UInt<3>("h0") @[AllToAllPE.scala 144:13]
    else :
      node _T_4 = eq(state, UInt<3>("h4")) @[AllToAllPE.scala 147:20]
      when _T_4 : @[AllToAllPE.scala 147:32]
        io.busy <= stall_resp @[AllToAllPE.scala 148:13]
        node _T_5 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 149:21]
        io.cmd.ready <= _T_5 @[AllToAllPE.scala 149:18]
        io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 150:19]
        io.resp.bits.data <= UInt<6>("h20") @[AllToAllPE.scala 151:23]
        resp_value <= UInt<6>("h20") @[AllToAllPE.scala 152:16]
        when is_this_PE : @[AllToAllPE.scala 154:21]
          node _T_6 = bits(memIndex, 9, 0) @[AllToAllPE.scala 155:12]
          infer mport MPORT = memPE[_T_6], clock @[AllToAllPE.scala 155:12]
          MPORT <= rs1 @[AllToAllPE.scala 155:23]
          io.resp.bits.write_enable <= UInt<1>("h1") @[AllToAllPE.scala 156:33]
          w_en <= UInt<1>("h1") @[AllToAllPE.scala 157:12]
        else :
          io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 159:33]
          w_en <= UInt<1>("h0") @[AllToAllPE.scala 160:12]
        node _T_7 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 163:25]
        node _T_8 = and(load_signal, _T_7) @[AllToAllPE.scala 163:22]
        when _T_8 : @[AllToAllPE.scala 163:37]
          state <= UInt<3>("h4") @[AllToAllPE.scala 164:13]
        else :
          node _T_9 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 165:32]
          node _T_10 = and(store_signal, _T_9) @[AllToAllPE.scala 165:29]
          when _T_10 : @[AllToAllPE.scala 165:44]
            state <= UInt<3>("h5") @[AllToAllPE.scala 166:13]
          else :
            node _T_11 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 167:35]
            node _T_12 = and(allToAll_signal, _T_11) @[AllToAllPE.scala 167:32]
            when _T_12 : @[AllToAllPE.scala 167:47]
              state <= UInt<3>("h1") @[AllToAllPE.scala 168:13]
            else :
              when stall_resp : @[AllToAllPE.scala 169:27]
                state <= UInt<3>("h7") @[AllToAllPE.scala 170:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 172:13]
      else :
        node _T_13 = eq(state, UInt<3>("h5")) @[AllToAllPE.scala 175:20]
        when _T_13 : @[AllToAllPE.scala 175:33]
          io.busy <= UInt<1>("h1") @[AllToAllPE.scala 177:13]
          io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 178:18]
          io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 179:19]
          io.resp.bits.data <= UInt<6>("h21") @[AllToAllPE.scala 180:23]
          when is_this_PE : @[AllToAllPE.scala 182:21]
            node _T_14 = bits(memIndex, 9, 0) @[AllToAllPE.scala 183:26]
            infer mport MPORT_1 = memPE[_T_14], clock @[AllToAllPE.scala 183:26]
            resp_value <= MPORT_1 @[AllToAllPE.scala 183:18]
            w_en <= UInt<1>("h1") @[AllToAllPE.scala 184:12]
          else :
            w_en <= UInt<1>("h0") @[AllToAllPE.scala 186:12]
          io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 189:31]
          state <= UInt<3>("h6") @[AllToAllPE.scala 191:11]
        else :
          node _T_15 = eq(state, UInt<3>("h6")) @[AllToAllPE.scala 193:20]
          when _T_15 : @[AllToAllPE.scala 193:35]
            io.busy <= stall_resp @[AllToAllPE.scala 195:13]
            node _T_16 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 196:21]
            io.cmd.ready <= _T_16 @[AllToAllPE.scala 196:18]
            io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 197:19]
            io.resp.bits.data <= resp_value @[AllToAllPE.scala 198:23]
            io.resp.bits.write_enable <= w_en @[AllToAllPE.scala 199:31]
            node _T_17 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 201:25]
            node _T_18 = and(load_signal, _T_17) @[AllToAllPE.scala 201:22]
            when _T_18 : @[AllToAllPE.scala 201:37]
              state <= UInt<3>("h4") @[AllToAllPE.scala 202:13]
            else :
              node _T_19 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 203:32]
              node _T_20 = and(store_signal, _T_19) @[AllToAllPE.scala 203:29]
              when _T_20 : @[AllToAllPE.scala 203:44]
                state <= UInt<3>("h5") @[AllToAllPE.scala 204:13]
              else :
                node _T_21 = eq(stall_resp, UInt<1>("h0")) @[AllToAllPE.scala 205:35]
                node _T_22 = and(allToAll_signal, _T_21) @[AllToAllPE.scala 205:32]
                when _T_22 : @[AllToAllPE.scala 205:47]
                  state <= UInt<3>("h1") @[AllToAllPE.scala 206:13]
                else :
                  when stall_resp : @[AllToAllPE.scala 207:27]
                    state <= UInt<3>("h7") @[AllToAllPE.scala 208:13]
                  else :
                    state <= UInt<3>("h0") @[AllToAllPE.scala 210:13]
          else :
            node _T_23 = eq(state, UInt<3>("h7")) @[AllToAllPE.scala 213:20]
            when _T_23 : @[AllToAllPE.scala 213:36]
              io.busy <= UInt<1>("h1") @[AllToAllPE.scala 215:13]
              io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 216:18]
              io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 217:19]
              io.resp.bits.data <= resp_value @[AllToAllPE.scala 218:23]
              io.resp.bits.write_enable <= w_en @[AllToAllPE.scala 220:31]
              when stall_resp : @[AllToAllPE.scala 222:21]
                state <= UInt<3>("h7") @[AllToAllPE.scala 223:13]
              else :
                state <= UInt<3>("h0") @[AllToAllPE.scala 225:13]
            else :
              node _T_24 = eq(state, UInt<3>("h1")) @[AllToAllPE.scala 228:20]
              when _T_24 : @[AllToAllPE.scala 228:31]
                io.busy <= UInt<1>("h1") @[AllToAllPE.scala 229:13]
                io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 230:18]
                io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 231:19]
                io.resp.bits.data <= resp_value @[AllToAllPE.scala 232:23]
                w_en <= UInt<1>("h0") @[AllToAllPE.scala 234:10]
                io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 235:31]
                io.left.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 238:22]
                io.right.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 239:23]
                io.up.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 240:20]
                io.bottom.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 241:24]
                state <= UInt<3>("h3") @[AllToAllPE.scala 243:11]
              else :
                node _T_25 = eq(state, UInt<3>("h2")) @[AllToAllPE.scala 245:20]
                when _T_25 : @[AllToAllPE.scala 245:41]
                  node _T_26 = or(leftBusy, rightBusy) @[AllToAllPE.scala 247:25]
                  node _T_27 = or(_T_26, upBusy) @[AllToAllPE.scala 247:38]
                  node _T_28 = or(_T_27, bottomBusy) @[AllToAllPE.scala 247:48]
                  io.busy <= _T_28 @[AllToAllPE.scala 247:13]
                  io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 248:18]
                  io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 249:19]
                  io.resp.bits.data <= resp_value @[AllToAllPE.scala 250:23]
                  io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 251:31]
                  io.left.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 254:22]
                  io.right.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 255:23]
                  io.up.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 256:20]
                  io.bottom.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 257:24]
                  when io.end_AllToAll : @[AllToAllPE.scala 259:27]
                    state <= UInt<3>("h3") @[AllToAllPE.scala 260:13]
                  else :
                    state <= UInt<3>("h2") @[AllToAllPE.scala 262:13]
                else :
                  node _T_29 = eq(state, UInt<3>("h3")) @[AllToAllPE.scala 265:20]
                  when _T_29 : @[AllToAllPE.scala 265:36]
                    io.busy <= UInt<1>("h0") @[AllToAllPE.scala 266:13]
                    io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 267:18]
                    io.resp.valid <= UInt<1>("h1") @[AllToAllPE.scala 268:19]
                    io.resp.bits.data <= UInt<1>("h0") @[AllToAllPE.scala 269:23]
                    io.resp.bits.write_enable <= UInt<1>("h0") @[AllToAllPE.scala 270:31]
                    state <= UInt<3>("h0") @[AllToAllPE.scala 272:11]
                  else :
                    io.busy <= UInt<1>("h0") @[AllToAllPE.scala 276:13]
                    io.cmd.ready <= UInt<1>("h0") @[AllToAllPE.scala 277:18]
                    io.resp.valid <= UInt<1>("h0") @[AllToAllPE.scala 278:19]
                    io.resp.bits.data <= UInt<64>("haaaaaaaa") @[AllToAllPE.scala 279:23]
                    io.resp.bits.write_enable <= UInt<1>("h1") @[AllToAllPE.scala 280:31]
    reg stateAction : UInt<3>, clock with :
      reset => (reset, UInt<3>("h0")) @[AllToAllPE.scala 289:28]
    node _T_30 = eq(stateAction, UInt<3>("h0")) @[AllToAllPE.scala 293:20]
    when _T_30 : @[AllToAllPE.scala 293:29]
      io.left.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 295:22]
      io.right.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 296:23]
      io.up.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 297:20]
      io.bottom.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 298:24]
      when start_AllToAll : @[AllToAllPE.scala 300:25]
        stateAction <= UInt<3>("h1") @[AllToAllPE.scala 301:19]
      else :
        stateAction <= UInt<3>("h0") @[AllToAllPE.scala 303:19]
    else :
      node _T_31 = eq(stateAction, UInt<3>("h1")) @[AllToAllPE.scala 305:26]
      when _T_31 : @[AllToAllPE.scala 305:37]
        io.left.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 307:22]
        io.right.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 308:23]
        io.up.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 309:20]
        io.bottom.in.ready <= UInt<1>("h1") @[AllToAllPE.scala 310:24]
        when io.end_AllToAll : @[AllToAllPE.scala 313:26]
          stateAction <= UInt<3>("h0") @[AllToAllPE.scala 314:19]
        else :
          stateAction <= UInt<3>("h1") @[AllToAllPE.scala 316:19]
      else :
        skip
    io.left.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 324:25]
    io.left.out.bits.x_0 <= UInt<1>("h0") @[AllToAllPE.scala 325:24]
    io.left.out.bits.y_0 <= UInt<1>("h0") @[AllToAllPE.scala 326:24]
    io.left.out.bits.x_dest <= UInt<1>("h0") @[AllToAllPE.scala 327:27]
    io.left.out.bits.y_dest <= UInt<1>("h0") @[AllToAllPE.scala 328:27]
    io.left.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 329:21]
    io.left.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 330:20]
    io.right.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 332:26]
    io.right.out.bits.x_0 <= UInt<1>("h0") @[AllToAllPE.scala 333:25]
    io.right.out.bits.y_0 <= UInt<1>("h0") @[AllToAllPE.scala 334:25]
    io.right.out.bits.x_dest <= UInt<1>("h0") @[AllToAllPE.scala 335:28]
    io.right.out.bits.y_dest <= UInt<1>("h0") @[AllToAllPE.scala 336:28]
    io.right.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 337:22]
    io.right.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 338:21]
    io.up.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 340:23]
    io.up.out.bits.x_0 <= UInt<1>("h0") @[AllToAllPE.scala 341:22]
    io.up.out.bits.y_0 <= UInt<1>("h0") @[AllToAllPE.scala 342:22]
    io.up.out.bits.x_dest <= UInt<1>("h0") @[AllToAllPE.scala 343:25]
    io.up.out.bits.y_dest <= UInt<1>("h0") @[AllToAllPE.scala 344:25]
    io.up.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 345:19]
    io.up.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 346:18]
    io.bottom.out.bits.data <= UInt<64>("h0") @[AllToAllPE.scala 348:27]
    io.bottom.out.bits.x_0 <= UInt<1>("h0") @[AllToAllPE.scala 349:26]
    io.bottom.out.bits.y_0 <= UInt<1>("h0") @[AllToAllPE.scala 350:26]
    io.bottom.out.bits.x_dest <= UInt<1>("h0") @[AllToAllPE.scala 351:29]
    io.bottom.out.bits.y_dest <= UInt<1>("h0") @[AllToAllPE.scala 352:29]
    io.bottom.out.valid <= UInt<1>("h0") @[AllToAllPE.scala 353:23]
    io.bottom.in.ready <= UInt<1>("h0") @[AllToAllPE.scala 354:22]
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
    left_in.io.deq.ready <= io.left.in.ready @[AllToAllPE.scala 373:17]
    right_in.io.deq.ready <= io.right.in.ready @[AllToAllPE.scala 374:18]
    up_in.io.deq.ready <= io.up.in.ready @[AllToAllPE.scala 375:15]
    bottom_in.io.deq.ready <= io.bottom.in.ready @[AllToAllPE.scala 376:19]


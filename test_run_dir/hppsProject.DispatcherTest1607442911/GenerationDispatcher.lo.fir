circuit GenerationDispatcher :
  module GenerationDispatcher :
    input clock : Clock
    input reset : UInt<1>
    input io_x_PE : UInt<4>
    input io_y_PE : UInt<4>
    input io_x_dest : UInt<4>
    input io_y_dest : UInt<4>
    output io_left : UInt<1>
    output io_right : UInt<1>
    output io_up : UInt<1>
    output io_bottom : UInt<1>

    node _T_4 = cvt(io_x_dest) @[Dispatcher.scala 208:35]
    node _T_5 = cvt(io_x_PE) @[Dispatcher.scala 208:50]
    node _T_6 = sub(_T_4, _T_5) @[Dispatcher.scala 208:40]
    node _T_7 = tail(_T_6, 1) @[Dispatcher.scala 208:40]
    node x_dest_transl = asSInt(_T_7) @[Dispatcher.scala 208:40]
    node _T_8 = cvt(io_y_dest) @[Dispatcher.scala 209:35]
    node _T_9 = cvt(io_y_PE) @[Dispatcher.scala 209:50]
    node _T_10 = sub(_T_8, _T_9) @[Dispatcher.scala 209:40]
    node _T_11 = tail(_T_10, 1) @[Dispatcher.scala 209:40]
    node y_dest_transl = asSInt(_T_11) @[Dispatcher.scala 209:40]
    node _T_12 = leq(x_dest_transl, y_dest_transl) @[Dispatcher.scala 211:24]
    node _T_13 = sub(asSInt(UInt<1>("h0")), y_dest_transl) @[Dispatcher.scala 211:60]
    node _T_14 = tail(_T_13, 1) @[Dispatcher.scala 211:60]
    node _T_15 = asSInt(_T_14) @[Dispatcher.scala 211:60]
    node _T_16 = lt(x_dest_transl, _T_15) @[Dispatcher.scala 211:58]
    node _T_17 = and(_T_12, _T_16) @[Dispatcher.scala 211:41]
    node _T_18 = geq(x_dest_transl, y_dest_transl) @[Dispatcher.scala 215:30]
    node _T_19 = sub(asSInt(UInt<1>("h0")), y_dest_transl) @[Dispatcher.scala 215:66]
    node _T_20 = tail(_T_19, 1) @[Dispatcher.scala 215:66]
    node _T_21 = asSInt(_T_20) @[Dispatcher.scala 215:66]
    node _T_22 = gt(x_dest_transl, _T_21) @[Dispatcher.scala 215:64]
    node _T_23 = and(_T_18, _T_22) @[Dispatcher.scala 215:47]
    node _T_24 = lt(x_dest_transl, y_dest_transl) @[Dispatcher.scala 219:30]
    node _T_25 = sub(asSInt(UInt<1>("h0")), y_dest_transl) @[Dispatcher.scala 219:66]
    node _T_26 = tail(_T_25, 1) @[Dispatcher.scala 219:66]
    node _T_27 = asSInt(_T_26) @[Dispatcher.scala 219:66]
    node _T_28 = geq(x_dest_transl, _T_27) @[Dispatcher.scala 219:63]
    node _T_29 = and(_T_24, _T_28) @[Dispatcher.scala 219:46]
    node _T_30 = gt(x_dest_transl, y_dest_transl) @[Dispatcher.scala 223:30]
    node _T_31 = sub(asSInt(UInt<1>("h0")), y_dest_transl) @[Dispatcher.scala 223:66]
    node _T_32 = tail(_T_31, 1) @[Dispatcher.scala 223:66]
    node _T_33 = asSInt(_T_32) @[Dispatcher.scala 223:66]
    node _T_34 = leq(x_dest_transl, _T_33) @[Dispatcher.scala 223:63]
    node _T_35 = and(_T_30, _T_34) @[Dispatcher.scala 223:46]
    node _GEN_0 = mux(_T_35, UInt<4>("h8"), UInt<1>("h0")) @[Dispatcher.scala 223:81 Dispatcher.scala 225:22 Dispatcher.scala 229:22]
    node _GEN_1 = mux(_T_29, UInt<3>("h4"), _GEN_0) @[Dispatcher.scala 219:81 Dispatcher.scala 221:22]
    node _GEN_2 = mux(_T_23, UInt<2>("h2"), _GEN_1) @[Dispatcher.scala 215:81 Dispatcher.scala 217:22]
    node _GEN_3 = mux(_T_17, UInt<1>("h1"), _GEN_2) @[Dispatcher.scala 211:75 Dispatcher.scala 213:22]
    node out_selector = _GEN_3 @[Dispatcher.scala 201:28]
    node _T = eq(out_selector, UInt<1>("h1")) @[Dispatcher.scala 203:29]
    node _T_1 = eq(out_selector, UInt<2>("h2")) @[Dispatcher.scala 204:30]
    node _T_2 = eq(out_selector, UInt<3>("h4")) @[Dispatcher.scala 205:27]
    node _T_3 = eq(out_selector, UInt<4>("h8")) @[Dispatcher.scala 206:31]
    io_left <= _T @[Dispatcher.scala 203:13]
    io_right <= _T_1 @[Dispatcher.scala 204:14]
    io_up <= _T_2 @[Dispatcher.scala 205:11]
    io_bottom <= _T_3 @[Dispatcher.scala 206:15]

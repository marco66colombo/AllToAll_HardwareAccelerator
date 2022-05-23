circuit IndexCalculator :
  module IndexCalculator :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip reset : UInt<1>, flip enable : UInt<1>, lastIndex : UInt<1>, index : UInt<16>}

    reg counter : UInt<16>, clock with :
      reset => (UInt<1>("h0"), counter) @[Counter.scala 25:22]
    when io.enable : @[Counter.scala 27:22]
      node _T = add(counter, UInt<1>("h1")) @[Counter.scala 29:47]
      node _T_1 = tail(_T, 1) @[Counter.scala 29:47]
      node _T_2 = mux(io.reset, UInt<1>("h0"), _T_1) @[Counter.scala 29:23]
      counter <= _T_2 @[Counter.scala 29:17]
    io.index <= counter @[Counter.scala 32:14]
    node _T_3 = sub(UInt<3>("h4"), UInt<1>("h1")) @[Counter.scala 33:44]
    node _T_4 = tail(_T_3, 1) @[Counter.scala 33:44]
    node _T_5 = eq(counter, _T_4) @[Counter.scala 33:29]
    io.lastIndex <= _T_5 @[Counter.scala 33:18]


circuit IndexCalculator :
  module IndexCalculator :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip reset : UInt<1>, flip enable : UInt<1>, last_index : UInt<1>, index : UInt<32>}

    reg counter : UInt<18>, clock with :
      reset => (UInt<1>("h0"), counter) @[IndexCalculator.scala 26:22]
    when io.enable : @[IndexCalculator.scala 28:22]
      node _T = add(counter, UInt<1>("h1")) @[IndexCalculator.scala 30:47]
      node _T_1 = tail(_T, 1) @[IndexCalculator.scala 30:47]
      node _T_2 = mux(io.reset, UInt<1>("h0"), _T_1) @[IndexCalculator.scala 30:23]
      counter <= _T_2 @[IndexCalculator.scala 30:17]
    io.index <= counter @[IndexCalculator.scala 33:14]
    node _T_3 = eq(counter, UInt<2>("h3")) @[IndexCalculator.scala 36:30]
    io.last_index <= _T_3 @[IndexCalculator.scala 36:19]


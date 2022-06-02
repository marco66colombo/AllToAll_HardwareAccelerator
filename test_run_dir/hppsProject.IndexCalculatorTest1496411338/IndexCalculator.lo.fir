circuit IndexCalculator :
  module IndexCalculator :
    input clock : Clock
    input reset : UInt<1>
    input io_reset : UInt<1>
    input io_enable : UInt<1>
    output io_last_index : UInt<1>
    output io_index : UInt<17>

    reg counter : UInt<17>, clock with :
      reset => (UInt<1>("h0"), counter) @[IndexCalculator.scala 26:22]
    node _T = add(counter, UInt<1>("h1")) @[IndexCalculator.scala 30:47]
    node _T_1 = tail(_T, 1) @[IndexCalculator.scala 30:47]
    node _T_2 = mux(io_reset, UInt<1>("h0"), _T_1) @[IndexCalculator.scala 30:23]
    node _GEN_0 = mux(io_enable, _T_2, counter) @[IndexCalculator.scala 28:22 IndexCalculator.scala 30:17 IndexCalculator.scala 26:22]
    node _T_3 = eq(counter, UInt<2>("h3")) @[IndexCalculator.scala 36:30]
    io_last_index <= _T_3 @[IndexCalculator.scala 36:19]
    io_index <= counter @[IndexCalculator.scala 33:14]
    counter <= _GEN_0

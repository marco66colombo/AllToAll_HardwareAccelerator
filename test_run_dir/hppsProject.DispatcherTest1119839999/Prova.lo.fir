circuit Prova :
  module Prova :
    input clock : Clock
    input reset : UInt<1>
    output io_out1 : UInt<1>
    output io_out2 : UInt<1>

    node sign = head(asSInt(UInt<9>("h175")), 1) @[Dispatcher.scala 194:22]
    node sign1 = head(asSInt(UInt<5>("h11")), 1) @[Dispatcher.scala 198:23]
    io_out1 <= sign @[Dispatcher.scala 195:13]
    io_out2 <= sign1 @[Dispatcher.scala 200:13]

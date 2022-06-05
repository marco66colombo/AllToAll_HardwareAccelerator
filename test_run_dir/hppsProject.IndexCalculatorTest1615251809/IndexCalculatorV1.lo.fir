circuit IndexCalculatorV1 :
  module IndexCalculatorV1 :
    input clock : Clock
    input reset : UInt<1>
    input io_reset : UInt<1>
    input io_enable : UInt<1>
    input io_dim_N : UInt<16>
    output io_index0 : UInt<7>
    output io_index1 : UInt<7>
    output io_index2 : UInt<7>
    output io_index3 : UInt<7>
    output io_valid0 : UInt<1>
    output io_valid1 : UInt<1>
    output io_valid2 : UInt<1>
    output io_valid3 : UInt<1>
    output io_x_dest_0 : UInt<3>
    output io_x_dest_1 : UInt<3>
    output io_x_dest_2 : UInt<3>
    output io_x_dest_3 : UInt<3>
    output io_y_dest_0 : UInt<3>
    output io_y_dest_1 : UInt<3>
    output io_y_dest_2 : UInt<3>
    output io_y_dest_3 : UInt<3>
    output io_pos_0 : UInt<16>
    output io_pos_1 : UInt<16>
    output io_pos_2 : UInt<16>
    output io_pos_3 : UInt<16>
    output io_last_iteration : UInt<1>

    reg dim_N : UInt<8>, clock with :
      reset => (UInt<1>("h0"), dim_N) @[IndexCalculator.scala 84:20]
    reg counter_PE : UInt<32>, clock with :
      reset => (UInt<1>("h0"), counter_PE) @[IndexCalculator.scala 87:25]
    reg counter_offset : UInt<16>, clock with :
      reset => (UInt<1>("h0"), counter_offset) @[IndexCalculator.scala 88:29]
    node _T = and(io_enable, io_reset) @[IndexCalculator.scala 91:20]
    node _GEN_0 = mux(_T, io_dim_N, dim_N) @[IndexCalculator.scala 91:32 IndexCalculator.scala 93:15 IndexCalculator.scala 84:20]
    node _GEN_1 = mux(_T, UInt<1>("h0"), counter_PE) @[IndexCalculator.scala 91:32 IndexCalculator.scala 94:20 IndexCalculator.scala 87:25]
    node _GEN_2 = mux(_T, UInt<1>("h0"), counter_offset) @[IndexCalculator.scala 91:32 IndexCalculator.scala 95:24 IndexCalculator.scala 88:29]
    node _T_1 = eq(io_reset, UInt<1>("h0")) @[IndexCalculator.scala 99:23]
    node _T_2 = and(io_enable, _T_1) @[IndexCalculator.scala 99:20]
    node _T_3 = add(counter_PE, UInt<2>("h3")) @[IndexCalculator.scala 101:24]
    node _T_4 = tail(_T_3, 1) @[IndexCalculator.scala 101:24]
    node _T_5 = geq(_T_4, UInt<4>("h8")) @[IndexCalculator.scala 101:29]
    node _T_6 = add(counter_offset, UInt<1>("h1")) @[IndexCalculator.scala 104:46]
    node _T_7 = tail(_T_6, 1) @[IndexCalculator.scala 104:46]
    node _T_8 = add(counter_PE, UInt<3>("h4")) @[IndexCalculator.scala 108:38]
    node _T_9 = tail(_T_8, 1) @[IndexCalculator.scala 108:38]
    node _GEN_3 = mux(_T_5, UInt<1>("h0"), _T_9) @[IndexCalculator.scala 101:43 IndexCalculator.scala 103:24 IndexCalculator.scala 108:24]
    node _GEN_4 = mux(_T_5, _T_7, _GEN_2) @[IndexCalculator.scala 101:43 IndexCalculator.scala 104:28]
    node _GEN_5 = mux(_T_2, _GEN_3, _GEN_1) @[IndexCalculator.scala 99:33]
    node _GEN_6 = mux(_T_2, _GEN_4, _GEN_2) @[IndexCalculator.scala 99:33]
    node _T_10 = mul(counter_PE, dim_N) @[IndexCalculator.scala 114:29]
    node _T_11 = add(_T_10, counter_offset) @[IndexCalculator.scala 114:37]
    node _T_12 = tail(_T_11, 1) @[IndexCalculator.scala 114:37]
    node _T_13 = add(counter_PE, UInt<1>("h1")) @[IndexCalculator.scala 115:29]
    node _T_14 = tail(_T_13, 1) @[IndexCalculator.scala 115:29]
    node _T_15 = mul(_T_14, dim_N) @[IndexCalculator.scala 115:35]
    node _T_16 = add(_T_15, counter_offset) @[IndexCalculator.scala 115:43]
    node _T_17 = tail(_T_16, 1) @[IndexCalculator.scala 115:43]
    node _T_18 = add(counter_PE, UInt<2>("h2")) @[IndexCalculator.scala 116:29]
    node _T_19 = tail(_T_18, 1) @[IndexCalculator.scala 116:29]
    node _T_20 = mul(_T_19, dim_N) @[IndexCalculator.scala 116:35]
    node _T_21 = add(_T_20, counter_offset) @[IndexCalculator.scala 116:43]
    node _T_22 = tail(_T_21, 1) @[IndexCalculator.scala 116:43]
    node _T_23 = add(counter_PE, UInt<2>("h3")) @[IndexCalculator.scala 117:29]
    node _T_24 = tail(_T_23, 1) @[IndexCalculator.scala 117:29]
    node _T_25 = mul(_T_24, dim_N) @[IndexCalculator.scala 117:35]
    node _T_26 = add(_T_25, counter_offset) @[IndexCalculator.scala 117:43]
    node _T_27 = tail(_T_26, 1) @[IndexCalculator.scala 117:43]
    node _T_28 = mul(counter_PE, dim_N) @[IndexCalculator.scala 120:29]
    node _T_29 = leq(_T_28, UInt<4>("h8")) @[IndexCalculator.scala 120:37]
    node _T_30 = add(counter_PE, UInt<1>("h1")) @[IndexCalculator.scala 121:29]
    node _T_31 = tail(_T_30, 1) @[IndexCalculator.scala 121:29]
    node _T_32 = mul(_T_31, dim_N) @[IndexCalculator.scala 121:35]
    node _T_33 = leq(_T_32, UInt<4>("h8")) @[IndexCalculator.scala 121:43]
    node _T_34 = add(counter_PE, UInt<2>("h2")) @[IndexCalculator.scala 122:29]
    node _T_35 = tail(_T_34, 1) @[IndexCalculator.scala 122:29]
    node _T_36 = mul(_T_35, dim_N) @[IndexCalculator.scala 122:35]
    node _T_37 = leq(_T_36, UInt<4>("h8")) @[IndexCalculator.scala 122:43]
    node _T_38 = add(counter_PE, UInt<2>("h3")) @[IndexCalculator.scala 123:29]
    node _T_39 = tail(_T_38, 1) @[IndexCalculator.scala 123:29]
    node _T_40 = mul(_T_39, dim_N) @[IndexCalculator.scala 123:35]
    node _T_41 = leq(_T_40, UInt<4>("h8")) @[IndexCalculator.scala 123:43]
    node _T_42 = rem(counter_PE, UInt<2>("h3")) @[IndexCalculator.scala 125:45]
    node _T_43 = add(counter_PE, UInt<1>("h1")) @[IndexCalculator.scala 131:46]
    node _T_44 = tail(_T_43, 1) @[IndexCalculator.scala 131:46]
    node _T_45 = rem(_T_44, UInt<2>("h3")) @[IndexCalculator.scala 125:45]
    node _T_46 = add(counter_PE, UInt<2>("h2")) @[IndexCalculator.scala 132:46]
    node _T_47 = tail(_T_46, 1) @[IndexCalculator.scala 132:46]
    node _T_48 = rem(_T_47, UInt<2>("h3")) @[IndexCalculator.scala 125:45]
    node _T_49 = add(counter_PE, UInt<2>("h3")) @[IndexCalculator.scala 133:46]
    node _T_50 = tail(_T_49, 1) @[IndexCalculator.scala 133:46]
    node _T_51 = rem(_T_50, UInt<2>("h3")) @[IndexCalculator.scala 125:45]
    node _T_52 = div(counter_PE, UInt<2>("h3")) @[IndexCalculator.scala 127:45]
    node _T_53 = add(counter_PE, UInt<1>("h1")) @[IndexCalculator.scala 136:46]
    node _T_54 = tail(_T_53, 1) @[IndexCalculator.scala 136:46]
    node _T_55 = div(_T_54, UInt<2>("h3")) @[IndexCalculator.scala 127:45]
    node _T_56 = add(counter_PE, UInt<2>("h2")) @[IndexCalculator.scala 137:46]
    node _T_57 = tail(_T_56, 1) @[IndexCalculator.scala 137:46]
    node _T_58 = div(_T_57, UInt<2>("h3")) @[IndexCalculator.scala 127:45]
    node _T_59 = add(counter_PE, UInt<2>("h3")) @[IndexCalculator.scala 138:46]
    node _T_60 = tail(_T_59, 1) @[IndexCalculator.scala 138:46]
    node _T_61 = div(_T_60, UInt<2>("h3")) @[IndexCalculator.scala 127:45]
    node _T_62 = eq(counter_offset, dim_N) @[IndexCalculator.scala 149:41]
    io_index0 <= bits(_T_12, 6, 0) @[IndexCalculator.scala 114:15]
    io_index1 <= bits(_T_17, 6, 0) @[IndexCalculator.scala 115:15]
    io_index2 <= bits(_T_22, 6, 0) @[IndexCalculator.scala 116:15]
    io_index3 <= bits(_T_27, 6, 0) @[IndexCalculator.scala 117:15]
    io_valid0 <= _T_29 @[IndexCalculator.scala 120:15]
    io_valid1 <= _T_33 @[IndexCalculator.scala 121:15]
    io_valid2 <= _T_37 @[IndexCalculator.scala 122:15]
    io_valid3 <= _T_41 @[IndexCalculator.scala 123:15]
    io_x_dest_0 <= _T_42 @[IndexCalculator.scala 130:17]
    io_x_dest_1 <= _T_45 @[IndexCalculator.scala 131:17]
    io_x_dest_2 <= _T_48 @[IndexCalculator.scala 132:17]
    io_x_dest_3 <= _T_51 @[IndexCalculator.scala 133:17]
    io_y_dest_0 <= bits(_T_52, 2, 0) @[IndexCalculator.scala 135:17]
    io_y_dest_1 <= bits(_T_55, 2, 0) @[IndexCalculator.scala 136:17]
    io_y_dest_2 <= bits(_T_58, 2, 0) @[IndexCalculator.scala 137:17]
    io_y_dest_3 <= bits(_T_61, 2, 0) @[IndexCalculator.scala 138:17]
    io_pos_0 <= counter_offset @[IndexCalculator.scala 141:14]
    io_pos_1 <= counter_offset @[IndexCalculator.scala 142:14]
    io_pos_2 <= counter_offset @[IndexCalculator.scala 143:14]
    io_pos_3 <= counter_offset @[IndexCalculator.scala 144:14]
    io_last_iteration <= _T_62 @[IndexCalculator.scala 149:23]
    dim_N <= bits(_GEN_0, 7, 0)
    counter_PE <= _GEN_5
    counter_offset <= _GEN_6

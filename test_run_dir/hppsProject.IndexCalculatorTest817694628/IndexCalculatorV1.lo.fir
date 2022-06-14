circuit IndexCalculatorV1 :
  module IndexCalculatorV1 :
    input clock : Clock
    input reset : UInt<1>
    input io_reset : UInt<1>
    input io_enable : UInt<1>
    input io_dim_N : UInt<16>
    output io_index0 : UInt<32>
    output io_index1 : UInt<32>
    output io_index2 : UInt<32>
    output io_index3 : UInt<32>
    output io_valid0 : UInt<1>
    output io_valid1 : UInt<1>
    output io_valid2 : UInt<1>
    output io_valid3 : UInt<1>
    output io_x_dest_0 : UInt<2>
    output io_x_dest_1 : UInt<2>
    output io_x_dest_2 : UInt<2>
    output io_x_dest_3 : UInt<2>
    output io_y_dest_0 : UInt<2>
    output io_y_dest_1 : UInt<2>
    output io_y_dest_2 : UInt<2>
    output io_y_dest_3 : UInt<2>
    output io_pos_0 : UInt<16>
    output io_pos_1 : UInt<16>
    output io_pos_2 : UInt<16>
    output io_pos_3 : UInt<16>
    output io_last_iteration : UInt<1>

    reg dim_N : UInt<16>, clock with :
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
    node _T_5 = gt(_T_4, UInt<4>("hf")) @[IndexCalculator.scala 101:29]
    node _T_6 = add(counter_offset, UInt<1>("h1")) @[IndexCalculator.scala 104:46]
    node _T_7 = tail(_T_6, 1) @[IndexCalculator.scala 104:46]
    node _T_8 = add(counter_PE, UInt<3>("h4")) @[IndexCalculator.scala 108:38]
    node _T_9 = tail(_T_8, 1) @[IndexCalculator.scala 108:38]
    node _GEN_3 = mux(_T_5, UInt<1>("h0"), _T_9) @[IndexCalculator.scala 101:42 IndexCalculator.scala 103:24 IndexCalculator.scala 108:24]
    node _GEN_4 = mux(_T_5, _T_7, _GEN_2) @[IndexCalculator.scala 101:42 IndexCalculator.scala 104:28]
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
    node _T_28 = leq(counter_PE, UInt<4>("hf")) @[IndexCalculator.scala 120:29]
    node _T_29 = add(counter_PE, UInt<1>("h1")) @[IndexCalculator.scala 121:29]
    node _T_30 = tail(_T_29, 1) @[IndexCalculator.scala 121:29]
    node _T_31 = leq(_T_30, UInt<4>("hf")) @[IndexCalculator.scala 121:35]
    node _T_32 = add(counter_PE, UInt<2>("h2")) @[IndexCalculator.scala 122:29]
    node _T_33 = tail(_T_32, 1) @[IndexCalculator.scala 122:29]
    node _T_34 = leq(_T_33, UInt<4>("hf")) @[IndexCalculator.scala 122:35]
    node _T_35 = add(counter_PE, UInt<2>("h3")) @[IndexCalculator.scala 123:29]
    node _T_36 = tail(_T_35, 1) @[IndexCalculator.scala 123:29]
    node _T_37 = leq(_T_36, UInt<4>("hf")) @[IndexCalculator.scala 123:35]
    node _T_38 = rem(counter_PE, UInt<3>("h4")) @[IndexCalculator.scala 125:45]
    node _T_39 = add(counter_PE, UInt<1>("h1")) @[IndexCalculator.scala 130:46]
    node _T_40 = tail(_T_39, 1) @[IndexCalculator.scala 130:46]
    node _T_41 = rem(_T_40, UInt<3>("h4")) @[IndexCalculator.scala 125:45]
    node _T_42 = add(counter_PE, UInt<2>("h2")) @[IndexCalculator.scala 131:46]
    node _T_43 = tail(_T_42, 1) @[IndexCalculator.scala 131:46]
    node _T_44 = rem(_T_43, UInt<3>("h4")) @[IndexCalculator.scala 125:45]
    node _T_45 = add(counter_PE, UInt<2>("h3")) @[IndexCalculator.scala 132:46]
    node _T_46 = tail(_T_45, 1) @[IndexCalculator.scala 132:46]
    node _T_47 = rem(_T_46, UInt<3>("h4")) @[IndexCalculator.scala 125:45]
    node _T_48 = div(counter_PE, UInt<3>("h4")) @[IndexCalculator.scala 126:45]
    node _T_49 = add(counter_PE, UInt<1>("h1")) @[IndexCalculator.scala 135:46]
    node _T_50 = tail(_T_49, 1) @[IndexCalculator.scala 135:46]
    node _T_51 = div(_T_50, UInt<3>("h4")) @[IndexCalculator.scala 126:45]
    node _T_52 = add(counter_PE, UInt<2>("h2")) @[IndexCalculator.scala 136:46]
    node _T_53 = tail(_T_52, 1) @[IndexCalculator.scala 136:46]
    node _T_54 = div(_T_53, UInt<3>("h4")) @[IndexCalculator.scala 126:45]
    node _T_55 = add(counter_PE, UInt<2>("h3")) @[IndexCalculator.scala 137:46]
    node _T_56 = tail(_T_55, 1) @[IndexCalculator.scala 137:46]
    node _T_57 = div(_T_56, UInt<3>("h4")) @[IndexCalculator.scala 126:45]
    node _T_58 = eq(counter_offset, dim_N) @[IndexCalculator.scala 145:41]
    io_index0 <= bits(_T_12, 31, 0) @[IndexCalculator.scala 114:15]
    io_index1 <= bits(_T_17, 31, 0) @[IndexCalculator.scala 115:15]
    io_index2 <= bits(_T_22, 31, 0) @[IndexCalculator.scala 116:15]
    io_index3 <= bits(_T_27, 31, 0) @[IndexCalculator.scala 117:15]
    io_valid0 <= _T_28 @[IndexCalculator.scala 120:15]
    io_valid1 <= _T_31 @[IndexCalculator.scala 121:15]
    io_valid2 <= _T_34 @[IndexCalculator.scala 122:15]
    io_valid3 <= _T_37 @[IndexCalculator.scala 123:15]
    io_x_dest_0 <= bits(_T_38, 1, 0) @[IndexCalculator.scala 129:17]
    io_x_dest_1 <= bits(_T_41, 1, 0) @[IndexCalculator.scala 130:17]
    io_x_dest_2 <= bits(_T_44, 1, 0) @[IndexCalculator.scala 131:17]
    io_x_dest_3 <= bits(_T_47, 1, 0) @[IndexCalculator.scala 132:17]
    io_y_dest_0 <= bits(_T_48, 1, 0) @[IndexCalculator.scala 134:17]
    io_y_dest_1 <= bits(_T_51, 1, 0) @[IndexCalculator.scala 135:17]
    io_y_dest_2 <= bits(_T_54, 1, 0) @[IndexCalculator.scala 136:17]
    io_y_dest_3 <= bits(_T_57, 1, 0) @[IndexCalculator.scala 137:17]
    io_pos_0 <= counter_offset @[IndexCalculator.scala 140:14]
    io_pos_1 <= counter_offset @[IndexCalculator.scala 141:14]
    io_pos_2 <= counter_offset @[IndexCalculator.scala 142:14]
    io_pos_3 <= counter_offset @[IndexCalculator.scala 143:14]
    io_last_iteration <= _T_58 @[IndexCalculator.scala 145:23]
    dim_N <= _GEN_0
    counter_PE <= _GEN_5
    counter_offset <= _GEN_6

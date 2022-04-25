circuit AllToAll :
  module AllToAllController :
    input clock : Clock
    input reset : Reset
    output io : { processor : { flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { inst : { funct : UInt<7>, rs2 : UInt<5>, rs1 : UInt<5>, xd : UInt<1>, xs1 : UInt<1>, xs2 : UInt<1>, rd : UInt<5>, opcode : UInt<7>}, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { rd : UInt<5>, data : UInt<64>}}, busy : UInt<1>, interrupt : UInt<1>, flip exception : UInt<1>}, flip mesh : { cmd : { flip load : UInt<1>, flip store : UInt<1>, flip doAllToAll : UInt<1>, flip rs1 : UInt<64>, flip rs2 : UInt<64>}, resp : { data : UInt<64>}}}

    node loadSignal = eq(io.processor.cmd.bits.inst.opcode, UInt<4>("hb")) @[AllToAllController.scala 41:55]
    reg state : UInt<2>, clock with :
      reset => (reset, UInt<2>("h0")) @[AllToAllController.scala 44:22]
    reg rd_address : UInt<5>, clock with :
      reset => (UInt<1>("h0"), rd_address) @[AllToAllController.scala 45:23]
    node _T = eq(state, UInt<2>("h0")) @[AllToAllController.scala 52:43]
    node _T_1 = mux(_T, io.processor.cmd.bits.inst.rd, rd_address) @[AllToAllController.scala 52:35]
    io.processor.resp.bits.rd <= _T_1 @[AllToAllController.scala 52:29]
    node _T_2 = eq(state, UInt<2>("h0")) @[AllToAllController.scala 54:14]
    when _T_2 : @[AllToAllController.scala 54:23]
      rd_address <= io.processor.cmd.bits.inst.rd @[AllToAllController.scala 55:16]
    node _T_3 = eq(state, UInt<2>("h0")) @[AllToAllController.scala 58:36]
    io.processor.cmd.ready <= _T_3 @[AllToAllController.scala 58:26]
    io.processor.interrupt <= UInt<1>("h0") @[AllToAllController.scala 60:26]
    io.processor.resp.bits.data <= UInt<64>("h0") @[AllToAllController.scala 61:31]
    node _T_4 = eq(state, UInt<2>("h0")) @[AllToAllController.scala 71:14]
    when _T_4 : @[AllToAllController.scala 71:23]
      io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 73:23]
      io.processor.cmd.ready <= UInt<1>("h1") @[AllToAllController.scala 75:16]
      io.processor.resp.valid <= UInt<1>("h0") @[AllToAllController.scala 77:17]
      io.mesh.cmd.load <= UInt<1>("h0") @[AllToAllController.scala 79:22]
      io.mesh.cmd.store <= UInt<1>("h0") @[AllToAllController.scala 80:23]
      io.mesh.cmd.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 81:28]
      io.mesh.cmd.rs1 <= UInt<64>("h0") @[AllToAllController.scala 82:21]
      io.mesh.cmd.rs2 <= UInt<64>("h0") @[AllToAllController.scala 83:21]
      when io.processor.cmd.valid : @[AllToAllController.scala 85:23]
        state <= UInt<2>("h1") @[AllToAllController.scala 86:13]
      else :
        when loadSignal : @[AllToAllController.scala 87:27]
          state <= UInt<2>("h2") @[AllToAllController.scala 88:13]
        else :
          state <= UInt<2>("h0") @[AllToAllController.scala 90:13]
    else :
      node _T_5 = eq(state, UInt<2>("h1")) @[AllToAllController.scala 92:20]
      when _T_5 : @[AllToAllController.scala 92:33]
        io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 94:23]
        io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 96:16]
        io.processor.resp.valid <= UInt<1>("h0") @[AllToAllController.scala 98:17]
        io.mesh.cmd.load <= UInt<1>("h0") @[AllToAllController.scala 100:22]
        io.mesh.cmd.store <= UInt<1>("h0") @[AllToAllController.scala 101:23]
        io.mesh.cmd.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 103:28]
        io.mesh.cmd.rs1 <= UInt<64>("h0") @[AllToAllController.scala 104:21]
        io.mesh.cmd.rs2 <= UInt<64>("h0") @[AllToAllController.scala 105:21]
        when UInt<1>("h1") : @[AllToAllController.scala 107:29]
          state <= UInt<2>("h3") @[AllToAllController.scala 108:15]
        else :
          state <= UInt<2>("h1") @[AllToAllController.scala 110:15]
      else :
        node _T_6 = eq(state, UInt<2>("h3")) @[AllToAllController.scala 112:20]
        when _T_6 : @[AllToAllController.scala 112:38]
          io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 114:23]
          io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 116:16]
          io.processor.resp.valid <= UInt<1>("h1") @[AllToAllController.scala 118:17]
          io.mesh.cmd.load <= UInt<1>("h0") @[AllToAllController.scala 120:22]
          io.mesh.cmd.store <= UInt<1>("h0") @[AllToAllController.scala 121:23]
          io.mesh.cmd.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 122:28]
          io.mesh.cmd.rs1 <= UInt<64>("h0") @[AllToAllController.scala 123:21]
          io.mesh.cmd.rs2 <= UInt<64>("h0") @[AllToAllController.scala 124:21]
          state <= UInt<2>("h0") @[AllToAllController.scala 127:11]
        else :
          node _T_7 = eq(state, UInt<2>("h2")) @[AllToAllController.scala 128:20]
          when _T_7 : @[AllToAllController.scala 128:29]
            io.processor.busy <= UInt<1>("h1") @[AllToAllController.scala 130:23]
            io.processor.cmd.ready <= UInt<1>("h0") @[AllToAllController.scala 132:16]
            io.processor.resp.valid <= UInt<1>("h0") @[AllToAllController.scala 134:17]
            io.mesh.cmd.load <= UInt<1>("h1") @[AllToAllController.scala 136:22]
            io.mesh.cmd.store <= UInt<1>("h0") @[AllToAllController.scala 137:23]
            io.mesh.cmd.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 138:28]
            io.mesh.cmd.rs1 <= UInt<64>("h0") @[AllToAllController.scala 139:21]
            io.mesh.cmd.rs2 <= UInt<64>("h0") @[AllToAllController.scala 140:21]
            state <= UInt<2>("h0") @[AllToAllController.scala 142:11]
          else :
            io.processor.busy <= UInt<1>("h0") @[AllToAllController.scala 148:23]
            io.processor.cmd.ready <= UInt<1>("h1") @[AllToAllController.scala 149:16]
            io.processor.resp.valid <= UInt<1>("h0") @[AllToAllController.scala 150:17]
            state <= UInt<2>("h0") @[AllToAllController.scala 151:11]
            io.mesh.cmd.load <= UInt<1>("h0") @[AllToAllController.scala 152:22]
            io.mesh.cmd.store <= UInt<1>("h0") @[AllToAllController.scala 153:23]
            io.mesh.cmd.doAllToAll <= UInt<1>("h0") @[AllToAllController.scala 154:28]
            io.mesh.cmd.rs1 <= UInt<64>("h0") @[AllToAllController.scala 155:21]
            io.mesh.cmd.rs2 <= UInt<64>("h0") @[AllToAllController.scala 156:21]

  module AllToAllPEupLeftCorner :
    input clock : Clock
    input reset : Reset
    output io : { flip load : UInt<1>, flip store : UInt<1>, flip doAllToAll : UInt<1>, flip rs1 : UInt<64>, flip rs2 : UInt<64>, data : UInt<64>, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 104:18]
    reg number_PE : UInt<16>, clock with :
      reset => (UInt<1>("h0"), number_PE) @[AllToAllPE.scala 108:22]
    number_PE <= UInt<16>("h0") @[AllToAllPE.scala 109:13]
    when io.load : @[AllToAllPE.scala 111:16]
      infer mport MPORT = memPE[UInt<1>("h0")], clock @[AllToAllPE.scala 113:12]
      node _T = cat(UInt<48>("h0"), number_PE) @[Cat.scala 30:58]
      MPORT <= _T @[AllToAllPE.scala 113:18]
      infer mport MPORT_1 = memPE[UInt<1>("h1")], clock @[AllToAllPE.scala 113:12]
      node _T_1 = cat(UInt<48>("h1"), number_PE) @[Cat.scala 30:58]
      MPORT_1 <= _T_1 @[AllToAllPE.scala 113:18]
      infer mport MPORT_2 = memPE[UInt<2>("h2")], clock @[AllToAllPE.scala 113:12]
      node _T_2 = cat(UInt<48>("h2"), number_PE) @[Cat.scala 30:58]
      MPORT_2 <= _T_2 @[AllToAllPE.scala 113:18]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 159:15]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 161:13]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 163:16]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 164:17]
    io.data <= UInt<64>("h0") @[AllToAllPE.scala 166:11]

  module AllToAllPEup :
    input clock : Clock
    input reset : Reset
    output io : { flip load : UInt<1>, flip store : UInt<1>, flip doAllToAll : UInt<1>, flip rs1 : UInt<64>, flip rs2 : UInt<64>, data : UInt<64>, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 104:18]
    reg number_PE : UInt<16>, clock with :
      reset => (UInt<1>("h0"), number_PE) @[AllToAllPE.scala 108:22]
    number_PE <= UInt<16>("h1") @[AllToAllPE.scala 109:13]
    when io.load : @[AllToAllPE.scala 111:16]
      infer mport MPORT = memPE[UInt<1>("h0")], clock @[AllToAllPE.scala 113:12]
      node _T = cat(UInt<48>("h0"), number_PE) @[Cat.scala 30:58]
      MPORT <= _T @[AllToAllPE.scala 113:18]
      infer mport MPORT_1 = memPE[UInt<1>("h1")], clock @[AllToAllPE.scala 113:12]
      node _T_1 = cat(UInt<48>("h1"), number_PE) @[Cat.scala 30:58]
      MPORT_1 <= _T_1 @[AllToAllPE.scala 113:18]
      infer mport MPORT_2 = memPE[UInt<2>("h2")], clock @[AllToAllPE.scala 113:12]
      node _T_2 = cat(UInt<48>("h2"), number_PE) @[Cat.scala 30:58]
      MPORT_2 <= _T_2 @[AllToAllPE.scala 113:18]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 215:13]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 217:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 218:16]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 219:17]
    io.data <= UInt<64>("h0") @[AllToAllPE.scala 221:11]

  module AllToAllPEupRightCorner :
    input clock : Clock
    input reset : Reset
    output io : { flip load : UInt<1>, flip store : UInt<1>, flip doAllToAll : UInt<1>, flip rs1 : UInt<64>, flip rs2 : UInt<64>, data : UInt<64>, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 104:18]
    reg number_PE : UInt<16>, clock with :
      reset => (UInt<1>("h0"), number_PE) @[AllToAllPE.scala 108:22]
    number_PE <= UInt<16>("h2") @[AllToAllPE.scala 109:13]
    when io.load : @[AllToAllPE.scala 111:16]
      infer mport MPORT = memPE[UInt<1>("h0")], clock @[AllToAllPE.scala 113:12]
      node _T = cat(UInt<48>("h0"), number_PE) @[Cat.scala 30:58]
      MPORT <= _T @[AllToAllPE.scala 113:18]
      infer mport MPORT_1 = memPE[UInt<1>("h1")], clock @[AllToAllPE.scala 113:12]
      node _T_1 = cat(UInt<48>("h1"), number_PE) @[Cat.scala 30:58]
      MPORT_1 <= _T_1 @[AllToAllPE.scala 113:18]
      infer mport MPORT_2 = memPE[UInt<2>("h2")], clock @[AllToAllPE.scala 113:12]
      node _T_2 = cat(UInt<48>("h2"), number_PE) @[Cat.scala 30:58]
      MPORT_2 <= _T_2 @[AllToAllPE.scala 113:18]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 173:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 175:13]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 177:15]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 178:17]
    io.data <= UInt<64>("h0") @[AllToAllPE.scala 180:11]

  module AllToAllPEleft :
    input clock : Clock
    input reset : Reset
    output io : { flip load : UInt<1>, flip store : UInt<1>, flip doAllToAll : UInt<1>, flip rs1 : UInt<64>, flip rs2 : UInt<64>, data : UInt<64>, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 104:18]
    reg number_PE : UInt<16>, clock with :
      reset => (UInt<1>("h0"), number_PE) @[AllToAllPE.scala 108:22]
    number_PE <= UInt<16>("h3") @[AllToAllPE.scala 109:13]
    when io.load : @[AllToAllPE.scala 111:16]
      infer mport MPORT = memPE[UInt<1>("h0")], clock @[AllToAllPE.scala 113:12]
      node _T = cat(UInt<48>("h0"), number_PE) @[Cat.scala 30:58]
      MPORT <= _T @[AllToAllPE.scala 113:18]
      infer mport MPORT_1 = memPE[UInt<1>("h1")], clock @[AllToAllPE.scala 113:12]
      node _T_1 = cat(UInt<48>("h1"), number_PE) @[Cat.scala 30:58]
      MPORT_1 <= _T_1 @[AllToAllPE.scala 113:18]
      infer mport MPORT_2 = memPE[UInt<2>("h2")], clock @[AllToAllPE.scala 113:12]
      node _T_2 = cat(UInt<48>("h2"), number_PE) @[Cat.scala 30:58]
      MPORT_2 <= _T_2 @[AllToAllPE.scala 113:18]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 240:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 242:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 243:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 244:17]
    io.data <= UInt<64>("h0") @[AllToAllPE.scala 246:11]

  module AllToAllPEmiddle :
    input clock : Clock
    input reset : Reset
    output io : { flip load : UInt<1>, flip store : UInt<1>, flip doAllToAll : UInt<1>, flip rs1 : UInt<64>, flip rs2 : UInt<64>, data : UInt<64>, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 104:18]
    reg number_PE : UInt<16>, clock with :
      reset => (UInt<1>("h0"), number_PE) @[AllToAllPE.scala 108:22]
    number_PE <= UInt<16>("h4") @[AllToAllPE.scala 109:13]
    when io.load : @[AllToAllPE.scala 111:16]
      infer mport MPORT = memPE[UInt<1>("h0")], clock @[AllToAllPE.scala 113:12]
      node _T = cat(UInt<48>("h0"), number_PE) @[Cat.scala 30:58]
      MPORT <= _T @[AllToAllPE.scala 113:18]
      infer mport MPORT_1 = memPE[UInt<1>("h1")], clock @[AllToAllPE.scala 113:12]
      node _T_1 = cat(UInt<48>("h1"), number_PE) @[Cat.scala 30:58]
      MPORT_1 <= _T_1 @[AllToAllPE.scala 113:18]
      infer mport MPORT_2 = memPE[UInt<2>("h2")], clock @[AllToAllPE.scala 113:12]
      node _T_2 = cat(UInt<48>("h2"), number_PE) @[Cat.scala 30:58]
      MPORT_2 <= _T_2 @[AllToAllPE.scala 113:18]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 263:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 264:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 265:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 266:17]
    io.data <= UInt<64>("h0") @[AllToAllPE.scala 268:11]

  module AllToAllPEright :
    input clock : Clock
    input reset : Reset
    output io : { flip load : UInt<1>, flip store : UInt<1>, flip doAllToAll : UInt<1>, flip rs1 : UInt<64>, flip rs2 : UInt<64>, data : UInt<64>, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 104:18]
    reg number_PE : UInt<16>, clock with :
      reset => (UInt<1>("h0"), number_PE) @[AllToAllPE.scala 108:22]
    number_PE <= UInt<16>("h5") @[AllToAllPE.scala 109:13]
    when io.load : @[AllToAllPE.scala 111:16]
      infer mport MPORT = memPE[UInt<1>("h0")], clock @[AllToAllPE.scala 113:12]
      node _T = cat(UInt<48>("h0"), number_PE) @[Cat.scala 30:58]
      MPORT <= _T @[AllToAllPE.scala 113:18]
      infer mport MPORT_1 = memPE[UInt<1>("h1")], clock @[AllToAllPE.scala 113:12]
      node _T_1 = cat(UInt<48>("h1"), number_PE) @[Cat.scala 30:58]
      MPORT_1 <= _T_1 @[AllToAllPE.scala 113:18]
      infer mport MPORT_2 = memPE[UInt<2>("h2")], clock @[AllToAllPE.scala 113:12]
      node _T_2 = cat(UInt<48>("h2"), number_PE) @[Cat.scala 30:58]
      MPORT_2 <= _T_2 @[AllToAllPE.scala 113:18]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 252:16]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 254:15]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 255:13]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 256:17]
    io.data <= UInt<64>("h0") @[AllToAllPE.scala 258:11]

  module AllToAllPEbottomLeftCorner :
    input clock : Clock
    input reset : Reset
    output io : { flip load : UInt<1>, flip store : UInt<1>, flip doAllToAll : UInt<1>, flip rs1 : UInt<64>, flip rs2 : UInt<64>, data : UInt<64>, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 104:18]
    reg number_PE : UInt<16>, clock with :
      reset => (UInt<1>("h0"), number_PE) @[AllToAllPE.scala 108:22]
    number_PE <= UInt<16>("h6") @[AllToAllPE.scala 109:13]
    when io.load : @[AllToAllPE.scala 111:16]
      infer mport MPORT = memPE[UInt<1>("h0")], clock @[AllToAllPE.scala 113:12]
      node _T = cat(UInt<48>("h0"), number_PE) @[Cat.scala 30:58]
      MPORT <= _T @[AllToAllPE.scala 113:18]
      infer mport MPORT_1 = memPE[UInt<1>("h1")], clock @[AllToAllPE.scala 113:12]
      node _T_1 = cat(UInt<48>("h1"), number_PE) @[Cat.scala 30:58]
      MPORT_1 <= _T_1 @[AllToAllPE.scala 113:18]
      infer mport MPORT_2 = memPE[UInt<2>("h2")], clock @[AllToAllPE.scala 113:12]
      node _T_2 = cat(UInt<48>("h2"), number_PE) @[Cat.scala 30:58]
      MPORT_2 <= _T_2 @[AllToAllPE.scala 113:18]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 187:15]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 189:17]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 192:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 193:13]
    io.data <= UInt<64>("h0") @[AllToAllPE.scala 195:11]

  module AllToAllPEbottom :
    input clock : Clock
    input reset : Reset
    output io : { flip load : UInt<1>, flip store : UInt<1>, flip doAllToAll : UInt<1>, flip rs1 : UInt<64>, flip rs2 : UInt<64>, data : UInt<64>, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 104:18]
    reg number_PE : UInt<16>, clock with :
      reset => (UInt<1>("h0"), number_PE) @[AllToAllPE.scala 108:22]
    number_PE <= UInt<16>("h7") @[AllToAllPE.scala 109:13]
    when io.load : @[AllToAllPE.scala 111:16]
      infer mport MPORT = memPE[UInt<1>("h0")], clock @[AllToAllPE.scala 113:12]
      node _T = cat(UInt<48>("h0"), number_PE) @[Cat.scala 30:58]
      MPORT <= _T @[AllToAllPE.scala 113:18]
      infer mport MPORT_1 = memPE[UInt<1>("h1")], clock @[AllToAllPE.scala 113:12]
      node _T_1 = cat(UInt<48>("h1"), number_PE) @[Cat.scala 30:58]
      MPORT_1 <= _T_1 @[AllToAllPE.scala 113:18]
      infer mport MPORT_2 = memPE[UInt<2>("h2")], clock @[AllToAllPE.scala 113:12]
      node _T_2 = cat(UInt<48>("h2"), number_PE) @[Cat.scala 30:58]
      MPORT_2 <= _T_2 @[AllToAllPE.scala 113:18]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 227:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 229:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 230:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 231:13]
    io.data <= UInt<64>("h0") @[AllToAllPE.scala 233:11]

  module AllToAllPEbottomRightCorner :
    input clock : Clock
    input reset : Reset
    output io : { flip load : UInt<1>, flip store : UInt<1>, flip doAllToAll : UInt<1>, flip rs1 : UInt<64>, flip rs2 : UInt<64>, data : UInt<64>, left : { out : UInt<64>, flip in : UInt<64>}, right : { out : UInt<64>, flip in : UInt<64>}, up : { out : UInt<64>, flip in : UInt<64>}, bottom : { out : UInt<64>, flip in : UInt<64>}}

    cmem memPE : UInt<64> [9] @[AllToAllPE.scala 104:18]
    reg number_PE : UInt<16>, clock with :
      reset => (UInt<1>("h0"), number_PE) @[AllToAllPE.scala 108:22]
    number_PE <= UInt<16>("h8") @[AllToAllPE.scala 109:13]
    when io.load : @[AllToAllPE.scala 111:16]
      infer mport MPORT = memPE[UInt<1>("h0")], clock @[AllToAllPE.scala 113:12]
      node _T = cat(UInt<48>("h0"), number_PE) @[Cat.scala 30:58]
      MPORT <= _T @[AllToAllPE.scala 113:18]
      infer mport MPORT_1 = memPE[UInt<1>("h1")], clock @[AllToAllPE.scala 113:12]
      node _T_1 = cat(UInt<48>("h1"), number_PE) @[Cat.scala 30:58]
      MPORT_1 <= _T_1 @[AllToAllPE.scala 113:18]
      infer mport MPORT_2 = memPE[UInt<2>("h2")], clock @[AllToAllPE.scala 113:12]
      node _T_2 = cat(UInt<48>("h2"), number_PE) @[Cat.scala 30:58]
      MPORT_2 <= _T_2 @[AllToAllPE.scala 113:18]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 201:16]
    io.bottom.out <= UInt<64>("h0") @[AllToAllPE.scala 203:17]
    io.left.out <= UInt<64>("h0") @[AllToAllPE.scala 205:15]
    io.right.out <= UInt<64>("h0") @[AllToAllPE.scala 206:16]
    io.up.out <= UInt<64>("h0") @[AllToAllPE.scala 207:13]
    io.data <= UInt<64>("h0") @[AllToAllPE.scala 209:11]

  module AllToAllMesh :
    input clock : Clock
    input reset : Reset
    output io : { cmd : { flip load : UInt<1>, flip store : UInt<1>, flip doAllToAll : UInt<1>, flip rs1 : UInt<64>, flip rs2 : UInt<64>}, resp : { data : UInt<64>}}

    inst vector_0 of AllToAllPEupLeftCorner @[AllToAllMesh.scala 83:41]
    vector_0.clock <= clock
    vector_0.reset <= reset
    inst vector_1 of AllToAllPEup @[AllToAllMesh.scala 94:41]
    vector_1.clock <= clock
    vector_1.reset <= reset
    inst vector_2 of AllToAllPEupRightCorner @[AllToAllMesh.scala 86:41]
    vector_2.clock <= clock
    vector_2.reset <= reset
    inst vector_3 of AllToAllPEleft @[AllToAllMesh.scala 100:41]
    vector_3.clock <= clock
    vector_3.reset <= reset
    inst vector_4 of AllToAllPEmiddle @[AllToAllMesh.scala 106:41]
    vector_4.clock <= clock
    vector_4.reset <= reset
    inst vector_5 of AllToAllPEright @[AllToAllMesh.scala 103:41]
    vector_5.clock <= clock
    vector_5.reset <= reset
    inst vector_6 of AllToAllPEbottomLeftCorner @[AllToAllMesh.scala 89:41]
    vector_6.clock <= clock
    vector_6.reset <= reset
    inst vector_7 of AllToAllPEbottom @[AllToAllMesh.scala 97:41]
    vector_7.clock <= clock
    vector_7.reset <= reset
    inst vector_8 of AllToAllPEbottomRightCorner @[AllToAllMesh.scala 92:41]
    vector_8.clock <= clock
    vector_8.reset <= reset
    vector_0.io.load <= io.cmd.load @[AllToAllMesh.scala 120:27]
    vector_0.io.store <= io.cmd.store @[AllToAllMesh.scala 121:28]
    vector_0.io.doAllToAll <= io.cmd.doAllToAll @[AllToAllMesh.scala 122:33]
    vector_0.io.rs1 <= io.cmd.rs1 @[AllToAllMesh.scala 124:26]
    vector_0.io.rs2 <= io.cmd.rs2 @[AllToAllMesh.scala 125:26]
    io.resp.data <= vector_0.io.data @[AllToAllMesh.scala 128:22]
    vector_1.io.load <= io.cmd.load @[AllToAllMesh.scala 120:27]
    vector_1.io.store <= io.cmd.store @[AllToAllMesh.scala 121:28]
    vector_1.io.doAllToAll <= io.cmd.doAllToAll @[AllToAllMesh.scala 122:33]
    vector_1.io.rs1 <= io.cmd.rs1 @[AllToAllMesh.scala 124:26]
    vector_1.io.rs2 <= io.cmd.rs2 @[AllToAllMesh.scala 125:26]
    io.resp.data <= vector_1.io.data @[AllToAllMesh.scala 128:22]
    vector_2.io.load <= io.cmd.load @[AllToAllMesh.scala 120:27]
    vector_2.io.store <= io.cmd.store @[AllToAllMesh.scala 121:28]
    vector_2.io.doAllToAll <= io.cmd.doAllToAll @[AllToAllMesh.scala 122:33]
    vector_2.io.rs1 <= io.cmd.rs1 @[AllToAllMesh.scala 124:26]
    vector_2.io.rs2 <= io.cmd.rs2 @[AllToAllMesh.scala 125:26]
    io.resp.data <= vector_2.io.data @[AllToAllMesh.scala 128:22]
    vector_3.io.load <= io.cmd.load @[AllToAllMesh.scala 120:27]
    vector_3.io.store <= io.cmd.store @[AllToAllMesh.scala 121:28]
    vector_3.io.doAllToAll <= io.cmd.doAllToAll @[AllToAllMesh.scala 122:33]
    vector_3.io.rs1 <= io.cmd.rs1 @[AllToAllMesh.scala 124:26]
    vector_3.io.rs2 <= io.cmd.rs2 @[AllToAllMesh.scala 125:26]
    io.resp.data <= vector_3.io.data @[AllToAllMesh.scala 128:22]
    vector_4.io.load <= io.cmd.load @[AllToAllMesh.scala 120:27]
    vector_4.io.store <= io.cmd.store @[AllToAllMesh.scala 121:28]
    vector_4.io.doAllToAll <= io.cmd.doAllToAll @[AllToAllMesh.scala 122:33]
    vector_4.io.rs1 <= io.cmd.rs1 @[AllToAllMesh.scala 124:26]
    vector_4.io.rs2 <= io.cmd.rs2 @[AllToAllMesh.scala 125:26]
    io.resp.data <= vector_4.io.data @[AllToAllMesh.scala 128:22]
    vector_5.io.load <= io.cmd.load @[AllToAllMesh.scala 120:27]
    vector_5.io.store <= io.cmd.store @[AllToAllMesh.scala 121:28]
    vector_5.io.doAllToAll <= io.cmd.doAllToAll @[AllToAllMesh.scala 122:33]
    vector_5.io.rs1 <= io.cmd.rs1 @[AllToAllMesh.scala 124:26]
    vector_5.io.rs2 <= io.cmd.rs2 @[AllToAllMesh.scala 125:26]
    io.resp.data <= vector_5.io.data @[AllToAllMesh.scala 128:22]
    vector_6.io.load <= io.cmd.load @[AllToAllMesh.scala 120:27]
    vector_6.io.store <= io.cmd.store @[AllToAllMesh.scala 121:28]
    vector_6.io.doAllToAll <= io.cmd.doAllToAll @[AllToAllMesh.scala 122:33]
    vector_6.io.rs1 <= io.cmd.rs1 @[AllToAllMesh.scala 124:26]
    vector_6.io.rs2 <= io.cmd.rs2 @[AllToAllMesh.scala 125:26]
    io.resp.data <= vector_6.io.data @[AllToAllMesh.scala 128:22]
    vector_7.io.load <= io.cmd.load @[AllToAllMesh.scala 120:27]
    vector_7.io.store <= io.cmd.store @[AllToAllMesh.scala 121:28]
    vector_7.io.doAllToAll <= io.cmd.doAllToAll @[AllToAllMesh.scala 122:33]
    vector_7.io.rs1 <= io.cmd.rs1 @[AllToAllMesh.scala 124:26]
    vector_7.io.rs2 <= io.cmd.rs2 @[AllToAllMesh.scala 125:26]
    io.resp.data <= vector_7.io.data @[AllToAllMesh.scala 128:22]
    vector_8.io.load <= io.cmd.load @[AllToAllMesh.scala 120:27]
    vector_8.io.store <= io.cmd.store @[AllToAllMesh.scala 121:28]
    vector_8.io.doAllToAll <= io.cmd.doAllToAll @[AllToAllMesh.scala 122:33]
    vector_8.io.rs1 <= io.cmd.rs1 @[AllToAllMesh.scala 124:26]
    vector_8.io.rs2 <= io.cmd.rs2 @[AllToAllMesh.scala 125:26]
    io.resp.data <= vector_8.io.data @[AllToAllMesh.scala 128:22]
    vector_0.io.left.in <= UInt<64>("h0") @[AllToAllMesh.scala 136:34]
    vector_0.io.up.in <= UInt<64>("h0") @[AllToAllMesh.scala 138:32]
    vector_0.io.right.in <= vector_1.io.left.out @[AllToAllMesh.scala 142:35]
    vector_0.io.bottom.in <= vector_3.io.up.out @[AllToAllMesh.scala 144:36]
    vector_1.io.up.in <= UInt<64>("h0") @[AllToAllMesh.scala 188:32]
    vector_1.io.left.in <= vector_0.io.right.out @[AllToAllMesh.scala 191:34]
    vector_1.io.right.in <= vector_2.io.left.out @[AllToAllMesh.scala 193:35]
    vector_1.io.bottom.in <= vector_4.io.up.out @[AllToAllMesh.scala 195:36]
    vector_2.io.right.in <= UInt<64>("h0") @[AllToAllMesh.scala 150:35]
    vector_2.io.up.in <= UInt<64>("h0") @[AllToAllMesh.scala 152:32]
    vector_2.io.left.in <= vector_1.io.right.out @[AllToAllMesh.scala 156:34]
    vector_2.io.bottom.in <= vector_5.io.up.out @[AllToAllMesh.scala 158:36]
    vector_3.io.left.in <= UInt<64>("h0") @[AllToAllMesh.scala 210:34]
    vector_3.io.right.in <= vector_4.io.left.out @[AllToAllMesh.scala 213:35]
    vector_3.io.up.in <= vector_0.io.bottom.out @[AllToAllMesh.scala 215:32]
    vector_3.io.bottom.in <= vector_6.io.up.out @[AllToAllMesh.scala 217:36]
    vector_4.io.left.in <= vector_3.io.right.out @[AllToAllMesh.scala 233:34]
    vector_4.io.right.in <= vector_5.io.left.out @[AllToAllMesh.scala 235:35]
    vector_4.io.up.in <= vector_1.io.bottom.out @[AllToAllMesh.scala 237:32]
    vector_4.io.bottom.in <= vector_7.io.up.out @[AllToAllMesh.scala 239:36]
    vector_5.io.right.in <= UInt<64>("h0") @[AllToAllMesh.scala 221:35]
    vector_5.io.left.in <= vector_4.io.right.out @[AllToAllMesh.scala 224:34]
    vector_5.io.up.in <= vector_2.io.bottom.out @[AllToAllMesh.scala 226:32]
    vector_5.io.bottom.in <= vector_8.io.up.out @[AllToAllMesh.scala 228:36]
    vector_6.io.left.in <= UInt<64>("h0") @[AllToAllMesh.scala 163:34]
    vector_6.io.bottom.in <= UInt<64>("h0") @[AllToAllMesh.scala 165:36]
    vector_6.io.right.in <= vector_7.io.left.out @[AllToAllMesh.scala 169:35]
    vector_6.io.up.in <= vector_3.io.bottom.out @[AllToAllMesh.scala 171:32]
    vector_7.io.bottom.in <= UInt<64>("h0") @[AllToAllMesh.scala 199:36]
    vector_7.io.left.in <= vector_6.io.right.out @[AllToAllMesh.scala 202:34]
    vector_7.io.right.in <= vector_8.io.left.out @[AllToAllMesh.scala 204:35]
    vector_7.io.up.in <= vector_4.io.bottom.out @[AllToAllMesh.scala 206:32]
    vector_8.io.right.in <= UInt<64>("h0") @[AllToAllMesh.scala 176:35]
    vector_8.io.bottom.in <= UInt<64>("h0") @[AllToAllMesh.scala 178:36]
    vector_8.io.left.in <= vector_7.io.right.out @[AllToAllMesh.scala 182:34]
    vector_8.io.up.in <= vector_5.io.bottom.out @[AllToAllMesh.scala 184:32]

  module AllToAllModule :
    input clock : Clock
    input reset : Reset
    output io : { flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { inst : { funct : UInt<7>, rs2 : UInt<5>, rs1 : UInt<5>, xd : UInt<1>, xs1 : UInt<1>, xs2 : UInt<1>, rd : UInt<5>, opcode : UInt<7>}, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { rd : UInt<5>, data : UInt<64>}}, busy : UInt<1>, interrupt : UInt<1>, flip exception : UInt<1>}

    inst controller of AllToAllController @[AllToAllAccelerator.scala 71:26]
    controller.clock <= clock
    controller.reset <= reset
    inst mesh of AllToAllMesh @[AllToAllAccelerator.scala 72:20]
    mesh.clock <= clock
    mesh.reset <= reset
    controller.io.processor.exception <= io.exception @[AllToAllAccelerator.scala 78:6]
    io.interrupt <= controller.io.processor.interrupt @[AllToAllAccelerator.scala 78:6]
    io.busy <= controller.io.processor.busy @[AllToAllAccelerator.scala 78:6]
    io.resp.bits.data <= controller.io.processor.resp.bits.data @[AllToAllAccelerator.scala 78:6]
    io.resp.bits.rd <= controller.io.processor.resp.bits.rd @[AllToAllAccelerator.scala 78:6]
    io.resp.valid <= controller.io.processor.resp.valid @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.resp.ready <= io.resp.ready @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.bits.inst.opcode <= io.cmd.bits.inst.opcode @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.bits.inst.rd <= io.cmd.bits.inst.rd @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.bits.inst.xs2 <= io.cmd.bits.inst.xs2 @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.bits.inst.xs1 <= io.cmd.bits.inst.xs1 @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.bits.inst.xd <= io.cmd.bits.inst.xd @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.bits.inst.rs1 <= io.cmd.bits.inst.rs1 @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.bits.inst.rs2 <= io.cmd.bits.inst.rs2 @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.bits.inst.funct <= io.cmd.bits.inst.funct @[AllToAllAccelerator.scala 78:6]
    controller.io.processor.cmd.valid <= io.cmd.valid @[AllToAllAccelerator.scala 78:6]
    io.cmd.ready <= controller.io.processor.cmd.ready @[AllToAllAccelerator.scala 78:6]
    mesh.io.cmd.load <= controller.io.mesh.cmd.load @[AllToAllAccelerator.scala 82:20]
    mesh.io.cmd.store <= controller.io.mesh.cmd.store @[AllToAllAccelerator.scala 83:21]
    mesh.io.cmd.doAllToAll <= controller.io.mesh.cmd.doAllToAll @[AllToAllAccelerator.scala 84:26]
    mesh.io.cmd.rs1 <= controller.io.mesh.cmd.rs1 @[AllToAllAccelerator.scala 85:19]
    mesh.io.cmd.rs2 <= controller.io.mesh.cmd.rs2 @[AllToAllAccelerator.scala 86:19]
    controller.io.mesh.resp.data <= mesh.io.resp.data @[AllToAllAccelerator.scala 87:32]

  module AllToAll :
    input clock : Clock
    input reset : UInt<1>
    output io : { flip cmd : { flip ready : UInt<1>, valid : UInt<1>, bits : { inst : { funct : UInt<7>, rs2 : UInt<5>, rs1 : UInt<5>, xd : UInt<1>, xs1 : UInt<1>, xs2 : UInt<1>, rd : UInt<5>, opcode : UInt<7>}, rs1 : UInt<64>, rs2 : UInt<64>}}, resp : { flip ready : UInt<1>, valid : UInt<1>, bits : { rd : UInt<5>, data : UInt<64>}}, busy : UInt<1>, interrupt : UInt<1>, flip exception : UInt<1>}

    inst aTaModule of AllToAllModule @[AllToAllTest.scala 13:25]
    aTaModule.clock <= clock
    aTaModule.reset <= reset
    aTaModule.io.cmd.valid <= io.cmd.valid @[AllToAllTest.scala 16:26]
    aTaModule.io.cmd.bits.inst.funct <= io.cmd.bits.inst.funct @[AllToAllTest.scala 17:36]
    aTaModule.io.cmd.bits.inst.rs2 <= io.cmd.bits.inst.rs2 @[AllToAllTest.scala 18:34]
    aTaModule.io.cmd.bits.inst.rs1 <= io.cmd.bits.inst.rs1 @[AllToAllTest.scala 19:34]
    aTaModule.io.cmd.bits.inst.xd <= io.cmd.bits.inst.xd @[AllToAllTest.scala 20:33]
    aTaModule.io.cmd.bits.inst.xs1 <= io.cmd.bits.inst.xs1 @[AllToAllTest.scala 21:34]
    aTaModule.io.cmd.bits.inst.xs2 <= io.cmd.bits.inst.xs2 @[AllToAllTest.scala 22:34]
    aTaModule.io.cmd.bits.inst.rd <= io.cmd.bits.inst.rd @[AllToAllTest.scala 23:33]
    aTaModule.io.cmd.bits.inst.opcode <= io.cmd.bits.inst.opcode @[AllToAllTest.scala 24:37]
    aTaModule.io.cmd.bits.rs1 <= io.cmd.bits.rs1 @[AllToAllTest.scala 25:29]
    aTaModule.io.cmd.bits.rs2 <= io.cmd.bits.rs2 @[AllToAllTest.scala 26:29]
    aTaModule.io.resp.ready <= io.resp.ready @[AllToAllTest.scala 27:27]
    io.cmd.ready <= aTaModule.io.cmd.ready @[AllToAllTest.scala 31:16]
    io.resp.valid <= aTaModule.io.resp.valid @[AllToAllTest.scala 32:17]
    io.resp.bits.rd <= aTaModule.io.resp.bits.rd @[AllToAllTest.scala 33:19]
    io.resp.bits.data <= aTaModule.io.resp.bits.data @[AllToAllTest.scala 34:21]
    io.interrupt <= aTaModule.io.interrupt @[AllToAllTest.scala 37:16]
    io.busy <= aTaModule.io.busy @[AllToAllTest.scala 38:11]
    aTaModule.io.exception <= io.exception @[AllToAllTest.scala 41:26]


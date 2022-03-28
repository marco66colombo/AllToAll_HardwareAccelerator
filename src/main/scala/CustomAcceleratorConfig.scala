package HPPS_Project

class WithCustomAccelerator extends Config((site, here, up) => {
    case BuildRoCC => Seq((p: Parameters) => {
            val withCustom = LazyModule.apply(new CustomAccelerator(OpcodeSet.custom0)(p))
            withCustom
        }
    )
  }
)

class CustomAcceleratorConfig extends Config(
    new CustomAccelerator ++
    new freechips.rocketchip.subsystem.WithNBigCores(1)
)
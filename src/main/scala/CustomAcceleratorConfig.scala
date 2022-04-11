package hppsProject

import chisel3._
import freechips.rocketchip.config.{Config, Parameters}
import freechips.rocketchip.diplomacy.LazyModule
import freechips.rocketchip.tile._
import hppsProject._

class WithCustomAccelerator extends Config((site, here, up) => {
    case BuildRoCC => Seq((p: Parameters) => {
            val withCustom = LazyModule.apply(new CustomAccelerator(OpcodeSet.custom0)(p))
            withCustom
        }
    )
  }
)

class CustomAcceleratorConfig extends Config(
    new WithCustomAccelerator ++
    new freechips.rocketchip.subsystem.WithNBigCores(1)
)
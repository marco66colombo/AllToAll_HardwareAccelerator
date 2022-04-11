package hppsProject

import chisel3._
import chisel3.util._
import chisel3.experimental.IntParam
import freechips.rocketchip.config._
import freechips.rocketchip.diplomacy._
import freechips.rocketchip.rocket._
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
    new CustomAccelerator ++
    new freechips.rocketchip.subsystem.WithNBigCores(1)
)
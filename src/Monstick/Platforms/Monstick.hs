
module Monstick.Platforms.Monstick where

import Monstick.Platforms.Types

import Ivory.BSP.STM32L431

import Ivory.BSP.STM32.ClockConfig
import Ivory.BSP.STM32.Peripheral.I2C
import Ivory.BSP.STM32.Peripheral.SPI
import Ivory.BSP.STM32.Peripheral.UART

import qualified Ivory.Tower.Base as Base
import Ivory.Tower.Drivers.Net.RN2483 (defaultRadioConfig)


-- external I2C1
i2c1Pins :: I2CPins
i2c1Pins = I2CPins { i2cpins_sda = pinB7
                   , i2cpins_scl = pinB8 }

-- internal
i2c2Pins :: I2CPins
i2c2Pins = I2CPins { i2cpins_sda = pinB11
                   , i2cpins_scl = pinB13 }

-- external I2C0
i2c3Pins :: I2CPins
i2c3Pins = I2CPins { i2cpins_sda = pinC1
                   , i2cpins_scl = pinC0 }

spiPins :: SPIPins
spiPins = SPIPins
    { spiPinMiso = pinB14
    , spiPinMosi = pinB15
    , spiPinSck  = pinB10
    }

-- CS0 -- pinB12
-- CS1 -- pinB9

-- modem
usart1Pins :: UARTPins
usart1Pins = UARTPins
  { uartPinTx = pinA9
  , uartPinRx = pinA10
  }
  -- RTS pinB3
  -- CTS pinB4

-- debug
usart2Pins :: UARTPins
usart2Pins = UARTPins
  { uartPinTx = pinA2
  , uartPinRx = pinA15
  }

monstick_cc :: ClockConfig
monstick_cc = ClockConfig { clockconfig_source = MSI $ 16 * 1000 * 1000 -- HSI16
                        , clockconfig_pll    = PLLFactorMNR
                          { pll_mnr_m = 1
                          , pll_mnr_n = 10
                          , pll_mnr_p = 7
                          , pll_mnr_q = 2
                          , pll_mnr_r = 2
                          }
                        , clockconfig_hclk_divider = 1
                        , clockconfig_pclk1_divider = 1
                        , clockconfig_pclk2_divider = 1
                        }

monstick :: Platform
monstick = Platform {
    platformClocks   = monstick_cc
  , platformMCU      = Nothing
  , platformMCUName  = "STM32L431RBT6"
  , platformPin      = pinH0
  , platformRedLED   = Base.LED pinH0 Base.ActiveHigh -- green as well
  , platformGreenLED = Base.LED pinH1 Base.ActiveHigh
  , platformSPI      = spi2
  , platformSPIPins  = spiPins
  , platformSPIDevs  = []
  , platformI2C      = i2c2
  , platformI2CPins  = i2c2Pins
  , platformUART     = usart2
  , platformUARTPins = usart2Pins
  , platformCAN      = monstickCAN
  , platformRadio    = monstickRadio
  }

monstickCAN :: CANConfig
monstickCAN = CANConfig {
    canPeriph        = can1
  , canPeriphFilters = canFilters
  , canRxPin         = pinA11
  , canTxPin         = pinA12
  }

monstickRadio :: Radio
monstickRadio = Radio {
    radioUART        = usart1
  , radioUARTPins    = usart1Pins
  , radioConfig      = defaultRadioConfig
  , radioResetPin    = pinC12
  }

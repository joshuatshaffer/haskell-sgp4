
module Sgp4.Unit (sgp4, sgp4Init) where

import Sgp4.Types
import Sgp4.Raw

sgp4Init :: Orbit -> Elsetrec
sgp4Init = initSgp4

sgp4 :: Elsetrec -> Time -> SatStatus
sgp4 = propagateSgp4

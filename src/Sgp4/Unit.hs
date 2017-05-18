
module Sgp4.Unit (propagate) where

import Sgp4.Types
import Sgp4.Raw

propagate :: Elsetrec -> Time -> SatStatus
propagate = propagateSgp4

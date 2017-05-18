module Sgp4.IO (twoline2rv) where

import Sgp4.Types
import Sgp4.Ext (jday, days2mdhms)
import Sgp4.Raw (initSgp4, Elsetrec)
import TLE

twoline2rv :: String -> String -> Elsetrec
twoline2rv l1 l2 = initSgp4 $ sgp4OrbitFromTLE $ parceTLE l1 l2

sgp4OrbitFromTLE :: TLE -> Orbit
sgp4OrbitFromTLE (TLE _ _ _ epochYear epochDay n' n'' bStar _ _ i _Ω e ω m0 n _ _) =
   Sgp4Orbit e
             (i * deg2rad)
             (_Ω * deg2rad)
             (ω * deg2rad)
             (n / xpdotp)
             (n' / (xpdotp * 1440.0))
             (n'' / (xpdotp * 1440.0 * 1440))
             (m0 * deg2rad)
             bStar
             (jday epochYear (days2mdhms epochYear epochDay) - 2433281.5)
  where
    deg2rad, xpdotp :: Double
    deg2rad = pi / 180.0
    xpdotp = 1440.0 / (2.0 * pi)

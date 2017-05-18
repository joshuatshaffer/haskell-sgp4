module Sgp4.IO (twoline2rv, Gravconst(Wgs72, Wgs84, Wgs72old)) where

import Sgp4.Ext (jday, days2mdhms)
import Sgp4.Raw (raw_sgp4init, p_free, Elsetrec, Gravconst(Wgs72, Wgs84, Wgs72old))
import TLE
import System.IO.Unsafe (unsafePerformIO)
import Foreign.ForeignPtr (newForeignPtr)

twoline2rv :: String -> String -> Gravconst -> Elsetrec
twoline2rv l1 l2 = initSgp4 (parceTLE l1 l2)

initSgp4 :: TLE -> Gravconst -> Elsetrec
initSgp4 (TLE _ _ _ epochYear epochDay n' n'' bStar _ _ i _Ω e ω m0 n _ _) whichconst =
    unsafePerformIO $ raw_sgp4init whichconst 'i' 0 epoch bStar n'con n''con e ωcon icon m0con ncon _Ωcon >>= newForeignPtr p_free
  where
    -- convert to sgp4 units
    epoch = jday epochYear (days2mdhms epochYear epochDay) - 2433281.5
    n'con = n' / (xpdotp * 1440.0)
    n''con = n'' / (xpdotp * 1440.0 * 1440)
    ωcon = ω * deg2rad
    icon = i * deg2rad
    m0con = m0 * deg2rad
    ncon = n / xpdotp
    _Ωcon = _Ω * deg2rad

    deg2rad, xpdotp :: Double
    deg2rad = pi / 180.0
    xpdotp = 1440.0 / (2.0 * pi)

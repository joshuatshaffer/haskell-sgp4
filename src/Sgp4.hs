
module Sgp4 (Time
            ,Position
            ,Velocity
            ,SatStatus (Orbiting, Decayed)
            ,Elsetrec
            ,Gravconst (Wgs72old, Wgs72, Wgs84)
            ,twoline2rv
            ,initSgp4
            ,propagate
            ) where

import Sgp4.Ext (jday, days2mdhms)
import qualified Sgp4.Raw as Raw
import Sgp4.Raw (Elsetrec, Gravconst(Wgs72old, Wgs72, Wgs84))
import TLE

import System.IO.Unsafe (unsafePerformIO)
import Foreign.ForeignPtr (newForeignPtr,withForeignPtr)

type Time = Double
type Position = (Double,Double,Double)
type Velocity = (Double,Double,Double)

data SatStatus = Orbiting Position Velocity | Decayed Int deriving (Show, Eq)

twoline2rv :: String -> String -> Gravconst -> Elsetrec
twoline2rv l1 l2 = initSgp4 (parceTLE l1 l2)

initSgp4 :: TLE -> Gravconst -> Elsetrec
initSgp4 (TLE _ _ _ epochYear epochDay n' n'' bStar _ _ i _Ω e ω m0 n _ _) whichconst =
    unsafePerformIO $ Raw.sgp4init whichconst 'i' 0 epoch bStar n'con n''con e ωcon icon m0con ncon _Ωcon >>= newForeignPtr Raw.p_free
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

propagate :: Elsetrec -> Time -> SatStatus
propagate elsetrec' t = unsafePerformIO $ withForeignPtr elsetrec' bod
  where bod elsetrec = do (isOk,err,r,v) <- Raw.sgp4 elsetrec t
                          return $ if isOk
                                    then Orbiting r v
                                    else Decayed err

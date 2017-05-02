
module Sgp4 where

import Sgp4.Raw
import Sgp4.IO


import Foreign.Ptr (Ptr)
import Foreign.C.Types (CDouble)
import Control.Applicative ((<$>))
import Foreign.Marshal.Array (peekArray,mallocArray)
import System.IO.Unsafe (unsafePerformIO)
{------------------------------- Main Goals ---------------------------------}

type Time = Double
type Position = (Double,Double,Double)
type Velocity = (Double,Double,Double)

data SatStatus = Orbiting Position Velocity | Decayed deriving (Show)
type Propagator = Time -> SatStatus

initFromTLE :: TLE -> ElsetrecPtr
initFromTLE (TLE satelliteNum classification internationalDesignator
  epochYear epochDay meanMotionDt1 meanMotionDt2 bStar
  elementNum checksumL1 inclination raan eccentricity
  argOfPeri meanAnomaly meanMotion revolutionNumber
  checksumL2) = unsafePerformIO $ raw_sgp4init Wgs84 'i' satelliteNum 0.0 bStar meanMotionDt1 meanMotionDt2 eccentricity argOfPeri inclination meanAnomaly meanMotion raan

propagatorFromElsetrecPtr :: ElsetrecPtr -> Propagator
propagatorFromElsetrecPtr elsetrec t = unsafePerformIO $ do
  r <- mallocArray 3 :: IO (Ptr CDouble)
  v <- mallocArray 3 :: IO (Ptr CDouble)
  isOk <- raw_sgp4 elsetrec t r v
  if isOk
    then do r' <- map cDoubleConv <$> peekArray 3 r
            v' <- map cDoubleConv <$> peekArray 3 v
            return $ Orbiting (head r', r' !! 1, r' !! 2) (head v', v' !! 1, v' !! 2)
    else return Decayed

propagatorFromTLE :: TLE -> Propagator
propagatorFromTLE = propagatorFromElsetrecPtr . initFromTLE

{------------------------------- Stretch Goals ------------------------------}

type URL = String
data SatID = SatNum Int | SatName String | IntDes Int Int String

setTLESources :: [URL] -> IO ()
setTLESources = undefined

getTLESources :: IO [URL]
getTLESources = undefined

updateTLE :: IO () -- Download new TLEs
updateTLE = undefined

getTLE :: SatID -> IO TLE -- returns the most recent TLE on file
getTLE = undefined

initPropagator :: SatID -> IO Propagator
initPropagator satid = fmap propagatorFromTLE (getTLE satid)

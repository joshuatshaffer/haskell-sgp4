
module Sgp4 where

import Sgp4.Raw
import Sgp4.IO
import Sgp4.Types

import System.IO.Unsafe (unsafePerformIO)

{------------------------------- Main Goals ---------------------------------}

initSgp4 :: Orbit -> ElsetrecPtr
initSgp4 (Sgp4Orbit e i _Ω ω n n' n'' m0 bStar epoch) =
  unsafePerformIO $ raw_sgp4init Wgs84 'i' 0 epoch bStar n' n'' e ω i m0 n _Ω

propagateSgp4 :: ElsetrecPtr -> Propagator
propagateSgp4 elsetrec t = unsafePerformIO $ do
  (isOk,r,v) <- raw_sgp4 elsetrec t
  return $ if isOk
            then Orbiting r v
            else Decayed

propagateTLE :: String -> String -> Propagator
propagateTLE l1 l2 = propagateSgp4 $ initSgp4 $ sgp4OrbitFromTLE $ parceTLE l1 l2

{------------------------------- Stretch Goals ------------------------------}

type URL = String

setTLESources :: [URL] -> IO ()
setTLESources = undefined

getTLESources :: IO [URL]
getTLESources = undefined

updateTLE :: IO () -- Download new TLEs
updateTLE = undefined

getTLE :: SatID -> IO TLE -- returns the most recent TLE on file
getTLE = undefined

initPropagator :: SatID -> IO Propagator
initPropagator = undefined

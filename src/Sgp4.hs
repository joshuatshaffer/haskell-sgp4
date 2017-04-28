
module Sgp4 where

{------------------------------- Main Goals ---------------------------------}

type Time = Double
type TLE = () -- undefined
type Position = (Double,Double,Double)
type Velocity = (Double,Double,Double)

data SatStatus = Orbiting Position Velocity | Decayed
type Propagator = Time -> SatStatus

propagatorFromTLE :: TLE -> Propagator
propagatorFromTLE = undefined

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

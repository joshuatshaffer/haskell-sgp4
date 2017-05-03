
module Sgp4.Types where

type Eccentricity = Double
type Inclination = Double
type RAAN = Double
type ArgPeriapsis = Double
type MeanAnomaly = Double
type MeanMotion = Double
type Epoch = Double
type BStar = Double

data Orbit = Sgp4Orbit Eccentricity Inclination RAAN ArgPeriapsis MeanMotion MeanMotion MeanMotion MeanAnomaly BStar Epoch
  deriving (Show)
--(Sgp4Orbit e i _Ω ω n n' n'' m0 bStar epoch)

data SatID = SatCatNum Int
           | SatName String
           | SatIntDes String
    deriving (Show)

data TLE = TLE Int Char String Int Double Double Double Double Int Int Double Double Double Double Double Double Int Int
  deriving (Show)
--(RawTLE satNum classification internationalDesignator epochYear epochDay meanMotionDt1 meanMotionDt2 bStar elementNum checksumL1 inclination raan eccentricity argOfPeri meanAnomaly meanMotion revolutionNumber checksumL2)

data Satellite = Sat SatID Orbit

type Time = Double
type Position = (Double,Double,Double)
type Velocity = (Double,Double,Double)

data SatStatus = Orbiting Position Velocity | Decayed deriving (Show)
type Propagator = Time -> SatStatus

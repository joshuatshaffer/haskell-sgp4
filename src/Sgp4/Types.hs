
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
  deriving (Show, Eq)
--(Sgp4Orbit e i _Ω ω n n' n'' m0 bStar epoch)

data SatID = SatCatNum Int
           | SatName String
           | SatIntDes String
    deriving (Show, Eq)

data Satellite = Sat SatID Orbit

type Time = Double
type Position = (Double,Double,Double)
type Velocity = (Double,Double,Double)

data SatStatus = Orbiting Position Velocity | Decayed Int deriving (Show, Eq)
type Propagator = Time -> SatStatus

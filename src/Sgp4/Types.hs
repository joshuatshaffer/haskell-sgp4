
module Sgp4.Types where

type Eccentricity = Double
type Inclination = Double
type RAAN = Double
type ArgPeriapsis = Double
type MeanAnomaly = Double
type MeanMotion = Double
type Epoch = Double
type BStar = Double

data SatID = SatCatNum Int
           | SatName String
           | SatIntDes String
    deriving (Show, Eq)

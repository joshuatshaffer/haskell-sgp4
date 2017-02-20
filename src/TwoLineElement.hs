module TwoLineElement (tlePatternLn1, tlePatternLn2, parceTLE) where

-- import Sgp4.Ext -- for several misc routines
import           Text.Regex.TDFA

angVelOfE = (2 * pi) / minPerDay -- rad / min
minPerDay = 24 * 60.0
deg2rad = (*) (pi/180)

data Satellite = Satellite
  {_satName                    :: String
  ,_satNumber                  :: Int
  ,_satClass                   :: Char
  ,_satInternationalDesignator :: String
  ,_satOrbit                   :: Orbit
  } deriving (Show, Eq)

data Orbit = Orbit
  {_epochYear        :: Int
  ,_epochDay         :: Double
  ,_eccentricity     :: Double  -- e
  ,_inclination      :: Double  -- i  -- radians
  ,_raan             :: Double  -- Ω  -- radians
  ,_argOfPeri        :: Double  -- ω  -- radians
  ,_meanMotion       :: Double  -- n  -- radians per minute
  ,_meanMotionDt1    :: Double
  ,_meanMotionDt2    :: Double
  ,_meanAnomaly      :: Double  -- M0 -- radians
  ,_bStar            :: Double  -- B* -- inverse earth radii
  ,_revolutionNumber :: Int
  } deriving (Show, Eq)

data TLE = TLE
  {_tleSatellite :: Satellite
  ,_elementNum   :: Int
  ,_checksumL1   :: Int
  ,_checksumL2   :: Int
  } deriving (Show, Eq)

-- "1 25544U 98067A   08264.51782528 -.00002182  00000-0 -11606-4 0  2927"
-- "2 25544  51.6416 247.4627 0006703 130.5360 325.0288 15.72125391563537"
-- 1 NNNNNC NNNNNAAA NNNNN.NNNNNNNN +.NNNNNNNN +NNNNN-N +NNNNN-N N NNNNN
-- 2 NNNNN NNN.NNNN NNN.NNNN NNNNNNN NNN.NNNN NNN.NNNN NN.NNNNNNNNNNNNNN

charClassAliases :: Char -> String
charClassAliases 'N' = "[0-9 ]"
charClassAliases 'C' = "[A-Z]"
charClassAliases 'A' = "[A-Z ]"
charClassAliases '+' = "[-+ ]"
charClassAliases '-' = "[-+]"
charClassAliases '.' = "\\."
charClassAliases x   = [x]

tlePatternLn1, tlePatternLn2 :: String
tlePatternLn1 = concatMap charClassAliases "1 (N{5})(C) (N{5}A{3}) (N{2})(N{3}.N{8}) (+.N{8}) (+N{5}-N) (+N{5}-N) 0 (N{4})(N)"
tlePatternLn2 = concatMap charClassAliases "2 (N{5}) (N{3}.N{4}) (N{3}.N{4}) (N{7}) (N{3}.N{4}) (N{3}.N{4}) (N{2}.N{8})(N{5})(N)"

parceTLE :: String -> String -> String -> TLE
parceTLE n ln1 ln2 = tle
  where
    tle = TLE
      {_tleSatellite = sat
      ,_elementNum = read $ l1m !! 8
      ,_checksumL1 = read $ l1m !! 9
      ,_checksumL2 = read $ l2m !! 8
      }
    sat = Satellite
      {_satName = n
      ,_satNumber = read $ head l1m
      ,_satClass = head $ l1m !! 1
      ,_satInternationalDesignator = l1m !! 2
      ,_satOrbit = orb
      }
    orb = Orbit
      {_epochYear = (\y -> if y < 57 then y + 2000 else y + 1900) . read $ l1m !! 3
      ,_epochDay = read $ l1m !! 4
      ,_eccentricity = read . ("0."++) $ l2m !! 3
      ,_inclination = deg2rad . read $ l2m !! 1
      ,_raan = deg2rad . read $ l2m !! 2
      ,_argOfPeri = deg2rad . read $ l2m !! 4
      ,_meanMotion = (*) angVelOfE . read $ l2m !! 6
      ,_meanMotionDt1 = (/) minPerDay . (*) angVelOfE . read . (\(x:xs)->x:'0':xs) $ l1m !! 5
      ,_meanMotionDt2 = (/) (minPerDay**2) . (*) angVelOfE . read . pudunk $ l1m !! 6
      ,_meanAnomaly = deg2rad . read $ l2m !! 5
      ,_bStar = read . pudunk $ l1m !! 7
      ,_revolutionNumber = read $ l2m !! 7
      }

    (_,_,_,l1m) = ln1 =~ tlePatternLn1 :: (String,String,String,[String])
    (_,_,_,l2m) = ln2 =~ tlePatternLn2 :: (String,String,String,[String])

    -- "-12345-6" -> "-0.12345e-6"
    pudunk :: String -> String
    pudunk s = head s : "0." ++ drop 1 (take 5 s) ++ "e" ++ drop 6 s

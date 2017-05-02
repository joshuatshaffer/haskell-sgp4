module Sgp4.IO where

import Text.Regex.TDFA

data TLE = TLE
  {satelliteNum :: Int
  ,classification :: Char
  ,internationalDesignator :: String
  ,epochYear :: Int
  ,epochDay :: Double
  ,meanMotionDt1 :: Double
  ,meanMotionDt2 :: Double
  ,bStar :: Double
  ,elementNum :: Int
  ,checksumL1 :: Int
  ,inclination :: Double
  ,raan :: Double
  ,eccentricity :: Double
  ,argOfPeri :: Double
  ,meanAnomaly :: Double
  ,meanMotion :: Double
  ,revolutionNumber :: Int
  ,checksumL2 :: Int
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
charClassAliases x = [x]

tlePatternLn1, tlePatternLn2 :: String
tlePatternLn1 = concatMap charClassAliases "1 (N{5})(C) (N{5}A{3}) (N{2})(N{3}.N{8}) (+.N{8}) (+N{5}-N) (+N{5}-N) 0 (N{4})(N)"
tlePatternLn2 = concatMap charClassAliases "2 (N{5}) (N{3}.N{4}) (N{3}.N{4}) (N{7}) (N{3}.N{4}) (N{3}.N{4}) (N{2}.N{8})(N{5})(N)"

parceTLE :: String -> String -> TLE
parceTLE ln1 ln2 = TLE
  satelliteNum classification internationalDesignator
  epochYear epochDay meanMotionDt1 meanMotionDt2 bStar
  elementNum checksumL1 inclination raan eccentricity
  argOfPeri meanAnomaly meanMotion revolutionNumber
  checksumL2
  where
    satelliteNum = read $ head l1m
    classification = head $ l1m !! 1
    internationalDesignator = l1m !! 2
    epochYear = (\x -> if x < 57 then x+2000 else x + 1900) . read $ l1m !! 3
    epochDay = read $ l1m !! 4
    meanMotionDt1 = (/(1440.0**2 / (2*pi))) . read . (\(x:xs)->x:'0':xs) $ l1m !! 5
    meanMotionDt2 = (/(1440.0**3 / (2*pi))) . read . pudunk $ l1m !! 6
    bStar = read . pudunk $ l1m !! 7
    elementNum = read $ l1m !! 8
    checksumL1 = read $ l1m !! 9
    inclination = (*) (pi / 180.0) . read $ l2m !! 1
    raan = (*) (pi / 180.0) . read $ l2m !! 2
    eccentricity = read . ("0."++) $ l2m !! 3
    argOfPeri = (*) (pi / 180.0) . read $ l2m !! 4
    meanAnomaly = (*) (pi / 180.0) . read $ l2m !! 5
    meanMotion = (/(1440.0 / (2*pi))) . read $ l2m !! 6
    revolutionNumber = read $ l2m !! 7
    checksumL2 = read $ l2m !! 8

    (_,_,_,l1m) = ln1 =~ tlePatternLn1 :: (String,String,String,[String])
    (_,_,_,l2m) = ln2 =~ tlePatternLn2 :: (String,String,String,[String])

    pudunk :: String -> String
    pudunk s = head s : "0." ++ drop 1 (take 5 s) ++ "e" ++ drop 6 s

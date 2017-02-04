module Sgp4.Io (twoline2rv, tlePatternLn1, tlePatternLn2) where

-- import Sgp4.Ext -- for several misc routines
import Sgp4.Unit (GravityConsts,Elsetrec,sgp4init)
import Text.Regex.Posix

{-
1 	01–01 	Line number 	1
2 	03–07 	Satellite number 	25544
3 	08–08 	Classification (U=Unclassified) 	U
4 	10–11 	International Designator (Last two digits of launch year) 	98
5 	12–14 	International Designator (Launch number of the year) 	067
6 	15–17 	International Designator (piece of the launch) 	A
7 	19–20 	Epoch Year (last two digits of year) 	08
8 	21–32 	Epoch (day of the year and fractional portion of the day) 	264.51782528
9 	34–43 	First Time Derivative of the Mean Motion divided by two [10] 	−.00002182
10 	45–52 	Second Time Derivative of Mean Motion divided by six (decimal point assumed) 	00000-0
11 	54–61 	BSTAR drag term (decimal point assumed) [10] 	-11606-4
12 	63–63 	The number 0 (originally this should have been "Ephemeris type") 	0
13 	65–68 	Element set number. Incremented when a new TLE is generated for this object.[10] 	292
14 	69–69 	Checksum (modulo 10) 	7

1 	01–01 	Line number 	2
2 	03–07 	Satellite number 	25544
3 	09–16 	Inclination (degrees) 	51.6416
4 	18–25 	Right ascension of the ascending node (degrees) 	247.4627
5 	27–33 	Eccentricity (decimal point assumed) 	0006703
6 	35–42 	Argument of perigee (degrees) 	130.5360
7 	44–51 	Mean Anomaly (degrees) 	325.0288
8 	53–63 	Mean Motion (revolutions per day) 	15.72125391
9 	64–68 	Revolution number at epoch (revolutions) 	56353
10 	69–69 	Checksum (modulo 10) 	7
-}

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


twoline2rv :: String -> String -> Char -> Char -> Char -> GravityConsts -> (Double,Double,Double, Elsetrec)
twoline2rv ln1 ln2 typerun typeinput opsmode whichconst = undefined

-- "1 25544U 98067A   08264.51782528 -.00002182  00000-0 -11606-4 0  2927"
-- "2 25544  51.6416 247.4627 0006703 130.5360 325.0288 15.72125391563537"
-- 1 NNNNNC NNNNNAAA NNNNN.NNNNNNNN +.NNNNNNNN +NNNNN-N +NNNNN-N N NNNNN
-- 2 NNNNN NNN.NNNN NNN.NNNN NNNNNNN NNN.NNNN NNN.NNNN NN.NNNNNNNNNNNNNN

charClassAliases :: Char -> String
charClassAliases 'N' = "[\\d ]"
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
parceTLE ln1 ln2 = undefined
  where
    (_,_,_,l1m) = ln1 =~ tlePatternLn1 :: (String,String,String,[String])
    (_,_,_,l2m) = ln2 =~ tlePatternLn2 :: (String,String,String,[String])

module Sgp4.IO where

import Text.Regex.TDFA
import Sgp4.Types

sgp4OrbitFromTLE :: TLE -> Orbit
sgp4OrbitFromTLE (TLE _ _ _ epochYear epochDay n' n'' bStar _ _ i _Ω e ω m0 n _ _) =
  (Sgp4Orbit e
             (i * pi / 180.0)
             (_Ω * pi / 180.0)
             (ω * pi / 180.0)
             (n * 2 * pi / 1440.0)
             (n' * 2 * pi / 1440.0**2)
             (n'' * 2 * pi / 1440.0**3)
             (m0 * pi / 180.0)
             (bStar)
             (jday epochYear (days2mdhms epochYear epochDay) - 2433281.5)
             )


days2mdhms :: Int -> Double -> (Int,Int,Int,Int,Double)
days2mdhms year days = (mon, day, hr, minute, sec)
  where
    lmonth :: [Int]
    lmonth = [0, 31, if (year `mod` 4) == 0 then 29 else 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

    (dayofyr,days') = properFraction days

    mownow = takeWhile (<dayofyr) $ scanl1 (+) lmonth
    mon = length mownow
    day = dayofyr - last mownow

    (hr, fhr) = properFraction (days' * 24.0)
    (minute, mhr) = properFraction (fhr * 60.0)
    sec = mhr * 60.0

fFloor :: (RealFrac a, Num b) => a -> b
fFloor = fromIntegral . floor

jday :: Int -> (Int,Int,Int,Int,Double) -> Double
jday year (mon, day, hr, minute, sec) = jd + jdFrac
  where
    fYear = fromIntegral year
    fMon = fromIntegral mon
    fDay = fromIntegral day
    fHr = fromIntegral hr
    fMinute = fromIntegral minute

    jd :: Double
    jd = 367.0 * fYear -
        fFloor ((7 * (fYear + fFloor ((fMon + 9) / 12.0))) * 0.25) +
        fFloor (275 * fMon / 9.0) +
        fDay + 1721013.5  -- use - 678987.0 to go to mjd directly
    jdFrac :: Double
    jdFrac = (sec + fMinute * 60.0 + fHr * 3600.0) / 86400.0

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
parceTLE ln1 ln2 = (TLE (read $ head l1m)
                       (head $ l1m !! 1)
                       (l1m !! 2)
                       ((\x -> if x < 57 then x+2000 else x + 1900) . read $ l1m !! 3)
                       (read $ l1m !! 4)
                       (read . (\(x:xs)->x:'0':xs) $ l1m !! 5)
                       (read . pudunk $ l1m !! 6)
                       (read . pudunk $ l1m !! 7)
                       (read $ l1m !! 8)
                       (read $ l1m !! 9)
                       (read $ l2m !! 1)
                       (read $ l2m !! 2)
                       (read . ("0."++) $ l2m !! 3)
                       (read $ l2m !! 4)
                       (read $ l2m !! 5)
                       (read $ l2m !! 6)
                       (read $ l2m !! 7)
                       (read $ l2m !! 8)
                           )
  where
    (_,_,_,l1m) = ln1 =~ tlePatternLn1 :: (String,String,String,[String])
    (_,_,_,l2m) = ln2 =~ tlePatternLn2 :: (String,String,String,[String])

    pudunk :: String -> String
    pudunk s = head s : "0." ++ drop 1 (take 5 s) ++ "e" ++ drop 6 s

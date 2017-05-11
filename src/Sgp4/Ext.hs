
module Sgp4.Ext (days2mdhms, jday) where

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

fFloor :: (RealFrac a) => a -> a
fFloor = fromIntegral .? floor
  where
    --constrain intermidiate type to Integer
    (.?) a b = a . (id :: Integer -> Integer) . b

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

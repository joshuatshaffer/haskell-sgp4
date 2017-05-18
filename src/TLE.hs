module TLE where

import Text.Regex.TDFA

data TLE = TLE Int Char String Int Double Double Double Double Int Int Double Double Double Double Double Double Int Int
  deriving (Show, Eq)
--(RawTLE satNum classification internationalDesignator epochYear epochDay meanMotionDt1 meanMotionDt2 bStar elementNum checksumL1 inclination raan eccentricity argOfPeri meanAnomaly meanMotion revolutionNumber checksumL2)

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
tlePatternLn1 = concatMap charClassAliases "1 (N{5})(C) (N{5}A{3}) (N{2})(N{3}.N{8}) (+.N{8}) (+N{5})(-N) (+N{5})(-N) 0 (N{4})(N)"
tlePatternLn2 = concatMap charClassAliases "2 (N{5}) (N{3}.N{4}) (N{3}.N{4}) (N{7}) (N{3}.N{4}) (N{3}.N{4}) (N{2}.N{8})(N{5})(N)"

parceTLE :: String -> String -> TLE
parceTLE ln1 ln2 = TLE (read $ head l1m)
                       (head $ l1m !! 1)
                       (l1m !! 2)
                       ((\x -> if x < 57 then x+2000 else x + 1900) . read $ l1m !! 3)
                       (read $ l1m !! 4)
                       (read . (\(x:xs)->x:'0':xs) $ l1m !! 5)
                       ((read . pudunk $ l1m !! 6) * 10.0 ** read (l1m !! 7))
                       ((read . pudunk $ l1m !! 8) * 10.0 ** read (l1m !! 9))
                       (read $ l1m !! 10)
                       (read $ l1m !! 11)
                       (read $ l2m !! 1)
                       (read $ l2m !! 2)
                       (read . ("0."++) $ l2m !! 3)
                       (read $ l2m !! 4)
                       (read $ l2m !! 5)
                       (read $ l2m !! 6)
                       (read $ l2m !! 7)
                       (read $ l2m !! 8)
  where
    (_,_,_,l1m) = ln1 =~ tlePatternLn1 :: (String,String,String,[String])
    (_,_,_,l2m) = ln2 =~ tlePatternLn2 :: (String,String,String,[String])

    pudunk :: String -> String
    pudunk s = head s : "0." ++ drop 1 s


import Sgp4.Types
import Sgp4
import Control.Arrow ((&&&))
import Text.Printf (printf)

type Ephemeris = [(Time, SatStatus)]

genEphemeris :: String -> String -> Ephemeris
genEphemeris ln1 ln2 = map (id &&& propagateTLE ln1 ln2) [(-1440),(-1430)..1440]

showEphemeris :: Ephemeris -> String
showEphemeris = unlines . map (\(t, Orbiting (r1,r2,r3) (v1,v2,v3)) -> printf (unwords $ replicate 7 "%.17e") t r1 r2 r3 v1 v2 v3)

readEphemeris :: String -> Ephemeris
readEphemeris = map (l2ei . map read . words) . lines
  where
    l2ei [t, r1, r2, r3, v1, v2, v3] = (t, Orbiting (r1,r2,r3) (v1,v2,v3))
    l2ei _ = error "All lines in ephemeris must have 7 doubles."

diffEphemeris :: Ephemeris -> Ephemeris -> Ephemeris
diffEphemeris = zipWith (\(t, Orbiting (r1,r2,r3) (v1,v2,v3)) (t', Orbiting (r1',r2',r3') (v1',v2',v3')) -> (t - t', Orbiting (r1 - r1', r2 - r2', r3 - r3') (v1 - v1', v2 - v2', v3 - v3')))

main :: IO ()
main = putStr $
  showEphemeris $
  genEphemeris "1 25544U 98067A   08264.51782528 -.00002182  00000-0 -11606-4 0  2927" "2 25544  51.6416 247.4627 0006703 130.5360 325.0288 15.72125391563537"


import Sgp4.IO
import Sgp4.Types
import Sgp4
import Control.Arrow ((&&&))

main :: IO ()
main = do
  let p = propagateTLE "1 25544U 98067A   08264.51782528 -.00002182  00000-0 -11606-4 0  2927" "2 25544  51.6416 247.4627 0006703 130.5360 325.0288 15.72125391563537"
  let s = unlines $
          map (\(t, Orbiting (r1,r2,r3) (v1,v2,v3)) ->
               show t ++ "   " ++
               show r1 ++ " " ++ show r2 ++ " " ++ show r3 ++ "   " ++
               show v1 ++ " " ++ show v2 ++ " " ++ show v3) $
          map (id &&& p) $ [0,10..1440]
  writeFile "test.txt" s

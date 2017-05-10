
import Sgp4.Types
import Sgp4
import Control.Arrow ((&&&))
import Text.Printf (printf)
import System.Process (runInteractiveCommand)
import System.IO (hGetContents)
import Control.Exception (catch, SomeException)

type Ephemeris = [(Time, SatStatus)]

genEphemeris :: String -> String -> Ephemeris
genEphemeris ln1 ln2 = map (id &&& propagateTLE ln1 ln2) [(-1440),(-1430)..1440]

showEphemeris :: Ephemeris -> String
showEphemeris = unlines . map wank
  where
    wank (t, Orbiting (r1,r2,r3) (v1,v2,v3)) = printf (unwords $ replicate 7 "%.17e") t r1 r2 r3 v1 v2 v3
    wank (t, s) = printf "%.17e" t ++ " " ++ show s

ephemeris2Matrix :: Ephemeris -> [[Double]]
ephemeris2Matrix = map (\(t, Orbiting (r1,r2,r3) (v1,v2,v3)) -> [t, r1, r2, r3, v1, v2, v3])

matrix2Ephemeris :: [[Double]] -> Ephemeris
matrix2Ephemeris = map l2ei
  where
    l2ei [t, r1, r2, r3, v1, v2, v3] = (t, Orbiting (r1,r2,r3) (v1,v2,v3))
    l2ei _ = error "All lines in ephemeris must have 7 doubles."

readEphemeris :: String -> Ephemeris
readEphemeris = matrix2Ephemeris . map (map read . words) . lines

diffEphemeris :: Ephemeris -> Ephemeris -> Ephemeris
diffEphemeris = zipWith (\(t, Orbiting (r1,r2,r3) (v1,v2,v3)) (t', Orbiting (r1',r2',r3') (v1',v2',v3')) -> (t - t', Orbiting (r1 - r1', r2 - r2', r3 - r3') (v1 - v1', v2 - v2', v3 - v3')))

readVerTLE :: String -> [(String,String)]
readVerTLE = wank . map (take 69) . filter ((/=) '#' . head) . lines
  where
    wank (a:b:xs) = (a,b):wank xs
    wank _ = []

diffEphe :: (String, String) -> IO ()
diffEphe (ln1,ln2) = do
  let e = genEphemeris ln1 ln2
  (_,outH,_,_) <- runInteractiveCommand ("./test-stuff/a.out " ++ show ln1 ++ " " ++ show ln2)
  e' <- fmap readEphemeris $ hGetContents outH
  let de = diffEphemeris e e'
  putStr $ showEphemeris e
  print . (maximum . map maximum) . ephemeris2Matrix $ de

main :: IO ()
main = do
    s <- readFile "test-stuff/SGP4-VER.TLE"
    mapM_ (\x -> catch (diffEphe x) handler) $ readVerTLE s
  where
    handler :: SomeException -> IO ()
    handler ex = putStrLn $ "Caught exception: " ++ show ex

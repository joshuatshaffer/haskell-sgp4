module Tests where
import AnomalyConversions

--testFuncInv :: (Num a, Ord a) => a -> (a -> b) -> (b -> a) -> a -> Bool
--testFuncInv tolr f g = (\x -> abs x <= tolr) . (\x -> x - (g . f) x)
ecs :: [Double]
ecs = [0,0.01..0.99]
ans :: [Double]
ans = [(-pi),(0.01-pi)..(pi-0.01)]

testErr f invf x = abs $ x - (invf . f) x

errs f invf = map (\x -> if x > pi then 2*pi-x else x) $ concatMap (\ec -> map (testErr (invf ec) (f ec)) ans) ecs

doTests :: IO ()
doTests = do
    putStrLn "M->E->M"
    putStr "max error = "
    print $ maximum mem

    putStrLn "E->M->E"
    putStr "max error = "
    print $ maximum eme

    putStrLn "E->T->E"
    putStr "max error = "
    print $ maximum ete

    putStrLn "T->E->T"
    putStr "max error = "
    print $ maximum tet

    putStrLn "M->T->M"
    putStr "max error = "
    print $ maximum mtm

    putStrLn "T->M->T"
    putStr "max error = "
    print $ maximum tmt
  where
    mem = errs meAn2EcAn ecAn2MeAn
    eme = errs ecAn2MeAn meAn2EcAn
    ete = errs ecAn2TrueAn trueAn2EcAn
    tet = errs trueAn2EcAn ecAn2TrueAn
    mtm = errs meAn2TrueAn trueAn2MeAn
    tmt = errs trueAn2MeAn meAn2TrueAn
{-
testAnomalyConversions ec an =
  [testFuncInv 1e-6 (meAn2EcAn ec)   (ecAn2MeAn ec)   an
  ,testFuncInv 1e-6 (ecAn2MeAn ec)   (meAn2EcAn ec)   an
  ,testFuncInv 1e-6 (ecAn2TrueAn ec) (trueAn2EcAn ec) an
  ,testFuncInv 1e-6 (trueAn2EcAn ec) (ecAn2TrueAn ec) an
  ,testFuncInv 1e-6 (meAn2TrueAn ec) (trueAn2MeAn ec) an
  ,testFuncInv 1e-6 (trueAn2MeAn ec) (meAn2TrueAn ec) an
  ]
tests :: IO [Test]
-}

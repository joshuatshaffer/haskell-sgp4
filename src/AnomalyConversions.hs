-- Originally for MATLAB by Luis Baars
-- Translated to Haskell by Joshua Shaffer

module AnomalyConversions
    (meAn2EcAn, ecAn2TrueAn
    ,trueAn2EcAn, ecAn2MeAn
    ,meAn2TrueAn, trueAn2MeAn
    ) where
import CommonMath (loopToRange)

meAn2EcAn :: RealFloat a => a -> a -> a
meAn2EcAn ec meAn = foo e
  where
    meAn' = loopToRange (-pi) pi meAn
    e = if (meAn' > -pi && meAn' < 0) || (meAn' > pi)
         then meAn' - ec
         else meAn' + ec
    foo oldE = finalE
      where newE = oldE + (meAn' - oldE + ec * sin oldE) / (1 - ec * cos oldE)
            finalE = if abs (newE - oldE) > 1e-6
                      then foo newE
                      else newE

ecAn2TrueAn :: RealFloat a => a -> a -> a
ecAn2TrueAn ec ecAn =
  atan2 (sin ecAn * sqrt (1 - ec**2) / x)
        ((cos ecAn - ec) / x)
  where x = 1 - ec * cos ecAn

trueAn2EcAn :: RealFloat a => a -> a -> a
trueAn2EcAn ec trueAn =
  atan2 (sin trueAn * sqrt (1 - ec**2) / x)
        ((ec + cos trueAn ) / x)
  where x = 1 + ec * cos trueAn

ecAn2MeAn :: RealFloat a => a -> a -> a
ecAn2MeAn ec ecAn = ecAn - ec * sin ecAn

meAn2TrueAn :: RealFloat a => a -> a -> a
meAn2TrueAn ec = ecAn2TrueAn ec . meAn2EcAn ec

trueAn2MeAn :: RealFloat a => a -> a -> a
trueAn2MeAn ec = ecAn2MeAn ec . trueAn2EcAn ec

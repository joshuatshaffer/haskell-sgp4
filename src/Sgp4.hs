module Sgp4 where

data SGP4Error = SGP4Error1 | SGP4Error2 | SGP4Error3 | SGP4Error4 | SGP4Error5 | SGP4Error6

instance Show SGP4Error where
  show SGP4Error1 = "mean elements, ecc >= 1.0 or ecc < -0.001 or a < 0.95"
  show SGP4Error2 = "mean motion less than 0.0"
  show SGP4Error3 = "pert elements, ecc < 0.0  or  ecc > 1.0"
  show SGP4Error4 = "semi-latus rectum < 0.0"
  show SGP4Error5 = "epoch elements are sub-orbital"
  show SGP4Error6 = "satellite has decayed"

parceTLE :: String -> String -> TLE
parceTLE = undefined

sgp4init :: TLE -> Either SGP4Error Elsetrec
sgp4init = undefined

sgp4 :: Elsetrec -> Time -> Either SGP4Error (Position, Velocity, Elsetrec)
sgp4 = undefined

module Io (twoline2rv) where

-- import Sgp4.Ext -- for several misc routines
import Sgp4.Unit (GravityConsts,Elsetrec,sgp4init)

twoline2rv :: String -> String -> Char -> Char -> Char -> GravityConsts -> (Double,Double,Double, Elsetrec)
twoline2rv ln1 ln2 typerun typeinput opsmode whichconst = undefined

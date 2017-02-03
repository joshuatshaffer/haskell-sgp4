--{-# LANGUAGE ForeignFunctionInterface, CPP #-}

module Sgp4 (initOrbit, propagate, mult) where

import           Foreign.C
import           Foreign.C.Types

#include "c-wrapper/wrapper.h"

--mult :: Int -> Int -> Int
{#fun pure mult as c_mult {`Int', `Int'} -> `Int'#}
mult = c_mult

-- Initialise data for SGP4 from a two-line element.
--initOrbit :: String -> String -> Elsetrec
initOrbit = undefined

-- Estimate position and velocity of the satellite at a given time.
--propagate :: Elsetrec -> Int -> Int -> Int -> Int -> Int -> Double -> (((Double,Double,Double),(Double,Double,Double)),Elsetrec)
propagate = undefined

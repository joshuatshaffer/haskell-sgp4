{-# LANGUAGE ForeignFunctionInterface #-}
module Sgp4 (propogate) where

import Foreign.C

foreign import ccall "wrapper.h propagateOrbit" c_propagate :: Int -> Int -> Int -> Int -> Int -> Double -> Double

-- estimate position and velocity of the satellite at a given time
propogate :: Int -> Int -> Int -> Int -> Int -> Double -> Double
propogate = c_propagate

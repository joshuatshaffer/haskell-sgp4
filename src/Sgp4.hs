{-# LANGUAGE ForeignFunctionInterface #-}
module Sgp4 (initOrbit, propogate) where

import Foreign.C
data Elsetrec
data PropagateTuple = PropagateTuple {r :: [CDouble]
                                     ,v :: [CDouble]
                                     ,satrec :: Elsetrec
                                     }

foreign import ccall "wrapper.h initOrbit" c_initOrbit :: CString -> CString -> Elsetrec
foreign import ccall "wrapper.h propagateOrbit" c_propagate :: Elsetrec -> CInt -> CInt -> CInt -> CInt -> CInt -> CDouble -> PropagateTuple

-- use a two line element to init orbit data for sgp4
initOrbit :: String -> String -> Elsetrec
initOrbit line1 line2 = undefined

-- estimate position and velocity of the satellite at a given time
propogate :: Elsetrec -> Int -> Int -> Int -> Int -> Int -> Double -> (((Double,Double,Double),(Double,Double,Double)), Elsetrec)
propogate satrec year month day hour minute second = undefined

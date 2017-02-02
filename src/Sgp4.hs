{-# LANGUAGE ForeignFunctionInterface, CPP #-}

module Sgp4 (initOrbit, propagate, mult) where

import           Foreign.C
import           Foreign.C.Types

data Elsetrec = Elsetrec
  {satnum :: CLong -- long int
  ,epochyr, epochtynumrev :: Int
  ,error :: Int
  ,operationmode :: Char
  ,init, method :: Char

  -- Near Earth
  ,isimp :: CInt
  ,aycof  , con41  , cc1    , cc4      , cc5    , d2      , d3   , d4    :: CDouble
  ,delmo  , eta    , argpdot, omgcof   , sinmao , t       , t2cof, t3cof :: CDouble
  ,t4cof  , t5cof  , x1mth2 , x7thm1   , mdot   , nodedot, xlcof , xmcof :: CDouble
  ,nodecf :: CDouble

  -- Deep Space
  ,irez :: CInt
  ,d2201  , d2211  , d3210  , d3222    , d4410  , d4422   , d5220 , d5232 :: CDouble
  ,d5421  , d5433  , dedt   , del1     , del2   , del3    , didt  , dmdt  :: CDouble
  ,dnodt  , domdt  , e3     , ee2      , peo    , pgho    , pho   , pinco :: CDouble
  ,plo    , se2    , se3    , sgh2     , sgh3   , sgh4    , sh2   , sh3   :: CDouble
  ,si2    , si3    , sl2    , sl3      , sl4    , gsto    , xfact , xgh2  :: CDouble
  ,xgh3   , xgh4   , xh2    , xh3      , xi2    , xi3     , xl2   , xl3   :: CDouble
  ,xl4    , xlamo  , zmol   , zmos     , atime  , xli     , xni           :: CDouble

  ,a      , altp   , alta   , epochdays, jdsatepoch       , nddot , ndot :: CDouble
  ,bstar  , rcse   , inclo  , nodeo    , ecco             , argpo , mo   :: CDouble
  ,no :: CDouble
  }

data PropagateTuple = PropagateTuple
  {rx,ry,rz :: CDouble
  ,vx,vy,vz :: CDouble
  ,satrec   :: Elsetrec
  }

--foreign import ccall "wrapper.h initOrbit" c_initOrbid :: CString -> CString -> Elsetrec
--foreign import ccall "wrapper.h propagateOrbit" c_propagate :: Elsetrec -> Int -> Int -> Int -> Int -> Int -> Double -> PropagateTuple

foreign import ccall "wrapper.h mult" c_mult :: CInt -> CInt -> CInt
--mult :: Int -> Int -> Int
mult = c_mult


initOrbit :: String -> String -> Elsetrec
initOrbit = undefined

-- estimate position and velocity of the satellite at a given time
propagate :: Elsetrec -> Int -> Int -> Int -> Int -> Int -> Double -> (((Double,Double,Double),(Double,Double,Double)),Elsetrec)
propagate = undefined
--propagate satrec y mo d h mi s = (((rx, ry, rz),(vx, vy, vz)), satrec)
--  where
--    (PropagateTuple rx ry rz vx vy vz satrec) = c_propagate satrec y mo d h mi s

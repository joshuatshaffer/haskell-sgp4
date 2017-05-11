{-# LANGUAGE CPP #-}

module Sgp4.Raw where

import Sgp4.Types
import Foreign.Ptr (Ptr,FunPtr)
import Foreign.C.Types
import Control.Applicative ((<$>))
import Foreign.Marshal.Array (peekArray,mallocArray)
import System.IO.Unsafe (unsafePerformIO)
import Foreign.ForeignPtr

#include "SGP4.h"

{#enum gravconsttype as Gravconst {underscoreToCase} deriving (Show, Eq) #}

type Elsetrec = ForeignPtr Elsetrec'

data Elsetrec'
{#pointer *elsetrec as ElsetrecPtr -> Elsetrec' #}

{# fun SGP4Funcs_sgp4init as raw_sgp4init { `Gravconst',`Char',`Int',`Double',`Double',`Double',`Double',`Double',`Double',`Double',`Double',`Double',`Double'} -> `ElsetrecPtr' #}
{# fun SGP4Funcs_sgp4 as raw_sgp4' { `ElsetrecPtr',`Double',id `Ptr C2HSImp.CDouble',id `Ptr C2HSImp.CDouble'} -> `Bool' #}
{# fun pure SGP4Funcs_gstime as gsTime { `Double'} -> `Double' #}

raw_sgp4 :: ElsetrecPtr -> Time -> IO (Bool,Int,Position,Velocity)
raw_sgp4 elsetrec t =
  do r <- mallocArray 3 :: IO (Ptr CDouble)
     v <- mallocArray 3 :: IO (Ptr CDouble)
     isOk <- raw_sgp4' elsetrec t r v
     err <- {#get elsetrec->error #} elsetrec
     r' <- map cDoubleConv <$> peekArray 3 r
     v' <- map cDoubleConv <$> peekArray 3 v
     return (isOk, cIntConv err, (head r', r' !! 1, r' !! 2), (head v', v' !! 1, v' !! 2))

cDoubleConv :: CDouble -> Double
cDoubleConv (CDouble x) = x

cIntConv :: CInt -> Int
cIntConv (CInt x) = fromIntegral x

foreign import ccall "stdlib.h &free"
  p_free :: FunPtr (Ptr a -> IO ())

initSgp4 :: Orbit -> Elsetrec
initSgp4 (Sgp4Orbit e i _Ω ω n n' n'' m0 bStar epoch) =
    unsafePerformIO $ raw_sgp4init Wgs84 'i' 0 epoch bStar n' n'' e ω i m0 n _Ω >>= newForeignPtr p_free

propagateSgp4 :: Elsetrec -> Propagator
propagateSgp4 elsetrec' t = unsafePerformIO $ withForeignPtr elsetrec' bod
  where bod elsetrec = do (isOk,err,r,v) <- raw_sgp4 elsetrec t
                          return $ if isOk
                                    then Orbiting r v
                                    else Decayed err

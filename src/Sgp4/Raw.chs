{-# LANGUAGE CPP #-}

module Sgp4.Raw (Elsetrec
                ,Gravconst (Wgs72old, Wgs72, Wgs84)
                ,sgp4init
                ,sgp4
                ,p_free
                ) where

import Foreign.Ptr (Ptr,FunPtr)
import Foreign.C.Types (CDouble)
import Control.Applicative ((<$>))
import Foreign.Marshal.Array (peekArray,allocaArray)
import Foreign.ForeignPtr (ForeignPtr)

#include "SGP4.h"

{#enum gravconst_t as Gravconst {underscoreToCase} deriving (Show, Eq) #}

type Elsetrec = ForeignPtr Elsetrec'

data Elsetrec'
{#pointer *elsetrec_t as ElsetrecPtr -> Elsetrec' #}

{# fun SGP4Funcs_sgp4init as sgp4init { `Gravconst',`Char',`Int',`Double',`Double',`Double',`Double',`Double',`Double',`Double',`Double',`Double',`Double'} -> `ElsetrecPtr' #}
{# fun SGP4Funcs_sgp4 as sgp4' { `ElsetrecPtr',`Double',id `Ptr C2HSImp.CDouble',id `Ptr C2HSImp.CDouble'} -> `Bool' #}

sgp4 :: ElsetrecPtr -> Double -> IO (Bool,Int,(Double,Double,Double),(Double,Double,Double))
sgp4 elsetrec t = allocaArray 3 (\r -> allocaArray 3 (\v -> foo r v))
  where
    foo r v = do isOk <- sgp4' elsetrec t r v
                 err <- {#get elsetrec_t->error #} elsetrec
                 r' <- toTuple r
                 v' <- toTuple v
                 return (isOk, fromIntegral err, r', v')
    toTuple :: Ptr CDouble -> IO (Double,Double,Double)
    toTuple p = (map realToFrac <$> peekArray 3 p) >>= (\[a,b,c]->return (a,b,c))

foreign import ccall "stdlib.h &free"
  p_free :: FunPtr (Ptr a -> IO ())

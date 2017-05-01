{-# LANGUAGE CPP #-}

module Sgp4.Raw where

#include "wrapper.h"
#include "SGP4.h"

{#enum gravconsttype as Gravconst {underscoreToCase} deriving (Show, Eq) #}


{# fun pure c_times_2 as ^ { `Int'} -> `Int' #}
{# fun pure c_add as ^ { `Int',`Int'} -> `Int' #}

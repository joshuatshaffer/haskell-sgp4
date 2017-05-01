{-# LANGUAGE CPP #-}

module Sgp4.Raw where

#include "wrapper.h"

{# fun pure c_times_2 as ^ { `Int'} -> `Int' #}
{# fun pure c_add as ^ { `Int',`Int'} -> `Int' #}

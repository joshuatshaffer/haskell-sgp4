{-# LANGUAGE CPP #-}

module Sgp4.Raw where

#include "wrapper.h"

{# fun pure c_times_2 as ^ { `Int'} -> `Int' #}

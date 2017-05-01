{-# LANGUAGE CPP #-}

module Sgp4.Raw where

#include "wrapper.h"
#include "SGP4.h"

{#enum gravconsttype as Gravconst {underscoreToCase} deriving (Show, Eq) #}

data Elsetrec
{#pointer *elsetrec as ElsetrecPtr -> Elsetrec #}

{-
bool SGP4Funcs_sgp4init (enum gravconsttype whichconst, char opsmode,
                         const int satn, const double epoch,
                         const double xbstar, const double xndot,
                         const double xnddot, const double xecco,
                         const double xargpo, const double xinclo,
                         const double xmo, const double xno,
                         const double xnodeo, struct elsetrec *satrec);

bool SGP4Funcs_sgp4 (
    // no longer need gravconsttype whichconst, all data contained in satrec
    struct elsetrec *satrec, double tsince, double r[3], double v[3]);
-}

{# fun SGP4Funcs_sgp4init as raw_sgp4init { `Gravconst',`Char',`Int',`Double',`Double',`Double',`Double',`Double',`Double',`Double',`Double',`Double',`Double',`ElsetrecPtr'} -> `Bool' #}
--{# fun SGP4Funcs_sgp4init as raw_sgp4 { `ElsetrecPtr',`Double',`Ptr Double',`Ptr Double'} -> `Bool' #}
{# fun pure SGP4Funcs_gstime as gsTime { `Double'} -> `Double' #}
{# fun pure c_times_2 as ^ { `Int'} -> `Int' #}
{# fun pure c_add as ^ { `Int',`Int'} -> `Int' #}

module CommonMath
    (deg2rad
    ,loopToRange
    ) where

deg2rad :: RealFloat a => a -> a
deg2rad = (*) (pi / 180)

loopToRange :: Real a => a -> a -> a -> a
loopToRange l u x | x < l  = loopToRange l u (x + r)
                  | x >= u = loopToRange l u (x - r)
                  | otherwise = x
                  where r = u - l

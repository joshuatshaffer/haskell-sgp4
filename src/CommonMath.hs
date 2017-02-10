module CommonMath
    (deg2rad
    ,loopToRange
    ,newtonsMethod
    ) where

deg2rad :: RealFloat a => a -> a
deg2rad = (*) (pi / 180)

loopToRange :: Real a => a -> a -> a -> a
loopToRange l u x | x < l  = loopToRange l u (x + r)
                  | x >= u = loopToRange l u (x - r)
                  | otherwise = x
                  where r = u - l

newtonsMethod :: (RealFrac a) => (a -> a) -> (a -> a) -> a -> a -> a
newtonsMethod f f' x0 tol = until isCloseEnough nextX x0
  where nextX x = x - f x / f' x
        isCloseEnough x = abs (f x) <= tol

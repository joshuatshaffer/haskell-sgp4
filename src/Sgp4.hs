{-# LANGUAGE TemplateHaskell #-}

module Sgp4 where
import Control.Lens

-- line :: LocVars -> LocVars
-- expr :: LocVars -> value
-- opper :: expr -> expr -> expr
-- assign :: expr -> var -> line

data Point = Point {_x :: Double, _y :: Double} deriving (Show, Eq)

makeLenses ''Point

va v l = view v l
li a _ = a

(.+) a b l = a l + b l
(.-) a b l = a l - b l
(.*) a b l = a l * b l
(./) a b l = a l / b l
(.=) v e l = set v (e l)

(.:) :: (a -> a) -> (a -> a) -> (a -> a)
(.:) = flip (.)

testPoint = set x 2 . set y 3 $ Point 0 0

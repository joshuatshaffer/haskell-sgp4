module Ext
    (sgn
    ,mag
    ,cross
    ,dot
    ,angle
    ,newtonnu
    ,asinh
    ,rv2coe
    ,jday
    ,days2mdhms
    ,invjday
    ) where

type Vector3 = (Double,Double,Double)

sgn :: Double -> Double
sgn = undefined

mag :: Vector3 -> Double
mag = undefined

cross :: Vector3 -> Vector3 -> Vector3
cross = undefined

dot :: Vector3 -> Vector3 -> Double
dot = undefined

angle :: Vector3 -> Vector3 -> Double
angle = undefined

newtonnu :: Double -> Double -> (Double,Double)
newtonnu = undefined

rv2coe :: Vector3 -> Vector3 -> Double -> (Double,Double,Double,Double,Double,Double,Double,Double,Double,Double,Double)
rv2coe = undefined

jday :: Int -> Int -> Int -> Int -> Int -> Double -> Double
jday = undefined

days2mdhms :: Int -> Double -> (Int,Int,Int,Int,Double)
days2mdhms = undefined

invjday :: Double -> (Int,Int,Int, Int,Int,Double)
invjday = undefined

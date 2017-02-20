module Castor where
import CommonMath (deg2rad, loopToRange)
import AnomalyConversions (meAn2TrueAn)

-- Simple orbit propagation as outlined by http://www.castor2.ca/04_Propagation/index.html
propagate :: Double -> Double -> Double -> Double -> Double -> Double -> Double -> Double -> Double
propagate t0 incl raan ec argPeri meAn0 meMo t = undefined
  where
    -- Step 2
    deltaT = t - t0

    -- Step 3
    meAnT = deg2rad . loopToRange 0 360 $ meAn0 + meMo*deltaT

    -- Step 4
    trueAn = meAn2TrueAn ec meAnT

    -- Step 5
    semiAxis = undefined -- a = [ m / (2pn)2 ] 1/3
    periDist = semiAxis * (1 - ec)

    -- Step 6
    satGeocentricDistance = ( periDist * (1+ec) ) / ( 1 + ec*cos trueAn)

    -- Step 7\
    radiusEarth, a1, j2, d1, a0, p0 :: Double
    radiusEarth = undefined
    a1 = semiAxis / 6378.135 -- convert from km to earth radii
    j2 = 1.0826267e-3 -- Second gravitational zonal harmonic of the Earth
    d1 = (3 * j2 * radiusEarth**2 * (3 * (cos incl)**2 - 1)) / (4 * a1**2 * (1 - ec**2)**(3/2))
    a0 = -a1 * ((134/81) * d1**3 + d1**2 + d1/3 - 1)
    p0 = a0*(1 - ec**2)

    deltaRaan = 360 * (-3 * j2 * radiusEarth**2 * meMo * deltaT * (cos incl) / (2 * p0**2)) -- 360o [ -3J2RE2nDtcosi / 2po2 ]
    raanT = raan + deltaRaan

    deltaArgPeri = 360 * (3 * j2 * radiusEarth**2 * meMo * deltaT * (5 * (cos incl)**2 - 1) / (4 * p0**2)) -- 360o [ 3J2RE2nDt (5cos2i - 1) / 4po2 ]
    argPeriT = argPeri + deltaArgPeri

    -- Step 8
    -- Step 9
    -- Step 10
    -- Step 11
    -- Step 12
    -- Step 13
    -- Step 14
    -- Step 15

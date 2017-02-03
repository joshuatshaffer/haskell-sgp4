module Unit
    (sgp4Version
    ,GravityConsts
    ,wgs72old, wgs72, wgs84
    ,Elsetrec
    ,sgp4init
    ,sgp4
    ,gstime
    ) where

sgp4Version :: String
sgp4Version = "SGP4 Version 2011-12-30"

-- define pi 3.14159265358979323846

-------------------------- structure declarations ----------------------------
data GravityConsts = GravityConsts
  {_tumin, _mu, _radiusearthkm, _xke, _j2, _j3, _j4, _j3oj2 :: Double}

data Elsetrec = Elsetrec
  {_satnum :: Integer -- long int in c++
  ,_epochyr, _epochtynumrev :: Int
  ,_error :: Int
  ,_operationmode :: Char
  ,_init, _method :: Char

  -- Near Earth --
  ,_isimp :: Int
  ,_aycof  , _con41  , _cc1    , _cc4      , _cc5    , _d2      , _d3   , _d4    :: Double
  ,_delmo  , _eta    , _argpdot, _omgcof   , _sinmao , _t       , _t2cof, _t3cof :: Double
  ,_t4cof  , _t5cof  , _x1mth2 , _x7thm1   , _mdot   , _nodedot, _xlcof , _xmcof :: Double
  ,_nodecf :: Double

  -- Deep Space --
  ,_irez :: Int
  ,_d2201  , _d2211  , _d3210  , _d3222    , _d4410  , _d4422   , _d5220 , _d5232 :: Double
  ,_d5421  , _d5433  , _dedt   , _del1     , _del2   , _del3    , _didt  , _dmdt  :: Double
  ,_dnodt  , _domdt  , _e3     , _ee2      , _peo    , _pgho    , _pho   , _pinco :: Double
  ,_plo    , _se2    , _se3    , _sgh2     , _sgh3   , _sgh4    , _sh2   , _sh3   :: Double
  ,_si2    , _si3    , _sl2    , _sl3      , _sl4    , _gsto    , _xfact , _xgh2  :: Double
  ,_xgh3   , _xgh4   , _xh2    , _xh3      , _xi2    , _xi3     , _xl2   , _xl3   :: Double
  ,_xl4    , _xlamo  , _zmol   , _zmos     , _atime  , _xli     , _xni            :: Double

  ,_a      , _altp   , _alta   , _epochdays, _jdsatepoch        , _nddot , _ndot  :: Double
  ,_bstar  , _rcse   , _inclo  , _nodeo    , _ecco              , _argpo , _mo    :: Double
  ,_no :: Double
  } deriving (Show, Eq)


--------------------------- function declarations ----------------------------
sgp4init :: GravityConsts -> Char -> Int -> Double -> Double -> Double -> Double -> Double -> Double -> Double -> Double -> Elsetrec -> Bool
sgp4init whichconst opsmode satn epoch xbstar xecco xargpo xinclo xmo xno xnodeo = undefined

sgp4 :: GravityConsts -> Elsetrec -> Double -> (((Double,Double,Double),(Double,Double,Double)),Elsetrec,Bool)
sgp4 whichconst satrec tsince = undefined


loopToRange :: (Num a, Ord a) => a -> a -> a -> a
loopToRange l u x | x >= u = loopToRange l u (x - r)
                  | x < l  = loopToRange l u (x + r)
                  | otherwise = x
                where r = u - l


gstime :: Double -> Double
gstime jdut1 = loopToRange b 0 (2*pi)
  where
    tut1 = (jdut1 - 2451545.0) / 36525.0
    a = -6.2e-6  * tut1**3 +
        0.093104 * tut1**2 +
        (876600.0*3600 + 8640184.812866) * tut1 +
        67310.54841 -- sec
    b = a * (pi / 180.0) / 240.0 --360/86400 = 1/240, to deg, to rad


wgs72old, wgs72, wgs84 :: GravityConsts
wgs72old = GravityConsts tumin mu radiusearthkm xke j2 j3 j4 j3oj2
  where
    mu     = 398600.79964;        -- in km^3 / s^2
    radiusearthkm = 6378.135;     -- km
    xke    = 0.0743669161;
    tumin  = 1.0 / xke;
    j2     =   0.001082616;
    j3     =  -0.00000253881;
    j4     =  -0.00000165597;
    j3oj2  =  j3 / j2;

wgs72 = GravityConsts tumin mu radiusearthkm xke j2 j3 j4 j3oj2
  where
    mu     = 398600.8;            -- in km^3 / s^2
    radiusearthkm = 6378.135;     -- km
    xke    = 60.0 / sqrt(radiusearthkm*radiusearthkm*radiusearthkm/mu);
    tumin  = 1.0 / xke;
    j2     =   0.001082616;
    j3     =  -0.00000253881;
    j4     =  -0.00000165597;
    j3oj2  =  j3 / j2;

wgs84 = GravityConsts tumin mu radiusearthkm xke j2 j3 j4 j3oj2
  where
    mu     = 398600.5;            -- in km^3 / s^2
    radiusearthkm = 6378.137;     -- km
    xke    = 60.0 / sqrt(radiusearthkm*radiusearthkm*radiusearthkm/mu);
    tumin  = 1.0 / xke;
    j2     =   0.00108262998905;
    j3     =  -0.00000253215306;
    j4     =  -0.00000161098761;
    j3oj2  =  j3 / j2;

module Units where
  -- to define 5 kilometers a day you should write "5 * (kilo * meter / day)"


  -- Prefixes
  exa = 10e18
  peta = 10e15
  tera = 10e12
  giga = 10e9
  mega = 10e6
  kilo = 10e3
  hecto = 10e2
  deca = 10e1

  deci = 10e-1
  centi = 10e-2
  milli = 10e-3
  micro = 10e-6
  nano = 10e-9
  pico = 10e-12
  femto = 10e-15
  atto = 10e-18

  -- Length
  meter = 1/1000

  -- Time
  second = 1
  minute = 60 * second
  hour = 60 * minute
  day = 24 * hour

  hertz = 1 / second

  -- Mass
  gram = 1/1000

  -- Angle
  radian = 1
  degree = (pi / 180) * radian

  -- Force
  newton = kilo * gram * meter / second**2

  -- Energy
  joule = newton * meter

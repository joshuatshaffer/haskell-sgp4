## This program is free software; you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 2 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with Octave; see the file COPYING.  If not, see
## <http://www.gnu.org/licenses/>.

## TrueToEccenAnomaly - Converts true anomaly to eccentric anomaly
##
## Inputs:
##   e = eccentricty
##   f = true anomaly (rad)
## Outputs:
##   E = eccentric anomaly (rad)

## Author: Luis Baars <orbitnerd@gmail.com>
## Created: 2012-02-14

function [ E ] = TrueToEccenAnomaly (e, f)
  if (e >= 1.0)
    error("TrueToEccenAnomaly does not support parabolic or hyperbolic orbits!")
  endif

  ## Calc the eccentric anomaly
  sinE = sin(f)*sqrt(1 - e^2)/(1 + e * cos(f));
  cosE = (e + cos(f))/(1 + e * cos(f));
  E = atan2(sinE, cosE);
endfunction

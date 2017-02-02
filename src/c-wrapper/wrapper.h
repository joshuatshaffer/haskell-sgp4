#ifndef _wrapper_
#define _wrapper_


#include "sgp4unit.h"
#ifdef __cplusplus
extern "C" {
#endif

int mult (int a, int b);

typedef struct {
    double rx, ry, rz, vx, vy, vz;
    elsetrec satrec;
} propagateTuple;

elsetrec initOrbit (char* line1, char* line2);

propagateTuple propagateOrbit (  const elsetrec satrec,
                                 const int year, const int month, const int day,
                                 const int hour, const int minute, const double second
                                 );


#ifdef __cplusplus
}
#endif

#endif

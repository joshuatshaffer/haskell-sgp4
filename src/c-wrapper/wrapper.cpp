#include "wrapper.h"

#include "sgp4ext.h"
#include "sgp4io.h"
#include "sgp4unit.h"
#define minutes_per_day 1440

elsetrec initOrbit (char* line1, char* line2) {
    char longstr1[130], longstr2[130];
    elsetrec satrec;
    double startmfe, stopmfe, deltamin;
    startmfe = stopmfe = deltamin = 0.0;
    gravconsttype whichconst = wgs72;
    twoline2rv (longstr1, longstr2,
                'c', ' ', 'i',
                whichconst,
                startmfe, stopmfe, deltamin,
                satrec
                );
    return satrec;
}

propagateTuple propagateOrbit ( elsetrec satrec,
                                const int year, const int month, const int day,
                                const int hour, const int minute, const double second
                                )
{
    //Return a position and velocity vector for a given date and time.
    propagateTuple output;
    output.satrec = satrec;

    double tsince;
    jday(year, month, day, hour, minute, second, tsince);
    tsince = (tsince - output.satrec.jdsatepoch) * minutes_per_day;

    double r[3], v[3];

    gravconsttype whichconst = wgs72;
    sgp4 (whichconst, output.satrec, tsince, output.r, output.v);

    return output;
}

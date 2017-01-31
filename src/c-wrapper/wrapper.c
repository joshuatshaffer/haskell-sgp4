#import "wrapper.h"

elsetrec initOrbit (char* line1, char* line2) {
        char longstr1[130], longstr2[130];
        elsetrec satrec;
        double startmfe, stopmfe, deltamin;
        startmfe = stopmfe = deltamin = 0.0;

        twoline2rv (longstr1, longstr2,
                    'c', '', 'i',
                    gravconsttype.wgs72,
                    startmfe, stopmfe, deltamin,
                    satrec
                    )
        return satrec;
}

propagateTuple propagateOrbit (
        const elsetrec& satrec,
        const int year, const int month, const int day,
        const int hour, const int minute, const double second
        )
{
        //Return a position and velocity vector for a given date and time.
        propagateTuple output;

        double tsince;
        jday(year, month, day, hour, minute, second, tsince);
        tsince = (tsince - output.satrec.jdsatepoch) * minutes_per_day;

        double r[3], v[3];
        sgp4 (gravconsttype.wgs72, output.satrec, tsince, output.r, output.v);

        return output;
}

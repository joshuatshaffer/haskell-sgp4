#import "sgp4unit.h"
#import "sgp4io.h"

typedef struct propagateTuple {
    double r[3], v[3];
    elsetrec satrec;
} propagateTuple;

elsetrec initOrbit (char* line1, char* line2);

propagateTuple propagateOrbit (
    const elsetrec& satrec,
    const int year, const int month, const int day,
    const int hour, const int minute, const double second
    );

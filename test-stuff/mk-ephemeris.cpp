
#include "SGP4.h"

#include <stdio.h>

#define F "%+11e"
#define FORMAT F " " F " " F " " F " " F " " F " " F "\n"

int main (int argc, char *argv[]) {
    char *line1 = argv[1];
    char *line2 = argv[2];
    double start_time = -1440;
    double end_time = 1440;
    double time_step = 10;

    double a;
    elsetrec satrec;
    SGP4Funcs::twoline2rv (line1, line2, 'c', '-', 'i', wgs84, a, a, a, satrec);

    double r[3], v[3];
    for (double t = start_time; t <= end_time; t += time_step) {
        SGP4Funcs::sgp4 (satrec, t, r, v);
        printf (FORMAT, t, r[0], r[1], r[2], v[0], v[1], v[2]);
    }

    return 0;
}

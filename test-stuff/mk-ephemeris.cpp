
#include "orig-sgp4/SGP4.h"

#include <iomanip>
#include <iostream>
#include <limits>

using namespace std;

#define FORMAT                                                                 \
    std::setprecision (std::numeric_limits<double>::max_digits10)              \
        << std::scientific

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
        if (SGP4Funcs::sgp4 (satrec, t, r, v)) {
            cout << FORMAT << t << " ";
            cout << FORMAT << r[0] << " ";
            cout << FORMAT << r[1] << " ";
            cout << FORMAT << r[2] << " ";
            cout << FORMAT << v[0] << " ";
            cout << FORMAT << v[1] << " ";
            cout << FORMAT << v[2] << endl;
        } else {
            cout << "Decayed " << satrec.error << endl;
        }
    }
    return 0;
}

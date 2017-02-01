#ifndef _wrapper_
#define _wrapper_


#ifdef __cplusplus
extern "C" {
#endif


double propagateOrbit (
    const int year, const int month, const int day,
    const int hour, const int minute, const double second
    );


#ifdef __cplusplus
}
#endif

#endif

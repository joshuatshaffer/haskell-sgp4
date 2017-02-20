#ifndef _WRAPPER_H_
#define _WRAPPER_H_

#include "SGP4.h"

#ifdef __cplusplus
extern "C"
{
typedef elsetrec *ElsetrecPtr;
#else
typedef void *ElsetrecPtr;
#endif

ElsetrecPtr w_sgp4init ();
void w_sgp4 (ElsetrecPtr satrec, double tsince);
void w_free_elsetrec (ElsetrecPtr satrec);

#ifdef __cplusplus
}
#endif

#endif

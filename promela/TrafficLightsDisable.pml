#include "TrafficLights.pml"

ltl disableSuccess { ... }; /* this is needed by Vocareum */
/* other properties of your own that won’t be checked by Vocareum */
ltl ... { ... }
ltl ... { ... }  

init {
	run Intersection();
	enableI(); /* statements or macro that enables intersection */
	disableI(); /* statements or macro that disables intersection */
}


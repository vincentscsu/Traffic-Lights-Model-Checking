#include "TrafficLights.pml"

ltl disableSuccess { <>(sL[0].s == OFF) }; /* this is needed by Vocareum */

init {
	run Intersection();
	run enableI(); /* statements or macro that enables intersection */
	run disableI(); /* statements or macro that disables intersection */
}
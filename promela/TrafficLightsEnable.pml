
#include "TrafficLights.pml"

ltl safePedestrian{ ... }; /* this is needed by Vocareum */
/* variation of above for other lights, your properties, won’t be checked by Vocareum */
ltl safePedestrian01 { ... }
ltl safePedestrian11 { ... }  
ltl safeStraightTraffic { ...  }; /* this is needed by Vocareum */
... /* and so on */


init {
	run Intersection();
	enableI(); /* statements or macro that enables intersection */
}

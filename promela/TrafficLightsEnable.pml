#include "TrafficLights.pml"

/* ltl */
/*ltl safePedestrain { []((sL[0].p[0] == WALK) -> (sL[0].v[0] == RED && sT[0].[0] == RED)) } /* when WALK, all lights must be RED */

/* variation of above for other lights, your properties, won’t be checked by Vocareum */
/*ltl safePedestrian01 { ... }*/
/*ltl safePedestrian11 { ... }*/  
/*ltl safeStraightTraffic { ...  }; /* this is needed by Vocareum */
/* and so on */


init {	
	run Intersection();
	/* statements or macro that enables intersection */
	run sIenable();	
	run LinearLightset();
	run TurnLightSet();
}
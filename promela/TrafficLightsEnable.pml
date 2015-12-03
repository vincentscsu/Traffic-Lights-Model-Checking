#include "TrafficLights.pml"

/* ltl */
ltl safePedestrian { []((sL[0].p[0] == WALK) -> (sL[0].v[0] == RED && sT[0].v[0] == RED)) } /* when WALK, all lights must be RED */
ltl safeStraightTraffic { []((sL[0].v[0] == GREEN) -> (sL[1].v[0] == RED && sL[1].v[1] == RED && sT[1].v[0] == RED && sT[1].v[1] == RED)) } /* when an sL is GREEN, all v lights in the other sL and sT should be RED */ 
ltl safeLeftTurn { []((sT[0].v[0] == GREEN) -> (sL[1].v[0] == RED && sL[1].v[1] == RED && sT[1].v[0] == RED && sT[1].v[1] == RED)) } /* when an sT is GREEN, all v lights in the other sL and sT should be RED */ 

/* when walk, one set of linear light set must be red, and all turn light sets must be red */
ltl pedestrianDelay { [] (!(sL[0].p[0] == WALK) W (sL[0].v[0] == RED && sT[0].v[0] == RED && sL[0].v[1] == RED && sT[0].v[1] == RED && sT[1].v[0] == RED && sT[1].v[1] == RED)) }
/* when linear green, the same pedestrian lights must be don't walk, the other linear set must be red, the same turn light set must be red */
ltl straightTrafficDelay { [] (!(sL[0].v[0] == GREEN) W (sL[0].p[0] == DONT_WALK && sL[0].p[1] == DONT_WALK && sL[1].v[0] == RED && sL[1].v[1] == RED && sT[0].v[0] == RED && sT[0].v[1] == RED)) }
/* when turn, the same linear set must be red, all pedestrian must be don't walk, and the other turn must be red */
ltl leftTurnDelay { [] (!(sT[0].v[0] == GREEN) W (sL[0].v[0] == RED && sL[0].v[1] == RED && sL[0].p[0] == DONT_WALK && sL[0].p[1] == DONT_WALK && sL[1].p[0] == DONT_WALK && sL[1].p[1] == DONT_WALK && sT[1].v[0] == RED && sT[1].v[1] == RED)) }

/* always eventually crossing the intersection */
ltl productivePedestrian { []<> (sL[0].p[0] == WALK)}
ltl productiveStraightGoingVehicle { []<> (sL[0].v[0] == GREEN) } 
ltl productiveLeftTurningVehicle { []<> (sT[0].v[0] == GREEN) }

/* light stays the same until the next color */
ltl signalOrderOrange { []((sL[0].v[0] == GREEN) -> (sL[0].v[0] == GREEN) U (sL[0].v[0] == ORANGE)) } 
ltl signalOrderRed { []((sL[0].v[0] == ORANGE) -> (sL[0].v[0] == ORANGE) U (sL[0].v[0] == RED)) }
ltl signalOrderGreen { []((sL[0].v[0] == RED) -> (sL[0].v[0] == RED) U (sL[0].v[0] == GREEN)) }

init {	
	run Intersection();
	/* statements or macro that enables intersection */
	run enableI();
	run LinearLightSet(0);
	run LinearLightSet(1);
	run TurnLightSet(0);
	run TurnLightSet(1);
}
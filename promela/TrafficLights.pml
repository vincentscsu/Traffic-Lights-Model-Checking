/* signal values of lights and light set statuses */
mtype = { OFF, RED, GREEN, ORANGE, WALK, DONT_WALK };

/* intersection statuses */
mtype = { ENABLED, DISABLED, FAILED };

/* light set events */
mtype = { INIT, ADVANCE, PRE_STOP, STOP, ALL_STOP  };

/* data structure for composite state of a linear light set */
typedef LinearLightSetState  {
        mtype s; 		/* light-set status */
        mtype v[2];     /* signal values of pedestrian lights */
        mtype p[2];	/* signal values of vehicular stop lights */

};

/* data structure for composite state of a turn light set */
typedef TurnLightSetState   {
        mtype s;		/* light set status */
        mtype v[2];	/* signal values of vehicular turn lights */
};

/* these are the only global variables to be used in all properties */
LinearLightSetState sL[2]; 
TurnLightSetState sT[2];
mtype sI; /* intersection status */

/* usage examples of global variables */
/*
 sL[0].s => current status of linear light set with index 0
 sL[1].v[0] => current signal value of vehicle light 0 of linear light set 1
 sL[1].p[1] => current signal value of pedestrian light 1 of linear light set 1
 sT[1].s => current status of turn light set with index 1
 sT[0].v[0] => current signal value of vehicle light 1 of turn light set 0
 sI => current status of intersection
*/

/* other global variables of your own */
... 

/* channels  */
... 

/* macros */
/* you’ll need plenty of macros to keep your model organized, clean, non-redundant */

inline xyz() { 
 ... 
}

…

inline abc() {
 ... 
}

... 

/* proctype definitions  */

proctype Intersection() {
	... 
}

proctype LinearLightSet(bit i) {
	... 
}

... 
... 
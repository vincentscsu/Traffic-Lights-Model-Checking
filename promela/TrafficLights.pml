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

mtype ack; /* acknowledgement from lightset to intersection */
bool pOn; /* on/off for pedestrian light */ 
bool hit; /* variable for testing */

/* channels  */
chan to_linearlightset = [1] of { mtype };
chan to_turnlightset = [1] of { mtype };
chan to_intersection = [1] of { mtype };

/* macros */
/* you’ll need plenty of macros to keep your model organized, clean, non-redundant */

inline toGreen(L) {
	 L.v[0] = GREEN;
	 L.v[1] = GREEN;
} 

inline toRed(L) {
	 L.v[0] = RED;
	 L.v[1] = RED;
}

inline toOrange(L) {
	 L.v[0] = ORANGE;
	 L.v[1] = ORANGE;
}

inline toWalk(L) {
	L.p[0] = WALK;
	L.p[1] = WALK;	
} 

inline toDontWalk(L) {
	L.p[0] = DONT_WALK;
	L.p[1] = DONT_WALK;	
} 

inline allStop(L) {
	L.v[0] = RED;
	L.v[1] = RED;
	L.p[0] = DONT_WALK;
	L.p[1] = DONT_WALK;
	pOn = false;	
}

/* proctype definitions  */

proctype Intersection() {
	   
	   sI == ENABLED -> 
	   to_linearlightset!INIT;
	   to_intersection?ack;
	   to_turnlightset!INIT;
	   to_intersection?ack;
	   
	   do 
	   :: to_linearlightset!ADVANCE; 
	      to_intersection?ack; 
	      to_linearlightset!ALL_STOP;
	      to_intersection?ack;
		
		  to_turnlightset!ADVANCE; 
		  to_intersection?ack;   
		  pOn = true;
	   od
}
   
proctype LinearLightSet() { /* model only one light in one lightset because they run sequentially */
	  hit = 1;
	  to_linearlightset?INIT; /* wait for INIT signal from intersection */ 

	  /* init LinearLightSet 1 */
	  allStop(sL[0]) 
	  to_intersection!ack;			
		
	  /* go into the infinite loop */   
	  do
	  :: to_linearlightset?ADVANCE;
	     toGreen(sL[0]);
	     toDontWalk(sL[0]); 
	     
	     /* signals itself to PRE_STOP */
	  	 to_linearlightset!PRE_STOP;
	  	 
	     to_linearlightset?PRE_STOP;
	     toOrange(sL[0]);
	     toDontWalk(sL[0]); 

	     /* signals itself to STOP */
	     to_linearlightset!STOP;
	     
	     to_linearlightset?STOP;
	     toRed(sL[0]);
	     
	     if /* if pOn is true, pedestrian can walk */ 
	     :: pOn == true -> toWalk(sL[0]); 
	     :: skip; /* IMPORTANT! Otherwise deadlock. */
	     fi

	     /* sends an acknowledgement to intersection */	     
	     to_intersection!ack;
	     
	  :: to_linearlightset?ALL_STOP;
	     /* stop everything and signals intersection */
	     allStop(sL[0]);
	     to_intersection!ack;
	  od
}

proctype TurnLightSet() { /* model only one light in one lightset because they run sequentially */
	to_turnlightset?INIT;
	toRed(sT[0]); 
	to_intersection!ack;

	do
	:: to_turnlightset?ADVANCE;
	   toGreen(sT[0]);
	   to_turnlightset!PRE_STOP;
	   
	   to_turnlightset?PRE_STOP; 
	   toOrange(sT[0]); 
	   to_turnlightset!STOP;
	   
	   to_turnlightset?STOP; 
	   toRed(sT[0]); 
	   to_intersection!ack;
	od	
}

proctype sIenable() {
	sI = ENABLED;
}

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

/* channels  */
chan to_linearlightset = [1] of { mtype };
chan to_turnlightset = [1] of { mtype };
chan to_intersection = [1] of { mtype };

/* macros */
/* you’ll need plenty of macros to keep your model organized, clean, non-redundant */

inline xyz() { 
} 

inline abc() {
} 

/* proctype definitions  */

proctype Intersection() {
	 /* inifinte loop */

	   sI == ENABLED; 
	   to_linearlightset!INIT; ->
	   							 do	/* check if there is a message to receive */   						
	   							 :: len(to_intersection) > 0 -> to_intersection?ack ->
								    to_turnlightset!INIT; 
								    do /* check if there is a message to receive */
								    :: len(to_intersection) > 0 -> to_intersection?ack ->								    		    
									   do 
									   :: to_linearlightset!ADVANCE; 
										  to_intersection?ack -> 
										  to_linearlightset!ALL_STOP;
										  to_intersection?ack ->
										  
									   	  to_turnlightset!ADVANCE; 
										  to_intersection?ack ->   
									   	  pOn = true;
									   	  
									   od
									 od
								  :: skip;
								  od
}
   
proctype LinearLightSet() { /* model only one light in one lightset because they run sequentially */
	to_linearlightset?INIT -> d_step { sL[0].v[0] = RED -> sL[0].p[0] = DONT_WALK -> pOn = false; to_intersection!ack;}			
		   
	do
	  :: to_linearlightset?ADVANCE -> 
	     d_step { sL[0].v[0] = GREEN -> sL[0].p[0] = DONT_WALK }  
	  	 to_linearlightset!PRE_STOP;
	  :: to_linearlightset?PRE_STOP -> 
	     d_step { sL[0].v[0] = ORANGE -> sL[0].p[0] = DONT_WALK };
	     to_linearlightset!STOP;
	  :: to_linearlightset?STOP -> 
	     d_step { sL[0].v[0] = RED -> if 
	     							  :: pOn == true -> sL[0].p[0] = WALK; 
	     							  fi }
	     to_intersection!ack;
	  :: to_linearlightset?ALL_STOP -> d_step { sL[0].v[0] = RED -> sL[0].p[0] = DONT_WALK -> pOn = false; };
	     to_intersection!ack;
	od
}

proctype TurnLightSet() { /* model only one light in one lightset because they run sequentially */
	to_turnlightset?INIT -> d_step { sT[0].v[0] = RED -> to_intersection!ack; }

	do
	  :: to_turnlightset?ADVANCE -> sT[0].v[0] = GREEN; to_turnlightset!PRE_STOP;
	  :: to_turnlightset?PRE_STOP -> sT[0].v[0] = ORANGE; to_turnlightset!STOP;
	  :: to_turnlightset?STOP -> sT[0].v[0] = RED; to_intersection!ack;
	od	
}

proctype sIenable() {
	sI = ENABLED;
}

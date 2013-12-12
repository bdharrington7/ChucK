//Conductor.ck
/*  Title: The Final Meltdown
    Author: Anonymous
    Assignment: 8 - Final
    Soundcloud link: TODO add link
*/

/***
* This class is an event driver to send pulses to all other instruments. We're changing 
* paradigms here, instead of every class figuring out how long to play, we give signals
* when a beat has passed
***/
1 => int debug;
EventBroadcaster eb;
Drums drums;

"CONDUCTOR:" => string section;

while(true)
{
	if (debug) { <<< section, "Sending drum signal" >>>;}
	42 => eb.drum.drumBit;
	eb.drum.signal();

	1::second => now;
}
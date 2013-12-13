//Conductor.ck
/*  Title: The Final Meltdown
    Author: Anonymous
    Assignment: 8 - Final
    Soundcloud link: TODO add link
*/

/***
* This class is an event driver to send pulses to all other instruments. We're changing 
* paradigms here, instead of every class figuring out how long to play, we give signals
* when a beat has passed, along with information such as gain. The classes themselves will 
* know what / when to play.
* drums will have to be different, sending regular pulses, while 
***/
1 => int debug;
EventBroadcaster eb;
Drums drums;

"CONDUCTOR:" => string section;
0 => int beat;

while(true)
{

	if (debug) { <<< section, "Sending drum signal" >>>;}
	drums.getNote(0,beat) => eb.drum.drumByte;
	eb.drum.signal();

	beat++;

	1::second => now;
}
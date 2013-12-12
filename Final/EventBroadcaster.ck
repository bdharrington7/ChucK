//EventBroadcaster.ck
/*  Title: The Final Meltdown
    Author: Anonymous
    Assignment: 8 - Final
    Soundcloud link: TODO add link
*/

/***
* This class will hold a static reference to an event that can be used to signal 
* the classes that are listening
***/
//Machine.add(me.dir() + "/Eventful.ck");

// this class will contain all of the static events to signal other instruments


public class EventBroadcaster 
{
	"EVENT BROADCASTER:" => string section;
	static DrumEvent @ drum;
	static int init;

	if (!init)
	{
		setup();  // only call setup once
		1 => init;
	}

	fun void setup()
	{
		<<< section, "setting up drum event" >>>;
		new DrumEvent @=> drum;
	}


}
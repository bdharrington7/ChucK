//EventBroadcaster.ck
/*  Title: The Final Meltdown
    Author: Brian Harrington
    Assignment 8 Final: The Final Storm of Meltdowns
    Soundcloud link: https://soundcloud.com/destruction_synthesis/song-8-the-final-storm-of
*/

/***
* This class will hold a static reference to an event that can be used to signal 
* the classes that are listening
***/

// this class will contain all of the static events to signal other instruments


public class EventBroadcaster 
{
	"EVENT BROADCASTER:" => string section;
	static DrumEvent @ drum;
	static Eventful @ bass;
	static ChordEvent @ chord;
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
		<<< section, "setting up bass event" >>>;
		new Eventful @=> bass;

		new ChordEvent @=> chord;
	}


}
//ScoreBroadcaster.ck
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


public class ScoreBroadcaster 
{
	"SCORE BROADCASTER:" => string section;
	static ScoreEvent @ score;
	static int init;

	if (!init)
	{
		setup();  // only call setup once
		1 => init;
	}

	fun void setup()
	{
		<<< section, "setting up score event" >>>;
		new ScoreEvent @=> score;
	}


}
//Eventful.ck
/*  Title: The Final Meltdown
    Author: Brian Harrington
    Assignment 8 Final: The Final Storm of Meltdowns
    Soundcloud link: https://soundcloud.com/destruction_synthesis/song-8-the-final-storm-of
*/

/***
* This class will be used to augment the Event class in case we need extra functinality
***/
// superclass for all custom events
public class Eventful extends Event
{
	// we still have the methods of event() and broadcast() available to us,
	/// but we can put additional functionality here
	0 => int debug;
	"EVENTFUL:" => string section;
	if (debug) { <<< section, "loading..." >>>;}
	float gain;
	float freq;
	int midiNote;

	// auto conversion of note to frequency
	fun void note(int n){
		if (debug) { <<< section, "setting note to", n >>>;}
		n => midiNote;
		Std.mtof(n) => freq;
	}
}


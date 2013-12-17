//ExtraBass.ck
/*  Title: The Final Meltdown
    Author: Brian Harrington
    Assignment 8 Final: The Final Storm of Meltdowns
    Soundcloud link: https://soundcloud.com/destruction_synthesis/song-8-the-final-storm-of
*/
// this class isn't as independent as it could be, just using as a layer to the bass
public class ExtraBass extends HevyMetl 
{

	"BASS INSTRUMENT:" => string section;
	0 => int debug;
	if (debug) { <<< section, "loading class" >>>;}

	this => NRev rev => dac;
	0.05 => rev.mix;
	// give some layer to this bass by adding an osc
	SinOsc osc => ADSR env => dac;
	(30::ms, 30::ms, 0.9, 30::ms) => env.set;


	fun void bNoteOn (float fr, float ga, float vel)
	{
		if (debug) { <<< section, "calling noteOn", fr, "gain", ga >>>;}
		
		fr => this.freq => osc.freq;
		ga => this.gain => osc.gain;
		1 => env.keyOn;
		this.noteOn(vel);
	}


	fun void bNoteOff()
	{
		if (debug) { <<< section, "calling noteOff" >>>;}
		1 => env.keyOff;
		this.noteOff(1);
		
	}
}
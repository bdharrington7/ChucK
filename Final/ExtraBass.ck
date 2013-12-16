//ExtraBass.ck
/*  Title: The Final Meltdown
    Author: Anonymous
    Assignment: 8 - Final
    Soundcloud link: TODO add link
*/
// this class isn't as independent as it could be, just using as a layer to the bass
public class ExtraBass extends HevyMetl 
{

	"BASS INSTRUMENT:" => string section;
	1 => int debug;
	if (debug) { <<< section, "loading class" >>>;}

	this => NRev rev => dac;
	0.05 => rev.mix;
	// give some layer to this bass by adding an osc
	SinOsc osc => dac;


	fun void bNoteOn (float fr, float ga, float vel)
	{
		if (debug) { <<< section, "calling noteOn", fr, "gain", ga >>>;}
		
		fr => this.freq => osc.freq;
		ga => this.gain => osc.gain;
		this.noteOn(vel);
	}


	fun void bNoteOff()
	{
		if (debug) { <<< section, "calling noteOff" >>>;}
		this.noteOff(1);
		0 => osc.freq;
		0 => osc.gain;
	}
}
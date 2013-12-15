//ExtraBass.ck
/*  Title: The Final Meltdown
    Author: Anonymous
    Assignment: 8 - Final
    Soundcloud link: TODO add link
*/
// this class isn't as independent as it could be, just using as a layer to the bass
public class ExtraBass extends HevyMetl 
{

	"BASS:" => string section;
	1 => int debug;
	if (debug) { <<< section, "loading class" >>>;}
	// give some layer to this bass by adding an osc
	// SinOsc osc => dac;

	// fun void bNoteOn (float freq, float gain, float velocity)
	// {
	// 	if (debug) { <<< section, "calling noteOn", freq, " ", gain >>>;}
		
	// 	freq => this.freq;//=> osc.freq;
	// 	// gain / 2.0 => osc.gain;
	// 	gain => this.gain;
	// 	this.noteOn(velocity);
	// }

	// fun void bNoteOff()
	// {
	// 	if (debug) { <<< section, "calling noteOff" >>>;}
	// 	this.noteOff(1);
	// 	// 0 => osc.freq; // effectively off
	// }
}
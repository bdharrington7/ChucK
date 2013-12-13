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
	// give some layer to this bass by adding an osc
	// SinOsc osc => dac;

	fun void noteOn (float freq, float gain, float velocity)
	{
		if (debug) { <<< section, "calling noteOn", freq, " ", gain >>>;}
		this.noteOn(velocity);
		freq => this.freq;//=> osc.freq;
		// gain / 2.0 => osc.gain;
		gain => this.gain;
	}

	fun void noteOff()
	{
		if (debug) { <<< section, "calling noteOff" >>>;}
		this.noteOff(1);
		// 0 => osc.freq; // effectively off
	}


	// bass notes
	[56, 67] @=> int noteTrack1[];
	[noteTrack1] @=> int notes[][];

	fun int getNote(int track, int index)
	{
		if (debug) { <<< section, "getting note track", track, ", index", index >>>;}
		return notes[track][index % notes[track].cap()];
	}

	// gains
	[1.] @=> float gainTrack1[];
	[gainTrack1] @=> float gains[][];

	fun float getGain(int track, int index)
	{
		if (debug) { <<< section, "getting gain track", track, ", index", index >>>;}
		return gains[track][index % gains[track].cap()];
	}

	// TODO: recieve events

} 
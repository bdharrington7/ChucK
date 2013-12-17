//ChordInstrument.ck
/*  Title: The Final Meltdown
    Author: Brian Harrington
    Assignment 8 Final: The Final Storm of Meltdowns
    Soundcloud link: https://soundcloud.com/destruction_synthesis/song-8-the-final-storm-of
*/

public class ChordInstrument extends ModalBar
{
	"CHORD INSTRUMENT:" => string section;
	0 => int debug;
	if (debug) { <<< section, "loaing class..." >>>;}

	this => NRev rev => dac;
	0.01 => rev.mix;


	fun void cNoteOn (float fr, float ga, float vel)
	{
		if (debug) { <<< section, "calling noteOn", fr, "gain", ga >>>;}
		
		fr => this.freq;
		ga => this.gain;
		this.noteOn(vel);
	}

	fun void cNoteOff(){
		if (debug) { <<< section, "calling noteOff" >>>;}
		this.noteOff(1);
	}
}
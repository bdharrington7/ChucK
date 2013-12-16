//ChordInstrument.ck
/*  Title: The Final Meltdown
    Author: Anonymous
    Assignment: 8 - Final
    Soundcloud link: https://soundcloud.com/coursera_anon_673143250/assignment-8-final
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
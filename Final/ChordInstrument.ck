//ChordInstrument.ck

public class ChordInstrument extends BandedWG
{
	"CHORD INSTRUMENT:" => string section;
	1 => int debug;
	if (debug) { <<< section, "loaing class..." >>>;}

	this => NRev rev => dac;
	0.1 => rev.mix;


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
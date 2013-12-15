//BassPlayer.ck

public class BassPlayer {
	ExtraBass bass => dac;
	SinOsc bassOsc => dac; // extra layer

	"BASS PLAYER:" => string section;

	1 => int debug;

	// bass notes
	[45, 47, 0] @=> int noteTrack1[];
	[noteTrack1] @=> int notes[][];

	// function for the Conductor to get the note for this instrument
	fun int getNote(int track, int index)
	{
		if (debug) { <<< section, "getting note track", track, ", index", index >>>;}
		return notes[track][index % notes[track].cap()];
	}

	// gains
	[.5] @=> float gainTrack1[];
	[gainTrack1] @=> float gains[][];

	// function for the Conductor to get the gain for this instruments
	fun float getGain(int track, int index)
	{
		if (debug) { <<< section, "getting gain track", track, ", index", index >>>;}
		return gains[track][index % gains[track].cap()];
	}

	EventBroadcaster eb;

	spork ~ playBass(eb.bass);

	fun void playBass(Eventful evt)
	{
		if (debug) { <<< section, "going into while loop" >>>;}

		while (true)
		{
			evt =>now;
			if (debug) { 
				<<< section, "event received! gain:", evt.gain, "freq:", evt.freq, "midiNote", evt.midiNote >>>;
				<<< evt.gain >>>;
				<<< evt.freq >>>;
				<<< evt.midiNote >>>;
			}
			evt.freq => float theFreq;
			evt.gain => float theGain;

			if (theFreq > 0){
				if (debug) { <<< section, "playing note" >>>;}
				theFreq => bass.freq => bassOsc.freq;
				theGain => bass.gain;
				theGain => bassOsc.gain;
				bass.noteOn(1);
			}
		}
	}
}
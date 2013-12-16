//ChordPlayer.ck

public class ChordPlayer
{
	ChordInstrument chords[4];
	"CHORD PLAYER:" => string section;
	1 => int debug;

	// chord notes TODO change these, 2d array probably
	[[45, 48, 50],[48, 52, 53]] @=> int chordMelody1[][];
	[chordMelody1] @=> int notes[][][];

	// function for the Conductor to get the note for this instrument
	fun int[] getNotes(int track, int index)
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

	spork ~ playChord(eb.chord);

	fun void playChord(ChordEvent evt)
	{
		if (debug) { <<< section, "going into while loop" >>>;}

		while (true)
		{
			evt => now;
			if (debug) { 
				<<< section, "event received! gain:", evt.gain, "root freq:", evt.freqs[0], "root midiNote", evt.midiNotes[0], "arp:", evt.arp >>>;
			}
			evt.freqs @=> float theFreqs[];
			evt.gain => float theGain;

			if (evt.midiNotes[0] > 0){
				if (debug) { <<< section, "playing note" >>>;}
				// theFreqs => chord.freqs;
				// theGain => chord.gain;
				// chord.noteOn(1);
				for ( 0 => int i; i < theFreqs.cap(); i++){
					chords[i].cNoteOn(theFreqs[i], theGain, 1.);
				}
				
			}
			else {
				for (0 => int i; i < theFreqs.cap(); i++){
					chords[i].cNoteOff();
				}
			}
		}
	}
}
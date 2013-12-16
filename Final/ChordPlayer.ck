//ChordPlayer.ck
/*  Title: The Final Meltdown
    Author: Anonymous
    Assignment: 8 - Final
    Soundcloud link: https://soundcloud.com/coursera_anon_673143250/assignment-8-final
*/

public class ChordPlayer
{
	ChordInstrument chords[4];
	"CHORD PLAYER:" => string section;
	0 => int debug;

	// chord notes TODO change these, 2d array probably
	[[62, 65, 69, 74]] @=> int chordMelody0[][];
	[chordMelody0] @=> int notes[][][];

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
				if (evt.arp > 0::ms){  // play the arpeggio
					// spork so it doesn't block
					spork ~ playArp(theFreqs, theGain, evt.arp);
				}
				else {  // play a straight chord
					for ( 0 => int i; i < theFreqs.cap(); i++){
						chords[i].cNoteOn(theFreqs[i], theGain/theFreqs.cap(), 1.);
					}
				}
				
			}
			else {
				for (0 => int i; i < theFreqs.cap(); i++){
					chords[i].cNoteOff();
				}
			}
		}
	}

	fun void playArp(float freqs[], float theGain, dur split){
		split / freqs.cap() => dur pause; // this is the duration between notes

		for (0 => int i; i < freqs.cap(); i++){
			for (0 => int j; j < freqs.cap(); j++){
				chords[j].noteOff(1);  // stop playing all notes
			}
			freqs[i] => chords[i].freq;
			theGain => chords[i].gain;
			chords[i].noteOn(1);
			pause => now;
		}
		for (0 => int j; j < freqs.cap(); j++){
			chords[j].noteOff(1);  // stop playing all notes
		}
	}

	// builds a chord based on:
	// 1: root note, 2: root scale (1, 2, etc), 3: quality (Major, minor)
	fun int[] build(string ch){  // builds a chord
		if (debug) { <<< section, "building chord", ch >>>;}
		int root; // root midi note

		//if ()
	}
}
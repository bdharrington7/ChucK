//BassPlayer.ck
/*  Title: The Final Meltdown
    Author: Brian Harrington
    Assignment 8 Final: The Final Storm of Meltdowns
    Soundcloud link: https://soundcloud.com/destruction_synthesis/song-8-the-final-storm-of
*/
public class BassPlayer {
	ExtraBass bass;

	"BASS PLAYER:" => string section;

	0 => int debug;

	// bass notes
	[29, 29, 32, 32, 29, 29, 32, 32, 29, 29, 32, 32, 29, 29, 32, 34] @=> int bassMelody0[];
	[26,25] @=> int bassMelody1[];
	[29, 31, 32, 31, 29, 31, 29] @=> int bassMelody2[];
	[bassMelody0, bassMelody1, bassMelody2] @=> int notes[][];

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
			}
			evt.freq => float theFreq;
			evt.gain => float theGain;
			evt.midiNote => int theNote;

			if (theNote > 0){
				if (debug) { <<< section, "playing note" >>>;}
				bass.bNoteOn(theFreq, theGain, 1.);
			}
			else {
				bass.bNoteOff();
			}
		}
	}
}
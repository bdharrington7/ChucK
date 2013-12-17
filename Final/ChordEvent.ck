//ChordEvent.ck
/*  Title: The Final Meltdown
    Author: Brian Harrington
    Assignment 8 Final: The Final Storm of Meltdowns
    Soundcloud link: https://soundcloud.com/destruction_synthesis/song-8-the-final-storm-of
*/

public class ChordEvent extends Eventful
{
	0 => debug;
	"CHORD EVENT:" => section;
	if (debug) { <<< section, "loading..." >>>;}

	dur arp; // if we send a signal to arpeggiate, this is how long the arpeggio should last
	float freqs[];
	int midiNotes[];

	// auto conversion of note to frequency
	fun void notes(int n[]){
		new float[n.cap()] @=> freqs;
		new int[n.cap()] @=> midiNotes;
		for (0=> int i; i < n.cap(); i++){
			if (debug) { <<< section, "setting note to", n[i] >>>;}
			n[i] => midiNotes[i];
			Std.mtof(n[i]) => freqs[i];
		}
	}
}
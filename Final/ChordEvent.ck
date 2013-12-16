//ChordEvent.ck

public class ChordEvent extends Eventful
{
	1 => debug;
	"CHORD EVENT:" => section;
	if (debug) { <<< section, "loading..." >>>;}

	int arp; // flag to arpeggiate or not

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
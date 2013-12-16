//Conductor.ck
/*  Title: The Final Meltdown
    Author: Anonymous
    Assignment: 8 - Final
    Soundcloud link: TODO add link
*/

/***
* This class is an event driver to send pulses to all other instruments. We're changing 
* paradigms here, instead of every class figuring out how long to play, we give signals
* when a beat has passed, along with information such as gain. The classes themselves will 
* know what / when to play.
* drums will have to be different, sending regular pulses, while 
***/
1 => int debug;
BPM tempo;
EventBroadcaster eb;
Drums drums;
BassPlayer bass;
ChordPlayer chord;


"CONDUCTOR:" => string section;
//50::ms => now; // wait for the dust to settle?

// set the tempo
tempo.setBPM(120);

if (debug) {<<< section, "sporking chords" >>>;}
spork ~ playChord(0, 4);
// if (debug) { <<< section, "sporking drums" >>>;}
// spork ~ playDrums(0, 4);
// if (debug) { <<< section, "sporking bass" >>>;}
// spork ~ playBass(0, 5);
// must let time pass or this dies immediately
4::second => now;

fun void playDrums(int track, int beats)
{
	if(debug){ <<< section, "in playDrums" >>>;}
	0 => int beat;
	if (track == 0){
		repeat(beats)
		{
			drums.getNote(0,beat) => eb.drum.drumByte;
			if (debug) { <<< section, "Sending drum signal", eb.drum.drumByte >>>;}
			eb.drum.signal();

			beat++;

			tempo.qu => now;
		}
	}
	else if (track == 1){

	}
}


fun void playBass(int track, int beats)
{
	if (debug) {<<< section, "in playBass, " >>>;}
	0 => int note;
	if (track == 0){
		repeat (beats)
		{
			bass.getNote(0, note) => eb.bass.note;
			bass.getGain(0, note) => eb.bass.gain;
			eb.bass.signal();

			note++;
			tempo.ei => now;
		}
	}
	else if (track == 1){

	}
	// stop playing when done
	0 => eb.bass.note;
	eb.bass.signal();
}

fun void playChord(int track, int beats){
	if (debug) { <<< section, "int playChord" >>>;}
	0 => int note;
	if (track == 0) {
		repeat (beats){
			chord.getNotes(0, note) => eb.chord.notes;
			chord.getGain(0, note) => eb.chord.gain;
			eb.chord.signal();

			note++;
			tempo.ei => now;
		}
	}
	else if (track == 1){

	}

	// stop playing when done
	// TODO

}
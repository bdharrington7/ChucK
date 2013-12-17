//Conductor.ck
/*  Title: The Final Meltdown
    Author: Brian Harrington
    Assignment 8 Final: The Final Storm of Meltdowns
    Soundcloud link: https://soundcloud.com/destruction_synthesis/song-8-the-final-storm-of
*/

/***
* This class is an event driver to send pulses to all other instruments. We're changing 
* paradigms here, instead of every class figuring out how long to play, we give signals
* when a beat has passed, along with information such as gain. The classes themselves will 
* know what / when to play.
* Ok so after coding this a while it's more of a lead rather than a conductor
***/
0 => int debug;
0 => int recording;  // set this to 1 to record to disk
BPM tempo;
EventBroadcaster eb;
Drums drums;
BassPlayer bass;
ChordPlayer chord;
BeeThree organ; // solo


"CONDUCTOR:" => string section;

// set the tempo
tempo.setBPM(120);

// this is the main score part
// intro

WvOut w;
if(recording){
	dac => WvOut w => blackhole;
	"8.wav" => w.wavFilename;
	1 => w.record;
}

organ => JCRev rev => dac;
0.3 => rev.mix;
10 => Std.mtof => organ.freq;
0.1 => float orgGain;
orgGain => organ.gain;
repeat (8){
	organ.noteOn(1);
	tempo.ei => now;
	0.1 +=> orgGain;
	orgGain => organ.gain;
}

organ.noteOff(1);
0.15 => organ.gain;
0 => int timesThru;
repeat (2){
	if (timesThru > 0){
		if (debug) {<<< section, "playing solo" >>>;}
		spork ~ organSolo(0, 1);
	}
	if (debug) { <<< section, "sporking drums" >>>;}
	spork ~ playDrums(0, 48);
	if (debug) { <<< section, "sporking bass" >>>;}
	spork ~ playBass(0, 48);
	// must let time pass or this dies immediately
	tempo.wh*6 => now;
	if (debug) {<<< section, "sporking chords" >>>;}
	spork ~ playChord(0, 4);
	spork ~ playBass (1, 2);
	spork ~ playDrums(1, 16);
	tempo.wh*2 => now;
	timesThru++;
}


spork ~ organSolo(1, 2);

repeat (1){
	if (debug) { <<< section, "sporking drums" >>>;}
	spork ~ playDrums(0, 48);
	if (debug) { <<< section, "sporking bass" >>>;}
	spork ~ playBass(0, 48);
	// must let time pass or this dies immediately
	tempo.wh*6 => now;
	if (debug) {<<< section, "sporking chords" >>>;}
	spork ~ playChord(0, 4);
	spork ~ playBass (1, 2);
	spork ~ playDrums(1, 16);
	tempo.wh*2 => now;
}

// and now, for something completely different
spork ~ playDrums(2, 36);
spork ~ playBass(2, 7);
spork ~ organSolo(2, 2);
tempo.wh*5 => now;
// shut down
organ.noteOff(1);
0 => eb.bass.note;
eb.bass.signal();
tempo.dw => now;

// uncomment to export to wav
if (recording){
	0 => w.record;
}


fun void playDrums(int track, int beats)
{
	if(debug){ <<< section, "in playDrums" >>>;}
	
	if (track == 0){
		0 => int beat;
		repeat(beats)
		{
			drums.getNote(0,beat) => eb.drum.drumByte;
			if (debug) { <<< section, "Sending drum signal", eb.drum.drumByte >>>;}
			eb.drum.signal();

			beat++;

			tempo.ei => now;
		}
	}
	else if (track == 1){
		0 => int beat;
		repeat(beats)
		{
			drums.getNote(1,beat) => eb.drum.drumByte;
			if (debug) { <<< section, "Sending drum signal", eb.drum.drumByte >>>;}
			eb.drum.signal();

			beat++;

			tempo.ei => now;
		}
	}
	else if (track == 2){
		0 => int beat;
		repeat (beats){
			drums.getNote(2, beat) => eb.drum.drumByte;
			if (debug) { <<< section, "Sending drum signal", eb.drum.drumByte >>>;}
			eb.drum.signal();

			beat++;

			tempo.ei => now;
		}
	}
}


fun void playBass(int track, int beats)
{
	if (debug) {<<< section, "in playBass" >>>;}
	
	if (track == 0){
		0 => int note;
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
		0 => int note;
		repeat (beats)
		{
			bass.getNote(1, note) => eb.bass.note;
			bass.getGain(0, note) => eb.bass.gain;
			eb.bass.signal();

			note++;
			tempo.wh => now;
		}
	}
	else if (track == 2){
		0 => int note;
		repeat (beats)
		{
			bass.getNote(2, note) => eb.bass.note;
			bass.getGain(0, note) => eb.bass.gain;
			eb.bass.signal();

			note++;
			tempo.dh => now;
		}
	}
	// stop playing when done
	0 => eb.bass.note;
	eb.bass.signal();
}

fun void playChord(int track, int beats){
	if (debug) { <<< section, "in playChord" >>>;}
	0 => int note;
	if (track < 0){  // signal to turn off
		0 => eb.chord.gain;
		eb.chord.signal();
	}
	if (track == 0) {
		repeat (beats){
			chord.getNotes(0, note) => eb.chord.notes;
			chord.getGain(0, note) => eb.chord.gain;
			tempo.ha => eb.chord.arp;
			eb.chord.signal();

			note++;
			tempo.ha => now;
		}
	}
	else if (track == 1){

	}

	// stop playing when done
	0 => eb.chord.gain;
	eb.chord.signal();

}

fun void organSolo(int track, int beats){

	if (track == 0){
		if (debug) { <<< section, "playing track", track >>>;}
		repeat (beats){
			77 => Std.mtof => organ.freq;
			tempo.dw => now;
			tempo.qu => now;
			organ.noteOn(1);  // toot toot
			tempo.si => now;
			organ.noteOff(1);
			tempo.si => now;
			organ.noteOn(1);
			tempo.si => now;
			organ.noteOff(1);  // pause
			tempo.si => now;

			tempo.dw => now;
			tempo.qu => now;

			65 => Std.mtof => organ.freq;
			organ.noteOn(1);  // toot toot
			tempo.si => now;
			organ.noteOff(1);
			tempo.si => now;
			organ.noteOn(1);
			tempo.si => now;
			organ.noteOff(1);  // pause
			tempo.si => now;

			organ.noteOff(1);  // pause
			// tempo.qu => now;
		}

	}
	else if (track == 1){
		if (debug) { <<< section, "playing track", track >>>;}
		[65, 68, 70, 71] @=> int notes[];
		//0 => int note;
		repeat(beats){
			repeat (2){
				notes[0] => Std.mtof => organ.freq;
				organ.noteOn(1);
				tempo.qu => now;

				notes[1] => Std.mtof => organ.freq;
				organ.noteOn(1);
				tempo.ei => now;

				notes[2] => Std.mtof => organ.freq;
				organ.noteOn(1);
				tempo.ei => now;

				notes[3] => Std.mtof => organ.freq;
				organ.noteOn(1);
				tempo.de => now;

				notes[2] => Std.mtof => organ.freq;
				organ.noteOn(1);
				tempo.de => now;

				notes[1] => Std.mtof => organ.freq;
				organ.noteOn(1);
				tempo.ei => now;
			}
			notes[0] => Std.mtof => organ.freq;
			organ.noteOn(1);
			tempo.ha => now;
			organ.noteOff(1);
			tempo.dw => now;
		}
	}
	else if (track == 2){ // hm, stormy...
		if (debug) { <<< section, "playing track", track >>>;}
		[65, 68, 77, 65, 68, 77, 79, 80, 79, 80, 79, 75, 72,  
		72, 65, 68, 70, 72, 72, 65] @=> int notes[];
		[tempo.ei, tempo.ei, tempo.ha, tempo.ei, tempo.ei, tempo.ha, tempo.dq, tempo.ei, tempo.ei, tempo.ei, tempo.ei, tempo.ei, tempo.ha,
		tempo.qu, tempo.qu, tempo.ei, tempo.ei, tempo.ha, tempo.qu, tempo.dw] @=> dur durs[];
		for (0 => int i; i < notes.cap(); i++){
			if (debug) {<<< section, "song of storms" >>>;}
			notes[i] => Std.mtof => organ.freq;
			organ.noteOn(1);
			durs[i] => now;
		}
	}
}



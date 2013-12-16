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
* Ok so after coding this a while it's more of a lead rather than a conductor
***/
1 => int debug;
BPM tempo;
EventBroadcaster eb;
Drums drums;
BassPlayer bass;
ChordPlayer chord;
BeeThree organ; // solo


"CONDUCTOR:" => string section;
//50::ms => now; // wait for the dust to settle?

// set the tempo
tempo.setBPM(120);

// this is the main score part
// intro
// Noise noize => ResonZ res => dac;
// 0.03 => noize.gain;
// 23.0 => float f;
// while (f < 1000){
// 	f => res.freq;
// 	0.1 +=> f;
// 	1::ms => now;
// }
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
0.4 => organ.gain;
0 => int timesThru;
repeat (2){
	if (timesThru > 0){
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
	//tempo.wh => now;
	//spork ~ playChord(-1, 0);
	spork ~ playBass (1, 2);
	spork ~ playDrums(1, 16);
	tempo.wh*2 => now;
	timesThru++;
}


spork ~ organSolo(1, 2);

repeat (2){
	if (debug) { <<< section, "sporking drums" >>>;}
	spork ~ playDrums(0, 48);
	if (debug) { <<< section, "sporking bass" >>>;}
	spork ~ playBass(0, 48);
	// must let time pass or this dies immediately
	tempo.wh*6 => now;
	if (debug) {<<< section, "sporking chords" >>>;}
	spork ~ playChord(0, 4);
	//tempo.wh => now;
	//spork ~ playChord(-1, 0);
	spork ~ playBass (1, 2);
	spork ~ playDrums(1, 16);
	tempo.wh*2 => now;
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
				// notes[0] => Std.mtof => organ.freq;
				// organ.noteOn(1);
			}
			notes[0] => Std.mtof => organ.freq;
			organ.noteOn(1);
			tempo.ha => now;
			organ.noteOff(1);
			tempo.dw => now;
		}
	}
}



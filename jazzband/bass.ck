// bass.ck
/*  Title: SD Shredded Powerplant
    Author: Anonymous
    Assignment: 6 - threading (shredding) and concurrency
    Soundcloud link: https://soundcloud.com/coursera_anon_673143250/assignment-6
*/

"BASS:" => string section;

Std.atoi(me.arg(0)) => int track; // get the drum track we want to play

if (track <= 0){
    <<< section, "invalid track (", track, ") exiting" >>>;
    me.exit();
}

Std.atoi(me.arg(1)) => int debug; // debug flag that can be set when this file is loaded, defaults to 0, always last flag

[46, 48, 49, 51, 53, 54, 56, 58] @=> int scale[]; // (the Bb Aeolian mode)

0.625 * 4 => float wLen; // quarter note is 0.625

dur wh; //ole
dur ha; //lf
dur qu; //arter
dur ei; //ghth
dur si; //xteenth
dur th; //irtysecond
dur dw; // dotted whole == whole + half
dur dh; // (half + quarter)
dur dq; // (quarter + eighth)
dur de; // (eighth + sixteenth)
dur ds; // (sixteenth + thirtysecond)
if (debug) { <<< section, "Setting note durations: whole note is", wLen, "seconds" >>>; }
wLen::second => wh; //ole
    wh / 2 => ha; //lf
    wh / 4 => qu; //arter
    wh / 8 => ei; //ghth
    wh / 16 => si; //xteenth
    wh / 32 => th; //irtysecond
    wh + ha => dw; // dotted notes:
    ha + qu => dh;
    qu + ei => dq;
    ei + si => de;
    si + th => ds;

// build up the scale to a fuller one instead of just 8 notes
// find the lowest root note above 0
scale[0] => int currRoot;
while (true){
	if (currRoot - 12 < 0){
		break; // we're at the lowest note
	}
	12 -=> currRoot; // decrement currRoot by 12
}

6 => int octaves;
int sc[ octaves * (scale.cap()-1) ]; // new array to hold the whole scale: num octaves * (the scale size - the last note because it's an octave)
0 => int scIndex;
repeat (octaves){ // build up 6 octaves 
	if (debug) { <<< section, "adding scale from root note", currRoot >>>; }
	currRoot => sc[ scIndex++ ];
	for (1 => int i; i < scale.cap()-1; i++){  // assuming that the octave is present in the array
		// add the note that is the currRoot + difference between the root in the original array
		// and the one at i
		currRoot + (scale[i] - scale[0]) => sc[ scIndex++ ];  
	}
	12 +=> currRoot;
}
if (debug) {
	<<< section, "Scale is:" >>>;
	for (0 => int i; i < sc.cap(); i++){
		if (i % 7 == 0){
			<<< "Octave", i / 7, ":" >>>;
		}
		<<< sc[i] >>>;
	}
}

// setup sound chain
TriOsc osc1 => dac;
VoicForm sit =>  dac;
//0.05 => rev.mix;
"ooo" => sit.phoneme;

int notes[]; // note array for melody keys
dur durs[];  // durations for each note
float gains[]; // gains for each note

if (track == 1){ // intro / main?
    if (debug) { <<< section, "setting up track 1" >>>; }
//   1        2       3   4       5    6       7   8       9    10  11 12     13     14     15     16 
    [sc[15], sc[15], sc[8], sc[15],   0, sc[15],   0, sc[15],   0, sc[14], sc[15], sc[17], sc[15], sc[14]] @=> notes;
    [    si,     si,    ei,     si,  si,     si,   si,     si,   si,   ei,     si,     si,     si,     si ] @=> durs;
    [    1. ] @=> gains; // only need one since it doesn't change
}
else {
    <<< section, "Pattern not set, aborting" >>>;
    me.exit();
}

// vars for the while loop
th => dur resolution;    // resolution for the while loop's time passing
0::second => dur durNote; // keeps track of the note's remaining duration
0 => int noteIndex;       // index for the note in the different arrays

while(true){

	// set the melodic note
    if (durNote <= 0::second) { // if the note ran out of time
        //sit.clear(1);
        notes[ noteIndex % notes.cap() ] => int note;
        if (debug) <<< section, "Changing note to", note >>>;
        Std.mtof(note) => osc1.freq;
        Std.mtof(note) => sit.freq;
        gains[ noteIndex % gains.cap() ] => osc1.gain;
        if (gains[ noteIndex % gains.cap() ] > 0.){
             gains[ noteIndex % gains.cap() ]/2 => sit.gain;
             sit.noteOn(1);
        }
        else {
            sit.noteOff(1);
        }
        durs[ noteIndex % durs.cap() ] => durNote;
        
        noteIndex++; // increment the counter for next pass
    }
    resolution => now;
    resolution -=> durNote; // reduce duration of this note by the resloution
}
// accompany.ck
/*  Title: SD Shredded Powerplant
    Author: Anonymous
    Assignment: 6 - threading (shredding) and concurrency
    Soundcloud link: https://soundcloud.com/coursera_anon_673143250/assignment-6
*/

"ACCOMPANY:" => string section;


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

8 => int octaves;
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
BlowBotl acc[3];
Pan2 pan[3];
NRev rev;
Gain masterL, masterR;

0.03 => rev.mix;

for (0 => int i; i < acc.cap(); i ++){
	if(debug) { <<< section, "setting up pans and intruments" >>>;}
	new Pan2 @=> pan[i];
	new BlowBotl @=> acc[i] => pan[i];
	acc[i].noiseGain(0.03);
}

// send cound chains to effects and dac
for (0 => int i; i < pan.cap(); i++){
	if(debug) { <<< section, "sending pans to masters and dac" >>>;}
	pan[i].left => rev => masterL;
	pan[i].right => rev => masterR;
}
masterL => dac.left;
masterR => dac.right;

-0.5 => pan[0].pan;
0.5 => pan[2].pan;

// functions to set the different parts of the accompaniment 
fun void setNotes(int n[]){
	// if (null == n) { 
	// 	<<< section, "Null passed to fn setNotes" >>>;
	// 	return;
	// }
	if(debug){
		<<< section, "Setting notes to" >>>;
		for (0=> int i; i < n.cap(); i++){
			<<< n[i] >>>;
		}
	}
	0 => int c; // count for the intruments
	while (c < n.cap() && c < acc.cap()){
		// set the existing notes for the accompaniments
		Std.mtof( n[c] ) => acc[c].freq;
		c++;
	}
	while (c < acc.cap()){
		// fill out any extra accompaniement instruments with a 0
		if(debug){ <<< section, "Setting acc[", c, "] to 0" >>>; }
		
		0 => acc[c].gain;
		Std.mtof(0) => acc[c].freq;
		c++;
	}
}

fun void setGain( float g){
	for (0=> int i; i < acc.cap(); i++){
		g/acc.cap() => acc[i].gain;  // set each gain to a fraction of the gain that will add up to the total
	}
}

// set the note on or off, on is pos num, off is neg.
fun void setNoteOnOff(float vel){
	if (vel > 0.){
		if (debug){ <<< section, "Setting note on", vel >>>; } 
		for (0 => int i; i < acc.cap(); i++){
			acc[i].noteOn(vel);
		}
	} else {
		if (vel == 0.) { -1. => vel; } // if we get a 0, set to 1 for avalid value
		if (debug){ <<< section, "Setting note off", -vel >>>; } 
		for (0 => int i; i < acc.cap(); i++){
			acc[i].noteOn(-vel); // reverse the neg number
		}
	}
}



int notes[][]; // note array for melody keys
dur durs[];  // durations for each note
float gains[]; // gains for each note

if (track == 1){ // intro / main?
    if (debug) { <<< section, "setting up track 1" >>>; }
//   1        2       3      4       5       6       7       8       9       10      11      12     13     14     15     16 
    [[sc[36], sc[41], sc[43]], [sc[36], sc[42], sc[43]]] @=> notes;
    [    wh*2 ] @=> durs;
    [    .2    ] @=> gains;
    spork ~ chord();
    spork ~ increaseVibrato();
}
else if (track == 2){ // second / verse?
    if (debug) { <<< section, "setting up track 2" >>>; }  // 6/4 time
//   1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 
    [[sc[36], sc[41], sc[43]], [sc[36], sc[42], sc[43]]] @=> notes;
    [    wh*2 ] @=> durs;
    [    .4    ] @=> gains;
    spork ~ arpeggiate();
}
else {
    <<< section, "Pattern not set, aborting" >>>;
    me.exit();
}

fun void arpeggiate(){
	// vars for the while loop
	th => dur resolution;    // resolution for the while loop's time passing
	0::second => dur durNote; // keeps track of the note's remaining duration
	0 => int noteIndex;       // index for the note in the different arrays
	Math.random2(0, acc.cap()-1) => int instr => int last;// choose a random index to start on
	while(true){
		acc[instr].noteOff(1);
		do {
			Math.random2(0, acc.cap()-1) => instr;
		} while (instr == last);
		instr => last;
		if (debug) { <<< section, "turning on instrument", instr >>>;}
		acc[instr].noteOn(1);
		// set the melodic note
	    if (durNote <= 0::second) { // if the note ran out of time
	    	//setNoteOnOff(-1.);
	        setNotes(notes[ noteIndex % notes.cap() ]);
	        setGain(gains[ noteIndex % gains.cap() ]);
	        durs[ noteIndex % durs.cap() ] => durNote;
	        // DEBUG
	        //setNoteOnOff(1);
	        noteIndex++; // increment the counter for next pass
	    }
	    resolution => now;
	    resolution -=> durNote; // reduce duration of this note by the resloution
	}
}

0. => float vibGain; // gain for vibrato

fun void increaseVibrato(){
	
	while (true){
		if(vibGain < .99 ){
			0.1 +=> vibGain;
			if (debug) { <<< section, "Vibrato Gain is", vibGain >>>;}
			for (0 => int i; i < acc.cap(); i++){
				vibGain => acc[i].vibratoGain;
			}
			
		}
		0.2::second => now;
	}
}

fun void chord(){
	// vars for the while loop
	th => dur resolution;    // resolution for the while loop's time passing
	0::second => dur durNote; // keeps track of the note's remaining duration
	0 => int noteIndex;       // index for the note in the different arrays

	while(true){

		// set the melodic note
	    if (durNote <= 0::second) { // if the note ran out of time
	    	setNoteOnOff(-1.);
	    	0. => vibGain;
	        setNotes(notes[ noteIndex % notes.cap() ]);
	        setGain(gains[ noteIndex % gains.cap() ]);
	        durs[ noteIndex % durs.cap() ] => durNote;
	        // DEBUG
	        setNoteOnOff(1);
	        noteIndex++; // increment the counter for next pass
	    }
	    resolution => now;
	    resolution -=> durNote; // reduce duration of this note by the resloution
	}
}
0=> int counter;
while (true){
	if (debug) { <<< section, "keeping parent alive", counter++ >>>;}
	1::second => now; // keep the parent alive

}
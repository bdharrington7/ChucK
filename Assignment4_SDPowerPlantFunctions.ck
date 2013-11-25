// Assignment 4: SD Power Plant

// requirements:
// 30 seconds
// only midi notes in Eb Mixolydian mode: 51, 53, 55, 56, 58, 60, 61, 63
// quarter notes 0.6::second long
// Use of Osc, SndBuf, if / else, for / while, vars, comments,
// Std.mtof(), random nums, Arrays, panning, >= 3 functions

0 => int debug; // flag used for debugging purposes. set to 0 to hide all the text gen

<<< "Assignment 3: San Diego Power Plant" >>>; // just in case you didn't know

[51, 53, 55, 56, 58, 60, 61, 63] @=> int notes[];

// setup durations
2.4 => float wLen; // whole note length of time
wLen::second => dur w; //hole
       w / 2 => dur h; //alf
       w / 4 => dur q; //uarter, 2.4 / 4 = 0.6
       w / 8 => dur e; //ighth
       w / 16 => dur s; //ixteenth
       w / 32 => dur t; //hirtysecond

// load filenames
me.dir() + "/audio/" => string filepath;
string clickFn[6]; // there are only 5 clicks, but leaving index 0 blank to make it easier to remember
string hihatFn[5];
string kickFn[6];
string snareFn[4];
string stereofxFn[6];

for (1 => int i; i < 6; i++){
    if (i < clickFn.cap()){ // only add to the array if there's room
        filepath + "click_0" + i + ".wav" => clickFn[i];
        if(debug) <<< clickFn[i] >>>;  // for debugging, you'll see this a lot more below
    }
    if (i < hihatFn.cap()){
        filepath + "hihat_0" + i + ".wav" => hihatFn[i];
        if(debug) <<< hihatFn[i] >>>;
    }
    if (i < kickFn.cap()){
        filepath + "kick_0" + i + ".wav" => kickFn[i];
        if(debug) <<< kickFn[i] >>>;
    }
    if (i < snareFn.cap()){
        filepath + "snare_0" + i + ".wav" => snareFn[i];
        if(debug) <<< snareFn[i] >>>;
    }
    if (i < stereofxFn.cap()){
        filepath + "stereo_fx_0" + i + ".wav" => stereofxFn[i];
        if(debug) <<< stereofxFn[i] >>>;
    }
}

// id's
"snare" => string snare;
"kick" => string kick;
"hh" => string hh; // hihat
"hho" => string hho; //hihat open
"hclick" => string hc; // hi click
"lclick" => string lc; // lo click
"mel" => string mel;
"bass" => string bass;
"chord" => string chord;

// set up sound buffers
int inst[0]; // instrument indices
0 => inst[kick];
1 => inst[snare];
2 => inst[hh]; // hihat
3 => inst[hho]; // hihat open
4 => inst[hc];
5 => inst[lc];
6 => inst[mel];   // melody, some osc
7 => inst[bass];  // bass
8 => inst[chord];

SndBuf sndbuf[6];
Pan2 pan[sndbuf.cap() + 3];   // sndbuf.cap() + mel & bass

SinOsc chordOsc[3];
for (0 => int i; i < chordOsc.cap(); i++){
     chordOsc[i] => pan [ inst[ chord ] ];  // send to the same pan
     1.0 / 3 => chordOsc[i].gain;  // set the gain, chordOsc main will me [0]
}
TriOsc bassOsc => pan [ inst[ bass ] ];

SqrOsc melOsc => pan[ inst [mel] ];
0 => melOsc.gain;

// set up sound chains
Gain masterL => dac.left;
Gain masterR => dac.right;

for (0 => int i; i < pan.cap(); i++){
    if (i < sndbuf.cap()){  // only chuck existing SndBufs
        if (debug) { <<< "chuck sndbuf", i, "to pan" >>>; }
        sndbuf[i] => pan[i];
    }
    
    if (debug) { <<< "chuck pan", i, "to master" >>>; }
    // chuck each side of the pan to the corresponding master channel
    pan[i].left => masterL;
    pan[i].right => masterR;
}

// load sound files into SndBuf's
kickFn[1] => sndbuf[ inst[ kick ] ].read;
snareFn[2] => sndbuf[ inst[ snare ] ].read;
hihatFn[2] => sndbuf[ inst[ hh ] ].read;
hihatFn[3] => sndbuf[ inst[ hho ] ].read;
clickFn[2] => sndbuf[ inst[ hc ] ].read;
clickFn[1] => sndbuf[ inst[ lc ] ].read;

// set positions and volumes for drums as they won't change
1 => sndbuf[ inst[ kick ] ].gain;
1 => sndbuf[ inst[ snare ] ].gain;
0.25 => sndbuf[ inst[ hh ] ].gain;
0.25 => sndbuf[ inst[ hho ] ].gain;

-0.5 => pan[ inst[ hh ] ].pan => pan[ inst[ hho ] ].pan;
0.5 => pan[ inst[ snare ] ].pan;

// prevent all sndbufs from playing
for (0 => int i; i < sndbuf.cap(); i++){
    sndbuf[i].samples() => sndbuf[i].pos;
}

/***** Fuctions *****/
// separate functions to set up melodies / chords,
// won't have any timing built in, will be taken care of by the drums, 
// but will get note params

// drums functions, pass durs in to determine how long to run
[1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 0] @=> int kick_ptn[];
[0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1] @=> int snare_ptn[];
[1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2] @=> int hh_ptn[];

0::second => dur accrued; // total time accrued
0 => int beat; // what beat we're on
-1 => int lastBeat; // keep track if we increment to the next element in the pattern
0 => int canReset; // prevent endless repositioning if we stay on the same position for a while
// drum function: 
fun void drumFor(dur len){
    t/kick_ptn.cap() => dur resolution; // resolution, must be <= smallest note, div by array size to make even
    // get the length of the array easier calcs
    Math.min(kick_ptn.cap(), Math.min(snare_ptn.cap(), hh_ptn.cap())) $ int => int al; // smallest array length
    while ( len > 0::second ) {
        // index is the ((accrued / ((wLen/al)::second)) $ int) % al
        // ((wLen/al)::second)) is the fraction of the array we've been through,
        // cast to an int to get a valid index (floor of the float), mod by al to loop. 
        // this allows the time signature to be flexible.
        ((accrued / ((wLen/al)::second)) $ int) % al => beat;
        //if (debug) { <<< "Beat:", beat >>>; }
        if (lastBeat != beat){ // the beat incremented
            1 => canReset;
            beat => lastBeat;
        }
        if (canReset && kick_ptn[beat] == 1){
            if (debug) { <<< "=Kick" >>>; }
            0 => sndbuf [ inst[ kick ] ].pos;
        }
        
        if (canReset && snare_ptn[beat] == 1){
            if (debug) { <<< "==Snare" >>>; }
            0 => sndbuf [ inst[ snare ] ].pos;
        }
        
        if(canReset){
            if (debug) { <<< "click", hh_ptn[beat] & 1, hh_ptn[beat] & 2 >>>; }
            if ( (hh_ptn[beat] & 0x1) > 0 ){ // bitwise ops let me put more instruments in
                if (debug) { <<< "===HiHat", hh_ptn[beat] & 1 >>>; }
                0 => sndbuf [ inst[ hh ] ].pos;
                sndbuf [ inst[ hho ] ].samples() => sndbuf [ inst[ hho ] ].pos; // stop the hho
            }
            if ( (hh_ptn[beat] & 0x2) > 0){
                if (debug) { <<< "===HiHatOpen", hh_ptn[beat] & 2 >>>; }
                0 => sndbuf [ inst[ hho ] ].pos;
            }
            
            if ( (hh_ptn[beat] & 0x4) > 0){
                if (debug) { <<< "===Click", hh_ptn[beat] & 4 >>>; }
                0 => sndbuf [ inst[ hc ] ].pos;
            }
            
            if ( (hh_ptn[beat] & 0x8) > 0){
                if (debug) { <<< "===Click", hh_ptn[beat] & 4 >>>; }
                0 => sndbuf [ inst[ hc ] ].pos;
            }
        }
        
        // set the flag to false after all checks have been made
        0 => canReset;
        
        // let time fly
        resolution => now;
        // account for the time spent
        accrued + resolution => accrued;
        len - resolution => len;
    }
}

// sets all the melody oscs to the same level / 3
fun void setChordGain(float gain){
    for (0 => int i; i < chordOsc.cap(); i++){
        gain / 3 => chordOsc[i].gain;
    }
}

// sets a chord based on the melody root note
fun void setChord(int rootNote, string flavor){
    4 => int mid;
    if (flavor == "minor") {
        3 => mid;
    } else { // default to major
        
    }
    
    Std.mtof(rootNote) => chordOsc[0].freq;
    Std.mtof(rootNote + mid) => chordOsc[1].freq;
    
    Std.mtof(rootNote + 7) => chordOsc[2].freq;
}

fun void setBassNote(int note){
    Std.mtof(note-24) => bassOsc.freq;
}

fun void setBassGain(float gain){
    gain => bassOsc.gain;
}

fun void setBassNote(int note, float vol){
    setBassNote(note);
    vol/2 => bassOsc.gain;
}


// helper functions
fun void setMasterGain(float gain){
    gain => masterL.gain;
    gain => masterR.gain;
}

fun void setPan(Pan2 p, float dir){
    if (dir > 1){
        1 => p.pan;
    } else if (dir < -1){
        -1 => p.pan;
    } else {
        dir => p.pan;
    }
}

fun void setMelN(int note){ // set melody note
    Std.mtof(note) => melOsc.freq;
}

fun void setMelNV(int note, float gain){ // note and vol
    Std.mtof(note) => melOsc.freq;
    gain => melOsc.gain;
}

fun void setMelNVP(int note, float gain, float p){ // note, vol, pan
    Std.mtof(note) => melOsc.freq;
    gain => melOsc.gain;
    Math.sin(p) => pan [inst [mel] ].pan;
}

fun void setMelNP(int note, float p){ // note and pan
    Std.mtof(note) => melOsc.freq;
    Math.sin(p) => pan [inst [mel] ].pan;
}


fun void setPattern(string which, int pattern[]){
    if (which == snare){
        pattern @=> snare_ptn;
    } else if (which == hh){
        pattern @=> hh_ptn;
    } else {
        pattern @=> kick_ptn;
    }
}

// setup 
"major" => string major;
"minor" => string minor;

/***** Main function ****/
setChordGain(1);
0.7 => bassOsc.gain;

//now + 3::second => time future;
0 => int count;
// intro
while( count < 2 ) {
     // call the functions
     
     setChord(notes[0], major);
     setBassNote(notes[0]);
     drumFor(w);
     setChord(notes[5], major);
     setBassNote(notes[5]);
     drumFor(h);
     setChord(notes[6], minor);
     drumFor(q);
     
     setChord(notes[3], major);
     setBassNote(notes[3]);
     if ( count == 1) break;
     drumFor(q);
     ++count;
}

setChordGain(0);
setBassGain(0);
setPattern(snare, [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1]);
setPattern(kick, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
setPattern(hh, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
drumFor(q);

setPattern(snare, [0, 0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1]);
setPattern(kick,  [1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0]);
setPattern(hh,    [1, 5, 1, 10, 1, 5, 1, 1, 1, 1, 1, 2]);
snare_ptn.cap() => int len;
setChordGain(1);
setBassGain(1);
0 => count;
while (count < 4 ){  // change it up 
    
    setChord(notes[0], major);
    setBassNote(notes[0]);
    setMelNVP(notes[0], 0.07, Math.random());
    drumFor(q);
    setMelN(notes[7]);
    drumFor(q);
    
    setMelNV(0, 0);
    setChord(notes[2], minor);
    setBassNote(notes[2]);
    drumFor(h); // rest melody
    
    setChord(notes[4], major);
    setBassNote(notes[1]);
    drumFor(q-(3*(w/len)));
    setMelNVP(notes[0]+12, 0.07, Math.random()); // pan?
    drumFor(w/len); // putting notes on the beat
    setMelNP(notes[1]+12, Math.random());
    drumFor(w/len); 
    setMelNP(notes[2]+12, Math.random());
    drumFor(w/len);
    setMelNP(notes[1]+12, Math.random());
    drumFor(q);
    setMelNV(0, 0);
    setChord(notes[6], major);
    setBassNote(notes[6]-12);
    drumFor(q+(3*(w/len)));
    ++count;
}

setChord(notes[0], major);
setBassNote(notes[0]);

w => now;
 

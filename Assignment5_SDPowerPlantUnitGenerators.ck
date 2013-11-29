// Assignment 5: San Diego Power Plant
/*  Title: The Generators
    Author: Brian Harrington
    Assignment: 5 - Unit Generators
    Soundcloud link: https://soundcloud.com/destruction_synthesis/song-5-the-generators
*/
// Requirements: 30 second comp using unit generators
// STK instruments
// only Db Phrygian: [49, 50, 52, 54, 56, 57, 59, 61]
// quarter notes are 0.75 seconds
// Use of Oscillator, SndBuf, at least one STK instrument, 
// if/else, for/while, variables, comments, Std.mtof(), Random, 
// use of arrays, Panning, Functions

<<< "Assignment 5: SD Power Plant Unit Generators" >>>;

0 => int debug; // debugging flag, set to 1 to see debug output

// global instrument id's
// sndBuf Names
"kick" => string kick;
"snare" => string snare;
"hh" => string hh; // hihat
"hho" => string hho; //hihat open
"hclick" => string hc; // hi click
"lclick" => string lc; // lo click

// Osc names
"mel" => string mel;
"bass" => string bass;
"chord" => string chord;

// stk Names
"sk" => string sk;

// global instrument array. 
StifKarp stif;

// makes it easier to loop over all instruments
[kick,snare,hh,hho,hc,lc] @=> string sndBufNames[];
[mel,bass,chord] @=> string oscNames[];
[sk] @=> string stkNames[];

string names[0];
// aggregate names
for (0 => int i; i < sndBufNames.cap(); i++){
    names << sndBufNames[i];
}

for (0 => int i; i < oscNames.cap(); i++){
    names << oscNames[i];
}
for (0 => int i; i < stkNames.cap(); i++){
    names << stkNames[i];
}


// global variables
int scale[]; // note array
dur resolution;


/* SETUP FUNCTION: setup
main set up function, calls other setup functions */
fun void setup(){
    
    [49, 50, 52, 54, 56, 57, 59, 61] @=> scale;
    
    setupNoteDurations(3.0); // quarter (0.75)*4 = 3.0 (whole), resolution gets set here
    setupFileNames();
    setupDrums(1);
    setupMelodies(1);
    setupSoundChains();
    
}

/* SETUP FUNCTION: setupNoteDurations
sets up all the note durations and fractions thereof */
// global variables
float wLen;
dur wh; //ole
dur ha; //lf
dur qu; //arter, 3.0 
dur ei; //ghth
dur si; //xteenth
dur th; //irtysecond
dur dw; // dotted whole == whole + half
dur dh; // (half + quarter)
dur dq; // (quarter + eighth)
dur de; // (eighth + sixteenth)
dur ds; // (sixteenth + thirtysecond)
fun void setupNoteDurations(float wholeNoteDur){
    if (debug) { <<< "Setting note durations: whole note is", wholeNoteDur >>>; }
    wholeNoteDur => wLen; // whole note length of time
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
    
    //set the resolution to smallest note
    th => resolution;
}

// global variables
string clickFn[6]; // there are only 5 clicks, but leaving index 0 blank to make it easier to remember
string hihatFn[5];
string kickFn[6];
string snareFn[4];
string stereofxFn[6];

/* SETUP FUNCTION: setupFileNames
setup for the sound buffer array names */
fun void setupFileNames(){
    if(debug) { <<< "Setting up file names" >>>; }
    me.dir() + "/audio/" => string filepath;
    ".wav" => string fileType;
    for (1 => int i; i < 6; i++){
        if (i < clickFn.cap()){ // only add to the array if there's room
            filepath + "click_0" + i + fileType => clickFn[i];
            if(debug) <<< clickFn[i] >>>;  // for debugging, you'll see this a lot more below
        }
        if (i < hihatFn.cap()){
            filepath + "hihat_0" + i + fileType => hihatFn[i];
            if(debug) <<< hihatFn[i] >>>;
        }
        if (i < kickFn.cap()){
            filepath + "kick_0" + i + fileType => kickFn[i];
            if(debug) <<< kickFn[i] >>>;
        }
        if (i < snareFn.cap()){
            filepath + "snare_0" + i + fileType => snareFn[i];
            if(debug) <<< snareFn[i] >>>;
        }
        if (i < stereofxFn.cap()){
            filepath + "stereo_fx_0" + i + fileType => stereofxFn[i];
            if(debug) <<< stereofxFn[i] >>>;
        }
    }
}

dur durs[0][0]; // duration double array. We set int arrays to the key for the instrument
float gains[0][0];
int notes[0][0];

/* SETUP FUNCTION: setupDrums
sets up the drum parts */
SndBuf percBuf[0]; // sound buffers for drums and other wav percussion
fun void setupDrums(int track){
    if(debug) { <<< "Setting up drums" >>>; }
    // setup SndBufs in array
    for (0 => int i; i < sndBufNames.cap(); i++){
        new SndBuf @=> percBuf[sndBufNames[i]];
    }
    if (debug) {
        <<< "setting to track", track >>>; 
    }
    if (track == 1){
        kickFn[1] => percBuf[kick].read;
        snareFn[2] => percBuf[snare].read;
        hihatFn[2] => percBuf[hh].read;
        hihatFn[3] => percBuf[hho].read;
        
        // I know there's a way to calculate this, might come back to it
        [si, ei, ei, ei, si, ei, si, ei, de] @=> durs[kick]; 
        [1., 1.] @=> gains[kick];  // for percussion we'll use gain as a trigger
        [qu, ha, qu] @=> durs[snare]; // half notes, offset by a quarter
        [0., 3.5, 3.5] @=> gains[snare];
        [th] @=> durs[hh];
        [.6, .3, .4, .3] @=> gains[hh]; // gives kind of a pulsing effect
        
        if (debug) { <<< "durs array cap:",durs[kick].cap() >>>; }
    } else { // silence all drums
        for (0 => int i; i < sndBufNames.cap(); i++){
            "" => percBuf[sndBufNames[i]].read;
        }
    }
    // set all percussion to not play
    for (0 => int i; i < sndBufNames.cap(); i++){
        percBuf[sndBufNames[i]].samples() => percBuf[sndBufNames[i]].pos;
    }
    
}

/* SETUP FUNCTION: setupMelodies
sets up a particular melody. Sets up with normal sinOscs that can be changed later */
Osc oscs[0];
for (0 => int i; i < oscNames.cap(); i++){
    if (mel == oscNames[i]){
        new SqrOsc @=> oscs[oscNames[i]];
    }
    else {
        new SinOsc @=> oscs[oscNames[i]];
    }
    0 => oscs[oscNames[i]].gain; // turn off by default
}
fun void setupMelodies(int melody){
    if (melody == 1){
        if (debug) { <<< "setting up main melody" >>>; }
        // stk
        [de, si] @=> durs[sk];
        [.4] @=> gains[sk];
        [scale[0]-24, scale[6]-36, scale[0]-24, scale[2]] @=> notes[sk];
        
        // osc
        // back up the bass
        [de, si] @=> durs[bass];
        [.9, .9, .9, .0] @=> gains[bass];
        [scale[0]-12, scale[6]-24, scale[0]-12, scale[2]] @=> notes[bass];
        
        
    }
    else if (melody == 2){
        if (debug) { <<< "setting up melody 2" >>>; }
        // add melody
        [si, ei, si, ei, si, ei, si, ei, si, si, si] @=> durs[mel];
        [scale[6],scale[0]+12] @=> notes[mel];
        [.15] @=> gains[mel];
    }
    else if (melody == 3){
        if (debug) { <<< "setting up melody 3" >>>; }
        // add melody
        [wh, wh, dh, qu, wh] @=> durs[chord];
        [.3] @=> gains[chord];
        [scale[5]+12, scale[4]+12, scale[5]+12, scale[6]+12, scale[4]+12] @=> notes[chord];
        
        [de] @=> durs[mel];
        [scale[0], scale[2], scale[4], scale[7], scale[4], scale[2]] @=> notes[mel];
    }
    else if (melody == 4){
        [0.] @=> gains[mel];
        [0.] @=> gains[chord];
    }
    else {
        <<< "Error: incorrect choice" >>>;
    }
}

/* SETUP FUNCTION: setupSoundChains
sets up all the pans and other parts of sound chains */
Pan2 pan[0];
NRev rev[0];
Gain masterL => dac.left;
Gain masterR => dac.right;
fun void setupSoundChains(){
    if (debug) { <<< "Setting up sound chains:" >>>; }
    // set up the pans for all instruments
    if (debug) { <<< "   Setting up pans" >>>; }
    for (0 => int i; i < names.cap(); i++){
        if (debug) { <<< "      pan for", names[i] >>>; }
        new Pan2 @=> pan[names[i]];
        new NRev @=> rev[names[i]];
        0.05 => rev[names[i]].mix; // make it a little closer to what we want
        pan[names[i]].left => masterL;
        pan[names[i]].right => masterR;
    }
    if (debug) { <<< "   Chaining sndbufs to pans" >>>; }
    // set up drums and other sndbufs
    for (0 => int i; i < sndBufNames.cap(); i++){
        sndBufNames[i] => string currName;
        if (debug) { <<< "      sndbuf for", currName >>>; }
        percBuf[currName] => rev[currName] => pan[currName];
    }
    // set up oscs
    for (0 => int i; i < oscNames.cap(); i++){
        oscNames[i] => string currName;
        if (debug) { <<< "      osc for", currName >>>; }
        oscs[currName] => rev[currName] => pan[currName];
    }
    
    // set up instruments
    for (0 => int i; i < stkNames.cap(); i++){
        stkNames[i] => string currName;
        stif => rev[currName] => pan[currName];
    }
    
    // set up pans for drums
    -0.5 => pan[snare].pan;
    0.4 => pan[hh].pan;
}

// MAIN PROGRAM
setup();
dur remaining[0]; // remainder durations to check to advance or not
for (0 => int i; i < names.cap(); i++){ // initialize the remains
    0::second => remaining[names[i]];
}
int indexOf[0]; // index for instrument in its dur array
// initialize indices
for (0 => int i; i< names.cap(); i++){
    0 => indexOf[names[i]];
}


// intro
SndBuf sfx;
stereofxFn[4] => sfx.read;
0 => sfx.pos;
2 => sfx.gain;
0.38 => sfx.rate;
sfx => dac;
wh*2 => now;

0::second => dur accrued;
0 => int qNote; // which quarter note are we on?
0 => int justChanged;
while (true) {
    
    if (accrued == wh*2){
        // introduce melody
        if (debug) <<< "CALLING SETUP MELODIES">>>;
        setupMelodies(2);
    }
    
    if (accrued == wh*4){
        // introduce melody
        if (debug) <<< "CALLING SETUP MELODIES">>>;
        setupMelodies(3);
        0 => indexOf[chord];
    }
    
    if (accrued == wh*8-si){
        // introduce melody
        if (debug) <<< "Hush MELODIES">>>;
        setupMelodies(4);
        0 => oscs[mel].gain;
        0 => oscs[chord].gain;
    }
    if (accrued > wh*9){
        // fade
        if (masterL.gain() <= 0){
            break;
        }
        0.02 => float fadeRate;
        masterL.gain() - fadeRate => masterL.gain;
        masterR.gain() - fadeRate => masterR.gain;
    }
    
    // check to increment for drums
    for (0 => int n; n < names.cap(); n++){
        names[ n ] => string currName;
        if (debug > 1) { <<< "working on", currName >>>; }
        if(remaining[ currName ] <= 0::second){
            if(debug) { <<< currName, "has expired" >>>; }
            // reset the position, 
            gains[currName] @=> float currGains[]; // get the gains arr for this instrument
            notes[currName] @=> int currNotes[]; // get the notes array
            1 => int gCapacity => int fCapacity; // don't want to divide by zero, mod by 1 is always 0
            if (null != currGains){
                currGains.cap() => gCapacity;
                
            }
            if (null != currNotes){
                currNotes.cap() => fCapacity;
            }
            if (currName == mel){
                if (debug >1) { <<< currName, "index is", indexOf[currName] >>>; }
                if (debug >1) { <<< "fCapacity is", fCapacity >>>; }
                if (debug >1) { <<< "gCapacity is", gCapacity >>>; }
            }
            
            (indexOf[currName] % gCapacity) => int currGainsIndex;
            (indexOf[currName] % fCapacity) => int currNotesIndex;
            
            if (currName == mel){
                if (debug >1 ) { <<< "currGains index is", currGainsIndex >>>; }
                if (debug >1 ) { <<< "currNotes index is", currNotesIndex >>>; }
            }
            
            // check for null, and then get index mod by that array size
            if (null != currGains){ 
                
                if (null != percBuf[currName] && currGains[currGainsIndex] > 0.){  // only do for sound buffers
                    if (debug > 1) { <<< "resetting", currName >>>; }
                    0 => percBuf[ currName].pos;
                    Math.random2f(.97, 1.02) => percBuf[currName].rate; // tiny bit of randomness for realism
                    currGains[currGainsIndex] => percBuf[ currName].gain;
                }
                if (debug > 1) { <<< "... done" >>>; }
                
                if (null != oscs[currName]){
                    if (debug) { <<< "setting osc", currName, "to", currNotes[currNotesIndex], "and", currGains[currGainsIndex] >>>; }
                    Std.mtof(currNotes[currNotesIndex]) => oscs[currName].freq;
                    currGains[currGainsIndex] => oscs[currName].gain;
                }
                // trouble putting Stk's in an array, so we reference them by name...:(
                if (sk == currName){
                    if (debug >1) { <<< "modifying STK", currName, "Gains index", currGainsIndex >>>; }
                    if (currGains[currGainsIndex] > 0.){
                        if (debug) { <<< "turning Note ON" >>>; }
                        Std.mtof(currNotes[currNotesIndex]) => stif.freq;
                        currGains[currGainsIndex] => stif.noteOn;
                    }
                    else {
                        if (debug >1) { <<< "turning note OFF" >>>; }
                        -currGains[currGainsIndex] => stif.noteOff;
                    }
                }
                
            }
            
            //reset remaining duration,
            durs[ currName ] @=> dur currDurArray[];
            if (null != currDurArray){
                currDurArray[ indexOf[ currName ] % currDurArray.cap() ] => remaining[ currName ];
            }
            
            //and increment the counter
            if (debug && currName == sk) { <<< "Incrementing", currName, "from", indexOf[ currName ] >>>; }
            indexOf[ currName ]++;
        }
    }
    
    // calculate the remaining time left
    for (0 => int n; n < names.cap(); n++){
        resolution -=> remaining[names[n]]; // reduce the remaining duration by the resolution
    }
    
    if (accrued % qu == 0::second){
        ((accrued / wh) * 4 + 1) $ int => qNote;
        if (debug) <<< "Quarternote: ", qNote >>>;
    }
    
    resolution => now; // pass time
    resolution +=> accrued;
}
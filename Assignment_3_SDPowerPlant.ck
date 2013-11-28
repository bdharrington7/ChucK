// Assignment 3: SD power plant
// requirements: array of strings to load sound files
// reverse a sound at least once
// use modulo
// use the D Dorian scale
// quarter notes are 0.25::second
// use of oscillator, sndbuf, negative rate (reverse), 
// if else, for or while, Std.mtof(), random, arrays, panning

0 => int debug; // flag used for debugging purposes. set to 0 to hide all the text gen

<<< "Assignment 3: San Diego Power Plant" >>>; // just in case you didn't know

// time params
0.25::second => dur quarter;
quarter*2 => dur half;
quarter*4 => dur whole;
quarter/2 => dur eighth;
quarter/4 => dur six;
half+quarter => dur dotHalf; // dotted half note
whole+half => dur dotWhole; // dotted whole

// set up sound chains
Gain masterL => dac.left;
Gain masterR => dac.right;

// drums
SndBuf kick => Pan2 panKick;
SndBuf snare => Pan2 panSnare;
SndBuf hh => Pan2 panHH; // hi hat
SndBuf hho => panHH;     // hi hat open

// sfx
SndBuf sfx => Pan2 panSfx;

// oscillators
SqrOsc mel => Pan2 panMel; // melody oscillator
SinOsc bass => Pan2 panBass; // bass

// send channels to the masters
panKick.left => masterL;
panSnare.left => masterL;
panHH.left => masterL;
panSfx.left => masterL;
panMel.left => masterL;
panBass.left => masterL;

panKick.right => masterR;
panSnare.right => masterR;
panHH.right => masterR;
panSfx.right => masterR;
panMel.right => masterR;
panBass.right => masterR;

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

// load up the sound buffers
kickFn[5] => kick.read;  // for intro, change back to 1 after
snareFn[2] => snare.read;
hihatFn[2] => hh.read;
hihatFn[3] => hho.read;
stereofxFn[1] => sfx.read;

// set panning
0.7 => panHH.pan;
-0.4 => panSnare.pan;

// set up scale and timing arrays for melody. these have to be the same length.. kinda
[62,   65,  69,     60,     67,     72,     69,        62,   65,  69,     60,     67,     72,     69,          0,      65,     64   ] @=> int melody[];
[whole,half,quarter,quarter,quarter,quarter,whole+half,whole,half,quarter,quarter,quarter,quarter,dotHalf,quarter,quarter,quarter] @=> dur timingMel[];

// bass stuff in D
[38, 50] @=> int bassLine[]; // octave
[quarter, quarter] @=> dur timingBass[];

// hold up the music
kick.samples() => kick.pos;
snare.samples() => snare.pos;
hh.samples() => hh.pos;
hho.samples() => hho.pos;
sfx.samples() => sfx.pos;

0 => mel.gain;
0 => bass.gain;
1.5 => snare.gain;
0.6 => hh.gain => hho.gain;

0 => int counter; // number to mod to get the beat number, incremented in loop
16 => int numBeats; // number of beats in a loop
4 => int measures; // number of measures
0 => int prog;  // keeping track of how many times we do the loop +fill (4 meas)

0 => int noteIndex; // index for the melody array
0 => int bassIndex; // for the bass array
0::second => dur durMel; // melody note duration
0::second => dur durBass; //bass

// resolution: smallest note we can handle in this loop
eighth => dur resolution;

// intro
-1.8 => kick.rate; // reverse sound
whole => now;

//reset the kick
kickFn[1] => kick.read;
kick.samples() => kick.pos;
1 => kick.rate;

0.05 => mel.gain;
0.6 => bass.gain;

0 => int melChanged; // used to see if we changed the tune already
time start;
if (debug) now => start;  // start the timer to see length

while (prog < 4) {
    counter % numBeats => int beat; // what beat are we on?
    
    (counter / numBeats) % measures => int measure; // this will give a measure each containing numBeats notes
    
    // let's make the hh and snare sound less perfect...
    Math.random2f(1.0, 1.03) => hh.rate;  // assigning random to rate bends the pitch a little,
    Math.random2f(.95, 1.03) => snare.rate; // making these instruments sound more real
    
    if (debug) <<< "C:", counter, " B:", beat, " M:", measure >>>;
    
    //Std.mtof(60) => mel.freq;
    
    if (measure == 3 && beat > numBeats/2) { // half of last measure
        // fill
        if (debug) <<< "fill" >>>;
        0 => snare.pos;
        0 => sfx.pos;
        if (beat == numBeats -1){ // ending the fill...
            prog++;
        }
    }
    else {
        sfx.samples() => sfx.pos;
        if (beat % 2 == 0){ // hihat(s)
            0 => hh.pos;
            if (debug) <<< "HH" >>>;
        }
        if (beat % 8 == 3){
            0 => hho.pos;
            if (debug) <<< "HHO" >>>;
        }
        if (beat % 4 == 0 || beat == numBeats-1){ // kick
            0 => kick.pos;
            if (debug) <<< "  kick" >>>;
        }
        if (beat % 4 == 2){ // snare
            0 => snare.pos;
            if (debug) <<< "    snare" >>>;
        }
    }
    
    // change the bass line for the last measure
    if (measure == measures-1){
        [31, 43] @=> bassLine;
    }
    else {
        [38, 50] @=> bassLine; // not very efficient setting this array on every iteration but more readable
    }
    
    // change the melody two bars in. Some might hate this, some might love it...
    if (melChanged == 0 && prog == 2){
        if (debug) <<< "Switching melody" >>>;
        [74,     72,     69,     67,     69,     72,     69,      74,  72,  69,  67,  67] @=> melody;
        [dotHalf,quarter,dotHalf,quarter,quarter,quarter,dotWhole,half,half,half,half,whole+whole] @=> timingMel;
        1 => melChanged;
        0 => noteIndex;
    }
    
    // set the melodic note
    if (durMel <= 0::second) { // if the note ran out of time
        melody[noteIndex % melody.cap()] => int melNote;
        if (debug) <<< "Changing note to ", melNote >>>;
        Std.mtof(melNote) => mel.freq;
        timingMel[noteIndex % timingMel.cap()] => durMel;
        
        noteIndex++; // increment the counter for next pass
    }
    
    if (durBass <= 0::second){
        bassLine[bassIndex % bassLine.cap()] => int bassNote;
        if (debug) <<< "Changing bass to ", bassNote >>>;
        
        Std.mtof(bassNote) => bass.freq;
        timingBass[bassIndex % timingBass.cap()] => durBass;
        
        bassIndex++;
    }
    
    
    
    resolution => now;  // let time pass,
    durMel - resolution => durMel; // set the remaining time
    durBass - resolution => durBass;
    
    
    counter++;
}
// ending, with more cowbell
sfx.samples() => sfx.pos;
//0 => mel.gain;
//0 => bass.gain;
Std.mtof(62) => mel.freq; // all in the D dorian scale
Std.mtof(38) => bass.freq;
filepath + "cowbell_01.wav" => snare.read;
1::second => now;



if (debug) <<< "Total time:", (now - start)/second, "seconds" >>>;
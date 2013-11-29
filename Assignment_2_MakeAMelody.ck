/*  Title: Make a Melody
    Author: Brian Harrington
    Assignment: 2 - Libraries and arrays
    Soundcloud link: https://soundcloud.com/destruction_synthesis/assignment-2-makeamelody
*/

<<< "Assignment 2 - San Diego Power Plant" >>>;

TriOsc so => Pan2 p => dac; // bass oscillator
SinOsc mel => Pan2 q => dac; // melody oscillator

0.2 => mel.gain; // melody volume
0.6 => so.gain;  // bass volume
0 => p.pan;

// note durations
0.25::second => dur quarter;
quarter*2 => dur half;
quarter*4 => dur whole;
quarter/2 => dur eighth;
quarter/4 => dur sixteenth;

0 => int debug; // debug flag

// create the scale array
[50, 52, 53, 55, 57, 59, 60, 62] @=> int dorian[];

// create the bass array
int bassDorian[8];
for (0 => int i; i < dorian.cap(); i++){
    dorian[i]-12 => bassDorian[i];
}

// create the melody array 
int melodyDorian[8];
for (0 => int i; i < dorian.cap(); i++){
    dorian[i]+12 => melodyDorian[i];
}

/// start?
now + 30::second => time songLength;

while (now < songLength){ 
    
    // create the rhythm array. 
    0::second => dur totalTime;  // used to keep track of how much time we aggregated so far
    dur rhythm[0];  // rhythm array we're appending to
    [sixteenth,eighth,quarter,half,whole] @=> dur rhythmTypes[]; // choices for note length
    rhythmTypes.cap()-1 => int choiceRange;  // might need to cut down choices to fill out a bar
    whole => dur barLen;  // how long do we want each bar?
    
    while (totalTime < barLen){  // number of whole notes in a bar
        Math.random2(0,choiceRange) => int indexR; // rhythm index
        rhythm << rhythmTypes[indexR];   // append to the array
        totalTime + rhythmTypes[indexR] => totalTime;
        if (debug) { <<< totalTime >>>; }
        
        // calculate time left to fill. Here, we find the largest gap we can still fill, and 
        // eliminate the choices we cant fit in the time we have left
        barLen - totalTime => dur timeLeft;
        if (timeLeft < sixteenth) { break; } // shouldn't get here
        else if (timeLeft < eighth) { rhythmTypes.cap() -5 => choiceRange; } // eighth notes out  ""
        else if (timeLeft < quarter) { rhythmTypes.cap() -4 => choiceRange; } // quarter notes out ""
        else if (timeLeft < half) { rhythmTypes.cap() -3 => choiceRange; } // half notes out as well as above
        else if (timeLeft < whole){ rhythmTypes.cap() -2 => choiceRange; } // whole notes are out
        
        
    }
    
    // sanity check
    if (debug){
        0::second => dur aggregateTime;
        for (0 => int i; i < rhythm.cap(); i++){
            rhythm[i] + aggregateTime => aggregateTime;
        }
        
        if (aggregateTime == barLen){
            <<< "Time is sound" >>>; // wha?
        }
        else {
            <<< "Time is out of whack" >>>;
        }
    }
    
    
    // create a random bass line
    int bass [4]; // we'll keep this at 4 so the song makes sense kinda
    for (0 => int i; i < bass.cap(); i++){
        Math.random2(0, dorian.cap()-1) => bass[i];
    }
    // debug
    if(true){
        <<< "bass line: ">>>;
        for (0 => int i; i < bass.cap(); i++){
            <<< bass[i] >>>;
        }
    }
    // create a random melody
    // candidates: 3272, 44560145, 32364403, 67736701
    int melody[Math.random2(4,8)];
    for (0 => int i; i < melody.cap(); i++){
        Math.random2(0, dorian.cap()-1) => melody[i];
    }
    
    // debug
    if(true){
        <<< "melody line: ">>>;
        for (0 => int i; i < melody.cap(); i++){
            <<< melody[i] >>>;
        }
    }
    
    // calculate the pan direction for each note in the melody
    float pans[8];  // 8 is the number of notes in the scale, so we assign a pan position to each note
    2.0 / (8-1) => float panInc; // pan increment: pan span (2) / possible notes in melody
    -1.0 => float panPosition; // starting point for pan
    for (0 => int i; i < melody.cap(); i++){
        panPosition => pans[i];
        if(debug){ <<< "Pans[", i, "]:",pans[i] >>>; }
        panPosition + panInc => panPosition;  // increment panPosition by panInc
    }
    
    if(debug){
        <<< "Mel len:", melody.cap() >>>;
        <<< "Pan len:", pans.cap() >>>;
        <<< "Rhy len:", rhythm.cap() >>>;
        // <<< >>>;
    }
    
    0 => int firstBars;
    while (true) {
        for (0 => int b; b < bass.cap(); b++){
            Std.mtof(bassDorian[bass[b]]) => float bassHz;
            bassHz => so.freq;
            if(debug) { <<< "bass Hz:",bassHz >>>; }
            
            for (0 => int r; r < rhythm.cap(); r++){
                // calculate the pan: 
                
                // get a melody note that is the mod of the rhythm index (no out of bounds)
                r % melody.cap() => int mIndex;
                
                // use that index to choose a panning position
                pans[melody[mIndex]] => q.pan;
                
                Std.mtof(melodyDorian[melody[mIndex]]) => float melHz;
                melHz => mel.freq;
                if(debug) { <<< "mel Hz:",melHz, r, melody[mIndex], pans[melody[mIndex]] >>>; }
                rhythm[r] => now;
            }
        }
        firstBars +1 => firstBars;
        if (firstBars >= 2) break;
    }
}


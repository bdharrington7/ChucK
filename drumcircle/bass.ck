// bass.ck
/*  Title: Classy San Diego Powerplant
    Author: Anonymous
    Assignment: 7 - Classes and Objects
    Soundcloud link: TODO add link
*/
BPM tempo;
Scale scale;

"BASS:" => string section;

Std.atoi(me.arg(0)) => int track; // get the drum track we want to play

if (track <= 0){
    <<< section, "invalid track (", track, ") exiting" >>>;
    me.exit();
}

Std.atoi(me.arg(1)) => int debug; // debug flag that can be set when this file is loaded, defaults to 0, always last flag



// setup sound chain
TriOsc osc1 => dac;
Rhodey vox =>  dac;
//0.05 => rev.mix;


int noteOffsets[]; // note array for melody keys
string durs[];  // durations for each note
float gains[]; // gains for each note

if (track == 1){ // intro / main?
    if (debug) { <<< section, "setting up track 1" >>>; }
//            1            2       3   4                 5    6                 7          8             9        10         11 12            13            14           15            16 
    [0, 7] @=> noteOffsets;
    [    "si"] @=> durs;
    [    1. ] @=> gains; // only need one since it doesn't change
}
else {
    <<< section, "Pattern not set, aborting" >>>;
    me.exit();
}

// vars for the while loop
//tempo.th => dur resolution;    // resolution for the while loop's time passing
0::second => dur durNote; // keeps track of the note's remaining duration
0 => int noteIndex;       // index for the note in the different arrays
tempo.th => dur lastDuration;  // used to detect if there was a change in tempo

while(true){

	// set the melodic note
    if (durNote <= 0::second) { // if the note ran out of time
        //vox.clear(1);
        scale.sc[ scale.root + noteOffsets[ noteIndex % noteOffsets.cap() ] ] => int note; // add offset to the currrent root. This allows us to change keys
        if (debug) <<< section, "Changing note to", note >>>;
        Std.mtof(note) => osc1.freq;
        Std.mtof(note) => vox.freq;
        gains[ noteIndex % gains.cap() ] => osc1.gain;
        if (gains[ noteIndex % gains.cap() ] > 0.){
             gains[ noteIndex % gains.cap() ]/2 => vox.gain;
             vox.noteOn(1);
        }
        else {
            vox.noteOff(1);
        }
        tempo.durs(durs[ noteIndex % durs.cap() ]) => durNote;
        if (debug) { <<< section, "duration set to", durNote, "thirtysecond is", tempo.th >>>; }
        
        noteIndex++; // increment the counter for next pass
    }
    now => time start;
    tempo.th => now;
    if (debug)
    {
        now => time end;
        <<< "Elapsed time:", end - start >>>;
    }
    // we want the difference between the last duration and this new tempo in case there's a tempo change
    (tempo.th + (lastDuration - tempo.th)) -=> durNote; // reduce duration of this note by the resloution
    tempo.th => lastDuration;
}
// drums.ck
/*  Title: Classy San Diego Powerplant
    Author: Anonymous
    Assignment: 7 - Classes and Objects
    Soundcloud link: TODO add link
*/

public class Drums{
    // pre-constuctor
    BPM tempo;
    Debug db;

    "DRUMS:" => string section;
    1 => int play; // whether the while loop should continue

    0 => int debug;
    // 0.625 * 4 => float wLen; // quarter note is 0.625, wLen is whole note length

    // dur wh; //ole
    // if (debug) { <<< section, "Setting note durations: whole note is", wLen, "seconds" >>>; }
    // wLen::second => wh; //ole, we only need this duration for drums


    // load filenames, have to go to parent, then into audio dir
    me.dir(-1) + "/audio/" => string filepath;
    string clickFn[6]; // there are only 5 clicks, but leaving index 0 blank to make it easier to remember
    string hihatFn[5];
    string kickFn[6];
    string snareFn[4];
    string stereofxFn[6];

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

    // id's
    "kick" => string kick;
    "snare" => string snare;
    "hh" => string hh; // hihat
    "hho" => string hho; //hihat open
    "hclick" => string hc; // hi click
    "lclick" => string lc; // lo click

    [kick,snare,hh,hho,hc,lc] @=> string inst[];
    SndBuf sb[0]; // sound buffers for instruments
    Pan2 pan[0];  // pans for all these instruments
    NRev rev;
    Gain masterL => rev => dac.left;  // need two gains since it negates any pans through it
    Gain masterR => rev => dac.right; // pass both through the same reverb

    0.05 => rev.mix;
    0.6 => masterR.gain => masterL.gain;

    for (0 => int i; i < inst.cap(); i++){
        if (debug) { <<< section, "initialize SndBuf and Pan2 for", inst[i] >>>; }
        new SndBuf @=> sb[inst[i]];
        new Pan2 @=> pan[inst[i]];
        sb[inst[i]] => pan[inst[i]];
    }

    for (0 => int i; i < inst.cap(); i++){
        if (debug) { <<< section, "chuck pan", i, "to master" >>>; }
        // chuck each side of the pan to the corresponding master channel
        pan[inst[i]].left => masterL;
        pan[inst[i]].right => masterR;
    }

    if (debug) { <<< "Reading in ", kickFn[2]," to ", kick >>>; }
    kickFn[2] => sb[kick].read;
    sb[kick].samples() => sb[kick].pos;
    if (debug) { <<< "Reading in ", snareFn[2]," to ", snare >>>; }
    snareFn[2] => sb[snare].read;
    sb[snare].samples() => sb[snare].pos;
    if (debug) { <<< "Reading in ", hihatFn[2]," to ", hh >>>; }
    hihatFn[2] => sb[hh].read;
    sb[hh].samples() => sb[hh].pos;
    if (debug) { <<< "Reading in ", hihatFn[3]," to ", hho >>>; }
    hihatFn[3] => sb[hho].read;
    sb[hho].samples() => sb[hho].pos;


    // set positions and volumes for drums as they won't change
    if (debug) { <<< section, "setting gains" >>>; }
    1 => sb[ kick ].gain;
    1 => sb[ snare ].gain;
    0.25 => sb[ hh ].gain;
    0.25 => sb[ hho ].gain;

    if (debug) { <<< section, "setting pans" >>>; }
    -1 => pan[ hh ].pan => pan[ hho ].pan;
    0.5 => pan[ snare ].pan;

    int kick_ptn[];
    int snare_ptn[];
    int hh_ptn[];

    Shred loopChild;

    fun void playTrack(int track){
        db.flag => debug;
        1 => play; // set flag to play
        if (track <= 0){
            <<< "invalid track (", track, ") returning..." >>>;
            return;
        }
        if (track == 1){ // intro / main?
            if (debug) { <<< section, "setting up track 1" >>>; }
            reset();
        //   1     2     3     4     5     6     7     8     9    10    11    12    13    14    15    16 
            [1, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0] @=> kick_ptn;
            [0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0] @=> snare_ptn;
            [1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 2, 0, 0, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 2, 0] @=> hh_ptn;
            spork ~ playLoop();
        }
        else if (track == 2){ // second / verse?
            reset();
            if (debug) { <<< section, "setting up track 2" >>>; }  // this is where we fade out
            //   1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 
            [1, 0, 0, 0, 1, 1, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0] @=> kick_ptn;
            [0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0] @=> snare_ptn;
            [2, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 1, 1, 0, 0, 0] @=> hh_ptn;
            spork ~ playLoop() @=> loopChild;
            spork ~ fadeOut();
        }
        else {
            <<< section, "Kick pattern not set, aborting" >>>;
            me.exit();
        }
    }

    fun void fadeOut(){
        masterR.gain() => float begGain;
        while (play){
            if (debug) { <<< section, "Lowering master gain to", begGain >>>;}
            if (begGain > 0.05){
                0.05 -=> begGain;
            }
            else {
                0 => begGain;
            }
            
            begGain => masterR.gain => masterL.gain;
            0.2::second => now;
        }

    }

    fun void stop()
    {
        <<< "stopping drums" >>>;
        0 => play;
        loopChild.exit();  // doesn't seem to work, see below
        //1::ms => now; // let time pass for things to die
    }

    /* this doesn't seem to work as expected. Aside from the obvious concurrency race conditions, loopChild.exit() doesn't actually exit the class
    until a certain amount of time has passed */
    fun void reset(){
        if (debug) { <<< "resetting", section >>>; }
        0::second => dur accrued; // total time accrued
        0 => int beat; // what beat we're on
        -1 => int lastBeat; // keep track if we increment to the next element in the pattern
        0 => int canReset; // prevent endless repositioning if we stay on the same position for a while
        loopChild.exit();
        1::ms => now; // let time pass for things to die
    }

    0::second => dur accrued; // total time accrued
    0 => int beat; // what beat we're on
    -1 => int lastBeat; // keep track if we increment to the next element in the pattern
    0 => int canReset; // prevent endless repositioning if we stay on the same position for a while

    fun void playLoop(){
        /* Main loop where we play everything 
        */
        // get the length of the array easier calcs
        if (debug) { <<< section, "Getting ready to play loop" >>>; }
        Math.min(kick_ptn.cap(), Math.min(snare_ptn.cap(), hh_ptn.cap())) $ int => int al; // smallest array length
        //tempo.wh/al => dur resolution; // resolution, must be <= smallest note, div by array size to make even

        // resettals
        0::second => accrued; // total time accrued
        0 => beat; // what beat we're on
        -1 => lastBeat; // keep track if we increment to the next element in the pattern
        0 => canReset; // prevent endless repositioning if we stay on the same position for a while

        while ( play ) {
            // index is the ((accrued / ((wLen/al)::second)) $ int) % al
            // ((wLen/al)::second)) is the fraction of the array we've been through,
            // cast to an int to get a valid index (floor of the float), mod by al to loop. 
            // this allows the time signature to be flexible.
            ((accrued / ((tempo.wLen/al)::second)) $ int) % al => beat;
            
            if (lastBeat != beat){ // the beat incremented
                1 => canReset;
                beat => lastBeat;
                if (debug) { <<< "Beat:", beat >>>; }
            }
            if (canReset && kick_ptn[beat] == 1){
                if (debug) { <<< "=Kick" >>>; }
                0 => sb [ kick ].pos;
            }
            
            if (canReset && snare_ptn[beat] == 1){
                if (debug) { <<< "==Snare" >>>; }
                0 => sb [ snare ].pos;
            }
            
            if(canReset){
                //if (debug) { <<< "click", hh_ptn[beat] & 1, hh_ptn[beat] & 2 >>>; }
                if ( (hh_ptn[beat] & 0x1) > 0 ){ // bitwise ops let me put more instruments in
                    if (debug) { <<< "===HiHat", hh_ptn[beat] & 1 >>>; }
                    0 => sb [ hh ].pos;
                    sb [ hho ].samples() => sb [ hho ].pos; // stop the hho
                }
                if ( (hh_ptn[beat] & 0x2) > 0){
                    if (debug) { <<< "===HiHatOpen", hh_ptn[beat] & 2 >>>; }
                    0 => sb [ hho ].pos;
                }
                
                if ( (hh_ptn[beat] & 0x4) > 0){
                    if (debug) { <<< "===Lo Click", hh_ptn[beat] & 4 >>>; }
                    0 => sb [ lc ].pos;
                }
                
                if ( (hh_ptn[beat] & 0x8) > 0){
                    if (debug) { <<< "===Hi Click", hh_ptn[beat] & 8 >>>; }
                    0 => sb [ hc ].pos;
                }
            }
            
            // set the flag to false after all checks have been made
            0 => canReset;
            
            // let time fly
            tempo.wh/al => now;
            // account for the time spent
            tempo.wh/al +=> accrued;
        }
    }
}




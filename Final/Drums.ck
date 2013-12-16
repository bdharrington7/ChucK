// Drums.ck
/*  Title: The Final Meltdown
    Author: Anonymous
    Assignment: 8 - Final
    Soundcloud link: TODO add link
*/

public class Drums{
    // pre-constuctor
    //BPM tempo;

    "DRUMS:" => string section;
    1 => int play; // whether the while loop should continue

    1 => int debug;


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
    .6 => sb[ kick ].gain;
    1.3 => sb[ snare ].gain;
    0.25 => sb[ hh ].gain;
    0.25 => sb[ hho ].gain;

    if (debug) { <<< section, "setting pans" >>>; }
    -1 => pan[ hh ].pan => pan[ hho ].pan;
    0.5 => pan[ snare ].pan;

    // drum tracks

    // each section of drums is 4 bits placed in the integer like so:
    // in a 32-bit int, the bits are
    //        X    X    X    X   hho  hh  snre kick
    //      0000 0000 0000 0000 0000 0000 0000 0000
    // bit:31   27   23   19   15   11    7654 3210

    [0x090A, 0x0500, 0x07F0, 0x0500] @=> int track0[];
    [0x900A, 0x0000, 0x90F0, 0x0000, 0x900A, 0x000A, 0x90F0, 0x0000] @=> int track1[];

    [track0, track1] @=> int tracks[][];

    fun int getNote(int track, int index)
    {
        if (debug) { <<< section, "Getting track", track, "index", index >>>;}
        return tracks[track][index % tracks[track].cap()];
    }

    EventBroadcaster eb;

    spork ~ playLoop(eb.drum);

    fun void playLoop(DrumEvent drmEvt){
        /* Main loop where we play everything 
        */
        // get the length of the array easier calcs
        if (debug) { <<< section, "Getting ready to play loop" >>>; }

        while ( true ) {

            drmEvt => now; // wait
            if (debug) { <<< section, "Event received:", drmEvt.drumByte >>>; }

            // each section of drums is 4 bits placed in the integer like so:
            // in a 32-bit int, the bits are
            //        X    X    X    X   hho  hh  snre kick
            //      0000 0000 0000 0000 0000 0000 0000 0000
            // bit:31   27   23   19   15   11    7654 3210
            // bitmask and shift the bits over to find the gain for that drumpiece, use the gain as
            // a hit, and as, you guessed it, the gain. Since the gain comes in as a number between
            // 0 to 15, we divide by 15.0 to get a float between 0.0 and 1.0

            ((drmEvt.drumByte & 0xF) >> 0) / 15. => float kickGain;
            //if (debug) { <<< section, "kickGain:", kickGain >>>;}

            ((drmEvt.drumByte & 0xF0) >> 4) / 15. => float snareGain;
            //if (debug) { <<< section, "snareGain:", snareGain >>>;}

            ((drmEvt.drumByte & 0xF00) >> 8) / 15. => float hhGain;  // hihat 
            if (debug) { <<< section, "hhGain:", hhGain >>>;}

            ((drmEvt.drumByte & 0xF000) >> 12) / 15. => float hhoGain;  // hihat open
            if (debug) { <<< section, "hhoGain:", hhoGain >>>;}

            if (kickGain > 0){
                if (debug) { <<< "=Kick:", kickGain >>>; }
                kickGain => sb[ kick ].gain;
                0 => sb[ kick ].pos;
            }
            
            if (snareGain > 0){
                if (debug) { <<< "==Snare:", snareGain >>>; }
                snareGain => sb[ snare ].gain;
                0 => sb[ snare ].pos;
            }
            // //if (debug) { <<< "click", hh_ptn[beat] & 1, hh_ptn[beat] & 2 >>>; }
            if ( hhGain > 0 ){ 
                if (debug) { <<< "===HiHat", hhGain >>>; }
                0 => sb [ hh ].pos;
                sb [ hho ].samples() => sb [ hho ].pos; // stop the hh open
            }
            if ( hhoGain > 0) {
                if (debug) { <<< "===HiHatOpen", hhoGain >>>; }
                0 => sb [ hho ].pos;
            }
            
            // if ( (hh_ptn[beat] & 0x4) > 0){
            //     if (debug) { <<< "===Lo Click", hh_ptn[beat] & 4 >>>; }
            //     0 => sb [ lc ].pos;
            // }
            
            // if ( (hh_ptn[beat] & 0x8) > 0){
            //     if (debug) { <<< "===Hi Click", hh_ptn[beat] & 8 >>>; }
            //     0 => sb [ hc ].pos;
            // }
        }
    }
}




// bass.ck
/*  Title: Classy San Diego Powerplant
    Author: Brian Harrington
    Assignment: 7 - Classes and Objects
    Soundcloud link: https://soundcloud.com/destruction_synthesis/song-7-the-static-class
*/
public class Melody
{
    BPM tempo;
    Scale scale;
    Debug db;

    "MELODY:" => string section;
    <<< section, "loaded" >>>;
    // setup sound chain
    MelodyInstr vox => NRev rev => dac;
    0.05 => rev.mix;


    int noteOffsets[]; // note array for melody keys
    string durs[];  // durations for each note
    float gains[]; // gains for each note
    int play;   // flag to continue playing the while loop
    int debug;

    fun void stop(){
        0 => play;
    }

    fun void playTrack(int track){
        db.flag => debug;
        <<< section, "debug flag is", debug >>>;
        if (track <= 0){
            <<< section, "invalid track (", track, ") exiting" >>>;
            me.exit();
        }
        1 => play;
        if (track == 1){ // intro / main?
            if (debug) { <<< section, "setting up track 1" >>>; }
            [ 3, 5, 7, 5, 7] @=> noteOffsets;
            [    "si" ] @=> durs;
            [    1. ] @=> gains; // only need one since it doesn't change
            spork ~ playLoop();
        }
        else {
            <<< section, "Pattern not set, aborting" >>>;
            me.exit();
        }
    }

    fun void playLoop(){
        // vars for the while loop
        0::second => dur durNote; // keeps track of the note's remaining duration
        0 => int noteIndex;       // index for the note in the different arrays
        tempo.th => dur lastDuration;  // used to detect if there was a change in tempo

        while(play){

        	// set the melodic note
            if (durNote <= 0::second) { // if the note ran out of time
                //vox.clear(1);
                scale.sc[ scale.melodyRoot + noteOffsets[ noteIndex % noteOffsets.cap() ] ] => int note; // add offset to the currrent root. This allows us to change keys
                if (debug) <<< section, "Changing note to", note >>>;
                //Std.mtof(note) => osc1.freq;
                Std.mtof(note) => vox.freq;
                //gains[ noteIndex % gains.cap() ] / 2.0 => osc1.gain; // osc is more powerful than the STK
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
            tempo.th => now;
            tempo.th -=> durNote; // reduce duration of this note by the resloution
        }
    }
}
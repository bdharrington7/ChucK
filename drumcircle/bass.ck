// bass.ck
/*  Title: Classy San Diego Powerplant
    Author: Brian Harrington
    Assignment: 7 - Classes and Objects
    Soundcloud link: https://soundcloud.com/destruction_synthesis/song-7-the-static-class
*/
public class Bass
{
    BPM tempo;
    Scale scale;
    Debug db;

    "BASS:" => string section;

    // setup sound chain
    TriOsc osc1 => dac;
    ExtraBass vox => dac;


    int noteOffsets[]; // note array for melody keys
    string durs[];  // durations for each note
    float gains[]; // gains for each note
    int play; // flag to play while loop
    int debug; // local debug flag

    fun void playTrack(int track){
        db.flag => debug;
        1 => play;
        if (track <= 0){
            <<< section, "invalid track (", track, ") exiting" >>>;
            me.exit();
        }
        if (track == 1){ // intro / main?
            if (debug) { <<< section, "setting up track 1" >>>; }
        //   1     2     3     4     5     6     7     8     9     10    11     12     13     14     15     16 
            [0, 7, 0, 7, 0, 7, 0, 7, 0, 7, 0, 7, 0, 7, 0, 7, 9, 12, 9, 5, 9, 12, 9, 5, -1, 6, -1, 6, -1, 6, -1, 6] @=> noteOffsets;
            [    "si"] @=> durs;
            [    .7 ] @=> gains; // only need one since it doesn't change
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
                scale.sc[ scale.bassRoot + noteOffsets[ noteIndex % noteOffsets.cap() ] ] => int note; // add offset to the currrent root. This allows us to change keys
                if (debug) <<< section, "Changing note to", note >>>;
                Std.mtof(note) => osc1.freq;
                Std.mtof(note) => vox.freq;
                gains[ noteIndex % gains.cap() ] / 2.0 => osc1.gain; // osc is more powerful than the STK
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
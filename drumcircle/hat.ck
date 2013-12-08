// hat.ck
/*  Title: Classy San Diego Powerplant
    Author: Anonymous
    Assignment: 7 - Classes and Objects
    Soundcloud link: TODO add link
*/
// on the fly drumming with global BPM conducting
SndBuf hat => dac;
me.dir(-1)+"/audio/hihat_02.wav" => hat.read;

// make a conductor for our tempo 
// this is set and updated elsewhere
BPM tempo;

while (1)  {
    
    // play a measure of eighth notes
    for (0 => int beat; beat < 8; beat++)  {
        // play mostly, but leave out last eighth
        if (beat != 7) {
            0 => hat.pos;
        }
        tempo.ei => now;
    }
}    
    
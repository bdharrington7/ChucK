// kick.ck
/*  Title: Classy San Diego Powerplant
    Author: Anonymous
    Assignment: 7 - Classes and Objects
    Soundcloud link: TODO add link
*/
// on the fly drumming with global BPM conducting
SndBuf kick => dac;
me.dir(-1)+"/audio/kick_04.wav" => kick.read;

// make a conductor for our tempo 
// this is set and updated elsewhere
BPM tempo;

while (1)  {

    // play a measure of quarter note kicks
    for (0 => int beat; beat < 4; beat++)  {
        0 => kick.pos;
        tempo.qu => now;
    }
}    
    

// score.ck
/*  Title: Classy San Diego Powerplant
    Author: Brian Harrington
    Assignment: 7 - Classes and Objects
    Soundcloud link: https://soundcloud.com/destruction_synthesis/song-7-the-static-class
*/
// on the fly drumming with global BPM conducting
BPM tempo;
Drums drums;
Bass bass;
Simple sim;
Melody mel;
Debug db;
db.setGlobalDebug(0);
<<< "debug flag is", db.flag >>>;
tempo.setQuarterNote(0.625);
tempo.setDebugOn();
me.dir() => string dir;

[48, 50, 52, 53, 55, 57, 59, 60] @=> int scaleCIonian[];
Scale s;
s.setDebugOn();
s.setScale(scaleCIonian);
s.setBassRoot(17);
s.setMelodyRoot(38);

// uncomment to export to wav (and line 60)
// dac => WvOut w => blackhole;
// "7.wav" => w.wavFilename;
// 1 => w.record;

bass.playTrack(1);
drums.playTrack(1);

sim.playTrack("F6");

8.0 * tempo.qu => now;

mel.playTrack(1);
8.0 * tempo.qu => now;
sim.stop();

// weird transition
s.setBassRoot(22);
s.setMelodyRoot(43);

16.0 * tempo.qu => now;

// back to normal
s.setBassRoot(17);
s.setMelodyRoot(38);
8.0 * tempo.qu => now;

drums.stop();
1::ms => now;
drums.playTrack(2);
8.0 * tempo.qu => now;

// uncomment to export to wav
// 0 => w.record;


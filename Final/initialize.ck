// initialize.ck
/*  Title: The Final Meltdown
    Author: Brian Harrington
    Assignment 8 Final: The Final Storm of Meltdowns
    Soundcloud link: https://soundcloud.com/destruction_synthesis/song-8-the-final-storm-of
*/



// load dependencies first
me.dir() => string dir;
// our conductor/beat-timer class
Machine.add(dir + "/BPM.ck");

// Machine.add(dir + "/Debug.ck");
Machine.add(dir + "/Eventful.ck");
Machine.add(dir + "/DrumEvent.ck");
Machine.add(dir + "/ChordEvent.ck");

Machine.add(dir + "/EventBroadcaster.ck");
20::ms => now; // have to wait for the Event Broadcaster to load... 

// add any extended instruments
Machine.add(dir + "/ExtraBass.ck");
Machine.add(dir + "/ChordInstrument.ck");

// add players (drums is combined)
Machine.add(dir + "/Drums.ck");
Machine.add(dir + "/BassPlayer.ck");
Machine.add(dir + "/ChordPlayer.ck");




Machine.add(dir + "/Conductor.ck");
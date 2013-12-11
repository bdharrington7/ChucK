// initialize.ck
/*  Title: Classy San Diego Powerplant
    Author: Brian Harrington
    Assignment: 7 - Classes and Objects
    Soundcloud link: https://soundcloud.com/destruction_synthesis/song-7-the-static-class
*/

// Add all classes here!
me.dir() => string dir;
// our conductor/beat-timer class
Machine.add(dir + "/BPM.ck");
Machine.add(dir + "/Scale.ck");
Machine.add(dir + "/Debug.ck");


// load up the classes first
Machine.add(dir + "/ExtraBass.ck");
Machine.add(dir + "/MelodyInstr.ck");
Machine.add(dir + "/bass.ck");
Machine.add(dir + "/Simple-pitch.ck");
Machine.add(dir + "/drums.ck:1"); 
Machine.add(dir + "/melody.ck");
Machine.add(dir + "/score.ck");



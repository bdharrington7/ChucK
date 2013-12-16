// initialize.ck
/*  Title: The Final Meltdown
    Author: Anonymous
    Assignment: 8 - Final
    Soundcloud link: https://soundcloud.com/coursera_anon_673143250/assignment-8-final
*/

/*
Dear grader,
In the unlikely event that the sound comes out really distorted, please reference the above link. 
I tried my best to adjust levels to appease Windows users, but there's only so much I can do; I've 
tested on my friend's windows machines, and it comes out fine. There are a lot of files in this 
project, so here's a list of the requirements and their locations (and line numbers)

Use of Machine.add() to launch files								right below
Use of spork ~ to call functions concurrently						in Conductor.ck
Use of at least 2 classes, including one from lecture (BPM.ck)		way more than 2
Use of Oscillator													ExtraBass.ck
Use of SndBuf 														Drums.ck
Use of at least one STK instrument 									ChordInstrument, ExtraBass
Use of at least one STK audio effect (e.g. Chorus, Delay, JCRev)	ChordInstrument, ExtraBass
Use of if/else statements											everywhere
Use of for loop or while 											everywhere
Use of variables													everywhere
Use of comments														everywhere
Std.mtof()															Eventful, Conductor, and other places
Random Number														Drums.ck:177
Use of Arrays														*Player.ck
Use of Panning														Drums.ck:71
Use of at least one hand-written functions 							almost everywhere
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
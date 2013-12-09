// score.ck
/*  Title: Classy San Diego Powerplant
    Author: Anonymous
    Assignment: 7 - Classes and Objects
    Soundcloud link: TODO add link
*/
// on the fly drumming with global BPM conducting
BPM tempo;
Drums drums;
Simple sim;
Debug db;
db.setGlobalDebug(1);
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

// Machine.add(me.dir()+"/kick.ck") => int kickID;
// 8.0 * tempo.qu => now;

// Machine.add(me.dir()+"/snare.ck") => int snareID;
// 8.0 * tempo.qu => now;

// Machine.add(me.dir()+"/hat.ck") => int hatID;
// Machine.add(me.dir()+"/cowbell.ck") => int cowID;
// 8.0 * tempo.qu => now;

//8.0 * tempo.qu => now;

Machine.add(me.dir()+"/bass.ck:1:1") => int bassID;
drums.playTrack(1);
sim.play("F6");
8.0 * tempo.qu => now;

//<<< "Set tempo to 80BPM" >>>;  // let's not and say we did
//drums.reset();
//s.setRoot(22); 
//Machine.replace(drumsID, me.dir()+"/drums.ck:1:1") => drumsID;
//Machine.add(dir + "/Simple-pitch.ck");
8.0 * tempo.qu => now;

//<<< "Now set tempo to 160BPM" >>>;
//160.0 => newtempo;
//tempo.setBPM(newtempo);
//s.setRoot(23);
8.0 * tempo.qu => now;

/* if you want to run OTFBPM to change
// tempo as these all run, then comment
// out the lines below   */

// <<< "Gradually decrease tempo" >>>;
// while (newtempo > 60.0) {
//     newtempo - 20 => newtempo;
//     tempo.setBPM(newtempo);
//     <<< "tempo = ", newtempo >>>;
//     8.0 * tempo.qu => now;
// }

//Machine.remove(drumsID);
//Machine.remove(bassID);


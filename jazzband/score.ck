// score.ck
/*  Title: SD Shredded Powerplant
    Author: Anonymous
    Assignment: 6 - threading (shredding) and concurrency
    Soundcloud link: TODO: link
*/

Machine.add(me.dir() + "/drums.ck:1:1") => int drumID;

10::second => now;

Machine.add(me.dir() + "/bass.ck") => int bassID;

10::second => now;

Machine.add(me.dir() + "/flute.ck") => int fluteID;
Machine.add(me.dir() + "/piano.ck") => int pianoID;

10::second => now;

Machine.remove(drumID);
Machine.remove(bassID);
Machine.remove(fluteID);
Machine.remove(pianoID);
// score.ck
/*  Title: SD Shredded Powerplant
    Author: Anonymous
    Assignment: 6 - threading (shredding) and concurrency
    Soundcloud link: TODO: link
*/

Machine.add(me.dir() + "/drums.ck:1:1") => int drumID;

5::second => now;

Machine.add(me.dir() + "/bass.ck:1:1") => int bassID;

5::second => now;

Machine.add(me.dir() + "/melody.ck") => int melodyID;
Machine.add(me.dir() + "/accompany.ck") => int accompanyID;

10::second => now;

Machine.remove(drumID);
Machine.remove(bassID);
Machine.remove(melodyID);
Machine.remove(accompanyID);
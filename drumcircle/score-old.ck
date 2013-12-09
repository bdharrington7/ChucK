// score.ck
/*  Title: Classy San Diego Powerplant
    Author: Anonymous
    Assignment: 7 - Classes and Objects
    Soundcloud link: TODO add link
*/

Machine.add(me.dir() + "/drums.ck:1") => int drumID;

//5::second => now;

Machine.add(me.dir() + "/bass.ck:1") => int bassID;

5::second => now;

Machine.add(me.dir() + "/melody.ck:1") => int melodyID;

5::second => now;

Machine.replace(melodyID, me.dir() + "/melody.ck:2") => melodyID;

5::second => now;

Machine.remove(melodyID);
Machine.add(me.dir() + "/accompany.ck:1") => int accompanyID;

10::second => now;

Machine.replace(accompanyID, me.dir() + "/accompany.ck:2") => accompanyID;

10::second => now;

Machine.remove(accompanyID);
Machine.remove(bassID);
Machine.replace (drumID, me.dir() + "/drums.ck:2");
Machine.add(me.dir() + "/melody.ck:1") => melodyID;

5::second => now;

Machine.remove(drumID);
Machine.remove(melodyID);
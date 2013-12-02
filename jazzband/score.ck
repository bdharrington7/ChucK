// score.ck
/*  Title: SD Shredded Powerplant
    Author: Anonymous
    Assignment: 6 - threading (shredding) and concurrency
    Soundcloud link: TODO: link
*/

Machine.add(me.dir() + "/drums.ck:1") => int drumID;

//5::second => now;

Machine.add(me.dir() + "/bass.ck:1") => int bassID;

5::second => now;

Machine.add(me.dir() + "/melody.ck:1:1") => int melodyID;

5::second => now;

Machine.replace(melodyID, me.dir() + "/melody.ck:2:1") => melodyID;

5::second => now;

Machine.remove(melodyID);
Machine.add(me.dir() + "/accompany.ck:1") => int accompanyID;

5::second => now;

Machine.replace(melodyID, me.dir() + "/accompany.ck:2") => melodyID;

5::second => now;

Machine.remove(drumID);
Machine.remove(bassID);
Machine.remove(melodyID);
Machine.remove(accompanyID);
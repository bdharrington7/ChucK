// score.ck
/*  Title: SD Shredded Powerplant
    Author: Brian Harrington
    Assignment: 6 - threading (shredding) and concurrency
    Soundcloud link: https://soundcloud.com/destruction_synthesis/song-6-concurrent-schreduler
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
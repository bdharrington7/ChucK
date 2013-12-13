//Conductor.ck
/*  Title: The Final Meltdown
    Author: Anonymous
    Assignment: 8 - Final
    Soundcloud link: TODO add link
*/

/***
* This class is an event driver to send pulses to all other instruments. We're changing 
* paradigms here, instead of every class figuring out how long to play, we give signals
* when a beat has passed, along with information such as gain. The classes themselves will 
* know what / when to play.
* drums will have to be different, sending regular pulses, while 
***/
1 => int debug;
BPM tempo;
EventBroadcaster eb;
Drums drums;
ExtraBass bass;


"CONDUCTOR:" => string section;
50::ms => now; // wait for the dust to settle

spork ~ playDrums(0, 4);
spork ~ playBass(0, 4);
// must let time pass or this dies immediately
2::second => now;

fun void playDrums(int track, int beats)
{
	if(debug){ <<< section, "in playDrums" >>>;}
	0 => int beat;
	repeat(beats)
	{
		drums.getNote(0,beat) => eb.drum.drumByte;
		if (debug) { <<< section, "Sending drum signal", eb.drum.drumByte >>>;}
		eb.drum.signal();

		beat++;

		0.5::second => now;
	}
}


fun void playBass(int track, int beats)
{
	if (debug) {<<< section, "in playBass, " >>>;}
	0 => int note;
	repeat (beats)
	{
		bass.getNote(0, note) => eb.bass.note;
		bass.getGain(0, note) => eb.bass.gain;
		eb.bass.signal();

		note++;
		0.5::second => now;
	}
}
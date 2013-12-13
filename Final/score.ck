// score.ck
/*  Title: The Final Meltdown
    Author: Anonymous
    Assignment: 8 - Final
    Soundcloud link: TODO add link
*/

/**
* This class will dictate what the conductor does
**/

// on the fly drumming with global BPM conducting
"SCORE:" => string section;
1 => int debug;
// public class Score
// {
	BPM tempo;
	//EventBroadcaster eb;
	ScoreBroadcaster sb;

	tempo.setQuarterNote(0.625);
	tempo.setDebugOn();
	me.dir() => string dir;

	// fun void play()
	// {
		tempo.wh => now;
		1 => sb.score.sectionTrack["drums"];
		if (debug) { <<< section, "sending ScoreEvent for drums" >>>;}
		sb.score.signal();
		tempo.wh*2 => now;
		null => sb.score.sectionTrack["drums"];
		sb.score.signal();
		tempo.qu => now;

	// }
	//eb.score

	// [48, 50, 52, 53, 55, 57, 59, 60] @=> int scaleCIonian[];
	// Scale s;
	// s.setDebugOn();
	// s.setScale(scaleCIonian);
	// s.setBassRoot(17);
	// s.setMelodyRoot(38);

	// // uncomment to export to wav (and line 60)
	// // dac => WvOut w => blackhole;
	// // "7.wav" => w.wavFilename;
	// // 1 => w.record;

	// bass.playTrack(1);
	// drums.playTrack(1);

	// sim.playTrack("F6");

	// 8.0 * tempo.qu => now;

	// mel.playTrack(1);
	// 8.0 * tempo.qu => now;
	// sim.stop();

	// // weird transition
	// s.setBassRoot(22);
	// s.setMelodyRoot(43);

	// 16.0 * tempo.qu => now;

	// // back to normal
	// s.setBassRoot(17);
	// s.setMelodyRoot(38);
	// 8.0 * tempo.qu => now;

	// drums.stop();
	// 1::ms => now;
	// drums.playTrack(2);
	// 8.0 * tempo.qu => now;

	// uncomment to export to wav
	// 0 => w.record;
//}


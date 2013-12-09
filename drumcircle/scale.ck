// scale.ck
/*  Title: Classy San Diego Powerplant
    Author: Anonymous
    Assignment: 7 - Classes and Objects
    Soundcloud link: TODO add link
*/

public class Scale 
{
	9 => int octaves;
	"SCALE" => string section;
	// new array to hold the whole scale: num octaves * (the scale size - the last note because it's an octave)
	static int sc[]; // full scale
	static int bassRoot; // root note
	static int melodyRoot;

	0 => int debug;

	fun void setDebugOn()
	{
		1 => debug;
	}

	fun void setBassRoot(int rt)
	{
		rt => bassRoot;
	}

	fun void setMelodyRoot(int rt){
		rt => melodyRoot;
	}

	/* sets and builds the whole scale based on the array passed in */
	public void setScale(int scale[])
	{
		// build up the scale to a fuller one instead of just 8 notes
		// find the lowest root note above 0
		scale[0] => int currRoot;
		while (true){
			if (currRoot - 12 < 0){
				break; // we're at the lowest note for this scale
			}
			12 -=> currRoot; // decrement currRoot by 12
		}
		new int [ octaves * (scale.cap()-1) ] @=> sc;
		
		0 => int scIndex;
		repeat (octaves){ // build up all octaves 
			if (debug) { <<< section, "adding scale from root note", currRoot >>>; }
			currRoot => sc[ scIndex++ ];
			for (1 => int i; i < scale.cap()-1; i++){  // assuming that the octave is present in the array
				// add the note that is the currRoot + difference between the root in the original array
				// and the one at i
				currRoot + (scale[i] - scale[0]) => sc[ scIndex++ ];  
			}
			12 +=> currRoot;
		}
		if (debug) {
			<<< section, "Scale is:" >>>;
			for (0 => int i; i < sc.cap(); i++){
				if (i % 7 == 0){
					<<< "Octave", i / 7, ":" >>>;
				}
				<<< sc[i] >>>;
			}
		}
	}



}
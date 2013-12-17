//DrumEvent.ck
/*  Title: The Final Meltdown
    Author: Brian Harrington
    Assignment 8 Final: The Final Storm of Meltdowns
    Soundcloud link: https://soundcloud.com/destruction_synthesis/song-8-the-final-storm-of
*/

public class DrumEvent extends Eventful
{
	"DRUM EVENT:" => section;
	if (debug) { <<< section, "loading..." >>>;}

	int drumByte;  // using an int as a bit array

}
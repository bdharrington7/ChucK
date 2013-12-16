//DrumEvent.ck


public class DrumEvent extends Eventful
{
	1 => debug;
	"DRUM EVENT:" => section;
	if (debug) { <<< section, "loading..." >>>;}

	int drumByte;  // using an int as a bit array

}
// BPM.ck
/*  Title: The Final Meltdown
    Author: Anonymous
    Assignment: 8 - Final
    Soundcloud link: TODO add link
*/
// global BPM conductor Class
public class BPM
{
    // global variables
    static dur wh, //ole
               ha, //lf
               qu, //arter
               ei, //ghth
               si, //xteenth
               th, //irtysecond
               dw, // dotted whole is whole plus half
               dh, // half + quarter
               dq, // quarter + eighth
               de, // eighth + sixteenth
               ds, // sixteenth + thirtysecond
               dt; // thirtysecond + 64th 

    static float wLen; // whole note length
    
    // class variables
    "BPM" => string section;
    1 => int debug;


    /* Function to translate string to the actual static dur of the tempo */
    fun dur durs(string d)
    {
      // no switch statement, unfortunately
      if ("th" == d) return th; // put the most often used ones first
      else if ("si" == d) return si;
      else if ("ei" == d) return ei;
      else if ("qu" == d) return qu;
      else if ("ha" == d) return ha;
      else if ("wh" == d) return wh;
      else if ("dw" == d) return dw;
      else if ("dh" == d) return dh;
      else if ("dq" == d) return dq;
      else if ("de" == d) return de;
      else if ("ds" == d) return ds;
      else if ("dt" == d) return dt;
      else return 0::second;
    }
    
    /* Set the BPM by quarter note seconds */
    fun void setQuarterNote(float seconds)
    {
      if (debug) { <<< section, "Setting note durations: quarter note is", seconds, "seconds" >>>; }
      seconds * 4 => wLen;
      wLen ::second => wh;
                wh / 2 => ha; //lf
                wh / 4 => qu; //arter
                wh / 8 => ei; //ghth
                wh / 16 => si; //xteenth
                wh / 32 => th; //irtysecond
                wh + ha => dw; // dotted notes:
                ha + qu => dh;
                qu + ei => dq;
                ei + si => de;
                si + th => ds;
              th + th/2 => dt;  // 1.5 thirtysecond notes
    }

    /* set the tempo using a Beats per minute arg */
    fun void setBPM(float beat)  {
        // beat is BPM, example 120 beats per minute
        if (debug) { <<< section, "Setting BPM: " >>>; }
        60.0/(beat) => float SPB; // seconds per beat (quarternote)
        setQuarterNote(SPB);
    }
}


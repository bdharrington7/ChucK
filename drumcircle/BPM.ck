// BPM.ck
/*  Title: Classy San Diego Powerplant
    Author: Anonymous
    Assignment: 7 - Classes and Objects
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

    static float wLen; // whol note length

    //static dur durs[12];
    
    // class variables
    "BPM" => string section;
    0 => int debug;

    fun void setDebugOn(){
        1 => debug;
    }

    fun dur durs(string d)
    {
      if ("th" == d) return th;
      else if ("si" == d) return si;
      else if ("ei" == d) return ei;
      else if ("qu" == d) return qu;
      else return 0::second;
    }
    
    /* Set the BPM by quarter note seconds */
    fun void setQuarterNote(float seconds)
    {
      if (debug) { <<< section, "Setting note durations: quarter note is", seconds, "seconds" >>>; }
      seconds * 4 => wLen;
      seconds * 4 ::second => wh;
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

              // [wh, ha, qu, ei, si, th, dw, dh, dq, de, ds, dt] @=> durs; // store in an array for easy access
              // wh => durs["wh"];
              // ha => durs["ha"];
              // qu => durs["qu"];
              // ei => durs["ei"];
              // si => durs["si"];
              // th => durs["th"];
              // dw => durs["dw"];
              // dh => durs["dh"];
              // dq => durs["dq"];
              // de => durs["de"];
              // ds => durs["ds"];
              // dt => durs["dt"];
    }

    /* set the tempo using a Beats per minute arg */
    fun void setBPM(float beat)  {
        // beat is BPM, example 120 beats per minute

        60.0/(beat) => float SPB; // seconds per beat
        SPB * 4 => wLen;
        if (debug) { <<< section, "Setting BPM: whole note is", wLen, "seconds" >>>; }
        SPB*4 :: second => wh; //ole
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

              // [wh, ha, qu, ei, si, th, dw, dh, dq, de, ds, dt] @=> durs;
              // wh => durs["wh"];
              // ha => durs["ha"];
              // qu => durs["qu"];
              // ei => durs["ei"];
              // si => durs["si"];
              // th => durs["th"];
              // dw => durs["dw"];
              // dh => durs["dh"];
              // dq => durs["dq"];
              // de => durs["de"];
              // ds => durs["ds"];
              // dt => durs["dt"];
    }
}


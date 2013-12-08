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
    
    // class variables
    "BPM" => string section;
    0 => int debug;

    fun void setDebugOn(){
        1 => debug;
    }
    
    fun void tempo(float beat)  {
        // beat is BPM, example 120 beats per minute

        60.0/(beat) => float SPB; // seconds per beat
        if (debug) { <<< section, "Setting note durations: whole note is", SPB*4, "seconds" >>>; }
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
    }
}


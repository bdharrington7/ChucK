// bass.ck
/*  Title: SD Shredded Powerplant
    Author: Anonymous
    Assignment: 6 - threading (shredding) and concurrency
    Soundcloud link: TODO: link
*/

[49, 50, 52, 54, 56, 57, 59, 61] @=> scale; // TODO: This is the wrong scale

0.625 * 4 => float wLen; // quarter note is 0.625

dur wh; //ole
dur ha; //lf
dur qu; //arter
dur ei; //ghth
dur si; //xteenth
dur th; //irtysecond
dur dw; // dotted whole == whole + half
dur dh; // (half + quarter)
dur dq; // (quarter + eighth)
dur de; // (eighth + sixteenth)
dur ds; // (sixteenth + thirtysecond)
if (debug) { <<< "Setting note durations: whole note is", wLen, "seconds" >>>; }
wLen::second => wh; //ole
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



while(true){
    1::second => now;
}
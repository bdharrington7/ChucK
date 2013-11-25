<<< "Assignment_1_SanDiegoPowerPlant" >>>;

// using two types of oscillators
TriOsc s => dac; 
TriOsc saw => dac;


// keys
164.813778456434964 => float E3;
174.614115716501942 => float F3;
195.997717990874647 => float G3;
220.000 => float A3;
246.941650628062055 => float B3;
261.625565300598634 => float C;
293.664767917407560 => float D;
329.627556912869929 => float E;
349.228231433003884 => float F;
391.995435981749294 => float G;
440.000 => float A;
493.883301256124111 => float B;

// start in middle C
C => saw.freq;

0 => s.gain;
0.4 => saw.gain;
// flag to start the harmony
0 => int harmony;

// some melody / beat
now + 32::second => time consistent;  // simple 60 bpm
while (now < consistent){
    if(harmony != 0){ // start when flag is set
        0.5 => s.gain;
        C => s.freq;
    } // starting in C
    now + 4::second => time start;
    while(now < start) {
        0.5::second => now;
        0 => saw.gain;
        0.5::second => now;
        0.4 => saw.gain;
    }
    // key change
    E => saw.freq;
    A3 => s.freq;
    now + 4::second => start;
    while(now < start){
        0.5::second => now;
        0 => saw.gain;
        0.5::second => now;
        0.4 => saw.gain;
    }
    // key change
    A => saw.freq;
    F3 => s.freq;
    now + 4::second => start;
    while(now < start){
        0.5::second => now;
        0 => saw.gain;
        0.5::second => now;
        0.4 => saw.gain;
    }
    // key change
    G => saw.freq;
    G3 => s.freq;
    now + 4::second => start;
    while(now < start){
        0.5::second => now;
        0 => saw.gain;
        0.5::second => now;
        0.4 => saw.gain;
    }
    1 => harmony; // begin harmony second time around
}
// resolve
C => s.freq;
E => saw.freq;
1.5::second => now;
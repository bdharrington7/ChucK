<<< "Brian Harrington - Assignment 1" >>>;

TriOsc s => dac; 
SawOsc saw => dac;

0.6 => s.gain;
220 => int i;
0 => int sw; // switch
i => s.freq;
440 => saw.freq;
0.0 => saw.gain;

while (true){
    .5::ms => now;
    if (i > 440){
        1 => sw; // we're going to dec if sw ==1 
    }
    if (i < 220){
        0 => sw;  // increment
    }
    if (sw == 0){
       i++ => s.freq;
    }
    else {
       i-- => s.freq;
    }
}
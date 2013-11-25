// sound chain
SndBuf mySound => dac;
SndBuf snare => dac;

string snare_samples[3];

for (0 => int i; i < snare_samples.cap(); i++){
    me.dir() + "/audio/snare_0" + (1 + i) + ".wav" => snare_samples[i];
}

<<< snare_samples[0] >>>;

while(true){
    Math.random2(0, snare_samples.cap()-1) => int which;
    snare_samples[which] => snare.read;
    150::ms => now;
}

//filename => mySound.read;

0.5 => mySound.gain;
2.0 => mySound.rate;
mySound.samples() => int numSamples;

<<< numSamples >>>;

0 => mySound.pos;

while (true ) {
    numSamples => mySound.pos;
    -1.0 => mySound.rate; // reverse;
    
    1::second => now;
    
}
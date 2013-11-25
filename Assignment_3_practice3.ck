// sequencer
Gain master => dac;
SndBuf kick => master;
SndBuf hihat => master;
SndBuf snare => master;

// load sound files

me.dir() + "/audio/" => string audioFolder;
audioFolder + "kick_01.wav" => kick.read;
audioFolder + "hihat_01.wav" => hihat.read;
audioFolder + "snare_01.wav" => snare.read;

// set all positions to end so they don't play immediately
kick.samples() => kick.pos;
hihat.samples() => hihat.pos;
snare.samples() => snare.pos;

1.0 => snare.gain;
0.2 => hihat.gain;

0 => int counter;



while(true){
    counter % 8 => int beat;
    <<< "Beat:", beat >>>;
    
    if(beat % 4 == 0){
        0 => kick.pos;
        <<< "Kick" >>>;
    }
    
    //<<< "snare", beat+1>>>;
    if((beat + 2) % 4 == 0){
        0 => snare.pos;
        <<< "SNARE" >>>;
    }
    if (beat % 2 == 1){
        0 => hihat.pos;
        <<< "hihat" >>>;
    }
    
    counter++;
    0.25::second => now;
    
}
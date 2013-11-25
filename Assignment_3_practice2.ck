// sound chain

SndBuf snd => dac; 

me.dir() + "/audio/stereo_fx_01.wav" => string filename;

filename => snd.read;

while(true){
    
    0 => snd.pos;

    5::second => now;
}
// Simple-pitch.ck: modified from example in class
/*  Title: Classy San Diego Powerplant
    Author: Brian Harrington
    Assignment: 7 - Classes and Objects
    Soundcloud link: https://soundcloud.com/destruction_synthesis/song-7-the-static-class
*/
public class Simple  
{
    BPM tempo;
    // our Simple sound chain
    Impulse imp => ResonZ filt => dac;
    
    // some default settings
    100.0 => filt.Q => filt.gain;
    1000.0 => filt.freq;
    
    // set freq as we would any instrument 
    fun void freq(float freq)
    {
        freq => filt.freq;
    }    
    
    // method to allow setting Q
    fun void setQ(float Q)
    {
        Q => filt.Q => filt.gain;
    }
    
    // method to allow setting gain
    fun void setGain(float gain)
    {
        gain => imp.gain;
    }
    
    // play a note by firing impulse
    fun void noteOn(float volume)
    {
        volume => imp.next;
    }
    
    // three ways of setting pitch
    //  one by float frequency
    fun float pitch(float freq)
    {
        return freq => filt.freq;
    }
    
    // another to set pitch by MIDI note number
    fun float pitch(int noteNum)
    {
        return Std.mtof(noteNum) => filt.freq;
    }
    
    // another way to set pitch by noteName, capital A-G required
    // Needs specific format: C4, D#5, Eb3, As3, Bf6
    fun float pitch(string noteName)
    {
        [21,23,12,14,16,17,19] @=> int notes[]; // Note #s A thru G
        noteName.charAt(0) - 65 => int base;
        notes[base] => int note;
        0.0 => float freq;
        if (base > -1 && base < 7)  
        {
            if (noteName.charAt(1) == '#')  // either '#' symbol
                notes[base] + 1 => note;
            if (noteName.charAt(1) == 's')  // or 's' counts for sharp
                notes[base] + 1 => note;
            if (noteName.charAt(1) == 'b')  // either 'b' or
                notes[base] - 1 => note;
            if (noteName.charAt(1) == 'f') // 'f' counts for flat
                notes[base] - 1 => note;
        }
        else 
        {
            <<< "Illegal Note Name!!" >>>;
            return 0.0;
        }
        
        noteName.charAt(noteName.length()-1) - 48 => int oct;
        
        if (oct > -1 && oct < 10) 
        {
            note + 12*oct => note;
            return this.pitch(note);
        }
        else 
        {
            <<< "Illegal Octave!!" >>>;
            return 0.0;
        }
    }

    1 => int play;
    fun void stop(){
        0 => play;
    }

    fun void playTrack(string note)
    {
        pitch(note);
        spork ~ playLoop();
        
    }

    fun void playLoop(){
        while (play) 
        {
            1 => this.noteOn;
            tempo.de => now;
            1 => this.noteOn;
            tempo.si => now;
            1 => this.noteOn;
            tempo.ei => now;
        }
    }
    
}



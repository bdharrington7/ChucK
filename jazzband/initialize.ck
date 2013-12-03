// initialize.ck
/*  Title: SD Shredded Powerplant
    Author: Brian Harrington
    Assignment: 6 - threading (shredding) and concurrency
    Soundcloud link: https://soundcloud.com/destruction_synthesis/song-6-concurrent-schreduler
*/

// Something new will go here next week

/* DEAR GRADER: please use headphones. If the sound seems distorted, please reference the audio at the soundcloud link above
   Sorry it's not exactly 30 seconds, but it says "about" 30 seconds... */
/* REQUIREMENTS: for your ease, I will point out where I have used each requirement */

// REQUIREMENT                           								LOCATION:line
// Use of Machine.add() to launch files: 								here, and score.ck
// Use of spork ~ to call functions concurrently						accompany.ck:194
// Use of Oscillator													bass.ck
// Use of SndBuf name => 												drums.ck
// Use of at least one STK instrument 									accompany.ck and melody.ck
// Use of at least one STK audio effect (e.g. Chorus, Delay, JCRev) 	accompany.ck
// Use of if/else statements											everywhere
// Use of for loop or while 											everywhere
// Use of variables														everywhere
// Use of comments														everywhere.. including here
// Std.mtof()															accompany, melody
// Random Number														accompany.ck:191
// Use of Arrays														everywhere
// Use of Panning														accompany.ck:99-106
// Use of right timing (0.625::second quarter notes)					everywhere (at top)
// Use of right melodic notes (Bb Aeolian scale)						melody, bass, accompany
// Use of at least one hand-written function 							everywhere

// Add score file
Machine.add(me.dir() + "/score.ck");
//Keyboard.ck
/*  Title: The Final Meltdown
    Author: Anonymous
    Assignment: 8 - Final
    Soundcloud link: https://soundcloud.com/coursera_anon_673143250/assignment-8-final
*/
Hid hid; // human interface device

HidMsg msg; /// message from keyboard

BeeThree organ => JCRev rev => dac;

0 => int device;

if (!hid.openKeyboard(device) ) me.exit();

<<< "keyboard", hid.name(), "ready!" >>>;

while (true){
	hid => now;
	while (hid.recv(msg)){
		if (msg.isButtonDown()){
			<<< "BUTTON DOWN:", msg.ascii >>>;
			msg.ascii => Std.mtof => organ.freq;
			1 => organ.noteOn;
		}
		else {
			1 => organ.noteOff;
		}
	}
}
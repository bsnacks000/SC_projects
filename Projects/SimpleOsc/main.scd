// main script
(
~host = "Host_obj.scd".loadRelative;
~synth = "SimpleOsc_obj.scd".loadRelative;
~gui = "make_gui.scd".loadRelative;

//var host, synth, app -- give systems enough time to boot;
// run on AppClock to build GUI inside of Routine

c = Condition(false); // create global condition -- these need to be set in the host and any synths before gui is made

Routine{

	~h = ~host[0].value;  // create host instance
	c.wait;
	~s = ~synth[0].value([0,1]);  //create synth instance
	c.wait;
	~gui[0].value(~s.at(\get_synth).value); //build gui
	"success".postln;

}.play(AppClock);
)



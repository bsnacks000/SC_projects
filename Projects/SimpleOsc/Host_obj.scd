// Host object prototype for SimpleOsc project
// Most server info is hard-coded for this project
{ // 1. outer function scope -- any class init vars go here


	// 2. private var/method space -- also constructor
	var audio_bus = nil;
	var synth, gui, syn;


	//2a. constructor... optional; needs to be after any private funcs in case they need to be called
	{

		"SC_SYNTHDEF_PATH".setenv("Syndefs".resolveRelative.standardizePath); //customize this path for projects
		"echo $SC_SYNTHDEF_PATH".unixCmd;


		//Boot options for default server s

		s.options.numInputBusChannels = 0;
		s.options.numOutputBusChannels = 2;
		s.options.device = "SimpleOsc"; //jack_client name

		s.waitForBoot({   // block while server boots
			s.meter;
			s.plotTree;

			// set up number of extra audio busses here...
			// audio_bus = Bus.audio(s);

			"server booted".postln;

			c.test = true;   // sends to global condition after server is booted
			c.signal;

		});


	}.value;

	(   //3. Public API -- getters/setters/ public methods -- wrapped in an event()
		// these are called using above syntax: instance.at(\func_name).value(instance,...)
		get_bus_index:{
			audio_bus.index;
		},
		get_bus:{
			audio_bus;
		}
	)
};
// SimpleOsc_obj prototype for SimpleOsc project
// 1. builds a new Synth for syndef, Has one get and set method per arg
// class arg is the assigned output bus which is passed to the synthdef on creation
{ // 1. outer function scope -- any class init vars go here

	arg audio_outbus;

	// 2. private
	var synth = nil;

	//2a. constructor...
	{
		synth = Synth.new("SimpleOsc", [\out, audio_outbus]);
		c.test = true;  // sends to global condition c
		c.signal;

	}.value;

	(   //3. Public API -- call: instance.at(\func_name).value(instance,...)
		set_freq1:{
			arg self, freq;
			synth.set(\freq1, freq)
		},
		set_freq2:{
			arg self, freq;
			synth.set(\freq2, freq)
		},
		set_freq3:{
			arg self, freq;
			synth.set(\freq1, freq)
		},
		set_amp1:{
			arg self, amp;
			synth.set(\amp1,amp)
		},
		set_amp2:{
			arg self, amp;
			synth.set(\amp2,amp)
		},
		set_amp3:{
			arg self, amp;
			synth.set(\amp3,amp)
		},
		set_overall_amp:{
			arg self, amp;
			synth.set(\overall_amp, amp)
		},
		set_gate:{
			arg self, gate;
			synth.set(\gate, gate)
		},
		get_synth:{ synth }
	)
};


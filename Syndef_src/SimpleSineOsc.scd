(
SynthDef("SimpleSineOsc",{

	arg ar_out_bus = nil, amp = 0.5, freq = 440, env = 0.0;
	var sig = SinOsc.ar(freq) * amp * env;
	Out.ar(ar_out_bus, sig);

}).writeDefFile("~/Documents/SC_proj_local/Syndefs".standardizePath);
)
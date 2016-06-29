(
SynthDef("SimpleChannelMixer", {

	arg ar_in_bus, ar_out_bus, amp = 1.0;
	var sig;

	ar_in_bus = In.ar(ar_in_bus, 1);
	sig = ar_in_bus * amp;

	Out.ar(ar_out_bus, sig); // can be patched directly to audio outs or to another mixer

}).writeDefFile("~/Documents/SC_proj_local/Syndefs".standardizePath);
)
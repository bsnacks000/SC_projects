// Simple Global 4 Channel Mixer -- simple linear gain for each channel and master gain

(
SynthDef("Simple4Chan", {

	arg chan1_ar_in = nil, chan2_ar_in = nil, chan3_ar_in = nil, chan4_ar_in = nil, master_gain = 1.0,
		chan1_gain = 1.0, chan2_gain = 1.0, chan3_gain = 1.0, chan4_gain = 1.0;
	var out_sig, chan1, chan2, chan3, chan4;

	chan1 = In.ar(chan1_ar_in, 1) * chan1_gain;
	chan2 = In.ar(chan2_ar_in, 1) * chan2_gain;
	chan3 = In.ar(chan3_ar_in, 1) * chan3_gain;
	chan4 = In.ar(chan4_ar_in, 1) * chan4_gain;

	out_sig = Mix.ar([chan1, chan2, chan3, chan4])!2 * master_gain; // mix down with simple gain control
	Out.ar(0, out_sig); // final output to DAC

}).writeDefFile("~/Documents/SC_proj_local/Syndefs".standardizePath);
)
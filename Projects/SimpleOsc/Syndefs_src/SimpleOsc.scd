// Synthdef for SimpleOsc project
// Additive synth with freq and amp controls for 3 oscillators
// using multi-channel expansion and Mix to single output bus
(
SynthDef.new("SimpleOsc",
	{
		arg out = 0, freq1=400, amp1 = 0.5, freq2=300, amp2 = 0.3, freq3 = 100, amp3=0.2,
			overall_amp = 0.75, gate = 0;
		var sig, mix, env;

		sig = SinOsc.ar([freq1,freq2,freq3]) * [amp1, amp2, amp3];
		env = EnvGen.kr(Env.adsr, gate);
		mix = Mix.new(sig) * overall_amp * env;

		Out.ar(out, mix);  // mono out bus
	}
).writeDefFile("../Syndefs".resolveRelative.standardizePath);
)

// ---- test -----//
x = Synth.new("SimpleOsc",[\out, 0]);
x.set(\freq2,130,\amp2,0.1,\amp1,0.1,\freq3,550,\amp3,0.3)
x.set(\gate, 0);
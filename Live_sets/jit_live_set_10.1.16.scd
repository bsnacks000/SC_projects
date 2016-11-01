(
~synth_lib = (

	noise: SynthDef("pink_noise", { |out=0, amp = 0.5|
		Out.ar(out, PinkNoise.ar(amp)!2);
	}),

	noise_p: SynthDef("pink_noise_p", { |out=0, amp=0.5, atk=0.1, rel=0.1|
		Out.ar(out, PinkNoise.ar(amp)!2 * EnvGen.kr(Env.perc(atk,rel), doneAction:2));
	}),

	sine: SynthDef("sine", {|out=0, freq=400, amp=0.5|
		Out.ar(out, SinOsc.ar(freq)!2 * amp);
	}),

	sine_p: SynthDef("sine_p", {|out=0, freq=400, amp=0.5, atk=0.1, rel=0.1|
		Out.ar(out, SinOsc.ar(freq)!2 * amp * EnvGen.kr(Env.perc(atk,rel), doneAction:2));
	}),

	formant: SynthDef("formant", { |out=0, amp=0.5, fundfreq=400, formfreq=250, bwfreq=80|
		Out.ar(out, Formant.ar(fundfreq, formfreq,bwfreq)!2 * amp)
	}),

	formant_p: SynthDef("formant_p", { |out=0, amp=0.5, fundfreq=400, formfreq=250, bwfreq=80, atk=0.1, rel=0.1 |
		Out.ar(out, Formant.ar(fundfreq, formfreq,bwfreq)!2 * amp * EnvGen.kr(Env.perc(atk,rel), doneAction:2))
	})
);


~constructor = { |server, synth_lib|

	var proxy = ProxySpace.new(server);
	proxy.know=true;
	proxy.fadeTime = 3;

	synth_lib.do({ |i| i.add; }); // add all synths in lib
	proxy

	// init proxies -- for now two mix channels to master out

	/*proxy[\mix0] = NodeProxy.audio(server,2);
	proxy[\mix1] = NodeProxy.audio(server,2);

	proxy[\verb] = { FreeVerb.ar(proxy[\mix0].ar + proxy[\mix1].ar, 0.5, 0.5) }; // master reverb

	proxy[\master] = proxy[\mix1] + proxy[\mix2] + proxy[\verb];   // master output*/
};
)
/*************************/
s.reboot;


~sesh = ~constructor.(s,~synth_lib)

~sesh.master.pop;

~sesh.sine = \sine
~sesh.mix0 = ~sesh.sine

~sesh.mix0.xset(\freq, 500);


~sesh.sine.set(\freq, 100);



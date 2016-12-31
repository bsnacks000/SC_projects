// JIT, Audio and Server Code

(
SynthDef(\grain, {|out=0, freq=400, amp=0.1, atk=0.01, rel=0.05, pos=0 |
	var env = EnvGen.ar(Env.perc(atk,rel),doneAction:2) * amp;
	var sig = FSinOsc.ar(freq) * env;
	OffsetOut.ar(out, Pan2.ar(sig, pos));
}).add;
)

(
~pspace_constructor = {
	// creates single proxy space (p), pushes output proxies
	// API contains the parameter event obj and cloudGen function that builds the cloud... more controls can be added
	// Version1: hard coded for one global proxyspace and one instrument... future version needs to be dynamic

	{
		p = ProxySpace.new(s).know_(true);
		p.pattern.ar;
		p.out.ar;

		p.out = p.pattern;
		p.fadeTime = 3;

	}.value;

	//API exposes param object to outside controller... another option is to make this private and use
	// getters and setters
	(
		param: (
			instrument: \grain,
			dur: 0.1,
			freq: 400,
			amp: 0.1,
			atk: 0.01,
			rel: 0.05,
			pos: 0
		),


		cloudGen:{ |self, voices, fadeTime=3|

			p.pattern = nil;
			p.pattern.fadeTime = fadeTime; // changes individual pattern fadetime

			voices.do({ |i|
				p.pattern[i] = Pbind(
					\instrument, Pif(self.param.instrument.isKindOf(Function),self.param.instrument.value, self.param.instrument),
					\dur, Pif(self.param.dur.isKindOf(Function), self.param.dur.value , self.param.dur),
					\freq, Pif(self.param.freq.isKindOf(Function), self.param.freq.value, self.param.freq),
					\amp, Pif(self.param.amp.isKindOf(Function), self.param.amp.value, self.param.amp),
					\atk, Pif(self.param.atk.isKindOf(Function), self.param.atk.value, self.param.atk),
					\rel, Pif(self.param.rel.isKindOf(Function), self.param.rel.value, self.param.rel),
					\pos, Pif(self.param.pos.isKindOf(Function), self.param.pos.value, self.param.pos),
				);
			});
		}
	)
}
)


~synth = ~pspace_constructor.value  // also returns 'p' the ProxySpace

~synth.cloudGen(7,10) // change with this...

p.out.play;  // controls output proxy only... no direct control to
p.out.end;

~synth.param.dur = {exprand(0.1,0.5)};         // direct control of proxies via parameter event object
~synth.param.amp = Pwhite(0.01,0.1);
~synth.param.freq = Pexprand(150,1500,inf);
~synth.param.rel = 0.025;

p.pattern.end;
p.gui

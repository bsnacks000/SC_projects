p = ProxySpace.push(s)
(
SynthDef(\grain, {|out=0,freq=400, amp=0.1, atk=0.01, rel=0.1, pos=0|
	var env = EnvGen.ar(Env.perc(atk,rel), doneAction:2) * amp;
	var sig = SinOsc.ar(freq) * env;
	Out.ar(out,Pan2.ar(sig,pos));
}).add;
)

(
var num = 12;
~pattern=nil;
num.do({|i|
	~pattern[i] = Pbind(\instrument, \grain,
		\dur, {exprand(0.01, 0.2)}.value,
		\freq,{choose((120,150..1500))}.value,
		\atk, 0.01,
		\rel,{exprand(0.01,0.05)}.value ,
		\amp,0.03
	);
});
)
~pattern.fadeTime = 3;
~pattern.play;
~pattern.stop;
~pattern = nil;

f = Environment.new().know_(true);
(
f.pattern_func = { |num, inst, dur, freq, atk, rel, amp |
	~pattern=nil;
	num.do({|i|
		~pattern[i] = Pbind(\instrument, inst,
			\dur, dur,
			\freq,freq,
			\atk, atk,
			\rel,rel,
			\amp, amp
		);
	});
};
)

f = Environment().know_(true);
(
f.single_pbind = {| inst, dur, freq, atk, rel, amp |
	Pbind(\instrument, inst,\dur, dur, \freq, freq, \atk, atk, \rel, rel, \amp, amp);
}
)

(
var num = 10;
~pattern = nil;

num.do({|i| ~pattern[i] = f[\single_pbind].(

	\grain, Pexprand(0.05, 0.09), Pxrand((20,50..10500),inf),
	Prand((0.001,0.002..0.005),inf), Prand((0.001,0.002..0.005),inf), Pwhite(0.005,0.03))

});

)


~pattern.play;
f[\pattern_func].(10,\grain, Pexprand(0.05, 0.09), Pxrand((20,50..2500),inf), Prand((0.001,0.002..0.01),inf), Prand((0.001,0.002..0.01),inf), Pwhite(0.005,0.03))
~pattern.end;


// Pif wrapper tests for a Function... if it is then it is evaluated
// this produces the "single voice" effect
// this allows constants/patterns and seq.methods
(
var num = 5;
var dur={exprand(0.01, 0.2)}, freq={choose((120,150..2500))}, atk=0.01, rel={exprand(0.01,0.05)}, amp=Pwhite(0.01,0.05);

~pattern=nil;

num.do({|i|
	~pattern[i] = Pbind(\instrument, \grain,
		\dur, Pif(dur.isKindOf(Function),dur.value, dur),
		\freq, Pif(freq.isKindOf(Function),freq.value, freq),
		\atk, Pif(atk.isKindOf(Function),atk.value, atk),
		\rel, Pif(rel.isKindOf(Function),rel.value, rel),
		\amp, Pif(amp.isKindOf(Function),amp.value, amp)
	);
});
)
~pattern.end;






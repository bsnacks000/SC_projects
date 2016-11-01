// basic template for a quick build ProxySpace
// synth_defs and synth_funcs are seperated.

(
~constructor = { |server|

	var synth_defs = (
		sine: SynthDef("sine_da2", {|out=0, freq=400, amp=1, atk=0.01,rel=0.3 |
			Out.ar(out,SinOsc.ar(freq)!2 * amp * EnvGen.kr(Env([0,1,0],[atk,rel],[1,-1]),doneAction:2));
		})

	);

	var synth_funcs = (
		sine: {|freq=440, amp=0.5, scale= 0| SinOsc.ar(freq)!2 * amp + scale}

	);

	var init = { | server |

		var proxy = ProxySpace.new(server).know = true;

		synth_defs.do({|i| i.add }); // add all defs
		synth_funcs.keysValuesDo({|k,v| proxy[k] = v });

		proxy;
	}.value;

	init;
}
)

~test = ~constructor.(s)
~test.fadeTime = 5;
~test.sine.play;
~test.sine.xset(\freq, 500)
~test.sine.end
~test.pattern = Pbind(\instrument, "sine_da2", \freq, Pseq((760,740 .. 80),inf), \dur, Prand([0.05,0.1],inf), \rel, 0.05, \amp, 0.8, \atk, 0.01)

~test.out = NodeProxy.audio(s,2)
~test.out.play;
~test.out.end;
~test.out = ~test.pattern;
(
(40,60 .. 280)

)	
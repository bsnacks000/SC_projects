s.reboot;


x = {SinOsc.ar(440,0,0.5) * EnvGen.kr(Env([0,1,0],[0.01,0.1]),doneAction:2)}.asSynthDef.add.asDefName  // this works

Synth.new(x)
y = Pbind(\instrument, x, \dur, 1.5).play
y.stop


p = ProxySpace.push(s)


~sine = {SinOsc.ar(440,0,0.5) * EnvGen.kr(Env.perc(0.01,0.1),doneAction:2)}.asSynthDef.add // these encapsulate in SynthDef and add to SynthDesc
~sine.source.name.asSymbol // returns its key

~out.ar
~out.play;
~pattern = Pbind(\instrument, ~sine.source.name.asSymbol, \dur, 0.1) // this seems to work
~out = ~pattern
~out.fadeTime = 5;
~out.end;
~out.play;

x.name.asSymbol

SynthDescLib.global.read("synthdefs/default.scsyndef");
SynthDescLib.global.at(x.name.asSymbol) // shortcut, same as line above


(
// IMPORTANT!!!... wrap event in function and call to create closure...
// only then can events reference themselves for function calls

var x = { (a: "hello", b: 123, func: {| self, item | self[item.asSymbol] }) }.();
x.func("b").postln;
x.func(\a).postln;
x
)

// with the above... ALL synths can be created as simple UGEN functions.
// each synth lib can have three simple methods for converting the Synths into SynthDefs
// convert(item), convertAll(), get_name() --> for quickly getting the synth symbol for patterns
// in this way, any synth with da:2 envelope (when appropriate) can be used by patterns for performance
// or not depending on what you feel like doing


// testing a grain_synth library


(
~constructor = { |server|

	var synth_lib = (
		sine: {|freq=440, amp=0.5, scale= 0| SinOsc.ar(freq)!2 * amp + scale},

		sine_p: {|freq=200, amp=0.1, atk=0.01,rel=0.1| SinOsc.ar(freq)!2 * amp * EnvGen.ar(Env.perc(atk,rel),doneAction:2)
			}.asSynthDef(\ir!4,outClass:\OffsetOut).add
	);

	var init = { | server |

		var proxy = ProxySpace.new(server).know = true;

		synth_lib.keysValuesDo({|k,v| proxy[k.asSymbol] = v });

		proxy;
	}.value;

	init;
}
)

~test = ~constructor.(s)

~test.sine.source
~test.sine_p.source

ProxyMixer(~test)

~test.fadeTime = 8
(
~test.pattern = Pbind(\instrument, ~test.sine_p.source.name.asSymbol,
	\dur, 0.01, \freq, Pseq([Pseq((100,300..1100),2), Pseq((50,230..700),4), Pseq((100,220..490),1)],inf),
	\atk,0.005, \amp, 0.2, \rel, Prand((0.05..0.08),inf));
)

(
~test.pattern2 = Pbind(\instrument, ~test.sine_p.source.name.asSymbol,
	\dur, 0.1, \freq, Pseq([Pseq((3900,1500..300),7), Pseq((100,500..2670),4)],inf), \atk,0.001, \amp, 0.1);
)

(
~test.pattern3 = Pbind(\instrument, ~test.sine_p.source.name.asSymbol,
	\dur, 0.1, \freq, Pseq([Pseq((5900,230..300),5), Pseq((1100,500..170),3)],inf), \atk,0.001, \amp, 0.2, \rel,0.01);
)
(
~test.out = {FreeVerb.ar(
	~test.pattern.ar * ~test.lfo.kr + ~test.pattern2.ar * ~test.lfo.kr  + ~test.pattern3.ar * ~test.lfo.kr,
	0.7, 0.9,0.8,0.9)  }
)

~test.lfo = {LFNoise0.kr(15).exprange(0.01,1)}
~test.lfo2 = {SinOsc.kr(2).exprange(0.01,1)}

~test.out = ~test.pattern;
~test.out.play;

~test.out = ~test.pattern + ~test.sine
~test.sine.xset(\amp, 0.1, \freq, 200)

~test.sine.play;
~test.sine2 = ~test.sine;

~test.sine.fadeTime=0.5
Task({ inf.do({~test.sine.xset(\freq, (500..700).choose, \amp, (0.05..0.3).choose); 1.wait;}) }).stop;
Task({ inf.do({~test.sine2.xset(\freq, (20..100).choose, \amp, (0.05..0.3).choose); 0.5.wait;}) }).stop;

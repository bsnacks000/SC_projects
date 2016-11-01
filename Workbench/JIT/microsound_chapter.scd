currentEnvironment.clear


{Impulse.ar(MouseX.kr(12,48,1) * 0.1 ! 2)}.play;

(// Gabor grain
SynthDef(\gabor, { |out, freq=440, sustain=1, pan, amp=0.1, width=0.25 |
	var env = LFGauss.ar(sustain, width, loop:0,doneAction:2);
	var sig = FSinOsc.ar(freq, 0.5pi) * env;
	OffsetOut.ar(out, Pan2.ar(sig ,pan, amp));

}, \ir!6).add;
)


(// Gabor grain 1
SynthDef(\gabor1, { |out, freq=440, sustain=1, pan, amp=0.1 |
	var env = EnvGen.ar(Env.sine(sustain,amp),doneAction:2);
	var sig = FSinOsc.ar(freq);
	OffsetOut.ar(out, Pan2.ar(sig * env,pan));

}, \ir!6).add;
)


Pbindef(\grain,\instrument, \gabor, \freq, 1000, \dur, 0.5, \sustain, 20/1000, \amp, 0.2).play;

Pbindef(\grain, \sustain, 10/Pkey(\freq));
Pbindef(\grain, \sustain, 5/Pkey(\freq));
Pbindef(\grain, \sustain, 3/Pkey(\freq));
Pbindef(\grain, \sustain, 2/Pkey(\freq));
Pbindef(\grain, \sustain, 1/Pkey(\freq));

Pbindef(\grain, \sustain, Pseq((10..1),inf)/Pkey(\freq), \dur, 0.2)
Pbindef(\grain, \instrument, \gabor)
Pbindef(\grain).stop;


p = ProxySpace.push;
ProxyMixer(p)

~source = { SinOsc.ar * 0.1 };
~silence = {|sil_dur = 0.01| EnvGen.ar(Env([0,1,1,0,0,1,1,0],[0.01,2,0.001,sil_dur,0.001]), doneAction:2)!2 }
~listen = ~source * ~silence;
~listen.play;


~silence.spawn([\sil_dur, 0.001]);
~silence.spawn([\sil_dur, 0.005]);
~silence.spawn([\sil_dur, 0.01]);
~silence.spawn([\sil_dur, 0.1]);  //perception of gap in sound

p.pop;

s.reboot

//Order confusion with sound in fast succession
(
SynthDef(\percSin, {|out, amp=0.1, freq=440, sustain=0.01, pan |
	var snd = FSinOsc.ar(freq);
	var env = EnvGen.ar(Env.perc(0.1,0.9,amp),timeScale:sustain, doneAction:2);
	OffsetOut.ar(out, Pan2.ar(snd * env, pan));


}, \ir!5).add;

)
PdefAllGui()

Pbindef(\lo,*[instrument: \percSin, sustain: 0.05,freq: 250, amp:0.2,dur:0.5,lag:0]).play;
Pbindef(\hi,*[instrument: \percSin, sustain: 0.05,freq: 850, amp:0.2,dur:0.5,lag:0]).play;

Pbindef(\hi, \lag,0.1)
Pbindef(\hi, \lag,0.03)
Pbindef(\hi, \lag,0.001)
Pbindef(\hi, \lag,0.003)

Pbindef(\hi, \lag, ([-1,1]).choose * 0.02)

Pbindef(\hi, \pan,0);
Pbindef(\lo, \pan,-0);

Pbindef(\lo).stop; Pbindef(\hi).stop;

/////////
// Multiple grains fuse into a composite

(
Pbindef(\grain4, \instrument,\percSin,
	\sustain,0.07,\amp, 0.2, \freq, Pshuf([1000,600,350,250]), \dur, 0.001,\lag,0).play
)

Tdef(\grain, { loop({ Pbindef(\grain4).play; 0.1.wait })}).stop

Pbindef(\grain4, \freq, Pseq([1000,500,300,100].scramble))
Pbindef(\grain4, \freq, Pshuf([1000,600,300,200]));
Pbindef(\grain4).stop;


// Grain anatomy -- SynthDefs with different Envelopes
(
SynthDef(\gabor1, { |out, amp=0.1, freq = 440, sustain=0.01, pan = 0|
	var amp2 = amp * AmpComp.ir(freq.max(50)) * 0.5
	var env = EnvGen.ar(Env.sine(sustain,amp2),doneAction:2);
	var sig = FSinOsc.ar(freq) * env;
	OffsetOut.ar(out, Pan2.ar(snd * env,pan));

},\ir!5).add
)

(
SynthDef(\gabWide, { |out, amp=0.1, freq = 440, sustain=0.01, width=0.5, pan = 0|
	var holdT = sustain * width;
	var fadeT = 1 - width * sustain * 0.5;
	var amp2 = amp * AmpComp.ir(freq.max(50)) * 0.5;
	var env = EnvGen.ar(Env([0,1,1,0], [fadeT, holdT,fadeT],\sin),doneAction:2) * amp2;

	var sig = FSinOsc.ar(freq);
	OffsetOut.ar(out, Pan2.ar(sig * env,pan));

},\ir!5).add
)


(
SynthDef(\percSin, {|out, amp=0.1, freq=440, sustain=0.01, pan |
	var snd = FSinOsc.ar(freq);
	var amp2 = amp * AmpComp.ir(freq.max(50)) * 0.5;
	var env = EnvGen.ar(Env.perc(0.1,0.9,amp2),timeScale:sustain, doneAction:2);
	OffsetOut.ar(out, Pan2.ar(snd * env, pan));


}, \ir!5).add;

)

(
SynthDef(\revPercSin, {|out, amp=0.1, freq=440, sustain=0.01, pan |
	var snd = FSinOsc.ar(freq);
	var amp2 = amp * AmpComp.ir(freq.max(50)) * 0.5;
	var env = EnvGen.ar(Env.perc(0.9,0.1,amp2),timeScale:sustain, doneAction:2);
	OffsetOut.ar(out, Pan2.ar(snd * env, pan));

}, \ir!5).add;
)

(
SynthDef(\expoDec, {|out, amp=0.1, freq=440, sustain=0.01, pan |
	var snd = FSinOsc.ar(freq);
	var amp2 = amp * AmpComp.ir(freq.max(50)) * 0.5;
	var env = XLine.ar(amp2, amp2 * 0.001,sustain,doneAction:2);
	OffsetOut.ar(out, Pan2.ar(snd * env, pan));

}, \ir!5).add;
)

(
SynthDef(\revExpoDec, {|out, amp=0.1, freq=440, sustain=0.01, pan |
	var snd = FSinOsc.ar(freq);
	var amp2 = amp * AmpComp.ir(freq.max(50)) * 0.5;
	var env = XLine.ar(amp2 * 0.001,amp2, sustain,doneAction:2) * AmpComp.ir(freq) * 0.5;
	OffsetOut.ar(out, Pan2.ar(snd * env, pan));

}, \ir!5).add;
)


Pbindef(\grain0, \instrument, \gabor1, \freq, 500, \sustain, 0.01, \dur, 0.2).play

Pbindef(\grain0, \sustain, Pseq((0.005,0.01..0.05),inf));
Pbindef(\grain0, \dur, 0.1)
Pbindef(\grain0, \freq, Pseq((1000,800..50),inf))

Pbindef(\grain0, \instrument, \expoDec, \amp, 0.4)

Pbindef(\grain1, \instrument, \revPerc).play;
Pbindef(\grain1, \sustain, 0.01, \dur, Pseq([0.1,0.1,0.2,0.3],inf))
(
Pbindef(\grain0,
	\sustain, Pseq([Pseq((0.001,0.01..0.05),Prand([1,2,3],5)),Pseq((0.07,0.08..0.1),Prand([1,2,3],5))],inf))
)


























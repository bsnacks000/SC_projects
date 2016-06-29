// load a synthdef
s.boot;
(
SynthDef("gpdef",
    { arg out=0, freq=440, sustain=0.05, amp=0.1, pan;
        var env;
        env = EnvGen.kr(Env.perc(0.01, sustain), doneAction:2) * amp;
        Out.ar(out, Pan2.ar(SinOsc.ar(freq, 0, env), pan))
    }).add;
)
(
SynthDef("gpdef2",
    { arg out=0, freq=140, sustain=0.05, amp=0.1, pan;
        var env;
        env = EnvGen.kr(Env.perc(0.01, sustain), doneAction:2) * amp;
		Out.ar(out, Pan2.ar(Pulse.ar(freq,0.3, env), pan))
    }).add;
)

///////////

// changing with Pattern Proxies using Pdefn
(
Pdefn(\instrument, "gpdef");
Pdefn(\freq, Pseq([100,200,300,400,500], inf));
Pdefn(\dur, Pseq([0.2,0.1,0.1,0.1,0.2,0.1],inf));
)

(
Pdef(\pat1, Pbind(

	\instrument, Pdefn(\instrument),
	\freq, Pdefn(\freq),
	\dur, Pdefn(\dur)

));
)

Pdef(\pat1).play;
Pdefn(\instrument, "gpdef2");
Pdefn(\freq, Prand([200,300,500,600, 800, 1000],inf));
Pdefn(\dur, 0.05);

Pdef(\pat1).stop;

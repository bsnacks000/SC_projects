
(
s.options.numInputBusChannels = 0;
s.options.numOutputBusChannels = 2;
s.boot;
)

(
s.meter;
s.plotTree;
)

(

~constructor = { |server|

	var proxy = ProxySpace.new(server);
	proxy.know = true;
	proxy.fadeTime = 1;

	proxy[\osc] = { |freq=440, amp=0.5,scale=0 | (SinOsc.ar(freq) * amp + scale)!2};

	proxy[\control] = { MouseX.kr(100,400) };

};

)

//~synth.osc.source.asDefName  get "name" of temp Synthdef key for patterns

~synth = ~constructor.value(s);
~synth2 = ~constructor.value(s);

~synth.osc.xset(\freq, 250, \amp,0.25);
~synth.osc.play;


//~synth.osc.xmap(\freq, ~synth.control)

~synth2.fadeTime = 3;
~synth2.osc.xset(\freq, 100, \amp,0.1);

~synth.amp_mod =  {0.5 * ~synth2.osc.ar};
~synth.freq_mod = {|carrier=100, scale=100| carrier * ~synth2.osc + scale};

~synth.freq_mod.xset(\carrier, 234, \scale, 300);

~synth.osc.xmap(\amp, ~synth.amp_mod);

~synth.osc.xset(\freq, 450, \amp, 0.1).xmap(\freq, ~synth.freq_mod);



//Using Patterns as Node Proxies
(
~constructor2 = { |server|
	var proxy = ProxySpace.new(server);
	proxy.know = true;
	proxy.fadeTime = 1;

	SynthDef("osc", {|out=0, freq=400, amp=1, atk=0.01,rel=0.3 |
		Out.ar(out,SinOsc.ar(freq)!2 * amp * EnvGen.kr(Env([0,1,0],[atk,rel],[1,-1]),doneAction:2));
	}).add;


	SynthDef("saw", {|out=0, freq=400, amp=1, atk=0.01,rel=0.3 |
		Out.ar(out,Saw.ar(freq)!2 * amp * EnvGen.kr(Env([0,1,0],[atk,rel],[1,-1]),doneAction:2));
	}).add;


	Pdefn(\dur, 1);
	Pdefn(\freq, 200);
	Pdefn(\instrument, "osc");
	Pdefn(\atk, 0.01);
	Pdefn(\rel, 0.02);

	// store multiple patterns on a single proxy
	proxy[\osc_saw_patterns] = Pbind(
			\instrument, Pdefn(\instrument),
			\freq, Pdefn(\freq),
			\dur, Pdefn(\dur),
			\atk, Pdefn(\atk),
			\rel, Pdefn(\rel)
	);

	proxy[\out_monitor] = NodeProxy.audio(server,2)

	/*5.do({|i|
		proxy[\osc_saw_patterns][i] = Pbind(
			\instrument, Pdefn(\instrument),
			\freq, Pdefn(\freq),
			\dur, Pdefn(\dur),
			\atk, Pdefn(\atk),
			\rel, Pdefn(\rel)
		)
	});*/

};

)

~psynth = ~constructor2.value(s); // pattern plays in background silently

~psynth.out_monitor.play // this starts playback on the out monitor
~psynth.out_monitor = ~psynth.osc_saw_patterns

// filter the out channel using the patterns proxy.ar as input
~psynth.out_monitor[1] = {~psynth.osc_saw_patterns.ar * SinOsc.ar(SinOsc.kr(0.5,0,300,300))};
~psynth.out_monitor[2] = {~psynth.osc_saw_patterns.ar * LFCub.ar([2,8], add:-0.5);}    // can stack the results into different slots

~psynth.out_monitor = ~psynth.osc_saw_patterns

~psynth.control = {SinOsc.kr(10,0,200,1700)}

// control args with Pdef proxies
Pdefn(\instrument, "saw");
Pdefn(\dur, 2)
Pdefn(\freq,~psynth.control.asMap) // using asMap to map to the control input
Pdefn(\atk, 0.05)
Pdefn(\rel, 1.5)

// now you can change the control Proxy on the fly

~psynth.control = {LFNoise1.kr(5, 500,700)}



// ~name = ~psynth.osc.source.asDefName


// constructor 3... building a small synth library


(
~constructor3 = { |server, synth_lib|


	var proxy = ProxySpace.new(server);
	proxy.know = true;
	proxy.fadeTime = 1;

	synth_lib.do({|i| i.add }); // add the synths in the lib

	// build 1 output proxy
	proxy.out = NodeProxy.audio(server,2);


};


~simple_lib = (

	osc: SynthDef("osc", {|out=0, freq=400, amp=1, atk=0.01,rel=0.3 |
		Out.ar(out,SinOsc.ar(freq)!2 * amp * EnvGen.kr(Env([0,1,0],[atk,rel],[1,-1]),doneAction:2));
	}),

	saw: SynthDef("saw", {|out=0, freq=400, amp=1, atk=0.01,rel=0.3 |
		Out.ar(out,Saw.ar(freq)!2 * amp * EnvGen.kr(Env([0,1,0],[atk,rel],[1,-1]),doneAction:2));
	}),

	pulse: SynthDef("pulse", {|out=0, freq=400, amp=1, atk=0.01,rel=0.3 |
		Out.ar(out,Pulse.ar(freq)!2 * amp * EnvGen.kr(Env([0,1,0],[atk,rel],[1,-1]),doneAction:2));
	})

);
)


~psyn = ~constructor3.(s,~synth_lib);

(
~psyn.pattern[0] = Pbind(*[instrument: "osc", dur: 5,freq: Pwhite(200,500,inf) ,amp: 0.1,atk: 1,rel: 3 ]);
~psyn.pattern[1] = Pbind(*[instrument: "saw", dur: 3,freq: Pwhite(50,300,inf),amp: 0.1,atk: 2,rel: 4 ]);
~psyn.pattern[2] = Pbind(*[instrument: "pulse", dur: 6,freq: Pwhite(100,400,inf), amp: 0.1,atk: 1,rel: 5 ]);
~psyn.pattern[3] = Pbind(*[instrument: "osc", dur: 9,freq: Pwhite(300,600,inf) ,amp: 0.3,atk: 1,rel: 9 ]);
~psyn.pattern[4] = Pbind(*[instrument: "saw", dur: 10,freq: Pwhite(50,400,inf),amp: 0.2,atk: 2,rel: 8 ]);
~psyn.pattern[5] = Pbind(*[instrument: "pulse", dur: 11,freq: Pwhite(100,700,inf), amp: 0.2,atk: 1,rel: 7 ]);
)

(
~psyn.pattern1[0] = Pbind(*[instrument: "osc", dur: Pseq([0.1,0.1,0.1,0.05,0.06,0.07,0.5],inf) ,freq: Pseq([250,~psyn.mod.asMap,250,350,~psyn.mod.asMap,250],inf) ,amp: Pwhite(0.01,0.7,inf), atk: 0.01,rel: 0.04 ]);
~psyn.pattern1[1] = Pbind(*[instrument: "osc", dur: Pseq([0.01,0.01,0.1,0.07,0.5],inf) ,freq: Pseq([150,~psyn.mod.asMap,70,50,~psyn.mod.asMap,550],inf) ,amp: Pwhite(0.01,0.2,inf), atk: 0.01,rel: Prand([0.1,0.7],inf) ]);
~psyn.pattern1[2] = Pbind(*[instrument: "osc", dur: Pseq([0.01,0.1,0.2,0.5],inf) ,freq: Pseq([~psyn.mod.asMap,2170,1150,~psyn.mod.asMap,550],inf) ,amp: Pwhite(0.01,0.2,inf), atk: 0.01,rel: 0.1 ]);
~psyn.pattern1[3] = Pbind(*[instrument: "pulse", dur: Pseq([0.01,0.05,0.05,0.5],inf) ,freq: Pseq([~psyn.mod.asMap,100,200,~psyn.mod.asMap],inf) ,amp: Pwhite(0.01,0.05,inf), atk: 0.01,rel: Prand([0.1,0.7],inf)]);
)

~psyn.pattern1.removeLast;


~psyn.out.play; // out monitor

~psyn.out = ~psyn.pattern //+ ~psyn.pattern3;

~psyn.out.stop;

~psyn.out.fadeTime = 5;
~psyn.verb = { FreeVerb.ar(~psyn.pattern.ar,1,0.85,0.8) * 0.7 }

~psyn.mod = {SinOsc.kr(10,0,200,500)}
~psyn.mod[1] = {LFNoise1.kr(1).exprange(0.01,100);}

~psyn.delay = { DelayN.ar(~psyn.pattern1.ar, 2, 0.5) }
~psyn.delay2 = { DelayN.ar(~psyn.pattern1.ar, 4, 0.8) }

~psyn.out = ~psyn.verb + ~psyn.pattern1;

~psyn.out2 = NodeProxy.audio(s,2)

~psyn.out2.play;
~psyn.out2 = ~psyn.verb2

~psyn.verb2 = { FreeVerb.ar(~psyn.delay.ar + ~psyn.delay2.ar,1,0.75,0.8) * 0.6 }






(// builds an environment with neccesary
~local = (
	server: s,
	cond: Condition(false),
	syn_path: "~/Documents/SC_proj_local/Syndefs".standardizePath
);
~host = HostMixerDev(~local.syn_path,~local.server,~local.cond);
)

~inst = SimpleOscInstDev(~host);
~inst.initPdef;

~inst.set_pattern_on;
~inst.set_pattern_off;

~inst.set_dur_pattern([0.5,0.1,0.1,0.1,0.1]);
~inst.set_rel(0.5);
~inst.set_atk(0.001);
~inst.set_dcy(0.02);
~inst.set_sus(Prand([0.0,0.04,0.02],inf));


~inst.synths[0].set(\freq, 1820);


~inst2 = SimpleOscInstDev(~host);



// host testing
~host.mixer.set(\chan1_ar_in, ~host.ar_busses[0]); // set up two audio busses and
~host.mixer.set(\chan2_ar_in, ~host.ar_busses[1]);
~host.mixer.set(\gain, 0.15);
x = Synth.new("SimpleSineOsc",[\ar_out_bus, ~host.ar_busses[0]]);
x.free;
y = Synth.new("SimpleSineOsc",[\ar_out_bus, ~host.ar_busses[1], \amp, 0.2, \freq, 320]);
y.free;

// Module testing
~mod = SimpleOscModuleDev(~local.server); // builds a SimpleOsc Module
~mod.initModule;
~mod.module.free

// Instrument testing

(
SynthDef("PercEnv_da2", {

	arg out_bus_num = nil, atk = 0.005, rel = 0.3, level = 0.5;
	var env = EnvGen.kr(Env.perc(atk, rel, level), doneAction:2);
	Out.kr(out_bus_num, env);

}).add;
)


(
SynthDef("SimpleSineOsc",{

	arg ar_out_bus = nil, amp = 0.5, freq = 440, env = 0.0;
	var sig = SinOsc.ar(freq) * amp * env;
	Out.ar(ar_out_bus, sig);

}).add;
)

(
~bus_audio = Bus.new('audio',0,2,s);
~bus_kr = Bus.new('control',16,1,s);
~synth = Synth("SimpleSineOsc", [\env,~bus_kr.asMap, \ar_out_bus,~bus_audio.index]);
)
(
Pdefn(\dur, Pseq([0.6,0.5,0.16],inf).trace);
Pdefn(\instrument, "PercEnv_da2");
Pdefn(\atk, 0.01);
Pdefn(\rel, 0.1);

		// Pdef for Simple Perc envelope
		Pdef(\pattern,
			Pbind(
				\instrument,Pdefn(\instrument),
				\out_bus_num, ~bus_kr.index,
				\dur, Pdefn(\dur),
				\atk, Pdefn(\atk),
				\rel, Pdefn(\rel)
			)
		);
)


Pdef('pattern').play;
Pdef('pattern').stop;
Pdefn(\atk, 0.001)
Pdefn(\rel, 0.5)
Pdefn(\dur, Pseq([1,3,0.1,0.3], inf).trace)


(
p = Pbind(
	\instrument, "PercEnv_da2",
	\dur, Pseq([0.6,0.5,0.16],inf).trace,
	\atk, 0.005,
	\rel, 0.01,
	\out_bus_num, ~bus_kr.index
).play;
)

p.stop


)


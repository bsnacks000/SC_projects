s.boot;
s.plotTree;

//Add synths to server
(
SynthDef("SimpleSine", {

	arg freq = 440, amp = 0.5, env = 0;
	Out.ar(0, (SinOsc.ar(freq) * amp * env)!2);

}).add;

SynthDef("Amp_env", {

	arg kr_out_bus = nil,gate = 1, atk=0.01, dcy=0.1,sus=0.5,rel=0.1;
	Out.kr(kr_out_bus, EnvGen.kr(Env.adsr(atk,dcy,sus,rel),gate,doneAction:2));

}).add;

SynthDef("Freq_env", {   // Constant values

	arg kr_out_bus, val=1, gate = 1;
	var env = EnvGate.new(1,gate,doneAction:2); //fadeTime helps curve the tone a little bit
	Out.kr(kr_out_bus,env * val);

}).add;

)

//Initialize Busses
(
~kr_bus1 = Bus.control(s);
~kr_bus2 = Bus.control(s);
~synth = Synth.new("SimpleSine", [\freq, ~kr_bus1.asMap, \env, ~kr_bus2.asMap]);
)

// Initialize Pdefs
(
Pdefn(\dur, Pseq([0.1,0.1,0.1,0.1,0.3],inf));
Pdefn(\freq_val, Pseq([100,200,300,400,500],inf));


Pdef(\freq_env,
	Pbind(
		\instrument, "Freq_env",
		\dur, Pdefn(\dur),
		\kr_out_bus, ~kr_bus1,

		\val, Pdefn(\freq_val)
));

Pdefn(\atk, 0.01);
Pdefn(\dcy, 0.1);
Pdefn(\sus, 0.0);
Pdefn(\rel, 0.2);

Pdef(\amp_env,
	Pbind(
		\instrument, "Amp_env",
		\dur, Pdefn(\dur),
		\kr_out_bus, ~kr_bus2,

		\atk, Pdefn(\atk),
		\dcy, Pdefn(\dcy),
		\sus, Pdefn(\sus),
		\rel, Pdefn(\rel)
	)
);
)

// duration shared and synced between both pDefs?
x = Ppar([Pdef(\amp_env), Pdef(\freq_env)],inf).play;
x.stop;

//creates a group on the server
x = Pgpar([Pdef(\amp_env), Pdef(\freq_env)],inf).play
x.stop


//controls

Pdefn(\dur, Prand([0.05,0.01,0.08],inf));
Pdefn(\freq_val, Prand([300,11250,16100,100,2004],inf));
Pdefn(\atk, 0.0007);
Pdefn(\dcy, 0.005);
Pdefn(\sus, 0.1);
Pdefn(\rel, 0.1);


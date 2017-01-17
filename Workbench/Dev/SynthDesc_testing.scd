
// the goal is to keep SynthDefs for TransGrain in classes with their APIs
// They should only be added to the server if there is no global reference in SynthDescLib

// this script tests whether a Syndef is already loaded


s.boot;
SynthDef(\test, { Out.ar(0, SinOsc.ar()!2 * 0.5); }).add;


SynthDescLib.global.at(\test) == nil;


if(SynthDescLib.global.at(\test) == nil, {
	SynthDef(\test, { Out.ar(0, SinOsc.ar()!2 * 0.5); }).add;
}, {
	"SynthDef already added...".postln;
});

x = Synth(\test)
x.free
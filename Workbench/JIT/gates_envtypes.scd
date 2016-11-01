s.reboot

x = {PinkNoise.ar * 0.5}.play;
x.free;

x = { Pulse.ar(ExpRand(30,500)) * Line.kr(1,0,1, doneAction:2)}.play;
x = { Pulse.ar(ExpRand(200,500), ExpRand(0.01,1)) * XLine.kr(1, 0.01, 1, doneAction:2)}.play
x = { var dur = 1; Pulse.ar(XLine.kr(ExpRand(200,700),50,dur)) * XLine.kr(1,0.001,dur, doneAction:2)}.play

(
y = Env.new([0,1,0.2,0],[0.5,1,2], [\sine, \sine, 0]);
x = { Pulse.ar(ExpRand(200,500)) * EnvGen.kr(y, doneAction:2)}.play
)


x = {|t_gate=0|Pulse.ar(ExpRand(200,500)) * EnvGen.kr(y,t_gate)}.play
x.set(\t_gate, 1)

x = { |gate=0|Pulse.ar(100) * EnvGen.kr(Env.adsr, gate)}.play
x.set(\gate, 0)

Pbind
s.quit;
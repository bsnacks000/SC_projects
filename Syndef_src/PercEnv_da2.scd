(
SynthDef("PercEnv_da2", {

	arg out_bus_num = nil, atk = 0.005, rel = 0.3, level = 0.5;
	var env = EnvGen.kr(Env.perc(atk, rel, level), doneAction:2);
	Out.kr(out_bus_num, env);

}).writeDefFile("~/Documents/SC_proj_local/Syndefs".standardizePath);
)
(
SynthDef("AsrEnv_da2", {

	arg out_bus_num = nil, atk = 0.005, dcy = 0.3, rel = 0.1, sus = 0.5, gate = 1;
	var env = EnvGen.kr(Env.adsr(atk,dcy,sus,rel),gate, doneAction:2);
	Out.kr(out_bus_num, env);

}).writeDefFile("~/Documents/SC_proj_local/Syndefs".standardizePath);
)
(
	"SC_SYNTHDEF_PATH".setenv("Syndefs".resolveRelative.standardizePath); //customize this path for projects
	"echo $SC_SYNTHDEF_PATH".unixCmd;
s.boot;
)
s.quit;

// getting a val from synth


x = Synth.new("SimpleOsc");
x.set(\gate, 1);
x.set(\gate, 0);
x.free;


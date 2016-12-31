// control structures for Trans-Grain

//1. Parse an object of objects and assign to the global

(
~param =  (
		instrument: \grain,
		dur: 0.1,
		freq: 400,
		amp: 0.1,
		atk: 0.01,
		rel: 0.05,
		pos: 0
);

~p_objs = (
	consts: (instrument: \grain2),
	tuples: (dur: #[0.01,0.1]),
	seqs: (freq: (50,100..300)),
	patterns: (pos: Pwhite(-1,1))
)

)

// need to assign a method as a function parameter

~f = {||

	(
		a: value;
	)
}

(
var x = {};
x.class

)








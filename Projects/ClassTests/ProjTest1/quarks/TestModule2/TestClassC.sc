TestClassC {
	var <>a, <>b, <>c, <>d, <>e;

	*new{ | a, b, c, d |
		^super.newCopyArgs(a,b,c,d).init;
	}

	init{
		a = 1;
		b = 2;
		c = 3;
		d = 4;
		e = 5;
	}

	info {
		"Instance variables are:  a = ".post; a.value.post;
		" b = ".post; b.value.post;
		" c = ".post; c.value.postln;
		" d = ".post; d.value.postln;
		" e = ".post; e.value.postln;
	}



}
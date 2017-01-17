TestClass {
	var <>a, <>b, <>c;
	*new{arg a, b, c;
		^super.newCopyArgs(a,b,c);
	}

	init{
		a = 1;
		b = 2;
		c = 3;
	}

	set{arg arga, argb, argc;
		a = arga;
		b = argb;
		c = argc;
	}

	info {
		"Instance variables are:  a = ".post; a.value.post;
		" b = ".post; b.value.post;
		" c = ".post; c.value.postln;
	}
}

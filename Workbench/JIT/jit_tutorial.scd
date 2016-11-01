//using a ref as proxy

y = `(nil) // this creates a proxy as a Reference Object `()
y

z = y + 10  // returns a function
y.(34)        // evaluate
z.()          // now z evaluates

// without the reference this does not work
y = nil
z = y + 10 // this fails
y = [nil]
z = y + 10 // this fails


// using Environment variables.. global dictionary...
currentEnvironment.postln();

~x; // nil
~x = 9
~x
~x + 200 // stored
currentEnvironment.postln();

// using a function as a proxy
y = nil;
z = {y} + 10; //
y = 34;
z.();

//Node Proxy
s.boot;
y = NodeProxy.audio(s,2); // directly creating into interpreter vars... always takes a static num of channels
z = NodeProxy.audio(s,2);


z.play;
z.source = y.sin * 0.2;

(
y.source = {
	Saw.ar([200,100],1,0)
}
)
y.clear
z.clear

s.quit;

// using a proxyspace
p = ProxySpace.push(s.boot);

~z.play;
~z = ~y.sin * 0.2;
~y = { Saw.ar([200,300], 2.3 * pi)};
currentEnvironment.postln()


p.clear; //kills the proxy space
p.pop; // pops it from currentEnvironment
currentEnvironment.postln()

// normal Environment lookup
~a = 9;
~b = -90
~b + ~a

// accessing environment via dict lookup with symbols
x = currentEnvironment;
x[\a]
x[\b]
x[\a] + x[\b] // equivalent to ~a + ~b ... tilde is a shortcut. all env vars reside as a key:value pair in some env
x.know=true; // this allows class attribute style calling to work
x.a


~pspace = ProxySpace.new(s).know(true);
~pspace.know = true;
s.boot;

~pspace
~pspace[\synth] = {RLPF.ar(Impulse.ar(10) * 32, [950,200],0.14)};
~pspace[\synth].play;   // a Monitor is created and is independent of the proxy... allows code changes to be implemented on fly
~pspace[\synth].free;

~pspace.know = true;

currentEnvironment.removeAt(\pspace);
currentEnvironment

~object = ();
~object.pspace = ProxySpace.new(s)

~object.pspace.know = true;

~object.pspace.synth = nil;


~pspace2 = ProxySpace.new(s).know = true; // this works somehow




















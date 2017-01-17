//testing loading a module from a local file... here its pushed into an interpreter variable
(

m = Environment().know_(true);
m.mod_test = "module_test.scd".loadRelative[0];

~x = m.mod_test[\classB].(100,120); // this access scheme is the only way to correctly initiate the classes
~y = m.mod_test[\classA].("hey","what");

~x.getA().postln;
~x.getB().postln;

~y.getA().postln;
~y.getB().postln;

~x.setA(42);
~x.getA().postln;


)

~x[\getA].() // this works too


~new = Environment.make({ ~a = 1; ~b = 2; }).know_(true); // this might be an even better way of making a module instance if it can sit in its own file.
currentEnvironment

// this file uses Environment.make
~module = "module_test2.scd".loadRelative[0]
~someClass = ~module[\xClass].value(1000,2000)
~someClass.getA()



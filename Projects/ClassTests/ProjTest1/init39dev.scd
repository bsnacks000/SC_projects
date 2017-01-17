// Installs a class from a local Quark and then uninstalls it
// These three lines need to be excuted -- wrap in a util function

// The API for 3.9dev changed slightly


(
var localpath = thisProcess.nowExecutingPath.dirname +/+ "quarks"; // add this as a local path for install
Quarks.install(localpath +/+ "TestModule"); // now install each Module seperately
Quarks.install(localpath +/+ "TestModule2");

thisProcess.recompile;
)

// all classes in each module(folder) are compiled and ready

x = TestClass(1,2,3);
y = TestClassB();
z = TestClassC();
x.info;
y.info;
z.info

(
Quarks.uninstall("TestModule");   // explicitly cleanup and recompile so as not to pollute the global class library with project classes
Quarks.uninstall("TestModule2");
thisProcess.recompile;
)

x = TestClass(1,2,3) // error
Quarks.clear;
thisProcess.recompile;





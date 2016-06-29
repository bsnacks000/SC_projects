// Installs a class from a local Quark and then uninstalls it
// These three lines need to be excuted -- wrap in a util function

(
~myQuark = Quarks(reposPath:"", localPath: thisProcess.nowExecutingPath.dirname +/+ "quarks");
~myQuark.install("TestClass"); // install and recompile library
thisProcess.recompile;
)

~test = TestClass(1,2,3);
~test.info;

(
~myQuark = Quarks(reposPath:"", localPath: thisProcess.nowExecutingPath.dirname +/+ "quarks");
~myQuark.uninstall("TestClass");
thisProcess.recompile;
)

~test = TestClass(1,2,3);  // returns Class not defined error
~test.info;
( // Prototype style object creation similar to javascript...

// this makes an empty object and then adds onto


var object = Event.new(); // creates an empty object
var object2 = Event.new(proto: object, parent: object); // creates a second object2 with object1 as parent and proto
var object3 = Event.new(proto: object);

object.name = "new guy";             // set a variable to object
object.get_name = { |self|
	self.name ++ "... added this";
};

object2.proto.n = 42;   // adding an object via the prototype chain

object2.n.postln();  // 42... looks up the proto chain
object3.get_name.postln();  // returns new_guy

object2;      // yet object2 and object3 is blank since nothing has been added to these instances...

object3.only_three = "this is only in object3 instance";
object2.only_two = "this is only in object2 instance";
object2.postln();
object3.postln();
object;

)


( // using literal

var object = (
	proto: nil,
	parent: nil,

	name: "Bob",
	get_name: {|self|
		self.name ++ "... has been gotten"
	}

);

object.get_name();

)

( // using a constructor function that returns a literal object prototype
// this creates a object "factory"... children link to the parent/proto by passing args to a closure


var make_obj = { arg name, parent = nil, proto = nil;
	(
		parent: parent,        // setting parent/prototype
		proto: proto,

		name: name,  // instance vars

		get_name: {|self|
			self.name ++ "... has been gotten"
		}
	);
};


var parent = make_obj.("hep");
var child1 = make_obj.("tup", parent, parent);

// add vars and method to the parent...
parent.n1 = 42;
parent.n2 = 1;
parent.add_meth = {|self| self.n1 + self.n2};

parent.postln();
child1.n1.postln();  // child gets the vars and reference from prototype chain
child1.n2;

child1.add_meth();

child1.subtract = {|self| self.n1 - self.n2};  // unique method to the child1 instance
parent.subtract();  // returns nil
child1.subtract(); // returns 41

)





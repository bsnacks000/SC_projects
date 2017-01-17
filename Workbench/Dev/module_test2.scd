Environment.make({

	~xClass = {|inA, inB|
		var privA = inA;
		var privB = inB;

		(
			getA: {|self| privA; },
			getB: {|self| privB; },
			setA: {|self, x| privA = x;},
			setB: {|self, x| privB = x;}
		)
	};

	~yClass = {|inA, inB|
		var privA = inA;
		var privB = inB;

		(
			getA: {|self| privA; },
			getB: {|self| privB; },
			setA: {|self, x| privA = x;},
			setB: {|self, x| privB = x;}
		)
	};

}).know_(true);
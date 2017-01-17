// a module...  an Event object with individual classes as keys
(
		classA: { | inA=10, inB=20 |

			var privA = inA;
			var privB = inB;

			(
				getA: {|self| privA; },
				getB: {|self| privB; },
				setA: {|self, x| privA = x;},
				setB: {|self, x| privB = x;}
			)
		},

		classB: { | inA=50, inB=60 |

			var privA = inA;
			var privB = inB;

			(
				getA: {|self| privA; },
				getB: {|self| privB; },
				setA: {|self, x| privA = x;},
				setB: {|self, x| privB = x;}
			)
		}

)
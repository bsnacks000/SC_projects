// pseudo-object that makes the gui
{
	arg synth;   //class init var -- reference to synth (or synths)

	//loads callback library/env
	var callbacks = "./Gui/callbacks.scd".loadRelative;

	//gui vars
	var parent, knob_amp1, knob_amp2, knob_amp3, knob_freq1, knob_freq2, knob_freq3,
	val_amp1, val_amp2, val_amp3, val_freq1, val_freq2, val_freq3, on_off,
	overall_amp;

	//constructor builds gui
	{
		//Window.closeAll;
		parent = Window.new("GUI", Rect(750,50,250,250)).front.alwaysOnTop_(true);

		// build objects
		knob_amp1 = Knob(parent, Rect(20,20,50,50));
		knob_amp2 = Knob(parent, Rect(80,20,50,50));
		knob_amp3 = Knob(parent, Rect(140,20,50,50));
		knob_freq1 = Knob(parent, Rect(20,120,50,50));
		knob_freq2 = Knob(parent, Rect(80,120,50,50));
		knob_freq3 = Knob(parent, Rect(140,120,50,50));

		val_amp1 = NumberBox(parent, Rect(20,80,50,20));
		val_amp2 = NumberBox(parent, Rect(80,80,50,20));
		val_amp3 = NumberBox(parent, Rect(140,80,50,20));
		val_freq1 = NumberBox(parent, Rect(20,180,50,20));
		val_freq2 = NumberBox(parent, Rect(80,180,50,20));
		val_freq3 = NumberBox(parent, Rect(140,180,50,20));

		on_off = Button(parent, Rect(200,20,30,30));
		overall_amp = Slider(parent, Rect(200,60,25,140));
		//vu = LevelIndicator(parent, Rect(275,50,10,150)); need to figure this out

		// assign callbacks and other values
		knob_amp1.action_({|obj| callbacks[0][\knob_amp].value(obj, synth,\amp1, val_amp1); });
		knob_amp2.action_({|obj| callbacks[0][\knob_amp].value(obj, synth,\amp2, val_amp2); });
		knob_amp3.action_({|obj| callbacks[0][\knob_amp].value(obj, synth,\amp3, val_amp3); });

		knob_freq1.action_({|obj| callbacks[0][\knob_freq].value(obj, synth,\freq1, val_freq1); });
		knob_freq2.action_({|obj| callbacks[0][\knob_freq].value(obj, synth,\freq2, val_freq2); });
		knob_freq3.action_({|obj| callbacks[0][\knob_freq].value(obj, synth,\freq3, val_freq3); });

		// val boxes slaved to knobs
		val_amp1.clipLo_(0).clipHi_(1).decimals_(2);
		val_amp2.clipLo_(0).clipHi_(1).decimals_(2);
		val_amp3.clipLo_(0).clipHi_(1).decimals_(2);
		val_freq1.clipLo_(20).clipHi_(5000).decimals_(2);
		val_freq2.clipLo_(20).clipHi_(5000).decimals_(2);
		val_freq3.clipLo_(20).clipHi_(5000).decimals_(2);


		// on_off and amp slider
		on_off.states_([["OFF"],["ON"]]).action_({
			|obj| callbacks[0][\on_off].value(obj, synth, \gate)});

		overall_amp.background_(Color(0,0,0,0.25)).value_(0.5).action_({
			|obj| callbacks[0][\amp_slider].value(obj, synth, \overall_amp)});

		parent.onClose_({synth.free;})

	}.value;
};

// Container class of callback methods for gui objects
// each takes obj and reference to the synth and synth parameter

(

knob_amp:{
	arg obj, synth, syn_param,link_obj;
	var amp;

	amp = obj.value.linexp(0,1,0.001,1); //ControlSpec help file

	synth.set(syn_param, amp); // use Node Watcher to avoid sending if synth is not on
	link_obj.value_(obj.value.linexp(0,1,0.001,1))

},
knob_freq:{
	arg obj, synth, syn_param, link_obj;
	var freq;

	freq = obj.value.linexp(0,1,20,5000); //ControlSpec help file

	synth.set(syn_param, freq);   // use Node Watcher to avoid sending if synth is not on
	link_obj.valueAction_(obj.value.linexp(0,1,20,5000))

},
val_box_amp:{
	arg obj, link_obj;

	//obj.value = (link_obj.value);
	link_obj.value.postln;

},

val_box_freq:{
	arg obj, link_obj;

	//obj.value = (link_obj.value);
	link_obj.value.postln;
},

amp_slider:{
	arg obj, synth, syn_param;

	var amp;
	amp = obj.value.linexp(0,1,0.001,1);
	synth.set(syn_param, amp)
},

on_off:{
	arg obj, synth, syn_param;

	if(obj.value == 1, {synth.set(syn_param, 1);}, {synth.set(syn_param, 0);});
}


)
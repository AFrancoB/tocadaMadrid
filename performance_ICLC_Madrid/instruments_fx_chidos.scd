(
// filtros;
SynthDef(\compander, {|in=99, out=0, gate=1, pan= 0|
	var sig, env;
	sig= Pan2.ar(Compander.ar(In.ar(in,2), WhiteNoise.ar(0.99), 0.75, mul:0.9), pan);
	env= EnvGen.kr(Env.adsr(0.0001,1,0.1),gate, doneAction:0);
	Out.ar(out, sig*env)
}).add;


SynthDef(\crackle, {|in=8, out=99, gate=1|
	var sig, env;
	sig= Pan2.ar(Crackle.ar(TExpRand.kr(0.1,1.5, Dust.kr(13)))*In.ar(in), LFNoise2.ar(0.2));
	env= EnvGen.kr(Env.asr(0.0001,1,0.1),gate, doneAction:2);
	Out.ar(out, sig*env)
}).add;

SynthDef(\reverb, {|in=10, out=99, gate=1|
	var sig, env;
	sig= FreeVerb2.ar(In.ar(in), In.ar(in+1), 0.2, 0.3, 0.2);
	env= EnvGen.kr(Env.asr(0.0001,1,0.1),gate, doneAction:2);
	Out.ar(out, sig*env)
}).add;

SynthDef(\combC, {|in=12, out=99, gate=1|
	var sig, env;
	sig= Pan2.ar(CombC.ar(In.ar(in,2),1, LFNoise2.ar(0.05, 0.05, 0.06), 0.5, 0.35), LFNoise2.ar(0.2));
	env= EnvGen.kr(Env.asr(0.0001,1,0.1),gate, doneAction:2);
	Out.ar(out, sig*env)
}).add;

SynthDef(\convo, {|in=14, out=99, gate=1|
	var sig, env;
	sig= Pan2.ar(Convolution.ar(In.ar(in,2), WhiteNoise.ar(0.4), 512/8, 0.5).distort, LFNoise2.ar(0.2));
	env= EnvGen.kr(Env.asr(0.0001,1,0.1),gate, doneAction:2);
	Out.ar(out, sig*env*0.2)
}).add;

SynthDef(\verb, {|in=16, out=99, gate=1|
	var sig, env;
	sig= GVerb.ar(In.ar(in,2), 20, 2, 0.4, mul:0.25);
	env= EnvGen.kr(Env.asr(0.0001,1,0.1),gate, doneAction:2);
	Out.ar(out, sig*env)
}).add;

SynthDef(\vowel, {|in=18, out=99, gate=1, pan=0, vowel= 0|
	var sig, env;
	// bandpass filter con muchas bandas, filtra el input usando formantes de vocales,
	// la clase Vowel es la que genera las frecuencias donde ocurren los filtros tambien se decide la amplitud y el ancho de cada banda
	sig= BPFStack.ar(In.ar(in,2),Vowel([\a,\e,\i,\o,\u][0], [\bass, \tenor, \alto, \soprano]),1, 4, 1);
	sig= Pan2.ar(sig, pan)*4;
	env= EnvGen.kr(Env.asr(0.0001,1,0.1),gate, doneAction:2);
	Out.ar(out, sig*env)
}).add;


// instrumentos
(
SynthDef(\pianoPhM, { |out=0, freq=440,gate=1, sust=0.08, trig=0, amp=0.5,rho=1|
	    var sig = OteyPiano.ar(freq, amp, Impulse.kr(trig))*EnvGen.kr(Env.asr(0.001,sust,0.1),gate,doneAction:2);

	Out.ar(out, Pan2.ar(sig*1, LinLin.kr(freq,36.midicps,90.midicps,-0.75,0.75)));
}).add;
);

(
SynthDef(\pluck, {| freq=220, coef=0.1, amp=1, pan=0, out=0 |
	var sig, env;

	sig= Pluck.ar(Pulse.ar(freq*[0.25, 0.5, 0.75]), Impulse.ar(0), freq.reciprocal, freq.reciprocal, 1, coef, amp);
	sig= Pan2.ar(Mix(sig), pan);

	env= EnvGen.kr(Env.perc(0.01, 1.2), doneAction:2);

	Out.ar(out, sig*env)
}).add
);

)

(
var baseDir = "C:/Users/afran/Desktop/performance_ICLC_Madrid/drumKits/IAMM_Kits";
//var baseDir = thisProcess.nowExecutingPath.dirname;//this line is not working dont know why
var iamm = [
	SoundFile.collectIntoBuffers(baseDir++"/Kit_1/*",s),
	SoundFile.collectIntoBuffers(baseDir++"/Kit_2/*",s),
	SoundFile.collectIntoBuffers(baseDir++"/Kit_3/*",s),
	SoundFile.collectIntoBuffers(baseDir++"/Kit_4/*",s),
	SoundFile.collectIntoBuffers(baseDir++"/Kit_5/*",s),
	SoundFile.collectIntoBuffers(baseDir++"/Kit_6/*",s),
	SoundFile.collectIntoBuffers(baseDir++"/Kit_7/*",s),
	SoundFile.collectIntoBuffers(baseDir++"/Kit_8/*",s)
];

~iamm= iamm;

(
SynthDef(\drums, {|amp=1, out=10, pan=0, bufnum=0, numChanns=1, rate=1, trig=0.01, pos=0, done=2, att= 0.001, sust= 0.3, dec=0.001|

	var sig, env;

	sig= PlayBuf.ar(2, bufnum, rate, Impulse.kr(trig), pos, loop:0)*amp;
	sig= Pan2.ar(sig, pan);

	env= EnvGen.kr(Env([0,1,1,0],[att, sust, dec]),doneAction:2);

	Out.ar(out, Limiter.ar(sig,0.99)*env)

}).add;
);




(
// this function will work as a administrator of drums and drumkits;
~drums= { |kit, instrument|
	var diccionarioKit = Dictionary.new(2000);
	var diccionarioInst = Dictionary.new(2000);

// choose between kits
diccionarioKit.add(\k1    ->  0);
diccionarioKit.add(\k2    ->  1);
diccionarioKit.add(\k3    ->  2);
diccionarioKit.add(\k4    ->  3);
diccionarioKit.add(\k5    ->  4);
diccionarioKit.add(\k6    ->  5);
diccionarioKit.add(\k7    ->  6);
diccionarioKit.add(\k8    ->  7);

	// config for kit 1;
	diccionarioInst.add(\bass       -> [5, ""]);
	diccionarioInst.add(\cHat       -> [10, ""]);
	diccionarioInst.add(\oHat       -> [0, ""]);
	diccionarioInst.add(\pHat       -> [12, ""]);
	diccionarioInst.add(\snare      -> [7, ""]);
	diccionarioInst.add(\cymbal     -> [6, ""]);
	diccionarioInst.add(\vibraSlap  -> [1, ""]);
	diccionarioInst.add(\maracas    -> [2, ""]);
	diccionarioInst.add(\cabasa     -> [3, ""]);
	diccionarioInst.add(\shGuiro    -> [4, ""]);
	diccionarioInst.add(\hiConga    -> [10, ""]);
	diccionarioInst.add(\loGuiro    -> [11, ""]);
	diccionarioInst.add(\tambourine -> [11, ""]);
	diccionarioInst.add(\loAgogo    -> [13, ""]);
	diccionarioInst.add(\hiAgogo    -> [14, ""]);
	diccionarioInst.add(\clap       -> [15, ""]);
	diccionarioInst.add(\XXXXXXX    -> [16, ""]);
	diccionarioInst.add(\XXXXXXX    -> [17, ""]);
	diccionarioInst.add(\XXXXXXX    -> [18, ""]);
	diccionarioInst.add(\XXXXXXX    -> [19, ""]);
	diccionarioInst.add(\XXXXXXX    -> [20, ""]);

// this outputs the bufnum of the instrument and the kit as well as a comment that right now is empty
		diccionarioInst.at(instrument.asSymbol)[1].postln;
~iamm[diccionarioKit.at(kit.asSymbol)][diccionarioInst.at(instrument.asSymbol)[0]];

}
);
)
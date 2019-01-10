(
s.options.numBuffers = 1024 * 16;
Can.defaultServerConfig;
s.boot;
s.waitForBoot({
	~baseDir = thisProcess.nowExecutingPath.dirname;
	(~baseDir++"/drums_Synth_Func.scd").load;
	(~baseDir++"/instruments_fx_chidos.scd").load;

	~compander= Synth(\compander);
	~crackle=   Synth(\crackle);
	~reverb=    Synth(\reverb);
	~combC=     Synth(\combC);
	~convo=     Synth(\convo);
	~verb=      Synth(\verb);
	~vowelA=    Synth(\vowel, [\vowel, 0, \in, 18]);
	~vowelE=    Synth(\vowel, [\vowel, 1, \in, 20]);
	~vowelI=    Synth(\vowel, [\vowel, 2, \in, 22]);
	~vowelO=    Synth(\vowel, [\vowel, 3, \in, 24]);
	~vowelU=    Synth(\vowel, [\vowel, 4, \in, 26]);
});

);

(
var durs, notes, amps, transps, tempos, base, percent, drums1, drums2, piano, bajo, bjorkBeats, ampBeats, ampPiano, outBeats, outPiano;

// melody;

durs=   (8!64).reciprocal;
notes=  [48, 60, 67, 68, 65, 68.5].stutter(10);
//notes= [60, 63, 65, 67, [60,48,72], \rest].stutter(10)

// voices;
transps= [0, 12, -12, 24, -24];
// transps= [0, 12, -12, 24, -24];
amps=    [1, 0.5, 0.5, 0.5, 0.5];
//amps=  [1, 0.5, 0.5, 0.5, 0.5]
base=    5;
//base=  50;

tempos=  [4, 5, 6, 7, 8];
//tempos=  [20,10,28,16,32];
//tempos=  [1022,1021,1030,1107,1055];

percent= [5, 1, 1, 1, 1];
//percent= [1, 1, 1, 1, 1];

// instruments;
drums1= [~drums.(\k1, \bass), ~drums.(\k1, \cHat), ~drums.(\k1, \oHat),~drums.(\k1, \snare),];

drums2= [~drums.(\k1, \bass), ~drums.(\k1, \snare)];

bajo=   [\pluck];
piano=  [\pianoPhM];

// desmadre euclidiano

bjorkBeats= [Pseq(Bjorklund(3,8),inf)];

ampBeats= [Pseq(Bjorklund(3,8),inf)];

ampPiano= [Pseq(Bjorklund(3,8),inf)];

// desmadre random

outBeats= [[99, 8, 10, 12], [5, 3, 1, 1]];

outPiano= [(99!10), 18, 20, 22, 24, 26].flatten;


Can.diverge(\divergence,

	melody: Can.melody(durs,notes),
	voices: Can.divoices(transps, amps),

	tempos: Can.divtempos(tempos,percent, normalize: true),
	baseTempo: base,

	instruments: [[\drums], drums1,drums2, piano],

	player:

	{|id, canon, instruments, repeat = inf|

		var pBindBeatPlayer = {|ins, bjork, amp=1, pan=0, out=0, repeat=1|
			{|voice, index|
				Pbind(
					\bjorklund, /*bjork.wrapAt(index)*/ 1,
					\instrument, ins[0].wrapAt(index),
					\dur, Pseq(([voice.onset] ++ voice.durs ++ [voice.remainder]), repeat),
					\out, out,
					\amp, Pseq([1,1,1,1,0]*2, inf) /*amp.wrapAt(index)*/,
					\pan, pan.wrapAt(index),
					\bufnum, Pfunc({|event|
						if( event[\bjorklund] == 1, {ins[1].wrapAt(index)},
							{ins[2].wrapAt(index)})
					}),
					\osc, Pfunc({|event|
						NetAddr("127.0.0.1", 57120).sendBundle(Server.default.latency, [
							("/voice"++index),
							event[\dur],
							event[\bjorklund],
							event[\amp],
							event[\pan]
						])
					})
				)
			}
		};

		var pBindPianoPlayer = {|ins, bjork, amp=1, pan=0, out=0, repeat=1|
			{|voice, index|
				Pbind(
					\instrument, ins[3].wrapAt(index),
					\dur, Pseq(([voice.onset] ++ voice.durs ++ [voice.remainder])*0.5, repeat),
					\midinote, Pseq([\rest]++voice.notes ++ [\rest], inf),
					\out, out,
					\amp, Pseq([1,1,1,1,1,1,0]*4,inf) /*amp.wrapAt(index)*/,
					\pan, pan.wrapAt(index),
					\osc, Pfunc({|event|
						NetAddr("127.0.0.1", 57120).sendBundle(Server.default.latency, [
							("/voice"++index),
							event[\dur],
							event[\midinote],
							event[\amp],
							event[\pan]
						])
					})

				)
			}
		};

		var beat = canon
		.collect(
			pBindBeatPlayer.(
				instruments,
				bjork: bjorkBeats,
				amp: ampBeats,
				pan: [
					0,
					Pseq([1,1,0,1],inf),
					Pseq([0,-1,-1],inf),
					Pseq([0,0,1,-1], inf),
					Pseq([0,0,0.5,-0.5],inf)
				],
				out: Pwrand(outBeats[0],outBeats[1].normalizeSum,inf),
				repeat: repeat
			)
		);

		var piano = canon
		.collect(
			pBindPianoPlayer.(
				instruments,
				amp: ampPiano,
				pan: [
					0,
					Pseq([1,1,0,1],inf),
					Pseq([0,-1,-1],inf),
					Pseq([0,0,1,-1], inf),
					Pseq([0,0,0.5,-0.5],inf)
				],
				out: Pxrand(outPiano,inf),
				repeat: repeat
			)
		);

		Pdef(id ? UniqueID.next.asSymbol, Ppar(piano++beat), repeat);

	},
	repeat: inf,
	convergeOnLast: true

)

)

s.meter
s.record
(

Pdef(\divergence).play;
)
Pdef(\divergence).stop;
s.stopRecording;

s.meter
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mindwave_mobile2/enums/algo_state_reason.dart';
import 'package:mindwave_mobile2/enums/headset_state.dart';
import 'package:mindwave_mobile2/mindwave_mobile2.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mindwave_mobile2_example/screens/profile.dart';

import 'package:mindwave_mobile2_example/util/snackbar_popup.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:pausable_timer/pausable_timer.dart';

class MorningMeditation extends StatefulWidget {
  
  const MorningMeditation(
      {super.key,
      });

  @override
  State<MorningMeditation> createState() => _MorningMeditationState();
}

class _MorningMeditationState extends State<MorningMeditation> {
  double _progress = 0.0;
  bool isConnected = false;
  final MindwaveMobile2 headset = MindwaveMobile2();
  HeadsetState _headsetState = HeadsetState.DISCONNECTED;
  //AlgoState _algoState = AlgoState.INITED;
  //AlgoReason _algoReason = AlgoReason.SIGNAL_QUALITY;
  int dataunits = 0;

  late StreamSubscription<HeadsetState>? _headsetStateSubscription;
  late StreamSubscription<Map>? _algoStateReasonSubscription;
  StreamSubscription<int>? _meditationStreamSubscription;
  Timer _timer = Timer(Duration.zero, () {});
 
  //timerp = PausableTimer(const Duration(milliseconds: 100), () {});
  int c = 0;
  bool f = false;
  int ok = 0;
  bool showgraph = false;
  
  PausableTimer timerp = PausableTimer(const Duration(milliseconds: 100), () {
    // You might want to put some default functionality here if needed.
  });
  bool op=true;
  bool isPlaying=false;
  int sessionval = 1;
  bool showtimerandmusic = false;
  List<int> fixedSizeList = List.filled(40, 0);
  int c1 = 0;
  int c2 = 0;
  int c3 = 0;
  int c4 = 0; 
  double percent = 1;
  
  late AudioPlayer audioPlayer = AudioPlayer();
   Uri audioUri = Uri.parse('D/Desktop/bciapp/example/assets/guided_1.mp3'); // Example local file path
   //UriAudioSource audioSource = UriAudioSource(uri: audioUri);
  @override
  void initState() {
    super.initState();
   
    // percent = 1.0; // Reset percent to full at the start of each session
    // _timer.cancel(); // Cancel any existing timer
    // _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
    //   if (percent == 0) {
    //     print("hello");
    //     timer.cancel();
        
    //     setState(() {
    //       percent = 0; // Ensure percent does not go below 0
    //     });
    //   } else if(percent>0.0) {
    //     setState(() {
    //       percent -= 0.1;
    //       print("KSJDC $percent");
    //     });
    //   }
    // });
    _headsetStateSubscription = headset.onStateChange().listen((state) {
      //print("Your session time is : ${widget.value}");
      _headsetState = state;
      if (state == HeadsetState.DISCONNECTED) {
        headset.disconnect();
      }
      if (mounted) {
        setState(() {});
      }
    });

    // _algoStateReasonSubscription =
    //     headset.onAlgoStateReasonChange().listen((state) {
    //   _algoState = state['State'];
    //   _algoReason = state['Reason'];
    //   if (mounted) {
    //     setState(() {});
    //   }
    // });

    print("current session : $sessionval");
  }
void _updateProgress(double duration, bool ison) {
  print("update");
  const interval = Duration(milliseconds: 100); // Update every 100 milliseconds
  final increment = (interval.inMilliseconds / 1000) / duration; // Calculate the increment per interval
  print(ison);
  timerp.cancel();
  if (_progress == 0.0) { // Only reset progress if it's the start of the timer
      _progress = 0.0; // Reset progress to 0
    } // Cancel any existing timer
   // Reset progress to 0
  timerp = PausableTimer.periodic(interval, () {
    if (!ison) {
        print("stop");
        timerp.pause();  // Stop the timer if the progress bar is not active
        return;
      }else{
        
    setState(() {
      _progress += increment;
      if (_progress >= 1.0) {
        _progress = 1.0; // Cap the progress at 100%
        timerp.start();
      }
    });
      }
  });
  timerp.start();
}

// Future<void> playLocalAudio() async {
//     String audioPath = 'assets/audio/audio.mp3'; // Path to your audio file in the assets folder
//     ByteData data = await rootBundle.load(audioPath);
//     List<int> bytes = data.buffer.asUint8List();

//     Directory tempDir = await getTemporaryDirectory();
//     String tempPath = '${tempDir.path}/audio_temp.mp3';

//     File tempFile = File(tempPath);
//     await tempFile.writeAsBytes(bytes);

//     audioPlayer.play(tempPath, isLocal: true);
//   }


  @override
  void dispose() {
    _headsetStateSubscription?.cancel();
    _algoStateReasonSubscription?.cancel();
    _meditationStreamSubscription?.cancel();
    _timer.cancel();
    headset.disconnect();
    
    super.dispose();
  }

  bool get isWorking {
    return _headsetState == HeadsetState.WORKING;
  }

  Future onConnectPressed() async {
    try {
      await MindwaveMobile2.instance.connect();
      setState(() {
        isConnected = true;
      });
    } catch (e) {
      if (context.mounted) {
        showSnackBarPopup(
            context: context, text: e.toString(), color: Colors.red);
      }
    }
  }

  Future onDisconnectPressed() async {
    try {
      await MindwaveMobile2.instance.disconnect();
      setState(() {
        isConnected = false;
      });
    } catch (e) {
      if (context.mounted) {
        showSnackBarPopup(
            context: context, text: e.toString(), color: Colors.red);
      }
    }
  }

  void _addData(dynamic data, int c1, int c2, int c3, int c4) {
    final userDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc('Meditationdata')
        .collection('Sessiondatas')
        .doc('session2');
    userDoc.set({
      'MeditationData': data,
      "counter1": c1,
      "counter2": c2,
      "counter3": c3,
      "counter4": c4
    }, SetOptions(merge: true));
    print("Your data: $data");
  }

  // Future<void> fetchdata() async {
  //   final userDoc = FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc('Meditationdata')
  //       .collection('currentsession')
  //       .doc('val');
  //   DocumentSnapshot<Map<String, dynamic>> docSnapshot = await userDoc.get();
  //   if (docSnapshot.exists) {
  //     userDoc.set({'currentsession': 1}, SetOptions(merge: true));
  //     setState(() {
  //       sessionval;
  //     });
  //   } else {
  //     setState(() {
  //       sessionval = 1;
  //     });
  //     userDoc.set({'currentsession': sessionval}, SetOptions(merge: true));
  //   }
  // }

  // void _startTimer() {
  //   _timer = Timer(Duration(seconds: 40), () {

  //       _isTimerRunning = false;
  //       f = false;
  //       _meditationStreamSubscription?.cancel();
  //     });

  //   _isTimerRunning = true;
  // }
  double sum = 0;
  double avg = 0;
  bool start = false;
  // void _startListeningToMeditationStream(Stream<int> stream) {
  //   _meditationStreamSubscription = stream.listen((data) {
  //     if (data > 5 && start == false) {
  //       f = true;
  //       showtimerandmusic = true;
  //       _startSession();
  //     }

  //     if (f && ok == 0) {
  //       print("Your stream is started : ${data} at $c");
  //       fixedSizeList[c] = data;
  //       sum = data + sum;
  //       start = true;
  //       c++;
  //     }

  //     if (c == fixedSizeList.length) {
  //       f = false;
  //       ok = 1;

  //       _stopSession();
  //       setState(() {
  //         _isdataadded = true;
  //         avg = sum / fixedSizeList.length;
  //       });

  //       _meditationStreamSubscription?.cancel();
  //       headset.disconnect();
  //       print("Your session data: $fixedSizeList");
  //     }
  //   }); 
  // }

  Widget buildConnectButton(BuildContext context) {
    return Row(children: [
      TextButton(
        onPressed: isWorking ? onDisconnectPressed : onConnectPressed,
        child: Text(
          isWorking ? "DISCONNECT" : "CONNECT",
        ),
      )
    ]);
  }

  Widget buildStateWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Connection Status",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        ElevatedButton(
          onPressed: null,
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: _headsetState == HeadsetState.WORKING
                ? Colors.green
                : Colors.red,
            disabledForegroundColor: Colors.white,
          ),
          child: Text(_headsetState.name),
        ),
      ],
    );
  }

  Widget gaugebuild(BuildContext context, int data) {
    return Center(
      child: Container(
        child: SfRadialGauge(axes: <RadialAxis>[
          RadialAxis(minimum: 0, maximum: 10, ranges: <GaugeRange>[
            GaugeRange(startValue: 0, endValue: 3, color: Colors.green),
            GaugeRange(startValue: 3, endValue: 7, color: Colors.orange),
            GaugeRange(startValue: 7, endValue: 10, color: Colors.red)
          ], pointers: <GaugePointer>[
            NeedlePointer(value: data.toDouble() / 10.0)
          ], annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                widget: Container(
                    child: Text('${(data / 10)}',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold))),
                angle: 90,
                positionFactor: 0.5)
          ])
        ]),
      ),
    );
  }

  Widget buildtimer(BuildContext context) {
    return Countdown(
      seconds: 20,
      build: (BuildContext context, double time) => Text(time.toString()),
      interval: Duration(milliseconds: 100),
      onFinished: () {
        print('Timer is done!');
      },
    );
  }

 Widget progressbar(BuildContext context) {
   
    return  LinearProgressIndicator(
            value: _progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          );
       
  }

  void togglePlayPause() {
    if (isPlaying) {
      audioPlayer.pause();
    } else {
       audioPlayer.play(AssetSource('guided_1.mp3'));
    }
    setState(() {
      isPlaying = !isPlaying;
      op=!op;
      print(op);
      _updateProgress(20, !op);
    });
  }

  Widget Printdata(BuildContext context, String title, Stream<int> stream) {
    return StreamBuilder<int>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Your error ${snapshot.error}");
            return Container();
          }
          if (!snapshot.hasData) {
            return Container();
          }
          if (snapshot.hasData) {
            print("indside");
            print("Your $title data is : ${snapshot.data} ");
            if (snapshot.data! > 0 && snapshot.data! <= 40) {
              c1++;
            } else if (snapshot.data! > 40 && snapshot.data! <= 55) {
              c2++;
            } else if (snapshot.data! > 55 && snapshot.data! <= 70) {
              c3++;
            } else {
              c4++;
            }
            _addData(snapshot.data, c1, c2, c3, c4);
          }
          return gaugebuild(context, snapshot.data!);
        });
  }

  Widget displayavg(double avg) {
    return Text(
      "Your calmness level is: $avg",
      style: const TextStyle(color: Colors.white),
    );
  }

  
  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Morning Meditation'),
      actions: [
        buildConnectButton(context),
        SizedBox(width: 85),
        IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
          },
          icon: const Icon(Icons.person)
        ),
      ],
    ),
    body: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        buildStateWidget(context),
        ElevatedButton(
          onPressed: () {
            setState(() {
              showgraph = true;
              // isPlaying = !isPlaying;
              // op=!op;
              // _updateProgress(20, !op);
              
    
            });
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text('Start your session', style: TextStyle(color: Colors.white)),
        ),
           if(showgraph) Printdata(context, "Meditation", headset.onAlgoMeditationUpdate()),
           if (showgraph) progressbar(context),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            // ElevatedButton(
            //   onPressed: (){
            //     setState(() {
            //       op=true;
            //        audioPlayer.play(AssetSource('guided_1.mp3'));
            //     });
            //     _updateProgress(20, op);
            //     print("inside start $op");
            //   },
            //   child: Text('Start Progress'),
            //   style: ElevatedButton.styleFrom(primary: Colors.green),
            // ),
            // ElevatedButton(
            //   onPressed: (){
            //     setState(() {
            //       op=false;
            //       audioPlayer.pause();
                  
            //     });
            //      _updateProgress(20, op);
            //     print(op);
            //   },
            //   child: Text('Pause Progress'),
            //   style: ElevatedButton.styleFrom(primary: Colors.red),
              
            // ),

              ElevatedButton.icon(
              onPressed: togglePlayPause,
              icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
              label: Text(''),
            ),
          
          ],
        ),
      ],
    ),
  );
}
}
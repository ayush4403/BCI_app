import 'dart:async';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:flutter/material.dart';
import 'package:mindwave_mobile2/enums/algo_state_reason.dart';
import 'package:mindwave_mobile2/enums/headset_state.dart';
import 'package:mindwave_mobile2/mindwave_mobile2.dart';

import 'package:mindwave_mobile2_example/screens/profile.dart';

import 'package:mindwave_mobile2_example/util/snackbar_popup.dart';


class MorningMeditation extends StatefulWidget {
  final bool audiostatus;
  final String? audiofile;
  final int value;
  const MorningMeditation(
      {super.key, required this.audiostatus, required this.audiofile, required this.value});

  @override
  State<MorningMeditation> createState() => _MorningMeditationState();
}

class _MorningMeditationState extends State<MorningMeditation> {
  bool isConnected = false;
  final MindwaveMobile2 headset = MindwaveMobile2();
  HeadsetState _headsetState = HeadsetState.DISCONNECTED;
  //AlgoState _algoState = AlgoState.INITED;
  //AlgoReason _algoReason = AlgoReason.SIGNAL_QUALITY;
  int dataunits = 0;

  late StreamSubscription<HeadsetState>? _headsetStateSubscription;
  late StreamSubscription<Map>? _algoStateReasonSubscription;
  StreamSubscription<int>? _meditationStreamSubscription;
  late Timer _timer;

  int c = 0;
  bool f = false;
  int ok = 0;
  bool showgraph = false;
  int sessionval = 1;
  bool showtimerandmusic = false;
  List<int> fixedSizeList = List.filled(40, 0);
  int seconds = 5 * 60;
  late Timer timer;

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void stopTimer() {
    timer.cancel();
  }

  @override
  void initState() {
    super.initState();
    _headsetStateSubscription = headset.onStateChange().listen((state) {
  
  print("Your session time is : ${widget.value}");
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

  // void _addData(dynamic data) {
  //   final userDoc = FirebaseFirestore.instance
  //       .collection('Users')
  //       .doc('Meditationdata')
  //       .collection('Sessiondatas')
  //       .doc('session2');
  //   userDoc.set({'MeditationData': data}, SetOptions(merge: true));
  //   print("Your data: $data");
  // }

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

  
  Widget gaugebuild(BuildContext context,int data) {
    return Center(
        child: Container(
          child: SfRadialGauge(
          axes: <RadialAxis>[
            RadialAxis(minimum: 0, maximum: 10,
            ranges: <GaugeRange>[
              GaugeRange(startValue: 0, endValue: 3, color:Colors.green),
              GaugeRange(startValue: 3,endValue: 7,color: Colors.orange),
              GaugeRange(startValue: 7,endValue: 10,color: Colors.red)],
            pointers: <GaugePointer>[
              NeedlePointer(value: data.toDouble()/10.0)],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(widget: Container(child: 
                 Text('${(data/10)}',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold))),
                 angle: 90, positionFactor: 0.5
              )]
          )]),),);
      
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
            print("Your $title data is : ${snapshot.data} ");
          }
          return gaugebuild(context,snapshot.data!);
        });
  }

  

  Widget displayavg(double avg) {
    return Text("Your calmness level is: $avg",style: const TextStyle(color: Colors.white),);
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          buildConnectButton(context),
          SizedBox(
            width: 85,
          ),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
              icon: const Icon(Icons.person)),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          buildStateWidget(context),
          ElevatedButton(
            onPressed: () {
              setState(() {
                showgraph = true;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent,
            ),
            child: const Text('Start your session'),
          ),

          if (showgraph)
            Printdata(context, "Meditation", headset.onAlgoMeditationUpdate()),
            
          
        ],
      ),
    );
  }
}
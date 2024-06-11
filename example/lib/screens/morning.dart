import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mindwave_mobile2/enums/algo_state_reason.dart';
import 'package:mindwave_mobile2/enums/headset_state.dart';
import 'package:mindwave_mobile2/mindwave_mobile2.dart';
import 'package:mindwave_mobile2_example/screens/graphui.dart';
import 'package:mindwave_mobile2_example/screens/profile.dart';
import 'package:mindwave_mobile2_example/util/snackbar_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MorningMeditation extends StatefulWidget {
  const MorningMeditation({super.key});

  @override
  State<MorningMeditation> createState() => _MorningMeditationState();
}

class _MorningMeditationState extends State<MorningMeditation> {
  bool isConnected = false;
  final MindwaveMobile2 headset = MindwaveMobile2();
  HeadsetState _headsetState = HeadsetState.DISCONNECTED;
  AlgoState _algoState = AlgoState.INITED;
  AlgoReason _algoReason = AlgoReason.SIGNAL_QUALITY;
  int dataunits = 0;

  late StreamSubscription<HeadsetState>? _headsetStateSubscription;
  late StreamSubscription<Map>? _algoStateReasonSubscription;
  StreamSubscription<int>? _meditationStreamSubscription;
  late Timer _timer;
  bool _isTimerRunning = false;
  bool _isdataadded = false;
  int c = 0;
  bool f = false;
  int ok = 0;
  List<int> fixedSizeList = List.filled(40, 0);
  bool showgraph = false;

  @override
  void initState() {
    super.initState();
    _headsetStateSubscription = headset.onStateChange().listen((state) {
      _headsetState = state;
      if (state == HeadsetState.DISCONNECTED) {
        headset.disconnect();
      }
         if (mounted) {
        setState(() {});
       
      }
    });

    _algoStateReasonSubscription =
        headset.onAlgoStateReasonChange().listen((state) {
      _algoState = state['State'];
      _algoReason = state['Reason'];
         if (mounted) {
        setState(() {});
      }
    });
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

  void _addData(dynamic data) {
    final userDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc('Meditationdata')
        .collection('Sessiondatas')
        .doc('session1');
    userDoc.set({'MeditationData': data}, SetOptions(merge: true));
    print("Your data: $data");
  }

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
  void _startListeningToMeditationStream(Stream<int> stream) {
    _meditationStreamSubscription = stream.listen((data) {
      if (data > 5 && start == false) {
        f = true;
        _startSession();
      }

      if (f && ok == 0) {
        print("Your stream is started : ${data} at $c");
        fixedSizeList[c] = data;
        sum = data + sum;
        start = true;
        c++;
      }

      if (c == fixedSizeList.length) {
        f = false;
        ok = 1;
        
        _stopSession();
        setState(() {
        _isdataadded = true;
          avg = sum / fixedSizeList.length;
        });

        _meditationStreamSubscription?.cancel();
        headset.disconnect();
        print("Your session data: $fixedSizeList");
      }
    });
  }

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
        const Text(
          "Connection Status",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

  Widget graph(BuildContext context, String title, Stream<int> stream) {
    _startListeningToMeditationStream(stream);

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
            print("Your $title data is : ${snapshot.data} : ${c}");
          }

          if (f && ok == 0) {
            _addData(fixedSizeList);

            return LiveGraph(
              dataStream: stream,
              op: fixedSizeList,
              length: fixedSizeList.length,
            );
          }
          if (_isdataadded) {
            return LiveGraph(
              dataStream: Stream.empty(),
              op: [],
              length: 0,
            );
          } else {
            return Container();
          }
        });
  }

  void _startSession() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        content: Text("Your session has been started!"),
        actions: [
          
        ],
      ),
    );
    Timer(const Duration(seconds: 1), () {
    Navigator.of(context).pop();
  });
  }
  Widget displayavg(double avg){
    return Text("Average: $avg");
  }

  void _stopSession() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Your session has been completed!"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.06,
          ),
           Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
         buildConnectButton(context),
            ],
          ),
          const Divider(height: 20, color: Colors.black),
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
            child: Text('Start your 40 sec session'),
          ),
          if (showgraph)
            graph(context, "Meditation", headset.onAlgoMeditationUpdate()),
            SizedBox(height: 30),
            if(_isdataadded)
            displayavg(avg)
        ],
      ),
    );
  }
}

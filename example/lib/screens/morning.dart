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
  int c = 0;
  bool f = false;
  int ok = 0;
  List<int> fixedSizeList = List.filled(40, 0);

  @override
  void initState() {
    super.initState();
    _headsetStateSubscription = headset.onStateChange().listen((state) {

        _headsetState = state;
        if (state == HeadsetState.DISCONNECTED) {
          headset.disconnect();
        }
      });
    

    _algoStateReasonSubscription =
        headset.onAlgoStateReasonChange().listen((state) {
     
        _algoState = state['State'];
        _algoReason = state['Reason'];
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

  void _addData(int data) {
    final userDoc =
        FirebaseFirestore.instance.collection('Users').doc('Meditationdata');
    userDoc.set({'MeditationData': data}, SetOptions(merge: true));
    print("Your data: $data");
  }

  void _startTimer() {
    _timer = Timer(Duration(seconds: 40), () {
      
        _isTimerRunning = false;
        f = false;
        _meditationStreamSubscription?.cancel();
      });
    
    _isTimerRunning = true;
  }

  void _startListeningToMeditationStream(Stream<int> stream) {
    _meditationStreamSubscription = stream.listen((data) {
      
        if (data > 5 && !_isTimerRunning) {
          f = true;
          _startTimer();
        }

        if (f && ok == 0) {
          if (c < fixedSizeList.length) {
            fixedSizeList[c] = data;
            c++;
          }

          if (c == fixedSizeList.length) {
            f = false;
            ok = 1;
            _meditationStreamSubscription?.cancel();
            print("Your session data: $fixedSizeList");
          }
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
          "MindWave State",
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
            return Text("Error: ${snapshot.error}");
          }
          if (!snapshot.hasData) {
            return Text("No data available");
          }
          if (snapshot.hasData) {
            print("Your ${title} value: ${snapshot.data}");
            _addData(snapshot.data!);

            print("Your $title data is : ${snapshot.data} : ${c}");
          }

          if (f && ok == 0) {
            return LiveGraph(
              dataStream: stream,
              op: fixedSizeList,
              length: fixedSizeList.length,
            );
          } else {
            return Container();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: isWorking ? onDisconnectPressed : onConnectPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isWorking ? Colors.red : Colors.green,
                ),
                child: Text(isWorking ? 'Disconnect' : 'Connect'),
              ),
           
            ],
          ),
          const Divider(height: 20, color: Colors.black),
          buildStateWidget(context),
          graph(context, "Meditation", headset.onMeditationUpdate()),
        ],
      ),
    );
  }
}

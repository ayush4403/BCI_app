import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mindwave_mobile2/enums/algo_state_reason.dart';
import 'package:mindwave_mobile2/enums/headset_state.dart';
import 'package:mindwave_mobile2/mindwave_mobile2.dart';
import 'package:mindwave_mobile2_example/util/snackbar_popup.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  bool isConnected = false;
  final MindwaveMobile2 headset = MindwaveMobile2();
  HeadsetState _headsetState = HeadsetState.DISCONNECTED;
  AlgoState _algoState = AlgoState.INITED;
  AlgoReason _algoReason = AlgoReason.SIGNAL_QUALITY;
  int dataunits = 0;

  late StreamSubscription<HeadsetState>? _headsetStateSubscription;
  late StreamSubscription<Map>? _algoStateReasonSubscription;
  StreamSubscription<int>? _meditationStreamSubscription;
  late StreamController<double> _streamController;
  late AnimationController _controller;
  late Animation<double> _animation;
  double _currentValue = 0.5;
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

  bool get isWorking {
    return _headsetState == HeadsetState.WORKING;
  }

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
    _streamController = StreamController<double>();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      upperBound: 1,
      lowerBound: 0
    );
   _controller.forward(); 
   
    _streamController.stream.listen((value) {
      setState(() {
        _currentValue = value;
      });
      _controller.forward(from: 0);
    });

    
  }

  void _updateBallPosition(double value) {
    _streamController.add(value);
  }

  @override
  void dispose() {
    _headsetStateSubscription?.cancel();
    _algoStateReasonSubscription?.cancel();
    _meditationStreamSubscription?.cancel();
    _controller.dispose();
    _streamController.close();
    super.dispose();
  }

  Widget buildStateWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        // const Padding(
        //   padding: EdgeInsets.all(10.0),
        //   child: Text(
        //     "Connection Status",
        //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        //   ),
        // ),
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          buildConnectButton(context),
          buildStateWidget(context),
        ],
      ),
      body: Stack(
        children: <Widget>[

          StreamBuilder<int>(
            stream: headset.onAlgoMeditationUpdate(),
            initialData: 1,
            builder: (context, snapshot) {
              print("Your Meditation : ${snapshot.data!}");
              double position = (MediaQuery.of(context).size.height-MediaQuery.of(context).size.height*0.2) * (snapshot.data!/ 100);
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Positioned(
                    bottom: position,
                    left: MediaQuery.of(context).size.width / 2 - 25,
                    child: child!,
                  );
                },
                child: Ball(),
              );
            },
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Slider(
          //     value: _currentValue,
          //     onChanged: (value) {
          //       _updateBallPosition(value);
          //     },
          //     min: 0.0,
          //     max: 1.0,
          //     divisions: 100,
          //     label: _currentValue.toStringAsFixed(2),
          //   ),
          // ),
        ],
      ),
    );
  }
}



class Ball extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
    );
  }
}

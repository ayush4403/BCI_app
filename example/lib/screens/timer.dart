// import 'dart:async';
// import 'package:flutter/material.dart';


// class StopwatchApp extends StatefulWidget {
//    void Function()? onpressed;
//    bool oncompleted;
//   StopwatchApp({required this.onpressed,required this.oncompleted});
//   @override
//   _StopwatchAppState createState() => _StopwatchAppState();
// }

// class _StopwatchAppState extends State<StopwatchApp> {
//   int seconds = 5 * 60;
//   late Timer timer;

// void initState(){
//   super.initState();
//   startTimer();
// }

//   void startTimer() {
//     timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       if (seconds > 0) {
//         setState(() {
//           seconds--;
//         });
//       } else {
//         timer.cancel();
//       }
//     });
//   }

//   void stopTimer() {
//     timer.cancel();
//   }

//   String formatTime(int seconds) {
//     int mins = seconds ~/ 60;
//     int secs = seconds % 60;
//     return '$mins:${secs.toString().padLeft(2, '0')}';
//   }

//   @override
//   Widget build(BuildContext context) {
  
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Text(
//               formatTime(seconds),
//               style: TextStyle(fontSize: 48),
//             ),
//             SizedBox(height: 20),
          
//           ],
//         ),
//       );
  
//   }

//   @override
//   void dispose() {
//     timer.cancel();
//     super.dispose();
//   }
// }

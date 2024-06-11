import 'package:flutter/material.dart';



class SessionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isTodaySession = true;
  int _totalTodaySession = 10;
  int _totalTodayTime = 30;
  int _totalSession = 50;
  int _totalTime = 120;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ToggleButtons(
          isSelected: [_isTodaySession, !_isTodaySession],
          onPressed: (int index) {
            setState(() => _isTodaySession = index == 0);
          },
          borderRadius: BorderRadius.circular(10),
          selectedBorderColor: Colors.blueAccent,
          selectedColor: Colors.white,
          fillColor: Colors.blueAccent.withOpacity(0.2),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Today\'s Session', style: TextStyle(fontSize: 16)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text('Total Session', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  _isTodaySession
                      ? 'Today\'s Session: $_totalTodaySession Sessions Time:  $_totalTodayTime minutes'
                      : 'Total Session: $_totalSession \n Time: $_totalTime  minutes',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
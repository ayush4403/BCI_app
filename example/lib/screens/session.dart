import 'package:flutter/material.dart';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  _SessionScreenState createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  bool _isTodaySession = true;
  int _totalTodaySession = 10;
  int _totalTodayTime = 30;
  int _totalSession = 50;
  int _totalTime = 120;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Analysis'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleButtons(
              isSelected: [_isTodaySession, !_isTodaySession],
              onPressed: (int index) {
                setState(() => _isTodaySession = index == 0);
              },
              borderRadius: BorderRadius.circular(10),
              selectedBorderColor: Colors.blueAccent,
              selectedColor: Colors.white,
              fillColor: Colors.blueAccent.withOpacity(0.5),
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child:
                      Text('Today\'s Session', style: TextStyle(fontSize: 16)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Total Session', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Card(
                color: Colors.blue[100],
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        _isTodaySession
                            ? 'Today\'s Session: $_totalTodaySession Sessions Time:  $_totalTodayTime minutes'
                            : 'Total Session: $_totalSession \n Time: $_totalTime  minutes',
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

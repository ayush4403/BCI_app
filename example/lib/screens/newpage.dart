import 'package:flutter/material.dart';
import 'dart:async';

class Newpage1 extends StatefulWidget {
  const Newpage1({super.key});
 _NewPageState createState() => _NewPageState();
}



class _NewPageState extends State<Newpage1> {
  final PageController _activitiesController = PageController();
  final PageController _gamesController = PageController();
  Timer? _activitiesTimer;
  Timer? _gamesTimer;

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _activitiesTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_activitiesController.hasClients) {
        int nextPage = _activitiesController.page!.round() + 1;
        if (nextPage == 4) {
          nextPage = 0;
        }
        _activitiesController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });

    _gamesTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_gamesController.hasClients) {
        int nextPage = _gamesController.page!.round() + 1;
        if (nextPage == 4) {
          nextPage = 0;
        }
        _gamesController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _activitiesTimer?.cancel();
    _gamesTimer?.cancel();
    _activitiesController.dispose();
    _gamesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Mind Sync',
              style: TextStyle(color: Colors.white),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.add, color: Colors.blue),
              onPressed: () {
                // Add your onPressed code here!
              },
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Text(
                  '',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 5),
                Text(
                  '',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(width: 5),
                Icon(Icons.circle, color: Colors.red, size: 10),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height:170),
            Text(
              'Activities',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            SizedBox(height: 20),
            Container(
              height: 150,
              child: PageView(
                controller: _activitiesController,
                children: [
                  buildCard(Colors.red, 'Activity 1'),
                  buildCard(Colors.green, 'Activity 2'),
                  buildCard(Colors.blue, 'Activity 3'),
                  buildCard(Colors.yellow, 'Activity 4'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Games',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
            SizedBox(height: 20),
            Container(
              height: 150,
              child: PageView(
                controller: _gamesController,
                children: [
                  buildCard(Colors.purple, 'Game 1'),
                  buildCard(Colors.orange, 'Game 2'),
                  buildCard(Colors.cyan, 'Game 3'),
                  buildCard(Colors.pink, 'Game 4'),
                ],
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   backgroundColor: Colors.black,
      //   selectedItemColor: Colors.blue,
      //   unselectedItemColor: Colors.white,
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.home),
      //       label: 'Home',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.search),
      //       label: 'Search',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.play_circle_outline),
      //       label: 'Play',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.access_time),
      //       label: 'History',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.person),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),
    );
  }

  Widget buildCard(Color color, String title) {
    return Container(
      width: 150,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
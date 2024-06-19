import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mindwave_mobile2_example/graphs/resources/app_colors.dart';
import 'package:mindwave_mobile2_example/screens/bluetooth_off_screen.dart';
import 'package:mindwave_mobile2_example/screens/gamelist.dart';
import 'package:mindwave_mobile2_example/screens/scan_screen.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedindex = 0;
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;
  @override
  void initState() {
    super.initState();
    _adapterStateStateSubscription =
        FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedindex = index;
    });
  }

  static const List<Widget> _pages = [
    Icon(
      Icons.home,
      size: 150,
    ),
   GameList(),
    Icon(Icons.local_activity, size: 150),
    ScanScreen()
  ];
  Widget NavBarWidget() {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text('MindWave Mobile'),
        //   actions: []),
        body: Center(
          child: _pages.elementAt(_selectedindex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.blue),
          // color: Colors.blueAccent,
          child: BottomNavigationBar(
            backgroundColor: Colors.deepOrangeAccent,
            elevation: 8,
            // fixedColor: Colors.white60,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.white,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.gamepad), label: 'Games'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_activity), label: 'Activities'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.bluetooth), label: 'Bluetooth'),
            ],
            currentIndex: _selectedindex,
            onTap: _onItemTapped,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Widget screen = _adapterState == BluetoothAdapterState.on
        ? NavBarWidget()
        : BluetoothOffScreen(adapterState: _adapterState);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: screen,
      theme: ThemeData.dark(),
    );
  }
}

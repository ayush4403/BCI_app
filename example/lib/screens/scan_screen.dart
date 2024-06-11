import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mindwave_mobile2/mindwave_mobile2.dart';
import 'package:mindwave_mobile2_example/screens/custom_scan_button.dart';
import 'package:mindwave_mobile2_example/screens/morning.dart';
import 'package:mindwave_mobile2_example/screens/profile.dart';
import 'package:mindwave_mobile2_example/screens/buffer_screen.dart'; // Ensure you have this import

import '../util/snackbar_popup.dart';
import '../widgets/scan_result_tile.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({Key? key}) : super(key: key);

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  List<ScanResult> _scanResults = [];
  bool _isScanning = false;
  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;
  late ScanResult result;

  @override
  void initState() {
    super.initState();

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      if (results.isNotEmpty) {
        _scanResults = results;
        if (mounted) {
          setState(() {});
          Navigator.of(context)
              .popUntil((route) => route.isFirst); // Pop to the first screen
        }
      }
    }, onError: (e) {
      showSnackBarPopup(
          context: context, text: e.toString(), color: Colors.red);
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop(); // Pop the BufferScreen on error
      }
    });
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  Future onScanPressed() async {
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const BufferScreen()));
    } catch (e) {
      if (context.mounted) {
        showSnackBarPopup(
            context: context, text: e.toString(), color: Colors.red);
      }
    }
  }

  Future onStopPressed() async {
    try {
      await FlutterBluePlus.stopScan();
      if (Navigator.of(context).canPop()) {
        Navigator.of(context)
            .pop(); // Ensure to pop the BufferScreen if manually stopping the scan
      }
    } catch (e) {
      if (context.mounted) {
        showSnackBarPopup(
            context: context, text: e.toString(), color: Colors.red);
      }
    }
  }

  void onOpenPressed(BluetoothDevice device) async {
    try {
      await MindwaveMobile2.instance.init(device.remoteId.str);
      onStopPressed();
    } catch (e) {
      if (context.mounted) {
        showSnackBarPopup(
            context: context, text: e.toString(), color: Colors.red);
      }
    }
    MaterialPageRoute route = MaterialPageRoute(
      builder: (context) => const MorningMeditation(),
    );
    if (context.mounted) {
      Navigator.of(context).push(route);
    }
  }

  Future onRefresh() {
    if (!_isScanning) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }
    if (mounted) {
      setState(() {});
    }
    return Future.delayed(const Duration(milliseconds: 500));
  }

  // Widget buildScanButton(BuildContext context) {
  //   if (_isScanning) {
  //     return ElevatedButton(
  //       onPressed: onStopPressed,
  //       style: ButtonStyle(
  //         backgroundColor: MaterialStateProperty.all(Colors.red),
  //       ),
  //       child: const Icon(Icons.stop),
  //     );
  //   } else {
  //     return ElevatedButton(
  //       style: ElevatedButton.styleFrom(
  //       backgroundColor: Colors.blue, // Set background color to blue
  //     ),
  //         onPressed: onScanPressed, child: const Text("SCAN", style:TextStyle(color: Colors.white)));
  //   }
  // }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    return _scanResults.map((r) {
      if (r.device.platformName == "MindWave Mobile") {
        return ScanResultTile(
          result: r,
          onTap: () => onOpenPressed(r.device),
        );
      } else {
        return Container();
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Bluetooth Devices',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileScreen()));
              },
              icon: const Icon(
                Icons.person,
                color: Colors.black,
              )),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          children: <Widget>[
            ..._buildScanResultTiles(context),
          ],
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.center,
        child: CustomScanButton(
          onPressed: _isScanning ? onStopPressed : onScanPressed,
        ),
      ),
    );
  }
}

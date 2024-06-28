import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:mindwave_mobile2/mindwave_mobile2.dart';
import 'package:mindwave_mobile2_example/screens/bluetooth_off_screen.dart';
import 'package:mindwave_mobile2_example/screens/Games/gameview.dart';
import 'package:mindwave_mobile2_example/screens/graphui.dart';
import 'package:mindwave_mobile2_example/screens/home.dart';
import 'package:mindwave_mobile2_example/screens/morning.dart';
import 'package:mindwave_mobile2_example/screens/profile.dart';

import '../util/snackbar_popup.dart';
import 'device_screen.dart';
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
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;

  @override
  void initState() {
    super.initState();

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      print(": type: ${results.runtimeType}");
      if (mounted) {
        setState(() {});
      }
    }, onError: (e) {
      showSnackBarPopup(
          context: context, text: e.toString(), color: Colors.red);
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      if (mounted) {
        setState(() {});
      }
    });
    _adapterStateStateSubscription =
        FlutterBluePlus.adapterState.listen((state) {
      _adapterState = state;
      if (mounted) {
        setState(() {});
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
    } catch (e) {
      if (context.mounted) {
        showSnackBarPopup(
            context: context, text: e.toString(), color: Colors.red);
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future onStopPressed() async {
    try {
      FlutterBluePlus.stopScan();
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
      builder: (context) => SessionSelectionPage(),
    );
    if (context.mounted) {
      Navigator.of(context).push(route);
    }
  }

  Future onRefresh() {
    if (_isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }
    if (mounted) {
      setState(() {});
    }
    return Future.delayed(const Duration(milliseconds: 500));
  }

  Widget buildScanButton(BuildContext context) {
    if (FlutterBluePlus.isScanningNow) {
      return ElevatedButton(
        onPressed: onStopPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.red),
        ),
        child: const Icon(Icons.stop),
      );
    } else {
      return ElevatedButton(
          onPressed: onScanPressed, child: const Text("SCAN"));
    }
  }

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
        title: const Text('Bluetooth Devices'),
        
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
        child: buildScanButton(context),
      ),
    );
  }
}
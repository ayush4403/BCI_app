import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../util/snackbar_popup.dart';

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, this.adapterState}) : super(key: key);

  final BluetoothAdapterState? adapterState;

  Widget buildBluetoothOffIcon(BuildContext context) {
    return const Icon(
      Icons.bluetooth_disabled,
      size: 200.0,
      color: Colors.white54,
    );
  }

  Widget buildTitle(BuildContext context) {
    String? state = adapterState?.toString().split(".").last;
    return Text(
      'Your Bluetooth is ${state ?? 'not available'}',
      style: Theme.of(context)
          .primaryTextTheme
          .titleSmall
          ?.copyWith(color: Colors.white),
    );
  }

  Widget buildTurnOnButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue, // Set background color to blue
        ),
        onPressed: () async {
          try {
            if (Platform.isAndroid) {
              await FlutterBluePlus.turnOn();
            }
          } catch (e) {
            if (context.mounted) {
              showSnackBarPopup(
                  context: context, text: e.toString(), color: Colors.red);
            }
          }
        },
        child: const Text('TURN ON', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildBluetoothOffIcon(context),
            buildTitle(context),
            if (Platform.isAndroid) buildTurnOnButton(context),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BufferScreen extends StatelessWidget {
  const BufferScreen({Key? key}) : super(key: key);

  Future<void> _onCancelPressed(BuildContext context) async {
    await FlutterBluePlus.stopScan();
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
                'assets/device.jpg'), // Ensure you have this image in your assets
            const SizedBox(height: 20),
            const Text('Scanning...',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => _onCancelPressed(context),
              child: const Text('Cancel',
                  style: TextStyle(fontSize: 18, color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}

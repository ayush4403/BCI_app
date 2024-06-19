import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:mindwave_mobile2_example/screens/navbar.dart';
import 'scan_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Add your logo here
            Container(
              width: 100,
              height: 100,
              child: Image.asset(
                  'assets/mindwave.jpg'), // Ensure you have a logo image in assets folder
            ),
            SizedBox(height: 20),
            // Animated text
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                  'Mindwave',
                  textStyle: const TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                  speed: const Duration(milliseconds: 200),
                ),
              ],
              totalRepeatCount: 1,
              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
              onFinished: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const NavBar()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

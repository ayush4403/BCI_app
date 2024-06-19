import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';
import 'package:mindwave_mobile2_example/screens/profile.dart';
//import 'package:mindwave_mobile2_example/screens/Games/level.dart';
import 'package:mindwave_mobile2_example/screens/splashscreen.dart';
import 'screens/bluetooth_off_screen.dart';
import 'screens/scan_screen.dart';

void main() async {
if(kReleaseMode){
  Logger.root.level=Level.WARNING;

}
Logger.root.onRecord.listen((record) {
  debugPrint('${record.level.name}:${record.time}:${record.loggerName}:${record.message}');
});
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
    SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((value) => runApp(MyAppMain()));
  runApp(const MyAppMain());
}

class MyAppMain extends StatefulWidget {
  const MyAppMain({super.key});

  @override
  State<MyAppMain> createState() => _MyAppMainState();
}

class _MyAppMainState extends State<MyAppMain> {
  // BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  // late StreamSubscription<BluetoothAdapterState> _adapterStateStateSubscription;


GoRouter  router=GoRouter(routes:[
  GoRoute(path: '/scanscreen',
  builder: (context,state)=>const ScanScreen()),
   GoRoute(path: '/GameScreen',
  builder: (context,state)=>const Placeholder(color: Colors.green,)),
  GoRoute(path: '/BluetoothOffScreen',builder: (context,state)=>const ScanScreen()),
  GoRoute(path: '/',builder: (context,state)=>const Placeholder(child: Text('Home Screen'),)),
  GoRoute(path: '/ProfileScreen',builder: (context,state)=>const ProfileScreen(),),
  
] );


  @override
  void initState()  {
    super.initState();
    
    // _adapterStateStateSubscription =
    //     FlutterBluePlus.adapterState.listen((state) {
    //   _adapterState = state;
    //   if (mounted) {
    //     setState(() {});
    //   }
    // });
  }

  @override
  void dispose() {
    // _adapterStateStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Widget screen = _adapterState == BluetoothAdapterState.on
    //     ?  SplashScreen()
    //     : BluetoothOffScreen(adapterState: _adapterState);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.lightBlue,
      home: SplashScreen(),
      navigatorObservers: [BluetoothAdapterStateObserver()],
      theme: ThemeData.dark(),
    );
  }
}

class BluetoothAdapterStateObserver extends NavigatorObserver {
  StreamSubscription<BluetoothAdapterState>? _adapterStateSubscription;

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name == '/DeviceScreen') {
      _adapterStateSubscription ??=
          FlutterBluePlus.adapterState.listen((state) {
        if (state != BluetoothAdapterState.on) {
          navigator?.pop();
        }
      });
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Cancel the subscription when the route is popped
    _adapterStateSubscription?.cancel();
    _adapterStateSubscription = null;
  }
}

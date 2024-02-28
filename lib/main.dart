import 'package:flutter/material.dart';
import 'package:smart_frame/data/provider/mob_to_esp.dart';
import 'package:smart_frame/screens/select_device.dart';
import 'package:smart_frame/screens/shared.dart';
import 'package:smart_frame/screens/splash.dart';
import 'package:smart_frame/screens/wifiscan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Frame',
       home: splash(),
      // home: WifiMessageSender(),
    );
  }
}

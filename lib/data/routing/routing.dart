import 'package:flutter/material.dart';
import 'package:smart_frame/screens/select_device.dart';
import 'package:smart_frame/screens/settings.dart';
import 'package:smart_frame/screens/shared.dart';

class RoutingScreen {
  static void toSelectDevice(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => selectDevice(),
      ),
    );
  }

  static void toespSetting(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => espSetting()),
    );
  }

  static void toSharedScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Shared()),
    );
  }
}

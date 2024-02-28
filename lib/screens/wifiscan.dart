import 'package:flutter/material.dart';
import 'package:smart_frame/data/provider/mob_to_esp.dart';
// Import the provider

class WifiMessageSender extends StatefulWidget {
  @override
  _WifiMessageSenderState createState() => _WifiMessageSenderState();
}

class _WifiMessageSenderState extends State<WifiMessageSender> {
  final ESP8266Provider esp8266Provider = ESP8266Provider();
  TextEditingController messageController = TextEditingController();
  TextEditingController ipController = TextEditingController();

  @override
  void dispose() {
    esp8266Provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ESP8266 Message Sender'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: ipController,
              decoration: InputDecoration(labelText: "Enter IP Address"),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String ip = ipController.text.trim();
                esp8266Provider.connectToServer(ip);
              },
              child: Text('Connect'),
            ),
            SizedBox(height: 24,),
            TextField(
              controller: messageController,
              decoration: InputDecoration(labelText: 'Enter message'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String message = messageController.text.trim();
                esp8266Provider.sendMessage(message);
              },
              child: Text('Send Message'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    title: 'ESP8266 Communication',
    home: WifiMessageSender(),
  ));
}

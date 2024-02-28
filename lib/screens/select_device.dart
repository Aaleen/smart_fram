import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_frame/components/colors/styling.dart';
import 'package:smart_frame/components/colors/theme.dart';
import 'package:smart_frame/components/widgets/CustomTextField.dart';
import 'package:smart_frame/components/widgets/stylizedbutton.dart';
import 'package:smart_frame/data/provider/mob_to_esp.dart';
import 'package:smart_frame/screens/shared.dart';
import 'package:wifi_iot/wifi_iot.dart';
import 'package:wifi_scan/wifi_scan.dart';

TextEditingController SSIDController = TextEditingController();
TextEditingController PassController = TextEditingController();

class selectDevice extends StatefulWidget {
  const selectDevice({super.key});

  @override
  State<selectDevice> createState() => _selectDeviceState();
}

class _selectDeviceState extends State<selectDevice> {
  List<WiFiAccessPoint> accessPoints = <WiFiAccessPoint>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF5B6BF5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(9.0),
                  bottomRight: Radius.circular(9.0),
                ),
              ),
              height: 60,
              child: Row(
                children: [
                  SizedBox(width: 15),
                  Text("Select Device",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: fontColorWhite),
                      )),
                  SizedBox(
                    width: 140,
                  ),
                  IconButton(
                    onPressed: () async => _getScannedResults(context),
                    splashRadius: 30,
                    splashColor: iconColor,
                    icon: Icon(Icons.refresh_outlined),
                    color: iconColor,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Available Devices",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: fontColorBlack),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
                color: dividerColor,
                height: 13,
                indent: 12,
                endIndent: 12,
                thickness: 2),
            SizedBox(
              height: 10,
            ),
            Flexible(
              child: Center(
                child: accessPoints.isEmpty
                    ? const Text("NO SCANNED RESULTS")
                    : ListView.builder(
                        itemCount: accessPoints.length,
                        itemBuilder: (context, i) =>
                            _AccessPointTile(accessPoint: accessPoints[i])),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getScannedResults(BuildContext context) async {
    final can = await WiFiScan.instance.canStartScan();
    // call startScan API
    final result = await WiFiScan.instance.startScan();

    // reset access points.
    setState(() => accessPoints = <WiFiAccessPoint>[]);

    // get scanned results
    final results = await WiFiScan.instance.getScannedResults();
    setState(() => accessPoints = results);
  }
}

class _AccessPointTile extends StatelessWidget {
  final WiFiAccessPoint accessPoint;

  const _AccessPointTile({Key? key, required this.accessPoint})
      : super(key: key);

  // build row that can display info, based on label: value pair.
  Widget _buildInfo(String label, dynamic value) => Container(
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Row(
          children: [
            Text(
              "$label: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(child: Text(value.toString()))
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    SSIDController.clear();
    PassController.clear();

    Future<void> Connect() async {
      // connecting
      final ssid = SSIDController.text;
      final res = await WiFiForIoTPlugin.connect(
        ssid,
        password: PassController.text,
        security: NetworkSecurity.WPA,
        withInternet: true,
      );

      void _showSuccessDialog() {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Connection was successfull!'),
            );
          },
        );

        // Schedule navigation after 3 seconds
        Future.delayed(Duration(seconds: 3), () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => Shared(),
          ));
        });
      }

      if (res) {
        print("connected");
        Future.delayed(Duration(seconds: 2), () {
          _showSuccessDialog();
        });
      }
    }

    void ConnectionContainer(String title) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // backgroundColor: credBoxColor;
          return AlertDialog(
            title: Text(
              'Credentials',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: fontColorBlack),
            ),

            content: Column(
              children: [
                DynamicTextField(
                  controller: SSIDController,
                  height: 60,
                  width: 250,
                  icon: Icons.wifi,
                  labelText: 'SSID',
                  fontSize: 12,
                ),
                SizedBox(
                  height: 20,
                ),
                DynamicTextField(
                    controller: PassController,
                    height: 60,
                    width: 250,
                    icon: Icons.lock,
                    labelText: 'Password',
                    obscureText: true),
              ],
            ),

            actions: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    Connect();
                    Navigator.of(context).pop();
                    print(SSIDController.text);
                    print(PassController.text);
                    SSIDController.clear();
                    PassController.clear();
                  },
                  style: buttonPrimary,
                  child: Text("OK")),
              //   StylizedButton(
              //     label: 'Connect',
              //     startColor: Color(0xFFFEE500), // Use the color here,
              //     endColor: Color.fromARGB(255, 227, 205, 10),
              //     fontsize: 12,
              //     fontColor: Colors.black,
              //     width: 80,
              //     onPressed: () {
              //       Connect();
              //       Navigator.of(context).pop();
              //       print(SSIDController.text);
              //       print(PassController.text);
              //       SSIDController.clear();
              //       PassController.clear();
              //     },
              //   )
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            // backgroundColor: credBoxColor.withOpacity(0.8),
            backgroundColor: bgColor,
          );
        },
      );
    }

    final title = accessPoint.ssid.isNotEmpty ? accessPoint.ssid : "**EMPTY**";
    final signalIcon = accessPoint.level >= -80 ? Icons.wifi : Icons.wifi_2_bar;
    return ListTile(
      visualDensity: VisualDensity.compact,
      leading: Icon(signalIcon),
      title: Text(title),
      trailing: ElevatedButton(
          onPressed: () {
            ConnectionContainer(title);
            SSIDController.text = title;
          },
          style: buttonPrimary,
          child: Text("Connect")),
    );
  }
}

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_frame/components/colors/styling.dart';
import 'package:smart_frame/components/colors/theme.dart';
import 'package:smart_frame/components/widgets/CustomTextField.dart';
import 'package:smart_frame/components/widgets/stylizedbutton.dart';
import 'package:smart_frame/data/provider/http_feedprovider.dart';
import 'package:smart_frame/data/provider/locationCur.dart';
import 'package:smart_frame/data/provider/mob_to_esp.dart';
import 'package:smart_frame/data/routing/routing.dart';
import 'package:smart_frame/screens/settings.dart';
import 'package:smart_frame/screens/shared.dart';

class espSetting extends StatefulWidget {
  const espSetting({super.key});

  @override
  State<espSetting> createState() => _espSettingState();
}

class _espSettingState extends State<espSetting> {
  // List<XFile> ImageFileList = [];
  // File? _selectedImage;
  // final List<String> imageShare = [];
  String? value = '';
  final ESP8266Provider esp8266Provider = ESP8266Provider();
  TextEditingController messageController = TextEditingController();
  TextEditingController ipController = TextEditingController();
  bool connected = false;
  String curLocation = '';
  @override
  void dispose() {
    esp8266Provider.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   LocationHandler locationHandler = LocationHandler();
  //   locationHandler.getUserCurrentLatlng((p0) => {
  //         print("${p0.latitude}/${p0.longitude}"),
  //         curLocation = "${p0.longitude}/${p0.longitude}"
  //       });
  // }

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
                  Text("Setting",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: fontColorWhite),
                      )),
                  SizedBox(
                    width: 210,
                  ),
                  Icon(
                    connected ? Icons.circle : Icons.circle,
                    color: connected ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 4,
            ),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Send",
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
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      String message = '';
                      String formattedDate = '';
                      formattedDate =
                          "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
                      message = formattedDate.trim();
                      // esp8266Provider.sendMessage(message);
                      sendMessageToEsp.fetchData(message);
                      setState(() {
                        value = '';
                        value = formattedDate;
                      });
                    },
                    child: Text("Date"),
                    style: buttonPrimary,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String message = '';
                      String formattedTime = '';
                      formattedTime =
                          "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
                      message = formattedTime.trim();
                      // esp8266Provider.sendMessage(message);
                      sendMessageToEsp.fetchData(message);
                      setState(() {
                        value = '';
                        value = formattedTime;
                      });
                    },
                    child: Text("Time"),
                    style: buttonPrimary,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      curLocation = '';
                      await fetchLoc();
                      // LocationHandler locationHandler = LocationHandler();
                      // locationHandler.getUserCurrentLatlng((p0) => {
                      //       print("in fetchLoc"),
                      //       print("${p0.latitude}/${p0.longitude}"),
                      //       curLocation = "${p0.longitude}/${p0.longitude}"
                      //     });
                      Future.delayed(Duration(seconds: 5), () {
                        String message = '';
                        message = curLocation;
                        // esp8266Provider.sendMessage(message);
                        sendMessageToEsp.fetchData(message);
                        setState(() {
                          value = '';
                          value = curLocation;
                        });
                      });
                    },
                    child: Text("Location"),
                    style: buttonPrimary,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(9.0),
              child: Row(
                children: [
                  // Text(
                  //   "IP Address",
                  //   style: GoogleFonts.poppins(
                  //     textStyle: TextStyle(
                  //         fontSize: 17,
                  //         fontWeight: FontWeight.bold,
                  //         color: fontColorBlack),
                  //   ),
                  // ),
                ],
              ),
            ),
            // Divider(
            //     color: dividerColor,
            //     height: 13,
            //     indent: 12,
            //     endIndent: 12,
            //     thickness: 2),
            SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              // child: Row(
              //   children: [
              //     Expanded(
              //       flex: 8,
              //       child: DynamicTextField(
              //         labelText: 'IP Address',
              //         controller: ipController,
              //         height: 55,
              //       ),
              //     ),
              //     Spacer(
              //       flex: 1,
              //     ),
              //     StylizedButton(
              //       onPressed: () async {
              //         String ip = ipController.text.trim();
              //         bool isConnected =
              //             await esp8266Provider.connectToServer(ip);
              //         if (isConnected) {
              //           connected = true;
              //           setState(() {});
              //         } else {
              //           connected = false;
              //           setState(() {});
              //         }
              //       },
              //       label: 'Open Port',
              //       startColor: credBoxColor,
              //       endColor: credBoxColor,
              //       height: 55,
              //       width: 160,
              //       fontsize: 16,
              //       icon: Icons.cast_connected_rounded,
              //       // child: Text("Open Port"),
              //       // style: buttonPrimary,
              //     )
              //   ],
              // ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(9.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.start,
            //     children: [
            //       Text(
            //         "Image",
            //         style: GoogleFonts.poppins(
            //           textStyle: TextStyle(
            //               fontSize: 17,
            //               fontWeight: FontWeight.bold,
            //               color: fontColorBlack),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            // Divider(
            //     color: dividerColor,
            //     height: 13,
            //     indent: 12,
            //     endIndent: 12,
            //     thickness: 2),
            // SizedBox(
            //   height: 10,
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     children: [
            //       ElevatedButton(
            //         onPressed: () {
            //           _pickImagefromGallery();
            //         },
            //         child: Text("Select Image"),
            //         style: buttonPrimary,
            //       ),
            //       ElevatedButton(
            //         onPressed: () {
            //           _pickImagefromCamera();
            //         },
            //         child: Text("Take Photo"),
            //         style: buttonPrimary,
            //       ),
            //     ],
            //   ),
            // ),
            // const SizedBox(
            //   height: 50,
            // ),
            // _selectedImage != null
            //     ? Image.file(_selectedImage!)
            //     : Text("Please, select an image!",
            //         style: GoogleFonts.poppins(
            //           textStyle: TextStyle(
            //               fontSize: 20,
            //               fontWeight: FontWeight.w300,
            //               color: fontColorBlack),
            //         )),

            // SizedBox(
            //   height: 148,
            // ),

            Spacer(),
            // const SizedBox(
            //   height: 25,
            // ),
            value != null
                ? Text('$value',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                        color: fontColorBlack,
                      ),
                    ))
                : Text("",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w300,
                        color: fontColorBlack,
                      ),
                    )),
            Container(
              decoration: BoxDecoration(
                color: Color(0xFF5B6BF5),
                // borderRadius: BorderRadius.only(
                //   bottomLeft: Radius.circular(9.0),
                //   bottomRight: Radius.circular(9.0),
                // ),
              ),
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () {
                      RoutingScreen.toSharedScreen(context);
                    },
                    splashRadius: 30,
                    splashColor: iconColor,
                    icon: Icon(Icons.telegram),
                    color: iconColor,
                    iconSize: 40,
                  ),
                  IconButton(
                    onPressed: () {
                      RoutingScreen.toespSetting(context);
                    },
                    splashRadius: 30,
                    splashColor: iconColor,
                    icon: Icon(Icons.settings),
                    iconSize: 40,
                    color: iconColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future _pickImagefromGallery() async {
  //   final List<XFile>? returnedImage = await ImagePicker().pickMultiImage();

  //   if (returnedImage!.isNotEmpty) {
  //     ImageFileList.addAll(returnedImage);
  //   }
  //   ;
  //   setState(() {});
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => Shared(imagePaths: ImageFileList)),
  //   );
  // }

  // Future _pickImagefromCamera() async {
  //   final returnedImage =
  //       await ImagePicker().pickImage(source: ImageSource.camera);

  //   if (returnedImage == null) return;

  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //         builder: (context) => Shared(imagePaths: [returnedImage])),
  //   );
  //   // setState(() {
  //   //   _selectedImage = File(returnedImage!.path);
  //   // });
  // }
  Future<void> fetchLoc() async {
    LocationHandler locationHandler = LocationHandler();
    locationHandler.getUserCurrentLatlng((p0) => {
          print("in fetchLoc"),
          print("${p0.latitude},${p0.longitude}"),
          curLocation = "${p0.latitude},${p0.longitude}"
        });
  }
}

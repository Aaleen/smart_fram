import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_frame/components/colors/styling.dart';
import 'package:smart_frame/components/colors/theme.dart';
import 'package:smart_frame/data/provider/http_feedprovider.dart';
import 'package:smart_frame/data/provider/mob_to_esp.dart';
import 'package:smart_frame/data/routing/routing.dart';

class Shared extends StatefulWidget {
  // final List<XFile> imagePaths;

  // const Shared({Key? key, this.imagePaths = const []}) : super(key: key);

  @override
  State<Shared> createState() => _SharedState();
}

class _SharedState extends State<Shared> {
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   String ip = '192.168.4.1';
  //   esp8266Provider.connectToServer(ip);
  // }

  final ESP8266Provider esp8266Provider = ESP8266Provider();
  final ImagePicker _imagePicker = ImagePicker();
  List<String> _imagePaths = [];
  List<String> _base64Strings = [];
  List<XFile> ImageFileList = [];
  TextEditingController inputController = TextEditingController();
  void updateTextField(int index) {
    setState(() {
      inputController.text = _base64Strings[index];
      print(inputController.text);
    });
  }

  Future<void> openImage() async {
    try {
      final List<XFile>? pickedFiles = await _imagePicker.pickMultiImage();

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        for (var file in pickedFiles) {
          String imagePath = file.path;
          File imageFile = File(imagePath);
          Uint8List imageBytes = await imageFile.readAsBytes();
          String base64String = base64.encode(imageBytes);

          setState(() {
            _imagePaths.add(imagePath);
            _base64Strings.add(base64String);
          });
        }
      } else {
        print('No images selected');
      }
    } catch (e) {
      print('Error selecting images: $e');
    }
  }

  // void selectImages() async {
  //   final List<XFile>? selectedImages = await ImagePicker().pickMultiImage();
  //   if (selectedImages!.isNotEmpty && selectedImages != null) {
  //     ImageFileList!.addAll(selectedImages);
  //   }
  //   setState(() {});
  // }
  // Image.file(File(_imagePaths[index]), fit: BoxFit.cover),
  Widget showImage(String base64String) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          image:
              DecorationImage(image: MemoryImage(base64Decode(base64String)))),
    );
  }

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
                  Text("Shared",
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: fontColorWhite),
                      )),
                  SizedBox(
                    width: 210,
                  ),
                  IconButton(
                    onPressed: () async {
                      String message = inputController.text.trim();
                      message.trim();
                      // esp8266Provider.sendMessage(message);
                      sendMessageToEsp.sendImage(message);
                      // print("this is message:$message");
                      message = '';
                      Future.delayed(Duration.zero, () {
                        _showSuccessDialog();
                      });
                    },
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
                    "Image",
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: fontColorBlack),
                    ),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      openImage();
                    },
                    child: Text("Select Image"),
                    style: buttonPrimary,
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
            Expanded(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: _imagePaths!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Text("Selected Image"),
                          SizedBox(height: 5),
                          Image.file(File(_imagePaths[index]),
                              fit: BoxFit.cover),
                        ],
                      ),
                    );
                  },
                ),

                // child: _buildImageRows(),
                //=====Containers grid for gallery
                // children: [
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     // instead of these containers i want images in this size, i also want this to be wrapped within singlechildscrollview
                //     Container(
                //       color: credBoxColor,
                //       height: 150,
                //       width: 150,
                //     ),
                //     Container(
                //       color: credBoxColor,
                //       height: 150,
                //       width: 150,
                //     )
                //   ],
                // ),
                // SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Container(
                //       color: credBoxColor,
                //       height: 150,
                //       width: 150,
                //     ),
                //     Container(
                //       color: credBoxColor,
                //       height: 150,
                //       width: 150,
                //     )
                //   ],
                // ),
                // SizedBox(height: 20),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     Container(
                //       color: credBoxColor,
                //       height: 150,
                //       width: 150,
                //     ),
                //     Container(
                //       color: credBoxColor,
                //       height: 150,
                //       width: 150,
                //     )
                //   ],
                // ),
                // ],
              ),
            ),
            Expanded(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemCount: _base64Strings!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Text('Decoded Image'),
                          showImage(_base64Strings[index].trim()),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: inputController,
                readOnly: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Decode String',
                ),
              ),
            ),
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _base64Strings.length,
                itemBuilder: (context, index) {
                  return TextButton(
                    onPressed: () {
                      updateTextField(index);
                    },
                    child: Text('${index + 1}'),
                  );
                },
              ),
            ),
            Spacer(),
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Images sent successfully!'),
        );
      },
    );

    // Schedule navigation after 3 seconds
    // Future.delayed(Duration(seconds:2), () {
    //   Navigator.of(context).pop();
    // });
  }
  // List<Widget> _buildImageRows() {
  //   List<Widget> rows = [];
  //   for (int i = 0; i < widget.imagePaths.length; i += 2) {
  //     // Create a row with two images
  //     rows.add(
  //       Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: [
  //           _buildImageContainer(widget.imagePaths[i]),
  //           if (i + 1 < widget.imagePaths.length)
  //             _buildImageContainer(widget.imagePaths[i + 1]),
  //         ],
  //       ),
  //     );
  //     rows.add(SizedBox(height: 20)); // Add spacing between rows
  //   }
  //   return rows;
  // }

  // Widget _buildImageContainer(String imagePath) {
  //   return Container(
  //     height: 150,
  //     width: 150,
  //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
  //     child: Image.file(
  //       File(imagePath),
  //       fit: BoxFit.cover,
  //     ),
  //   );
  // }
}

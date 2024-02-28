import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_frame/components/colors/styling.dart';
import 'package:smart_frame/components/colors/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_frame/components/widgets/stylizedbutton.dart';
import 'package:smart_frame/data/routing/routing.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class splash extends StatelessWidget {
  const splash({super.key});

  @override
  Widget build(BuildContext context) {
    String link = 'https://www.upwork.com/freelancers/syedmuhammadaaleenr';
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset('assets/images/splash.png', height: 500),
                ],
              ),
              SizedBox(height: 5),
              Column(
                children: [
                  Column(
                    children: [
                      Text("Frame Your Memories!",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w800),
                          )),
                    ],
                  ),

                  // SizedBox(
                  //   height: 2,
                  // ),
                  Column(
                    children: [
                      Text("Illuminate Your Moments!",
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                                fontSize: 16.6, fontWeight: FontWeight.w700),
                          )),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              StylizedButton(
                  label: "Get Started",
                  onPressed: () {
                    RoutingScreen.toSelectDevice(
                        context); // Call the routing function
                  },
                  width: 150,
                  iconRight: Icons.arrow_forward_ios_rounded,
                  startColor: Color(0xFF5b6bf5),
                  endColor: Color(0xFF6170EF)),
              SizedBox(
                height: 5,
              ),
              Spacer(),
              // InkWell(
              //   child: Text(
              //     "Designed and Developed by: Aaleen Raza",
              //     style: GoogleFonts.poppins(
              //       textStyle: TextStyle(
              //         fontSize: 12,
              //         fontWeight: FontWeight.w200,
              //         color: fontColorBlack,
              //       ),
              //     ),
              //   ),
              //   onTap: () {_launchURL();},
              // ),
              Link(
                  target: LinkTarget.blank,
                  // uri: Uri.parse(
                  //     'https://www.upwork.com/freelancers/syedmuhammadaaleenr'),

                  uri: Uri.parse(link),
                  builder: (context, FollowLink) {
                    return ElevatedButton(
                      style: buttonSecondry,
                      onPressed: FollowLink,
                      child: Text(
                        "Designed and Developed by: Aaleen Raza",
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                      ),
                    );
                  }),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _launchURL() async {
    Uri _url =
        Uri.parse('https://www.upwork.com/freelancers/syedmuhammadaaleenr');
    if (await launchUrl(_url)) {
      await launchUrl(_url);
    } else {
      throw 'Could not launch $_url';
    }
  }
}

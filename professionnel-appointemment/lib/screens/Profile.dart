import 'dart:async';
import 'package:flutter/material.dart';
import 'package:professionnel/res/lists.dart';
import 'package:professionnel/screens/ClientWorkRequestPage.dart';
import 'package:professionnel/screens/ReviewsPage.dart'; // Import the ReviewsPage
import 'package:professionnel/widgets/text_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class Profilemec extends StatefulWidget {
  final AssetImage image;
  final String name;
  final String specialties;
  final String phoneNumber; // Added phone number field

  const Profilemec({
    Key? key,
    required this.image,
    required this.name,
    required this.specialties,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<Profilemec> createState() => _ProfileState();
}

class _ProfileState extends State<Profilemec> {
  var animate = false;
  var opacity = 0.0;
  late Size size;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      animator();
    });
  }

  animator() {
    if (opacity == 0.0) {
      opacity = 1;
      animate = true;
    } else {
      opacity = 0.0;
      animate = false;
    }
    setState(() {});
  }

  // Function to launch phone call
  void _launchPhoneCall(String phoneNumber) async {
    final Uri _phoneLaunchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunch(_phoneLaunchUri.toString())) {
      await launch(_phoneLaunchUri.toString());
    } else {
      throw 'Could not launch $_phoneLaunchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        color: Colors.white,
        height: size.height,
        width: size.width,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: opacity,
                child: Container(
                  height: size.height / 3,
                  width: size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: widget.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: size.height / 3 - 50,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 400),
                opacity: opacity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: widget.image,
                    ),
                    const SizedBox(height: 10),
                    TextWidget(
                      widget.name,
                      25,
                      Colors.black,
                      FontWeight.bold,
                      letterSpace: 0,
                    ),
                    const SizedBox(height: 10),
                    TextWidget(
                      widget.specialties,
                      20,
                      Colors.black.withOpacity(.6),
                      FontWeight.normal,
                      letterSpace: 0,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const SizedBox(
                            height: 50,
                            width: 50,
                            child: Center(
                              child: Icon(
                                Icons.star,
                                color: Colors.orange,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextWidget(
                              "Rating",
                              17,
                              Colors.black.withOpacity(.5),
                              FontWeight.bold,
                              letterSpace: 0,
                            ),
                            const SizedBox(height: 5),
                            TextWidget(
                              "4.5 out of 5",
                              23,
                              Colors.black,
                              FontWeight.bold,
                              letterSpace: 0,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    TextWidget(
                      "If you need an emergency intervention, feel free to call me",
                      16,
                      Colors.black.withOpacity(.6),
                      FontWeight.normal,
                      letterSpace: 0,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _launchPhoneCall(widget.phoneNumber);
                      },
                      child: TextWidget(
                        "Call ${widget.name}",
                        16,
                        Colors.white,
                        FontWeight.bold,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                children: [
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 400),
                    opacity: opacity,
                    child: InkWell(
                      onTap: () async {
                        animator();
                        await Future.delayed(
                          const Duration(milliseconds: 400),
                        );
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ClientWorkRequestPage(1),
                          ),
                        );
                        animator();
                      },
                      child: Container(
                        height: 65,
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blue.shade900,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextWidget(
                              "Make an appointment",
                              18,
                              Colors.white,
                              FontWeight.w500,
                              letterSpace: 1,
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.white,
                              size: 18,
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.white.withOpacity(.5),
                              size: 18,
                            ),
                            Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.white.withOpacity(.2),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReviewsPage(),
                        ),
                      );
                    },
                    child: TextWidget(
                      "Reviews",
                      16,
                      Colors.white,
                      FontWeight.bold,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade900,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

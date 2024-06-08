import 'package:flutter/material.dart';
import 'package:professionnel/screens/ClientWorkRequestPage.dart';
import 'package:professionnel/screens/HomeProf.dart';
import 'package:professionnel/screens/RatingReview.dart';
import 'package:professionnel/screens/SeeAll.dart';
import 'package:professionnel/screens/map_screen.dart';
import 'package:professionnel/screens/prof_home.dart';

import 'package:professionnel/screens/signin_screen.dart';
import 'package:professionnel/screens/signup_screen.dart';
import 'package:professionnel/screens/welcome_screen.dart';
import 'package:professionnel/screens/Oppointment.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.light(), // Utilisation du thème par défaut de Flutter
      initialRoute: 'welcome_screen',
      routes: {
        'signup_screen': (context) => const SignUpScreen(),
        'signin_screen': (context) => const SignInScreen(),
      },
      home: const SignInScreen(),
    );
  }
}

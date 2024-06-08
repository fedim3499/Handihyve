import 'package:flutter/material.dart';
import 'package:professionnel/screens/signin_screen.dart';
import 'package:professionnel/screens/signup_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/screens/signup_screen.dart': (context) => const SignUpScreen(),
      '/screens/signin_screen.dart': (context) => const SignInScreen(),
    };
  }
}

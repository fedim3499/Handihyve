import 'package:professionnel/screens/constants.dart';
import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({
    required Key key,
  }) : super(key: key);

  get kPrimaryColor => null;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyClipper(),
      child: Container(
        width: double.infinity,
        height: 350.0,
        color: kPrimaryColor,
      ),
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, size.height - 150);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 170);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

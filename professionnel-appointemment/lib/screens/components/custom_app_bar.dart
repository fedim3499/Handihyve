import 'package:professionnel/screens/components/rounded_button.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    required Key key,
  }) : super(key: key);

  get kPrimaryColor => null;

  get kDefaultPadding => null;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RoundedButton(
          icon: Icon(Icons.arrow_back),
          iconColor: kPrimaryColor,
          bgColor: Colors.white,
          tap: () {},
        ),
        SizedBox(width: kDefaultPadding),
        Text(
          'You are in place!',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        )
      ],
    );
  }
}

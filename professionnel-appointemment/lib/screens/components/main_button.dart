import 'package:professionnel/screens/components/rounded_button.dart';
import 'package:professionnel/screens/constants.dart';
import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    required Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          'Submit',
          style: TextStyle(
              color: kPrimaryColor, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(width: kDefaultPadding),
        RoundedButton(
            icon: Icon(Icons.arrow_forward),
            iconColor: Colors.white,
            bgColor: kPrimaryColor,
            tap: () {})
      ],
    );
  }
}

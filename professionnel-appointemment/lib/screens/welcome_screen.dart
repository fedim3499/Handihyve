// // ignore: unused_import
// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:professionnel/screens/signup_screen.dart';
// import 'package:professionnel/widgets/custom_scaffold.dart';

// class WelcomeScreen extends StatelessWidget {
//   const WelcomeScreen({Key? key}) : super(key: key);

//   void navigateToSignUpScreen(BuildContext context) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => const SignUpScreen()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       child: Column(
//         children: [
//           Flexible(
//             flex: 8,
//             child: Container(
//               padding: const EdgeInsets.symmetric(
//                 vertical: 0,
//                 horizontal: 40.0,
//               ),
//               child: Center(
//                 child: RichText(
//                   textAlign: TextAlign.center,
//                   text: const TextSpan(
//                     children: [
//                       TextSpan(
//                           text: 'Welcome Back!\n',
//                           style: TextStyle(
//                             fontSize: 45.0,
//                             fontWeight: FontWeight.w600,
//                           )),
//                       TextSpan(
//                           text:
//                               '\nEnter personal details to your employee account',
//                           style: TextStyle(
//                             fontSize: 20,
//                             height: 0,
//                           ))
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Flexible(
//             flex: 1,
//             child: Align(
//               alignment: Alignment.bottomRight,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: WelcomeButton(
//                       buttonText: "Sign in",
//                       onTap: () => navigateToSignUpScreen(
//                           context), // Utilisez la fonction navigateToSignInScreen
//                       color: Colors.transparent,
//                       textColor: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class WelcomeButton extends StatelessWidget {
//   const WelcomeButton({
//     Key? key,
//     required this.buttonText,
//     required this.onTap,
//     required this.color,
//     required this.textColor,
//   }) : super(key: key);

//   final String buttonText;
//   final void Function() onTap;
//   final Color color;
//   final Color textColor;

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onTap,
//       style: ElevatedButton.styleFrom(
//         foregroundColor: textColor,
//         backgroundColor: color,
//       ),
//       child: Text(buttonText),
//     );
//   }
// }

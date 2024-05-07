import 'package:elder_ring/Screen%20Sharing/custom_button.dart';
import 'package:flutter/material.dart';
//import 'package:the_final_zoom_clone/utils/auth_methods.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //final AuthMethods _authMethods = AuthMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Screen Sharing!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Image.asset('assets/images/onboarding.jpg'),
        ),
        CustomButton(
          text: 'Share Screen',
          onPressed: () {
            Navigator.pushNamed(context, '/home');
          },
        ),
        CustomButton(
            text: 'See Screen',
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            })
      ],
    ));
  }
}

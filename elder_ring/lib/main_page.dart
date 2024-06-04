import 'package:elder_ring/login_page.dart';
import 'package:elder_ring/elder_home_page.dart'; // Import HomePage
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // return HomePage(); // HomePage is not defined
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return const LoginPage();
              },
            ); // Wrap HomePage with StatefulBuilder
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

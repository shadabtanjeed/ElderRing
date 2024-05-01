import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'map_page.dart'; // Importing the MaPage widget

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Signed In as ${user?.email ?? ''}',
          style: const TextStyle(
            fontFamily: 'Jost',
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF2798E4)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: const Text(
                  'Medication Schedule',
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Handle button press
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF2798E4)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: const Text(
                  'Emergency',
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MaPage()), // Navigating to MaPage
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF2798E4)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: const Text(
                  'Location Sharing',
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

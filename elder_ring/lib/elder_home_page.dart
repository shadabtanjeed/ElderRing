import 'package:elder_ring/Group%20Chat/chat_home_screen.dart';
import 'package:elder_ring/Screen%20Sharing/home_screen_elderly.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Locations/mapMenu.dart';
import 'Medication Reminder/medication_schedule.dart';
import 'theme_provider.dart';
import 'login_page.dart'; // Make sure to import LoginPage

class ElderHomePage extends StatefulWidget {
  final String username;

  const ElderHomePage({Key? key, required this.username}) : super(key: key);

  @override
  State<ElderHomePage> createState() => ElderHomePageState();
}

class ElderHomePageState extends State<ElderHomePage> {
  final user = FirebaseAuth.instance.currentUser;

  String username = "";

  @override
  void initState() {
    super.initState();
    username = widget.username;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          MedicationSchedule(username: username),
                    ),
                  );
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Elderly_HomeScreen()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF2798E4)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: const Text(
                  'Share Screen',
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
                    MaterialPageRoute(builder: (context) => const MapMenu()),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF2798E4)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: const Text(
                  'Change Theme',
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
                    MaterialPageRoute(builder: (context) => Chat_HomeScreen()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFF2798E4)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: const Text(
                  'Chat',
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

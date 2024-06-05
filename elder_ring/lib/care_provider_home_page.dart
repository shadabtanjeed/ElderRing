import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elder_ring/Screen%20Sharing/home_screen_elderly.dart';
import 'package:elder_ring/Screen%20Sharing/home_scrren_careProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Locations/mapMenu.dart';
import 'Medication Reminder/medication_schedule.dart';
import 'theme_provider.dart';
import 'login_page.dart'; // Make sure to import LoginPage

class CareProviderHomePage extends StatefulWidget {
  final String username;

  const CareProviderHomePage({Key? key, required this.username})
      : super(key: key);

  @override
  State<CareProviderHomePage> createState() => CareProviderHomePageState();
}

class CareProviderHomePageState extends State<CareProviderHomePage> {
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
                        builder: (context) => const MedicationSchedule()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFFC73659)),
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
                onPressed: () async {
                  final String elder_name;
                  FirebaseFirestore firestore = FirebaseFirestore.instance;

                    Future<String> fetchAssociatedElder(String currentUsername) async {
                    // Fetch the document for the current user
                    QuerySnapshot querySnapshot = await firestore
                        .collection('user_db')
                        .where('username', isEqualTo: currentUsername)
                        .get();

                    // Extract the associated elder from the document
                    if (querySnapshot.docs.isNotEmpty) {
                      return querySnapshot.docs.first.get('associated_elder');
                    } else {
                      throw Exception('No user found for username: $currentUsername');
                    }
                  }

                  elder_name = await fetchAssociatedElder(username);
                    print(elder_name);


                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CareProvider_HomeScreen(username: widget.username,)),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xFFC73659)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: const Text(
                  'View Screen',
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
                      MaterialStateProperty.all(const Color(0xFFC73659)),
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
                      MaterialStateProperty.all(const Color(0xFFC73659)),
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
            ],
          ),
        ),
      ),
    );
  }
}

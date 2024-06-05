import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elder_ring/Screen%20Sharing/home_scrren_careProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'Locations/mapMenu.dart';
import 'Medication Reminder_Care Provider/cp_medication_schedule.dart';
import 'theme_provider.dart';
import 'login_page.dart'; // Make sure to import LoginPage
import 'package:elder_ring/Users/users.dart';

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

  String? elderUsername;
  static const careProviderColor = Color(0xFF006769);

  @override
  void initState() {
    super.initState();
    fetchAssociatedElder();
  }

  Future<void> fetchAssociatedElder() async {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('user_db')
          .where('username', isEqualTo: widget.username)
          .get();
      final documents = result.docs;
      if (documents.isNotEmpty) {
        setState(() {
          elderUsername = documents[0]['associated_elder'];
        });
      } else {
        Fluttertoast.showToast(msg: 'Error: User not found');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
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
              Users.clear();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
      body: elderUsername == null
          ? const Center(child: CircularProgressIndicator())
          : Center(
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
                                CareProviderMedicationSchedule(
                                    username: widget.username,
                                    elder_username: elderUsername!),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(careProviderColor),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
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
                          MaterialPageRoute(
                              builder: (context) =>
                                  const CareProvider_HomeScreen()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(careProviderColor),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
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
                          MaterialPageRoute(
                              builder: (context) => const MapMenu()),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(careProviderColor),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
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
                        themeProvider.toggleTheme();
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(careProviderColor),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'Signup/signup_page.dart';
import 'care_provider_home_page.dart';
import 'elder_home_page.dart';
import 'Users/users.dart';

FirebaseAuth auth = FirebaseAuth.instance;
String LoggedInUser = '';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final username_controller = TextEditingController();
  final password_controller = TextEditingController();
  static const Color loginPageColor = Color(0xFF2798E4);


  Future signIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: loginPageColor,
          ),
        );
      },
    );

    String username = username_controller.text.trim();
    String firebase_email = username_controller.text.trim() + '@gmail.com';
    String password = password_controller.text.trim();

    LoggedInUser = username;

    print("Trying to sign in with email: $firebase_email");

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: firebase_email,
        password: password,
      );
      Navigator.pop(context); // Close the progress dialog
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Sign-in successful!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: loginPageColor,
        ),
      );
      // Check if the user is signed in
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userType = await handleUserType(username);

        if (userType == 'elder') {
          Users.setElderlyUsername(username);
          Users.fetchAssociatedCareProvider();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ElderHomePage(username: username),
            ),
          );
        } else if (userType == 'care_provider') {
          Users.setCareProviderUsername(username);
          Users.fetchAssociatedElder();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CareProviderHomePage(username: username),
            ),
          );
        } else {
          Fluttertoast.showToast(msg: 'Error: User type not found');
        }
      }
    } catch (e) {
      Navigator.pop(context); // Close the progress dialog
      print("Error during sign-in: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to sign in: $e"),
        ),
      );
    }
  }

  Future<String> handleUserType(String username) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('user_db')
        .where('username', isEqualTo: username)
        .get();
    final documents = result.docs;
    if (documents.isEmpty) {
      Fluttertoast.showToast(msg: 'Error: User not found');
      return ''; // Indicate error or handle user not found scenario elsewhere
    }
    final userType = documents[0]['type'];
    return userType;
  }

  @override
  void dispose() {
    username_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset('Resources/logo.png'),
                ),
                const Text(
                  'Login',
                  style: TextStyle(
                    fontFamily: 'Jost',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: username_controller,
                      cursorColor: isDarkMode ? Colors.white : loginPageColor,
                      style: TextStyle(
                          fontFamily: 'Jost',
                          color: isDarkMode ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          fontFamily: 'Jost',
                          color: isDarkMode ? Colors.white : loginPageColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: isDarkMode ? Colors.white : loginPageColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: isDarkMode ? Colors.white : loginPageColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextField(
                      controller: password_controller,
                      obscureText: true,
                      cursorColor: isDarkMode ? Colors.white : loginPageColor,
                      style: TextStyle(
                          fontFamily: 'Jost',
                          color: isDarkMode ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                            fontFamily: 'Jost',
                            color: isDarkMode ? Colors.white : loginPageColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: isDarkMode ? Colors.white : loginPageColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: isDarkMode ? Colors.white : loginPageColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    signIn();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(loginPageColor),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Jost',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontFamily: 'Jost',
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 14, // Adjusted the font size to be smaller
                      ),
                      children: const <TextSpan>[
                        TextSpan(text: 'Do not have an account? '),
                        TextSpan(
                          text: 'Create Account',
                          style: TextStyle(
                            color: loginPageColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

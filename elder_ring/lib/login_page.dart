import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Signup/signup_page.dart';
import 'home_page.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final username_controller = TextEditingController();
  final password_controller = TextEditingController();

  Future signIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(
            color: Color(0xFF2798E4),
          ),
        );
      },
    );

    String firebase_email = username_controller.text.trim() + '@gmail.com';
    String password = password_controller.text.trim();

    print("Trying to sign in with email: $firebase_email");

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: firebase_email,
        password: password,
      );
      Navigator.pop(context); // Close the progress dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Sign-in successful!",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF2798E4),
        ),
      );
      // Check if the user is signed in
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  HomePage()), // Replace with your home page widget
        );
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
                      cursorColor:
                          isDarkMode ? Colors.white : const Color(0xFF2798E4),
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF2798E4),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF2798E4),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF2798E4),
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
                      cursorColor:
                          isDarkMode ? Colors.white : const Color(0xFF2798E4),
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF2798E4),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF2798E4),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: isDarkMode
                                ? Colors.white
                                : const Color(0xFF2798E4),
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
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF2798E4)),
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
                      style: DefaultTextStyle.of(context).style,
                      children: <TextSpan>[
                        TextSpan(text: 'Do not have an account? '),
                        TextSpan(
                          text: 'Create Account',
                          style: TextStyle(
                            color: const Color(0xFF2798E4),
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

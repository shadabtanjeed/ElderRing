import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final email_controller = TextEditingController();
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

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email_controller.text.trim(),
        password: password_controller.text.trim(),
      );
    } catch (e) {
      // Handle any errors here
    } finally {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    email_controller.dispose();
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
                      controller: email_controller,
                      cursorColor:
                          isDarkMode ? Colors.white : const Color(0xFF2798E4),
                      style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        labelText: 'Email',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

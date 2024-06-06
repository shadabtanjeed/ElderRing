import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elder_ring/Signup/signup_db_methods.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import '../login_page.dart';

FirebaseAuth auth = FirebaseAuth.instance;

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  bool isLoading = false; // Declare isLoading at class level

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final elderUsernameController = TextEditingController();
  int selectedRole = 0; // 0 for Elder People, 1 for Care Provider

  Future signUp() async {
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
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } catch (e) {
      // Handle any errors here
    } finally {
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    elderUsernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        body: SafeArea(
          top: true,
          child: Align(
            alignment: const AlignmentDirectional(0, 0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.black : Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    // Align vertically centered
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 25),
                        child: Text(
                          'Create Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Jost',
                            fontSize: 24,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20),
                          child: Text(
                            'Choose your role:',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Jost',
                              fontSize: 19,
                              letterSpacing: 0,
                            ),
                          ),
                        ),
                      ),
                      // Role selection widgets
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 10, 0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedRole = 0;
                                    });
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: selectedRole == 0
                                          ? const Color(0xFF2798E4)
                                          : const Color(0xFFF4E8E8),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 4,
                                          color: Color(0x33000000),
                                          offset: Offset(0, 2),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFF2798E4),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 7, 0, 0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                'Resources/elder_picture.png',
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Elder People',
                                          style: TextStyle(
                                            fontFamily: 'Jost',
                                            fontSize: 14,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w500,
                                            color: selectedRole == 0
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    10, 0, 0, 0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedRole = 1;
                                    });
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: selectedRole == 1
                                          ? const Color(0xFF2798E4)
                                          : const Color(0xFFF4E8E8),
                                      boxShadow: const [
                                        BoxShadow(
                                          blurRadius: 4,
                                          color: Color(0x33000000),
                                          offset: Offset(0, 2),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFF2798E4),
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Align(
                                          alignment:
                                              const AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 7, 0, 0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                'Resources/care_provider_image.png',
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          'Care Provider',
                                          style: TextStyle(
                                            fontFamily: 'Jost',
                                            fontSize: 14,
                                            letterSpacing: 0,
                                            fontWeight: FontWeight.w500,
                                            color: selectedRole == 1
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Username input field
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextField(
                              controller: usernameController,
                              cursorColor: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF2798E4),
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Username',
                                labelStyle: TextStyle(
                                  fontFamily: 'Jost',
                                  fontSize: 14,
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
                      ),
                      // Email input field
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextField(
                              controller: emailController,
                              cursorColor: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF2798E4),
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black),
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  fontFamily: 'Jost',
                                  fontSize: 14,
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
                      ),
                      // Password input field
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 10),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextField(
                              controller: passwordController,
                              cursorColor: isDarkMode
                                  ? Colors.white
                                  : const Color(0xFF2798E4),
                              style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.white : Colors.black),
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  fontFamily: 'Jost',
                                  fontSize: 14,
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
                      ),
                      // Elder username input field (only if selected role is care provider)
                      if (selectedRole == 1)
                        Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8, 0, 8, 10),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextField(
                                controller: elderUsernameController,
                                cursorColor: isDarkMode
                                    ? Colors.white
                                    : const Color(0xFF2798E4),
                                style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black),
                                decoration: InputDecoration(
                                  labelText: 'Associated Elder Username',
                                  labelStyle: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 14,
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
                        ),
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0, 10, 0, 10),
                          child: SizedBox(
                            width: 110,
                            height: 40,
                            child: ElevatedButton(
                              onPressed: () {
                                addUser();
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    const Color(0xFF2798E4)),
                                foregroundColor:
                                    MaterialStateProperty.all(Colors.white),
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0, 0),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 10),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Already have an account?',
                                style: TextStyle(
                                  fontFamily: 'Jost',
                                  fontSize: 13,
                                  letterSpacing: 0,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Log in',
                                  style: TextStyle(
                                    fontFamily: 'Jost',
                                    fontSize: 13,
                                    letterSpacing: 0,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2798E4),
                                  ),
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
          ),
        ),
      ),
    );
  }

  Future<void> addUser() async {
    bool hasDuplicateUsername = false;

    final SignupDatabaseMethods signupdbmethods = SignupDatabaseMethods();

    String username = usernameController.text.trim();
    String email = emailController.text.trim();

    bool isElder = selectedRole == 0;

    String elderUsername;

    if (!isElder) {
      elderUsername = elderUsernameController.text.trim();
    } else {
      elderUsername = 'N/A';
    }

    String password = passwordController.text.trim();

    String type = isElder ? 'elder' : 'care_provider';

    //search for duplicate username existing in the database
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('user_db')
        .where('username', isEqualTo: username)
        .get();

    final List<DocumentSnapshot> documents = result.docs;

    if (documents.length == 1) {
      hasDuplicateUsername = true;
    }

    if (hasDuplicateUsername) {
      //toast saying there is duplicate username and do not proceed
      Fluttertoast.showToast(
          msg: "Username already exists",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xFF2798E4),
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      //find the user with the elder username
      if (!isElder) {
        final QuerySnapshot elderResult = await FirebaseFirestore.instance
            .collection('user_db')
            .where('username', isEqualTo: elderUsername)
            .get();

        final List<DocumentSnapshot> elderDocuments = elderResult.docs;

        if (elderDocuments.isEmpty) {
          //toast saying there is no elder with the username
          Fluttertoast.showToast(
              msg: "No elder with the username",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: const Color(0xFF2798E4),
              textColor: Colors.white,
              fontSize: 16.0);
          return;
        }

        //update the associated_care_provider field of the elder with the signee username
        await FirebaseFirestore.instance
            .collection('user_db')
            .doc(elderDocuments[0].id)
            .update({'associated_care_provider': username});
      }

      Map<String, dynamic> UserInfoMap = {
        "username": username,
        "email": email,
        "password": password,
        "associated_elder": elderUsername,
        "type": type,
        "associated_care_provider": isElder ? "N/A" : "N/A"
      };

      String userId = randomAlphaNumeric(10);

      await signupdbmethods.addUserInfo(UserInfoMap, userId).then((value) {
        Fluttertoast.showToast(
            msg: "User Added Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: const Color(0xFF2798E4),
            textColor: Colors.white,
            fontSize: 16.0);
      });

      userId = randomAlphaNumeric(10);

      //add to group chat users
      Map<String, dynamic> GCUserMap = {
        "username": username,
        "email": email,
        "status": "Unavailable",
        "docID" : userId
      };


      await signupdbmethods.addGCUser(GCUserMap, userId);
      //

      String firebase_email = username + "@gmail.com";

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: firebase_email,
        password: password,
      );

      setState(() {
        isLoading = false;
      });

      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false, // removes all previous routes
        );
      });
    }
  }
}

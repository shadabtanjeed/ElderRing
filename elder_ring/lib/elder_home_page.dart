import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elder_ring/EmergencyMeds/AddEM.dart';
import 'package:elder_ring/EmergencyMeds/GetEMNameList.dart';
import 'package:elder_ring/Group%20Chat/chat_home_screen.dart';
import 'package:elder_ring/Notifications/local_notificatiions.dart';
import 'package:elder_ring/Screen%20Sharing/home_screen_elderly.dart';
import 'package:elder_ring/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'devMenu.dart';
import 'Medication Reminder/medication_schedule.dart';
import 'Notifications/notification_responder_page.dart';
import 'Notifications/global_notifications.dart';
import 'main.dart';
import 'theme_provider.dart';
import 'login_page.dart';
import 'package:elder_ring/Users/users.dart';
import 'package:elder_ring/Locations/shareLocation.dart';

class ElderHomePage extends StatefulWidget {
  final String username;

  const ElderHomePage({Key? key, required this.username}) : super(key: key);

  @override
  State<ElderHomePage> createState() => ElderHomePageState();
}

class ElderHomePageState extends State<ElderHomePage> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


  String mtoken = "";
  final user = FirebaseAuth.instance.currentUser;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String username = "";
  static const Color elderColor = Color(0xFF2798E4);

  @override
  void initState() {
    super.initState();
    username = widget.username;

    // Request permission and get the token
    requestPermission();
    getToken();

    listenToNotifications();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LocalNotifications.showSimpleNotification(title: 'Global Notification', body: 'Demo Body', payload: 'Demo Payload');
    });

    initInfo();
  }

  // To listen to any notificationClick or not
  void listenToNotifications() {
    LocalNotifications.onClickNotification.listen((payload) {
      List<String> payloadParts = payload.split('||');
      String medicineName = payloadParts[0];
      String time = payloadParts[1];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              NotificationResponderPage(payload: payload,
                medicineName: medicineName,
                time: time,),
        ),
      );
    });
  }

  void requestPermission() async {
    // To listen to any notificationClick or not
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  void getToken() async {
    FirebaseMessaging.instance.getToken().then((token) {
      if (token != null) {
        setState(() {
          mtoken = token;
        });
        saveToken(token);
      }
    }).catchError((e) {
      print('Failed to get token: $e');
    });
  }

  void saveToken(String token) async {
    try {
      await FirebaseFirestore.instance
          .collection('user_token')
          .doc(username)
          .set({'token': token}, SetOptions(merge: true));
      print('Token updated successfully');
    } catch (e) {
      print('Failed to update token: $e');
    }
  }

  void initInfo() async {
    // Get the current user's information
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Get the user's information from Firestore or your own database
      // For example:
      // String name = await getUserName(user.uid);
    }
  }


    int _selectedIndex = 0;

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
      });
    }

    @override
    Widget build(BuildContext context) {
      final themeProvider = Provider.of<ThemeProvider>(context);
      final isDarkMode = themeProvider.themeData == Darkmode;
      final backgroundColor = isDarkMode ? Colors.black : Colors.white;
      final textColor = isDarkMode ? Colors.white : Colors.black;
      final elderColorDynamic = isDarkMode ? Colors.grey[800] : elderColor;

      return Navigator(
        key: navigatorKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold
            (
            key: scaffoldKey,
            backgroundColor: backgroundColor,
            appBar: AppBar(
              automaticallyImplyLeading: true,
              title: Text(
                'Home',
                style: TextStyle(
                  color: Colors.white, // This is the text color
                  fontSize: 28,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: elderColorDynamic,
              // This is the AppBar's background color
              actions: [
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    Users.clear();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                ),
              ],
              centerTitle: true,
              elevation: 4,
            ),
            body: SafeArea(
              top: true,
              child: Align(
                alignment: AlignmentDirectional(0, 0),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 50),
                          child: Text(
                            'Welcome $username',
                            style: TextStyle(
                              fontFamily: 'Jost',
                              fontSize: 25,
                              letterSpacing: 0,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 25),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 13, 0),
                                    child: InkWell(
                                      onTap: () {
                                        // Navigate to Medication Schedule page
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                MedicationSchedule(
                                                  username: username,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: elderColorDynamic,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4,
                                              color: Color(0x33000000),
                                              offset: Offset(0, 2),
                                            )
                                          ],
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(width: 0.5),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0, 0),
                                              child: Padding(
                                                padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 9, 0, 0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  child: Image.asset(
                                                    'Resources/medicine.png',
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 8, 0, 0),
                                              child: Text(
                                                'Medication Schedule',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Jost',
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    EdgeInsetsDirectional.fromSTEB(13, 0, 0, 0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Elderly_HomeScreen(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: elderColorDynamic,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4,
                                              color: Color(0x33000000),
                                              offset: Offset(0, 2),
                                            )
                                          ],
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(width: 0.5),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0, 0),
                                              child: Padding(
                                                padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 7, 0, 0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  child: Image.asset(
                                                    'Resources/videoconference.png',
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 8, 0, 0),
                                              child: Text(
                                                'Video \nCall',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Jost',
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.w500,
                                                ),
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
                          Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 25),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 13, 0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EntryNamesPage()),
                                        );
                                      },
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: elderColorDynamic,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4,
                                              color: Color(0x33000000),
                                              offset: Offset(0, 2),
                                            )
                                          ],
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(width: 0.5),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0, 0),
                                              child: Padding(
                                                padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 7, 0, 0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  child: Image.asset(
                                                    'Resources/emergency-call.png',
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 8, 0, 0),
                                              child: Text(
                                                'Emergency\nMedications',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Jost',
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    EdgeInsetsDirectional.fromSTEB(13, 0, 0, 0),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                Chat_Home_Screen(
                                                    username: username),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: elderColorDynamic,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4,
                                              color: Color(0x33000000),
                                              offset: Offset(0, 2),
                                            )
                                          ],
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(width: 0.5),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0, 0),
                                              child: Padding(
                                                padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 7, 0, 0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  child: Image.asset(
                                                    'Resources/speech-bubble.png',
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 7, 0, 0),
                                              child: Text(
                                                'Chat\nMessaging',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Jost',
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.w500,
                                                ),
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
                          Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 0, 25),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 0, 13, 0),
                                    child: InkWell(
                                      onTap: () {
                                        // Navigate to Location Sharing page
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                            const ShareLocation(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: elderColorDynamic,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4,
                                              color: Color(0x33000000),
                                              offset: Offset(0, 2),
                                            )
                                          ],
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(width: 0.5),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0, 0),
                                              child: Padding(
                                                padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 7, 0, 0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  child: Image.asset(
                                                    'Resources/placeholder.png',
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0, 7, 0, 0),
                                              child: Text(
                                                'Location \nSharing',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontFamily: 'Jost',
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  letterSpacing: 0,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    EdgeInsetsDirectional.fromSTEB(13, 0, 0, 0),
                                    child: InkWell(
                                      onTap: () {
                                        sendSOSMessage();
                                      },
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: elderColorDynamic,
                                          boxShadow: [
                                            BoxShadow(
                                              blurRadius: 4,
                                              color: Color(0x33000000),
                                              offset: Offset(0, 2),
                                            )
                                          ],
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(width: 0.5),
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0, 0),
                                              child: Padding(
                                                padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 10, 0, 0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(8),
                                                  child: Image.asset(
                                                    'Resources/sos.png',
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: AlignmentDirectional(
                                                  0, 0),
                                              child: Padding(
                                                padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 15, 0, 0),
                                                child: Text(
                                                  'SOS',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontFamily: 'Jost',
                                                    color: Colors.white,
                                                    fontSize: 15,
                                                    letterSpacing: 0,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: elderColorDynamic,
              unselectedItemColor: Colors.black45,
              // Default icon color
              selectedItemColor: Colors.white,
              // Highlight color for selected item
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.warning),
                  label: 'SOS',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Menu',
                ),
              ],
              onTap: (index) {
                switch (index) {
                  case 0:
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ElderHomePage(username: username),
                      ),
                    );
                    break;
                  case 1:
                      sendSOSMessage();
                    break;
                  case 2:
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MapMenu()),
                    );
                    break;
                }
              },
            ),
          ),
          ),
        ),
      );
    }
  }

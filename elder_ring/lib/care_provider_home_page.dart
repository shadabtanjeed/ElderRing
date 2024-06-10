import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elder_ring/Group%20Chat/chat_home_screen.dart';
import 'package:elder_ring/Screen%20Sharing/home_scrren_careProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Locations/shareLocation.dart';
import 'Medication Reminder_Care Provider/cp_medication_schedule.dart';
import 'Notifications/SOSResponderPage.dart';
import 'Notifications/MedicineMissNotificationPage.dart';
import 'Notifications/local_notificatiions.dart';
import 'Notifications/notification_responder_page.dart';
import 'main.dart';
import 'theme_provider.dart';
import 'login_page.dart';
import 'Users/users.dart';
import 'locations/getLocation.dart';
import 'devMenu.dart';

class CareProviderHomePage extends StatefulWidget {
  final String username;

  const CareProviderHomePage({Key? key, required this.username})
      : super(key: key);

  @override
  State<CareProviderHomePage> createState() => CareProviderHomePageState();
}

class CareProviderHomePageState extends State<CareProviderHomePage> {
  String mtoken = "";

  final user = FirebaseAuth.instance.currentUser;
  String? elderUsername;

  @override
  void initState() {
    super.initState();
    elderUsername = Users.getElderlyUsername();
    listenToNotifications();

    // LocalNotifications.onClickNotification.listen((payload) {
    //   navigatorKey.currentState!.push(
    //     MaterialPageRoute(
    //       builder: (context) => NotificationResponderPage(payload: payload),
    //     ),
    //   );
    // });

    requestPermission();
    getToken();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['type'] == 'SOS') {
        String time = message.data['time'];
        // Handle SOS notification
        LocalNotifications.showSimpleNotification(
            title: 'SOS Notification',
            body: 'SOS Button has been pressed at time: $time !',
            payload: 'SOS Payload');
        // Navigate to the SOS page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SOSResponderPage(time: time),
          ),
        );
      }

      else if(message.data['type'] == 'MedicineMiss')
      {
        String time = message.data['time'];
        String medicine_name = message.data['medicine_name'];
        // Handle SOS notification
        LocalNotifications.showSimpleNotification(
            title: 'Medicine Miss Notification',
            body: 'Your elder has missed $medicine_name on $time!!',
            payload: 'Medicine Miss Payload');
        // Navigate to the SOS page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MedicineMissResponder(
              time: time,
              medicineName: medicine_name,
            )
          ),
        );
      }
      else
      {
        // Handle other types of notifications
        LocalNotifications.showSimpleNotification(
            title: 'Global Notification',
            body: 'Demo Body',
            payload: 'Demo Payload');
      }
    });

    initInfo();
  }

  void listenToNotifications() {
    LocalNotifications.onClickNotification.listen((payload) {
      List<String> payloadParts = payload.split('||');
      String time = payloadParts[1];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SOSResponderPage(time: time),
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
          .doc(LoggedInUser)
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

  void dispose() {
    LocalNotifications.onClickNotification.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        key: GlobalKey<ScaffoldState>(),
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFF006769), // Ensure consistent color
          automaticallyImplyLeading: true,
          title: Text(
            'Home',
            style: TextStyle(
              fontFamily: 'Jost',
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          elevation: 4,
        ),
        body: SafeArea(
          child: Align(
            alignment: AlignmentDirectional(0, 0),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
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
                        'Welcome User',
                        style: TextStyle(
                          fontFamily: 'Jost',
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
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
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 25),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 13, 0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CareProviderMedicationSchedule(
                                                elder_username: Users.getElderlyUsername(),
                                                username: 'username',
                                              )),
                                    );
                                  },
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF006769), // Corrected color
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4,
                                          color: Color(0x33000000),
                                          offset: Offset(0, 2),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 9, 0, 0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
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
                                          padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                                          child: Text(
                                            'Medication Schedule',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Jost',
                                              color: Colors.white,
                                              fontSize: 15,
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
                                padding: EdgeInsetsDirectional.fromSTEB(13, 0, 0, 0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => CareProvider_HomeScreen()),
                                    );
                                  },
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF006769),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4,
                                          color: Color(0x33000000),
                                          offset: Offset(0, 2),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 7, 0, 0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
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
                                          padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                                          child: Text(
                                            'Video \nCall',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Jost',
                                              color: Colors.white,
                                              fontSize: 15,
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
                          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 25),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 13, 0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => GetLocation()), // Update to your SeeLocation page
                                    );
                                  },
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF006769),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4,
                                          color: Color(0x33000000),
                                          offset: Offset(0, 2),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 7, 0, 0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
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
                                          padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                                          child: Text(
                                            'See Elderly\'s\nLocation',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Jost',
                                              color: Colors.white,
                                              fontSize: 15,
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
                                padding: EdgeInsetsDirectional.fromSTEB(13, 0, 0, 0),
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Chat_Home_Screen(
                                              username: Users.getLoginUser())), // Update to your ChatMessaging page
                                    );
                                  },
                                  child: Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Color(0xFF006769),
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4,
                                          color: Color(0x33000000),
                                          offset: Offset(0, 2),
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        width: 0.5,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Align(
                                          alignment: AlignmentDirectional(0, 0),
                                          child: Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(0, 7, 0, 0),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
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
                                          padding: EdgeInsetsDirectional.fromSTEB(0, 7, 0, 0),
                                          child: Text(
                                            'Chat\nMessaging',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontFamily: 'Jost',
                                              color: Colors.white,
                                              fontSize: 15,
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

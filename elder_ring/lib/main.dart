import 'dart:io'; // Correct import for Platform

import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:elder_ring/login_page.dart';
import 'package:elder_ring/main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:elder_ring/theme.dart';
import 'package:elder_ring/theme_provider.dart'; // Import the ThemeProvider
import 'package:provider/provider.dart';
import 'Notifications/NotificationResponder.dart';
import 'theme_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyA619vAUbNLH4oQXCdVDDx78zAFBQOeFBE",
      appId: "1:265423351389:android:459e59e3f7d5c1a91927b4",
      messagingSenderId: "265423351389",
      projectId: "elderring-9e5f6",
    ),
  );

  await AwesomeNotifications().initialize(
    'resource://drawable/app_logo',
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: const Color(0xFF2798E4),
        ledColor: Colors.white,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        locked: true,
      )
    ],
  );

  AwesomeNotifications().actionStream.listen((ReceivedAction receivedAction) {
    debugPrint('onActionReceivedMethod');
    final payload = receivedAction.payload ?? {};
    if (payload["navigate"] == "true") {
      navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => NotificationResponder(
            medicineName: payload['medicineName'] ?? '',
            time: DateTime.parse(payload['time'] ?? ''),
          ),
        ),
      );
    }
  });

  AwesomeNotifications()
      .createdStream
      .listen((ReceivedNotification receivedNotification) {
    debugPrint('onNotificationCreatedMethod');
  });

  AwesomeNotifications()
      .displayedStream
      .listen((ReceivedNotification receivedNotification) {
    debugPrint('onNotificationDisplayedMethod');
  });

  AwesomeNotifications()
      .dismissedStream
      .listen((ReceivedAction receivedAction) {
    debugPrint('onDismissActionReceivedMethod');
  });

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(Lightmode),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
      navigatorKey: navigatorKey, // Use the global navigator key
    );
  }
}

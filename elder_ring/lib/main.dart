import 'dart:io'; // Correct import for Platform

import 'package:elder_ring/Notifications/local_notificatiions.dart';
import 'package:elder_ring/login_page.dart';
import 'package:elder_ring/main_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:elder_ring/theme.dart';
import 'package:elder_ring/theme_provider.dart'; // Import the ThemeProvider
import 'package:provider/provider.dart';
import 'theme_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
            apiKey: "AIzaSyA619vAUbNLH4oQXCdVDDx78zAFBQOeFBE",
            appId: "1:265423351389:android:459e59e3f7d5c1a91927b4",
            messagingSenderId: "265423351389",
            projectId: "elderring-9e5f6",
          ),
        )
      : await Firebase.initializeApp();
  //await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
    );
  }
}

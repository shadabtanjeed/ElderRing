import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:googleapis/servicecontrol/v1.dart' as servicecontrol;

import '../Users/users.dart';

Future<String> getAccessToken() async {
  // Your client ID and client secret obtained from Google Cloud Console
  final serviceAccountJson = {
    "type": "service_account",
    "project_id": "elderring-9e5f6",
    "private_key_id": "57ca287c64f338ae9690b1fefb96c241eaff04f3",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCn0SiA18D9cc2T\niaMGaomEM68igPkhzizV6XDxMpDz0uJDiyuTUt57daJMd0eCp97ESwCBt0YFPwjm\nO+c1wUf9zDiQMYQgSMLoABZdZ8Q2oLb+xcQIFdJHkmwrOnoumZj5thBJ81kMyUnT\nS+pit6k+q6MaeKYAd98hGZjLzEb9AhRNMGLj7wnEiOJrxf8pz4XN9qr2eU7slhtO\n2Pr/MptxYvv+IhTUW0KTozkuKQ38Sf0U4TTeuOJMy+5urllqzV8DwUV6PvN9UmBg\nZN3tBsKNOcJIE+Cko/gt/PlRs7fC1zQMevUJtufnH7bbCGJSbQvj9LoJk2NH9kfu\n0r/ZZlQBAgMBAAECggEAAqcfyMmgV2FRKp/mX9eXTOu0PQtk5M/pjYgfLPDrsa8H\nvKGakr2gnrsBUcwg6UPWFaxJ2cMX7EVO0rTntsXTaYOs8TqXKBt+WUSHFfrp8yMf\nQW/G5YnSxSbfZt+JxurOrEPghgq+waD89cYhcmYM2tzDu0tk9GTwtgk9jRsxlBZJ\nw9C13eOuULvH1GHBF8dNWorVHUTWLf2/Bsylo/mYSOCSMMvq7XBrDp2jBTuxi4gM\njCBTt/KTZSQcPfj0FKcG/qNs27N1RfeJhfrPYehR1OOijnv6lN7JaQc6OoHH6qZT\nCemNfb9iIgLfInn2LM6vja8r+E6jW5z1FB/8N6XmQQKBgQDay7bC3FFyhqbrvJnQ\nuBne3Z4JsWNsfcfIARJIJcqYO5QEFIj/o1Hn/gxL3S895B8QBeVCyKvD+jmY642t\ncpomEmNC99TagmvquzShSCdcXhHMOXaci931kRBhx96LCHkcQjtB3eNpGjq1bBwb\nyYK36crKeoEHkQu6z37ut5QIzQKBgQDEWlCvM7ZAKJulmAwwCtEMSj8EFiXV34D6\nNiKDQGP+pUnDMD43c2wSqynL/Uc2F8YWh1rfPQVfoMdd5K98IPIS+K01InW3w1k9\n60icV9mIeubc0q7LTNJLzTL0BWHrYtVGL+jd2JVBLIXVnB6GGQLzBVn1nj3ubq8T\nR5bx1yrIBQKBgGLZkLue4GlWrolozzF+S6nmBGWqsBmvBhi1azYPZOW8XRYu1Opy\nNioTHCkWSCa1LteFYlv236uOHIGbQoovcbdrrU7vO0pxjCIj7BZFzAquMWpMN+to\nQaKVpIoYy9GSxWzf+3e5sOmmQQoASv6+3wEKbmVmTW9Gt77xyg4+AHKtAoGBAJD1\nWEGwPKlrEVWURdMl+SVInvMmYrJdefu/AYXCgNAbOLSYJiaL2MqDgKzvhKYjsQMq\n1GSgyRnLOcRQs1lBfVWSL1Vd5mhPGNBEpmt908QVb+CwzYibY1nA2RAb9Slw4qEZ\nd6JoZfAirX+A7Wv0hR/i4IIbW/9tyWTDYmWSgyv9AoGBAKjaB0pBJH5kyRJoyGvO\nd9vE/MjxuHfqXLLjG+eigq5UX+7E/g0oHs8d0XwAJyGynZmDt/NXUrzk1gO4bmwA\nh/X9Ip9KpwNnMjcVseClfYAOSjdlZOlWccLVsyt1aTUEaj99Ll9x4uOBxoDMCtS5\n2Ke92FvGg5+n2rihlY8dFWnR\n-----END PRIVATE KEY-----\n",
    "client_email": "firebase-adminsdk-73fus@elderring-9e5f6.iam.gserviceaccount.com",
    "client_id": "105249769543377864981",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-73fus%40elderring-9e5f6.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

  List<String> scopes = [
    "https://www.googleapis.com/auth/userinfo.email",
    "https://www.googleapis.com/auth/firebase.database",
    "https://www.googleapis.com/auth/firebase.messaging"
  ];

  final auth.ServiceAccountCredentials credentials = auth.ServiceAccountCredentials.fromJson(serviceAccountJson);

  final auth.AutoRefreshingAuthClient client = await auth.clientViaServiceAccount(credentials, scopes);

  // Obtain the access token
  final String accessToken = (await client.credentials).accessToken.data;

  // Return the access token
  return accessToken;
}



Future<void> sendFCMMessage() async {
  Users.fetchAssociatedCareProvider();
  String careProviderUsername = Users.getCareProviderUsername();
  String cp_token = '';

  if (careProviderUsername == '') {
    print('Failed to get care provider username');
    return;
  }

  final DocumentSnapshot result = await FirebaseFirestore.instance
      .collection('user_token')
      .doc(careProviderUsername)
      .get();

  if (result.exists) {
    cp_token = (result.data() as Map<String, dynamic>)?['token'];
  } else {
    print('Document does not exist on the database');
  }

  final String accessToken = await getAccessToken(); // Get the access token
  final String fcmEndpoint = 'https://fcm.googleapis.com/v1/projects/elderring-9e5f6/messages:send'; // Corrected URL
  final String? currentFCMToken = cp_token;

  if (currentFCMToken == null) {
    print('Failed to get FCM token');
    return;
  }

  print("FCM Token: $currentFCMToken");

  final Map<String, dynamic> message = {
    'message': {
      'token': currentFCMToken, // Token of the device you want to send the message to
      'notification': {
        'body': 'This is an FCM notification message!',
        'title': 'FCM Message'
      },
      'data': {
        'current_user_fcm_token': currentFCMToken, // Include the current user's FCM token in data payload
      },
    }
  };

  final http.Response response = await http.post(
    Uri.parse(fcmEndpoint),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode(message),
  );

  if (response.statusCode == 200) {
    print('FCM message sent successfully');
  } else {
    print('Failed to send FCM message: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}

Future<void> sendSOSMessage() async {
  Users.fetchAssociatedCareProvider();
  String careProviderUsername = Users.getCareProviderUsername();
  String cp_token = '';

  if (careProviderUsername == '') {
    print('Failed to get care provider username');
    return;
  }

  final DocumentSnapshot result = await FirebaseFirestore.instance
      .collection('user_token')
      .doc(careProviderUsername)
      .get();

  if (result.exists) {
    cp_token = (result.data() as Map<String, dynamic>)?['token'];
  } else {
    print('Document does not exist on the database');
  }

  final String accessToken = await getAccessToken(); // Get the access token
  final String fcmEndpoint = 'https://fcm.googleapis.com/v1/projects/elderring-9e5f6/messages:send'; // Corrected URL
  final String? currentFCMToken = cp_token;

  if (currentFCMToken == null) {
    print('Failed to get FCM token');
    return;
  }

  print("FCM Token: $currentFCMToken");

  final String time = DateTime.now().toIso8601String(); // Add this line

  final Map<String, dynamic> message = {
    'message': {
      'token': currentFCMToken,
      'notification': {
        'body': 'SOS Button has been pressed at time: $time !!',
        'title': 'SOS Notification'
      },
      'data': {
        'type': 'SOS',
        'time': DateTime.now().toIso8601String(), // Add this line
        'current_user_fcm_token': currentFCMToken,
      },
    }
  };

  final http.Response response = await http.post(
    Uri.parse(fcmEndpoint),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    },
    body: jsonEncode(message),
  );

  if (response.statusCode == 200) {
    print('FCM message sent successfully');
  } else {
    print('Failed to send FCM message: ${response.statusCode}');
    print('Response body: ${response.body}');
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final onClickNotification = BehaviorSubject<String>();

  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/logo');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: (int id, String? title, String? body,
                String? payload) async {});

    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap);
  }

  static Future<void> showSimpleNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channelId', 'channelName',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }

  static Future<void> showScheduledNotification({
    required String title,
    required String body,
    String? payload,
    required DateTime scheduledTime,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
            android: AndroidNotificationDetails('channelId', 'channelName',
                channelDescription: 'your channel description',
                importance: Importance.max,
                priority: Priority.high,
                ticker: 'ticker')),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload);
  }

  static Future<void> createMedicineNotification(
      String medicineName, TimeOfDay startTime, int intervalInHours) async {
    debugPrint('createMedicineNotification called at ${DateTime.now()}');
    debugPrint('Medicine Name: $medicineName');
    debugPrint('Start Time: $startTime');
    debugPrint('Interval in Hours: $intervalInHours');

    final now = DateTime.now();
    final startDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      startTime.hour,
      startTime.minute,
    );

    final initialNotificationTime = startDateTime.isBefore(now)
        ? startDateTime.add(Duration(days: 1))
        : startDateTime;

    debugPrint('Initial Notification Time: $initialNotificationTime');

    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channelId', 'channelName',
            channelDescription: 'Reminds user of taking medicine',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Time to take medicine',
      'It\'s time to take your medicine: $medicineName',
      tz.TZDateTime.from(initialNotificationTime, tz.local),
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: medicineName,
    );

    debugPrint('Initial notification scheduled at ${DateTime.now()}');

    for (int i = 1; i <= 3; i++) {
      final nextNotificationTime =
          initialNotificationTime.add(Duration(hours: intervalInHours * i));
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Time to take medicine',
        'It\'s time to take your medicine: $medicineName',
        tz.TZDateTime.from(nextNotificationTime, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: medicineName,
      );

      debugPrint('Notification $i scheduled at $nextNotificationTime');
    }

    Fluttertoast.showToast(
      msg:
          "Medicine notifications for $medicineName created successfully at ${startTime.hour}:${startTime.minute}",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xFF2798E4),
      textColor: Colors.white,
      fontSize: 16.0,
    );

    debugPrint(
        'Medicine notifications created successfully at ${DateTime.now()}');
  }
}

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

Future<void> CreateMedicineNotification(
    String medicineName, TimeOfDay startTime, int interval) async {
  DateTime startDateTime = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, startTime.hour, startTime.minute, 0, 0);

  AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: createUniqueId(),
        channelKey: 'basic_channel',
        title: 'Medicine Reminder',
        body: 'Time to take your $medicineName!',
        notificationLayout: NotificationLayout.Default,
        payload: {
          "navigate": "true",
          "medicineName": medicineName,
          "time": startDateTime.toIso8601String(),
        },
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'TAKE_MEDICINE',
          label: 'Take Medicine',
        ),
      ],
      schedule: NotificationInterval(
        interval: interval,
        timeZone: DateTime.now().timeZoneName,
        repeats: true,
      ));

  // Calculate the DateTime when the first notification will be shown
  DateTime firstNotificationTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      startTime.hour,
      startTime.minute,
      0,
      0);

  // Prepare the message
  String message =
      'Scheduled a $medicineName reminder for ${firstNotificationTime.toString()} with an interval of $interval minutes.';

  // Display a message with the time and date when the first notification will be shown
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.blue,
    textColor: Colors.white,
    fontSize: 16.0,
  );

  // Print the message to the terminal
  print(message);
}

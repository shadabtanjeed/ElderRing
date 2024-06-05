import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

int createUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}

Future<void> CreateMedicineNotification(
    String medicineName, TimeOfDay startTime, int intervalInHours) async {
  print('CreateMedicineNotification called with:');
  print('medicineName: $medicineName');
  print('startTime: $startTime');
  print('intervalInHours: $intervalInHours');

  DateTime now = DateTime.now();
  DateTime startDateTime = DateTime(
    now.year,
    now.month,
    now.day,
    startTime.hour,
    startTime.minute,
  );

  // If the start time is before now, schedule it for the next day
  if (startDateTime.isBefore(now)) {
    startDateTime = startDateTime.add(Duration(days: 1));
  }

  print('Scheduling first notification at: $startDateTime');
  print('Interval: $intervalInHours hours');

  // Prepare the message
  String message =
      'Scheduled a $medicineName reminder for ${startDateTime.toString()} with an interval of $intervalInHours hours.';

  for (int i = 0; i < 3; i++) {
    // Limit the number of notifications to 3 intervals
    // Schedule the notification at the specified start time
    bool createdNotification = await AwesomeNotifications().createNotification(
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
      schedule: NotificationCalendar.fromDate(
        date: startDateTime,
        repeats: false,
      ),
    );

    if (!createdNotification) {
      print('Failed to create notification');
    } else {
      print('Notification created successfully');
    }

    startDateTime = startDateTime.add(Duration(hours: intervalInHours));
  }

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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationResponder extends StatelessWidget {
  final String medicineName;
  final DateTime time;

  NotificationResponder({required this.medicineName, required this.time});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Reminder'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Did you take $medicineName on ${time.toString()}?',
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle 'Yes' button press
                  },
                  icon: Icon(Icons.check),
                  label: Text('Yes'),
                ),
                SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle 'No' button press
                  },
                  icon: Icon(Icons.close),
                  label: Text('No'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class MedicineMissResponder extends StatelessWidget {
  final String time;
  final String medicineName;

  MedicineMissResponder({required this.time, required this.medicineName});

  @override
  Widget build(BuildContext context) {
    DateTime parsedTime = DateTime.parse(time);
    String formattedTime = DateFormat('yyyy-MM-dd – kk:mm:ss').format(parsedTime);

    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Miss Notification'),
        backgroundColor: Color(0xFF006769), // Color theme from CareProviderHomePage
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Your associated elder has missed $medicineName at time: $formattedTime',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              Text(
                'Please check on your elderly.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Color(0xFF006769)), // Color theme from CareProviderHomePage
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                child: Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
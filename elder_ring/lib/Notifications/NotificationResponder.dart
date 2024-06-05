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
        backgroundColor: Color(0xFF2798E4),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          // Add margins on the two sides
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Did you take $medicineName on ${time.toString()}?',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center, // Align the text in the center
              ),
              SizedBox(height: 20),
              // Add some space between the text and the buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // Space the buttons evenly
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle 'Yes' button press
                      //navigate to MedicineSchedulePage
                      Navigator.pushNamed(context, '/MedicineSchedulePage');
                    },
                    icon: Icon(Icons.check),
                    label: Text('Yes'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF2798E4), // Set the text color
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      // Handle 'No' button press
                      Navigator.pushNamed(context, '/MedicineSchedulePage');
                    },
                    icon: Icon(Icons.close),
                    label: Text('No'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF2798E4), // Set the text color
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

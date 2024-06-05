import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NotificationResponder extends StatefulWidget {
  final String medicineName;
  final DateTime time;

  NotificationResponder({required this.medicineName, required this.time});

  @override
  _NotificationResponderState createState() => _NotificationResponderState();
}

class _NotificationResponderState extends State<NotificationResponder> {
  String emoji = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Medicine Reminder',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Color(0xFF2798E4),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Did you take ${widget.medicineName} on ${widget.time.toString()}?',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                emoji,
                style: TextStyle(fontSize: 50),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        emoji = '😊'; // Happy emoji
                      });
                      Navigator.pushNamed(context, '/MedicineSchedulePage');
                    },
                    icon: Icon(Icons.check),
                    label: Text('Yes'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF2798E4),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        emoji = '😞'; // Sad emoji
                      });
                      Navigator.pushNamed(context, '/MedicineSchedulePage');
                    },
                    icon: Icon(Icons.close),
                    label: Text('No'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF2798E4),
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

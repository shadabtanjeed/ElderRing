import 'package:elder_ring/Notifications/global_notifications.dart';
import 'package:elder_ring/elder_home_page.dart';
import 'package:elder_ring/login_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../Users/users.dart';
import '../Medication Reminder/medication_schedule.dart';

class NotificationResponderPage extends StatefulWidget {
  final String payload;
  final String medicineName;
  final String time;

  const NotificationResponderPage({
    Key? key,
    required this.payload,
    required this.medicineName,
    required this.time,
  }) : super(key: key);

  @override
  _NotificationResponderPageState createState() => _NotificationResponderPageState();
}

class _NotificationResponderPageState extends State<NotificationResponderPage> {
  String emoji = '';
  String username = Users.getLoginUser();

  @override
  Widget build(BuildContext context) {
    DateTime parsedTime = DateTime.parse(widget.time);

    // Format the DateTime object
    String formattedTime = DateFormat('h:mm a, d MMMM y').format(parsedTime);

    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MedicationSchedule(username: LoggedInUser),
          ),
        );
        return false;
      },
      child: Scaffold(
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
                  'Did you take ${widget.medicineName} on $formattedTime?',
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
                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ElderHomePage(username: LoggedInUser),
                            ),
                          );
                        });
                      },
                      icon: Icon(Icons.check),
                      label: Text('Yes'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF2798E4),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        setState(() {
                          emoji = '😞'; // Sad emoji
                        });
                        await sendMedicineMissNotification(widget.medicineName, widget.time);
                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ElderHomePage(username: LoggedInUser),
                            ),
                          );
                        });
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
      ),
    );
  }
}

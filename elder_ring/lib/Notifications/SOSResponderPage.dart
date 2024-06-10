import 'package:flutter/material.dart';

class SOSResponderPage extends StatelessWidget {
  final String time;

  SOSResponderPage({required this.time});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SOS Alert'),
        backgroundColor: Color(0xFF006769), // Color theme from CareProviderHomePage
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Your associated elder has pressed the SOS button at time: $time',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              Text(
                'Please respond as soon as possible',
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
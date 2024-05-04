import 'package:flutter/material.dart';

class MedicationSchedule extends StatefulWidget {
  const MedicationSchedule({Key? key}) : super(key: key);

  @override
  State<MedicationSchedule> createState() => _MedicationScheduleState();
}

class _MedicationScheduleState extends State<MedicationSchedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: const Text(
            'Medication Schedule',
            style: TextStyle(
                color: Colors.white,
                fontWeight:
                    FontWeight.w600), // Set the color to white and make it bold
          ),
        ),
        backgroundColor: Color(0xFF2798E4),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          // Set the back button color to white
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Handle button press
              },
              child: const Text('Add Medication'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle button press
              },
              child: const Text('View Medication'),
            ),
          ],
        ),
      ),
    );
  }
}

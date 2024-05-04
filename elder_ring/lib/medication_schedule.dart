import 'package:flutter/material.dart';
import 'package:elder_ring/add_new_medicine.dart';

class MedicationSchedule extends StatefulWidget {
  const MedicationSchedule({super.key});

  @override
  State<MedicationSchedule> createState() => _MedicationScheduleState();
}

class _MedicationScheduleState extends State<MedicationSchedule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Medication Schedule',
          style: TextStyle(
              color: Colors.white,
              fontWeight:
                  FontWeight.w600), // Set the color to white and make it bold
        ),
        backgroundColor: const Color(0xFF2798E4),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          // Set the back button color to white
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: const Center(
        child: Column(),
      ),
      floatingActionButton: Container(
        width: 75.0, // Set your desired width
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      const AddMedicine()), // Navigating to MedicationSchedule
            );
          },
          backgroundColor: const Color(0xFF2798E4),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: Colors.white),
              Text('Add',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

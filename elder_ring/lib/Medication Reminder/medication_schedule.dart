import 'package:flutter/material.dart';
import 'package:elder_ring/Medication%20Reminder/add_new_medicine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'medicine_database.dart';

class MedicationSchedule extends StatefulWidget {
  const MedicationSchedule({Key? key}) : super(key: key);

  @override
  State<MedicationSchedule> createState() => _MedicationScheduleState();
}

class _MedicationScheduleState extends State<MedicationSchedule> {
  Stream<QuerySnapshot>? MedicineInfoStream;

  @override
  void initState() {
    super.initState();
    MedicineInfoStream =
        FirebaseFirestore.instance.collection('medicine_schedule').snapshots();
  }

  Widget allMedicineDetails() {
    return StreamBuilder<QuerySnapshot>(
      stream: MedicineInfoStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // Check if snapshot.data is not null before using it
        if (snapshot.data != null) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data!.docs[index];
              // You can now use 'ds' to access the data in this document
              return Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ds['medicine_name'],
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2798E4)))("Dosage: " + ds['medicine_dosage'],,
                            Text
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600)),
                        Text("Interval: " + ds['interval'].toString(),
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600)),
                        Text(
                            ds['is_after_eating']
                                ? "After Meal"
                                : "Before Meal",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return Text('No data');
        }
      },
    );
  }

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
      body: Container(
        margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: allMedicineDetails(),
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

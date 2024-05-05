import 'package:flutter/material.dart';
import 'package:elder_ring/Medication%20Reminder/add_new_medicine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'medicine_database.dart';
import 'package:intl/intl.dart';

class MedicationSchedule extends StatefulWidget {
  const MedicationSchedule({super.key});

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
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data != null) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot ds = snapshot.data!.docs[index];
              String medicineType = ds['medicine_type'];
              String imagePath;
              switch (medicineType) {
                case 'Tablet':
                  imagePath = 'Resources/tablet.png';
                  break;
                case 'Syrup':
                  imagePath = 'Resources/syrup.png';
                  break;
                case 'Injections':
                  imagePath = 'Resources/injection.png';
                  break;
                default:
                  imagePath = 'Resources/tablet.png'; // default image
              }

              // Get the current time
              DateTime currentTime = DateTime.now();

              // Get the start_time from the database and convert it to DateTime
              DateTime startTime = (ds['start_time'] as Timestamp).toDate();

              // Get the interval from the database
              int interval = ds['interval'];

              // Calculate the next dose time
              DateTime nextDoseTime = startTime;
              if (interval > 0) {
                while (nextDoseTime.isBefore(currentTime)) {
                  nextDoseTime = nextDoseTime.add(Duration(hours: interval));
                }
              } else {
                // Handle the case where interval is not greater than 0
                // For example, you could set nextDoseTime to currentTime
                nextDoseTime = currentTime;
              }

              // Calculate the remaining time for the next dose
              Duration remainingTime = nextDoseTime.difference(currentTime);

              // Format the remaining time as a string
              String remainingTimeString = DateFormat('HH:mm').format(DateTime(
                  0,
                  0,
                  0,
                  remainingTime.inHours,
                  remainingTime.inMinutes.remainder(60)));

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
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),
                          // adjust the value as needed
                          child: Image.asset(
                            imagePath,
                            width: 50, // adjust the size as needed
                            height: 50, // adjust the size as needed
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ds['medicine_name'],
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2798E4))),
                              Text("Dosage: " + ds['medicine_dosage'],
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600)),
                              Text(
                                  "Interval (in hrs): " +
                                      ds['interval'].toString(),
                                  style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500)),
                              Text("Next Dose: " + remainingTimeString,
                                  style: const TextStyle(
                                    fontSize: 18, // increased font size
                                    fontWeight: FontWeight.w600, // made it bold
                                    color: Color(
                                        0xFFD70040), // changed color to red
                                  )),
                              Text(
                                  ds['is_after_eating']
                                      ? "After Meal"
                                      : "Before Meal",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: ds['is_after_eating']
                                          ? const Color(0xFF097969)
                                          : const Color(0xFFE97451))),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit,
                                  color: Color(0xFF2798E4)),
                              onPressed: () {
                                // Add your edit functionality here
                              },
                            ),
                            const SizedBox(width: 1),
                            // adjust the width as needed to change the spacing
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Color(0xFFD70040)),
                              onPressed: () {
                                // Add your delete functionality here
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else {
          return const Text('No data');
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF2798E4),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 30, left: 20, right: 20),
        child: allMedicineDetails(),
      ),
      floatingActionButton: Container(
        width: 75.0,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddMedicine()),
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

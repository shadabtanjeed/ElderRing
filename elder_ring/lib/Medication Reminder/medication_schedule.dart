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
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2798E4))),
                              Text("Dosage: " + ds['medicine_dosage'],
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600)),
                              Text("Interval: " + ds['interval'].toString(),
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600)),
                              Text(
                                  ds['is_after_eating']
                                      ? "After Meal"
                                      : "Before Meal",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: ds['is_after_eating']
                                          ? Color(0xFF097969)
                                          : Color(0xFFD70040))),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Color(0xFF2798E4)),
                              onPressed: () {
                                // Add your edit functionality here
                              },
                            ),
                            SizedBox(width: 1),
                            // adjust the width as needed to change the spacing
                            IconButton(
                              icon:
                                  Icon(Icons.delete, color: Color(0xFFD70040)),
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

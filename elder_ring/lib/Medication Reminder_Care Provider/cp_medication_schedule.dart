import 'package:elder_ring/Medication%20Reminder/update_medicine.dart';
import 'package:flutter/material.dart';
import 'package:elder_ring/Medication%20Reminder/add_new_medicine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../care_provider_home_page.dart';
import 'cp_add_new_medicine.dart';
import 'cp_update_medicine.dart';
import 'medicine_database.dart';
import 'package:intl/intl.dart';
import 'package:elder_ring/elder_home_page.dart';

class CareProviderMedicationSchedule extends StatefulWidget {
  final String elder_username;
  final String username;

  const CareProviderMedicationSchedule(
      {Key? key, required this.username, required this.elder_username})
      : super(key: key);

  @override
  State<CareProviderMedicationSchedule> createState() =>
      _CareProviderMedicationScheduleState();
}

class _CareProviderMedicationScheduleState
    extends State<CareProviderMedicationSchedule> {
  String elder_username = '';
  String username = '';
  Stream<QuerySnapshot>? MedicineInfoStream;

  @override
  void initState() {
    super.initState();
    elder_username = widget.elder_username;
    username = widget.username;
    MedicineInfoStream =
        FirebaseFirestore.instance.collection('medicine_schedule').snapshots();

    fetchUserMedicine();
  }

  Future<void> fetchUserMedicine() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('medicine_schedule')
        .where('username', isEqualTo: elder_username)
        .get();
    final documents = snapshot.docs;
    if (documents.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Error: The user does not have any medicine added yet');
    }
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
            child: CircularProgressIndicator(
              color: Color(0xFF006769),
            ),
          );
        }

        final List<QueryDocumentSnapshot> userMedicineDocs = snapshot.data!.docs
            .where((doc) => doc['username'] == elder_username)
            .toList();

        if (userMedicineDocs.isEmpty) {
          return const Center(
            child: Text('No medicine added yet for this user'),
          );
        }

        bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
        return ListView.builder(
          itemCount: userMedicineDocs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = userMedicineDocs[index];
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
                    color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
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
                                    color: isDarkMode
                                        ? Colors.white
                                        : Color(0xFF006769))),
                            Text("Dosage: " + ds['medicine_dosage'],
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black)),
                            Text(
                                "Interval (in hrs): " +
                                    ds['interval'].toString(),
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black)),
                            Text("Next Dose: " + remainingTimeString,
                                style: TextStyle(
                                  fontSize: 18, // increased font size
                                  fontWeight: FontWeight.w600, // made it bold
                                  color: isDarkMode
                                      ? Colors.white
                                      : Color(
                                          0xFFD70040), // changed color to red
                                )),
                            Text(
                                ds['is_after_eating']
                                    ? "After Meal"
                                    : "Before Meal",
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: isDarkMode
                                        ? Colors.white
                                        : ds['is_after_eating']
                                            ? const Color(0xFF097969)
                                            : const Color(0xFFE97451))),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit,
                                color: isDarkMode
                                    ? Colors.white
                                    : Color(0xFF006769)),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        CareProviderUpdateMedicine(
                                            medicineId: ds.id,
                                            username: username,
                                            elder_username: elder_username)),
                              );
                            },
                          ),
                          const SizedBox(width: 1),
                          // adjust the width as needed to change the spacing
                          IconButton(
                            icon: Icon(Icons.delete,
                                color: isDarkMode
                                    ? Colors.white
                                    : Color(0xFFD70040)),
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Confirm Deletion'),
                                    content: const Text(
                                        'Are you sure you want to delete this medicine?'),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Cancel'),
                                        style: TextButton.styleFrom(
                                            foregroundColor: isDarkMode
                                                ? Colors.white
                                                : Colors.black),
                                        // Change color here
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('Delete'),
                                        style: TextButton.styleFrom(
                                            foregroundColor: isDarkMode
                                                ? Colors.white
                                                : Colors.black),
                                        // Change color here
                                        onPressed: () async {
                                          Navigator.of(context)
                                              .pop(); // Move this line to here
                                          await DatabaseMethods()
                                              .deleteMedicineData(ds.id);
                                          Fluttertoast.showToast(
                                              msg:
                                                  "Medicine Deleted Successfully",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                                  Color(0xFF006769),
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
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
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => CareProviderHomePage(
                    username: username,
                  )),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Medication Schedule',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          backgroundColor: const Color(0xFF006769),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => CareProviderHomePage(
                        username: username,
                      )),
            ),
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
                MaterialPageRoute(
                    builder: (context) => CareProviderAddMedicine(
                          username: username,
                          elder_username: elder_username,
                        )),
              );
            },
            backgroundColor: const Color(0xFF006769),
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
      ),
    );
  }
}

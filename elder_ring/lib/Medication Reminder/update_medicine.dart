import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'medicine_database.dart';
import 'medication_schedule.dart';

class UpdateMedicine extends StatefulWidget {
  const UpdateMedicine({Key? key}) : super(key: key);

  @override
  State<UpdateMedicine> createState() => _UpdateMedicineState();
}

class _UpdateMedicineState extends State<UpdateMedicine> {
  String medicineType = 'Tablet';
  bool isAfterEating = false;
  TextEditingController intervalController = TextEditingController();
  TextEditingController medicineDosageController = TextEditingController();
  TextEditingController medicineNameController = TextEditingController();
  TextEditingController medicineTypeController = TextEditingController();
  TimeOfDay startTime = TimeOfDay.now();
  bool isLoading = false; // Add this line

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    intervalController.dispose();
    medicineDosageController.dispose();
    medicineNameController.dispose();
    medicineTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Add new medicine',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF2798E4),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          Container(
            margin: const EdgeInsets.all(20.0),
            child: ListView(
              children: [
                _buildTextField("Medicine Name:", 'Enter medicine name',
                    TextInputType.text, medicineNameController),
                const SizedBox(height: 20.0),
                _buildTextField("Medicine Dosage:", 'Enter medicine dosage',
                    TextInputType.text, medicineDosageController),
                const SizedBox(height: 20.0),
                const Text("Medicine Type:",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2798E4))),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMedicineTypeTile('Tablet', 'Resources/tablet.png'),
                    _buildMedicineTypeTile('Syrup', 'Resources/syrup.png'),
                    _buildMedicineTypeTile(
                        'Injection', 'Resources/injection.png'),
                  ],
                ),
                const SizedBox(height: 20.0),
                const Text("Medicine Timing:",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2798E4))),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMealTimeTile('Before Meal'),
                    _buildMealTimeTile('After Meal'),
                  ],
                ),
                const SizedBox(height: 20.0),
                _buildTextField(
                    "Interval (in hours):",
                    'Enter interval in hours',
                    TextInputType.number,
                    intervalController),
                const SizedBox(height: 20.0),
                const Text("Start Time:",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2798E4))),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: _pickTime,
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF2798E4)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: Text('Select Start Time'),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    await UpdateMedicine();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF2798E4)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: const Text(
                    'Update Medicine',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isLoading) // Add this line
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF2798E4),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, String hint, TextInputType inputType,
      TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2798E4))),
        const SizedBox(height: 10.0),
        Container(
          padding: const EdgeInsets.only(left: 10.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: const Color(0xFF2798E4))),
          child: TextField(
            controller: controller,
            keyboardType: inputType,
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: TextStyle(color: Colors.grey)),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicineTypeTile(String type, String imagePath) {
    return GestureDetector(
      onTap: () {
        setState(() {
          medicineType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: medicineType == type ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: const Color(0xFF2798E4)),
        ),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              width: 50, // you can adjust the size as needed
              height: 50, // you can adjust the size as needed
            ),
            Text(
              type,
              style: TextStyle(
                color: medicineType == type ? Colors.white : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTimeTile(String time) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isAfterEating = time == 'After Meal';
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: isAfterEating == (time == 'After Meal')
              ? Colors.blue
              : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: const Color(0xFF2798E4)),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isAfterEating == (time == 'After Meal')
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selectedTime != null) {
      setState(() {
        startTime = selectedTime;
      });
    }
  }

  Future<void> UpdateMedicine() async {
    setState(() {
      isLoading = true; // Add this line
    });

    String medicineId = randomAlphaNumeric(10);
    DatabaseMethods dbMethods = DatabaseMethods();

    // Create a DateTime object using the current date and the hour and minute from startTime
    DateTime startDateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      startTime.hour,
      startTime.minute,
    );

    // Convert the DateTime object to a Timestamp
    Timestamp startTimeStamp = Timestamp.fromDate(startDateTime);

    Map<String, dynamic> medicineInfoMap = {
      "medicine_name": medicineNameController.text,
      "medicine_dosage": medicineDosageController.text,
      "medicine_type": medicineType,
      "is_after_eating": isAfterEating,
      "interval": int.parse(intervalController.text),
      "start_time": startTimeStamp, // Store the Timestamp in Firestore
      "medicine_id": medicineId,
    };

    await dbMethods.UpdateMedicineInfo(medicineInfoMap, medicineId)
        .then((value) {
      Fluttertoast.showToast(
          msg: "Medicine Details Updated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xFF2798E4),
          textColor: Colors.white,
          fontSize: 16.0);
    });

    setState(() {
      isLoading = false; // Add this line
    });

    // Navigate to the MedicationSchedule page after a delay
    Future.delayed(Duration(seconds: 1), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MedicationSchedule()),
      );
    });
  }
}

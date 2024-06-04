import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'medicine_database.dart';
import 'medication_schedule.dart';

class UpdateMedicine extends StatefulWidget {
  final String medicineId;
  final String username;

  const UpdateMedicine(
      {Key? key, required this.medicineId, required this.username})
      : super(key: key);

  @override
  State<UpdateMedicine> createState() => _UpdateMedicineState();
}

class _UpdateMedicineState extends State<UpdateMedicine> {
  String username = '';
  String medicineType = 'Tablet';
  bool isAfterEating = false;
  TextEditingController intervalController = TextEditingController();
  TextEditingController medicineDosageController = TextEditingController();
  TextEditingController medicineNameController = TextEditingController();
  TextEditingController medicineTypeController = TextEditingController();
  TimeOfDay startTime = TimeOfDay.now();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    username = widget.username;
    fetchMedicineData();
  }

  Future<void> fetchMedicineData() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('medicine_schedule')
        .doc(widget.medicineId)
        .get();

    setState(() {
      medicineNameController.text = ds['medicine_name'];
      medicineDosageController.text = ds['medicine_dosage'];
      medicineType = ds['medicine_type'];
      isAfterEating = ds['is_after_eating'];
      intervalController.text = ds['interval'].toString();
      startTime =
          TimeOfDay.fromDateTime((ds['start_time'] as Timestamp).toDate());
    });
  }

  @override
  void dispose() {
    intervalController.dispose();
    medicineDosageController.dispose();
    medicineNameController.dispose();
    medicineTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Update medicine',
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
                    await UpdateMedicine(widget.medicineId);
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
          if (isLoading)
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
                hintStyle: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.grey)),
          ),
        ),
      ],
    );
  }

  Widget _buildMedicineTypeTile(String type, String imagePath) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        setState(() {
          medicineType = type;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: medicineType == type
              ? Colors.blue
              : isDarkMode
                  ? Colors.grey[800]
                  : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: const Color(0xFF2798E4)),
        ),
        child: Column(
          children: [
            Image.asset(
              imagePath,
              width: 50,
              height: 50,
            ),
            Text(
              type,
              style: TextStyle(
                color: medicineType == type
                    ? Colors.white
                    : isDarkMode
                        ? Colors.white
                        : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTimeTile(String time) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
              : isDarkMode
                  ? Colors.grey[800]
                  : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: const Color(0xFF2798E4)),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isAfterEating == (time == 'After Meal')
                ? Colors.white
                : isDarkMode
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

  Future<void> UpdateMedicine(String medicineId) async {
    setState(() {
      isLoading = true;
    });

    DatabaseMethods dbMethods = DatabaseMethods();

    DateTime startDateTime = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      startTime.hour,
      startTime.minute,
    );

    Timestamp startTimeStamp = Timestamp.fromDate(startDateTime);

    Map<String, dynamic> medicineInfoMap = {
      "medicine_name": medicineNameController.text,
      "medicine_dosage": medicineDosageController.text,
      "medicine_type": medicineType,
      "is_after_eating": isAfterEating,
      "interval": int.parse(intervalController.text),
      "start_time": startTimeStamp,
      "medicine_id": medicineId,
      "username": username,
    };

    await dbMethods
        .updateMedicineData(medicineId, medicineInfoMap)
        .then((value) {
      Fluttertoast.showToast(
          msg: "Medicine Details Updated Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color(0xFF2798E4),
          textColor: Colors.white,
          fontSize: 16.0);
    });

    setState(() {
      isLoading = false; // Add this line
    });

    // Navigate to the MedicationSchedule page after a delay
    // Navigate to the MedicationSchedule page after a delay
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MedicationSchedule(username: username)),
      );
    });
  }
}

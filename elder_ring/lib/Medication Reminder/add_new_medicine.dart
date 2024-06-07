import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elder_ring/Notifications/local_notificatiions.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:random_string/random_string.dart';
import 'medicine_database.dart';
import 'medication_schedule.dart';

class AddMedicine extends StatefulWidget {
  final String username;

  const AddMedicine({Key? key, required this.username}) : super(key: key);

  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
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
                    await addMedicine();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xFF2798E4)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  child: const Text(
                    'Add Medicine',
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

  Future<void> addMedicine() async {
    setState(() {
      isLoading = true;
    });

    String medicineId = randomAlphaNumeric(10);
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

    await dbMethods.addMedicineInfo(medicineInfoMap, medicineId).then((value) {
      Fluttertoast.showToast(
          msg: "Medicine Details Added Successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Color(0xFF2798E4),
          textColor: Colors.white,
          fontSize: 16.0);
    });

    await LocalNotifications.createMedicineNotification(
        medicineNameController.text,
        startDateTime,
        int.parse(intervalController.text));

    //await LocalNotifications.showScheduledNotification(title: 'Scheduled Notification', body: 'This is test', scheduledTime: startDateTime);

    setState(() {
      isLoading = false;
    });

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MedicationSchedule(username: username)),
      );
    });
  }
}

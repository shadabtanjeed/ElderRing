import 'package:flutter/material.dart';

class AddMedicine extends StatefulWidget {
  const AddMedicine({Key? key}) : super(key: key);

  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
  String medicineType = 'Tablet';
  String mealTime = 'Before Eating';
  int interval = 1;
  TimeOfDay startTime = TimeOfDay.now();

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
      body: Container(
        margin: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildTextField(
                "Medicine Name:", 'Enter medicine name', TextInputType.text),
            const SizedBox(height: 20.0),
            _buildTextField("Medicine Dosage:", 'Enter medicine dosage',
                TextInputType.text),
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
                _buildMedicineTypeTile('Tablet'),
                _buildMedicineTypeTile('Syrup'),
                _buildMedicineTypeTile('Injection'),
              ],
            ),
            const SizedBox(height: 20.0),
            const Text("Meal Time:",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2798E4))),
            const SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMealTimeTile('Before Eating'),
                _buildMealTimeTile('After Eating'),
              ],
            ),
            const SizedBox(height: 20.0),
            _buildTextField("Interval (in hours):", 'Enter interval in hours',
                TextInputType.number),
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
              onPressed: () {
                // Handle add medicine button press
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
    );
  }

  Widget _buildTextField(String label, String hint, TextInputType inputType) {
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

  Widget _buildMedicineTypeTile(String type) {
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
        child: Text(
          type,
          style: TextStyle(
            color: medicineType == type ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildMealTimeTile(String time) {
    return GestureDetector(
      onTap: () {
        setState(() {
          mealTime = time;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: mealTime == time ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: const Color(0xFF2798E4)),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: mealTime == time ? Colors.white : Colors.black,
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
}

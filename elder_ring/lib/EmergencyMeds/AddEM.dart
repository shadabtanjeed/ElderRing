import 'package:flutter/material.dart';
import 'package:elder_ring/EmergencyMeds/EMDBHander.dart';

class AddEntryPage extends StatefulWidget {
  @override
  _AddEntryPageState createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  List<String> _steps = [''];
  static const entryPageColor = Color(0xFF006769);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Entry',
          style: TextStyle(
            fontFamily: 'Jost',
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _title = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            ..._steps.map((step) {
              int index = _steps.indexOf(step);
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Step ${index + 1}',
                          labelStyle: const TextStyle(
                            fontFamily: 'Jost',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _steps[index] = value;
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a step';
                          }
                          return null;
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          _steps.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
            Row(
              children: [
                const Expanded(child: SizedBox.shrink()),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      _steps.add('');
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  bool result = await Emdb().addEMSteps(_title, _steps);
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Entry Status'),
                        content: Text(result
                            ? 'Entry added successfully'
                            : 'Failed to add entry'),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              if (result) {
                                Navigator.pop(context);
                              }
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: entryPageColor, // consistent color
                textStyle: const TextStyle(
                  fontFamily: 'Jost',
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: const Text('Add Entry'),
            ),
          ],
        ),
      ),
    );
  }
}
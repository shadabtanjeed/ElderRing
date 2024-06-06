import 'package:flutter/material.dart';
import 'package:elder_ring/EmergencyMeds/EMDBHander.dart';

class EntryDetailsPage extends StatelessWidget {
  final String docName;
  static const Color entryDetailsPageColor = Color(0xFF006769);

  EntryDetailsPage({required this.docName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          docName,
          style: const TextStyle(
            fontFamily: 'Jost',
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: Emdb().getEMSteps(docName),
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(
                  fontFamily: 'Jost',
                  fontSize: 18,
                  color: Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            );
          } else if (snapshot.hasData) {
            List<String> steps = snapshot.data!['steps'].cast<String>();
            return ListView.builder(
              itemCount: steps.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    'Step ${index + 1}',
                    style: const TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    steps[index],
                    style: const TextStyle(
                      fontFamily: 'Jost',
                      fontSize: 16,
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                'No steps found.',
                style: TextStyle(
                  fontFamily: 'Jost',
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class MaPage extends StatefulWidget {
  const MaPage({super.key});

  @override
  State<MaPage> createState() => _MaPageState();
}

class _MaPageState extends State<MaPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'This is the Map Page!',
              style: TextStyle(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(
                    context); // Navigates back to the previous screen (HomePage)
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

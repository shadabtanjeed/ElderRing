import 'package:flutter/material.dart';
import 'locationServices.dart';
import 'shareLocation.dart';
import 'crudscreen.dart';
import 'getLocation.dart';

class MapMenu extends StatefulWidget {
  const MapMenu({super.key});

  @override
  State<MapMenu> createState() => _MapMenuState();
}

class _MapMenuState extends State<MapMenu> {
  String latitude = '';
  String longitude = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Menu'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                LocationServices().fetchLocation().then((position) {
                  setState(() {
                    latitude = position.latitude.toString();
                    longitude = position.longitude.toString();
                  });
                });
              },
              child: const Text('Fetch Location'),
            ),
            const SizedBox(height: 20),
            Text(
              'Latitude: $latitude',
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              'Longitude: $longitude',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GetLocation()),
                );
              },
              child: const Text('Show Live Location'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ShareLocation()),
                );
              },
              child: const Text('Fire Share'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CrudScreen()),
                );
              },
              child: const Text('CRUDs'),
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

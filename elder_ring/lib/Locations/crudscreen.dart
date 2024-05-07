import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:elder_ring/models/locationObj.dart';

class CrudScreen extends StatefulWidget {
  const CrudScreen({Key? key}) : super(key: key);

  @override
  _CrudScreenState createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  final TextEditingController uniqueIdController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController updatedOnController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CRUD Operations'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: uniqueIdController,
              decoration: InputDecoration(
                labelText: 'Unique ID',
                contentPadding: const EdgeInsets.only(left: 10),
              ),
            ),
            TextField(
              controller: latitudeController,
              decoration: InputDecoration(
                labelText: 'Latitude',
                contentPadding: const EdgeInsets.only(left: 10),
              ),
            ),
            TextField(
              controller: longitudeController,
              decoration: InputDecoration(
                labelText: 'Longitude',
                contentPadding: const EdgeInsets.only(left: 10),
              ),
            ),
            TextField(
              controller: updatedOnController,
              decoration: InputDecoration(
                labelText: 'Last Updated',
                contentPadding: const EdgeInsets.only(left: 10),
              ),
              readOnly: true,
            ),
            ElevatedButton(
              onPressed: () async {
                LocationObj locationObj = LocationObj(
                  unique_id: uniqueIdController.text,
                  position: GeoPoint(
                    double.parse(latitudeController.text),
                    double.parse(longitudeController.text),
                  ),
                  updated_on: DateTime.now(),
                );
                await locationObj.createLocation();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF2798E4)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text('Create'),
            ),
            ElevatedButton(
              onPressed: () async {
                LocationObj locationObj =
                    await LocationObj.readLocation(uniqueIdController.text);
                latitudeController.clear();
                longitudeController.clear();
                updatedOnController.clear();
                latitudeController.text =
                    locationObj.position.latitude.toString();
                longitudeController.text =
                    locationObj.position.longitude.toString();
                updatedOnController.text = locationObj.updated_on.toString();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF2798E4)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text('Read'),
            ),
            ElevatedButton(
              onPressed: () async {
                LocationObj locationObj = LocationObj(
                  unique_id: uniqueIdController.text,
                  position: GeoPoint(
                    double.parse(latitudeController.text),
                    double.parse(longitudeController.text),
                  ),
                  updated_on: DateTime.now(),
                );
                await locationObj.updateLocation(locationObj.position);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF2798E4)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text('Update'),
            ),
            ElevatedButton(
              onPressed: () async {
                LocationObj locationObj = LocationObj(
                  position: const GeoPoint(0, 0),
                  unique_id: uniqueIdController.text,
                  updated_on: DateTime.parse("1865-08-15"),
                );
                await locationObj.deleteLocation();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF2798E4)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}

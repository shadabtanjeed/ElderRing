import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:elder_ring/models/locationObj.dart';
import 'crud.dart';

class CrudScreen extends StatefulWidget {
  @override
  _CrudScreenState createState() => _CrudScreenState();
}

class _CrudScreenState extends State<CrudScreen> {
  final CrudOperations crudOperations = CrudOperations();
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
      body: Column(
        children: [
          TextField(
            controller: uniqueIdController,
            decoration: const InputDecoration(labelText: 'Unique ID'),
          ),
          TextField(
            controller: latitudeController,
            decoration: const InputDecoration(labelText: 'Latitude'),
          ),
          TextField(
            controller: longitudeController,
            decoration: const InputDecoration(labelText: 'Longitude'),
          ),
          TextField(
            controller: updatedOnController,
            decoration: const InputDecoration(labelText: 'Last Updated'),
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
              await crudOperations.createLocation(locationObj);
            },
            child: const Text('Create'),
          ),
          ElevatedButton(
            onPressed: () async {
              LocationObj locationObj =
                  await crudOperations.readLocation(uniqueIdController.text);
              latitudeController.clear();
              longitudeController.clear();
              updatedOnController.clear();
              latitudeController.text =
                  locationObj.position.latitude.toString();
              longitudeController.text =
                  locationObj.position.longitude.toString();
              updatedOnController.text = locationObj.updated_on.toString();
            },
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
              await crudOperations.updateLocation(locationObj);
            },
            child: const Text('Update'),
          ),
          ElevatedButton(
            onPressed: () async {
              await crudOperations.deleteLocation(uniqueIdController.text);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

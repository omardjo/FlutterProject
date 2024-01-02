import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../model/Catastrophee.dart';

class AddCatastropheScreen extends StatefulWidget {
  final Function(Catastrophee) onAdd;

  const AddCatastropheScreen({Key? key, required this.onAdd}) : super(key: key);

  @override
  _AddCatastropheScreenState createState() => _AddCatastropheScreenState();
}

class _AddCatastropheScreenState extends State<AddCatastropheScreen> {
  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _magnitudeController = TextEditingController();
  final TextEditingController _radiusController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter Catastrophe'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titreController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: _typeController,
              decoration: InputDecoration(labelText: 'Type'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            TextField(
              controller: _magnitudeController,
              decoration: InputDecoration(labelText: 'Magnitude'),
            ),
            TextField(
              controller: _radiusController,
              decoration: InputDecoration(labelText: 'Radius'),
            ),
            TextField(
              controller: _latitudeController,
              decoration: InputDecoration(labelText: 'Latitude'),
            ),
            TextField(
              controller: _longitudeController,
              decoration: InputDecoration(labelText: 'Longitude'),
            ),
            ElevatedButton(
              onPressed: _saveCatastrophe,
              child: Text('Save Catastrophe'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveCatastrophe() async {
    // Create a new Catastrophe object with input values
    Catastrophee newCatastrophe = Catastrophee(
      titre: _titreController.text,
      type: _typeController.text,
      description: _descriptionController.text,
      date: DateTime.parse(_dateController.text),
      magnitude: double.parse(_magnitudeController.text),
      radius: double.parse(_radiusController.text),
      latitudeDeCatastrophe: double.parse(_latitudeController.text),
      longitudeDeCatastrophe: double.parse(_longitudeController.text),
      id: 'some_generated_id',
    );

    // Convert Catastrophe object to JSON
    Map<String, dynamic> catastropheJson = newCatastrophe.toJson();

    // Send the new catastrophe to the backend to be saved in the database
    final response = await http.post(
      Uri.parse('http://localhost:9090/catastrophe/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(catastropheJson),
    );

    if (response.statusCode == 200) {
      // Catastrophe successfully added to the database
      print('Catastrophe added successfully');
      // Call the callback to notify the parent screen about the new catastrophe
      widget.onAdd(newCatastrophe);
      // Pop the current screen to go back to the main screen
      Navigator.pop(context);
    } else {
      // Error occurred while saving the catastrophe
      print('Failed to add catastrophe. Status Code: ${response.statusCode}');
      print('Response body: ${response.body}');
      // You may want to handle the error here (e.g., show an error message)
    }
  }
}
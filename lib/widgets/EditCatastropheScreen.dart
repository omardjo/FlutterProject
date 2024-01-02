import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/Catastrophee.dart';

class EditCatastropheScreen extends StatefulWidget {
  final Catastrophee catastrophe;
  final Function() onUpdate;

  const EditCatastropheScreen({
    Key? key,
    required this.catastrophe,
    required this.onUpdate,
  }) : super(key: key);

  @override
  _EditCatastropheScreenState createState() => _EditCatastropheScreenState();
}

class _EditCatastropheScreenState extends State<EditCatastropheScreen> {
  late TextEditingController _titreController;
  late TextEditingController _typeController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late TextEditingController _magnitudeController;
  late TextEditingController _radiusController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  @override
  void initState() {
    super.initState();
    _titreController = TextEditingController(text: widget.catastrophe.titre);
    _typeController = TextEditingController(text: widget.catastrophe.type);
    _descriptionController =
        TextEditingController(text: widget.catastrophe.description);
    _dateController = TextEditingController(
        text: widget.catastrophe.date.toLocal().toString());
    _magnitudeController =
        TextEditingController(text: widget.catastrophe.magnitude.toString());
    _radiusController =
        TextEditingController(text: widget.catastrophe.radius.toString());
    _latitudeController = TextEditingController(
        text: widget.catastrophe.latitudeDeCatastrophe.toString());
    _longitudeController = TextEditingController(
        text: widget.catastrophe.longitudeDeCatastrophe.toString());
  }

  @override
  void dispose() {
    _titreController.dispose();
    _typeController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _magnitudeController.dispose();
    _radiusController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    print("Saving changes...");

    // Create a modified catastrophe object
    final modifiedCatastrophe = Catastrophee(
      id: widget.catastrophe.id,
      titre: _titreController.text,
      type: _typeController.text,
      description: _descriptionController.text,
      date: DateTime.parse(_dateController.text),
      magnitude: double.parse(_magnitudeController.text),
      radius: double.parse(_radiusController.text),
      latitudeDeCatastrophe: double.parse(_latitudeController.text),
      longitudeDeCatastrophe: double.parse(_longitudeController.text),
    );

    // Prepare the URL, headers, and request body
    final url = 'http://localhost:9090/catastrophe/${modifiedCatastrophe.id}';
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode(modifiedCatastrophe);

    print("Request URL: $url");
    print("Request Body: $body");

    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(width: 16),
              Text("Saving changes..."),
            ],
          ),
        ),
      );

      // Send the PUT request to update the catastrophe
      final response =
          await http.put(Uri.parse(url), headers: headers, body: body);

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // Check the response status code
      if (response.statusCode == 200) {
        // Successful update
        widget
            .onUpdate(); // Call the onUpdate callback to update the data table
        Navigator.pop(context); // Pop the current screen
      } else {
        // Error handling
        print('Failed to update catastrophe: ${response.statusCode}');
        // Show error message in a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text("Failed to update catastrophe: ${response.statusCode}"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Exception handling
      print('Exception during update: $e');
      // Show error message in a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("An error occurred during the update."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Catastrophe'),
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
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveChanges,
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
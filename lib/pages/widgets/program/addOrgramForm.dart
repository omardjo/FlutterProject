

import 'package:flutter/material.dart';
import 'package:safeguard/model/program.dart';
import 'package:image_picker/image_picker.dart';
import '../../../model/program.dart';

class AddProgramForm extends StatefulWidget {
  final Function(Program) onAdd;
  final Function(Program) onUpdate;
  final Program? programToEdit;

  AddProgramForm({
    required this.onAdd,
    required this.onUpdate,
    this.programToEdit,
  });

  @override
  _AddProgramState createState() => _AddProgramState();
}

class _AddProgramState extends State<AddProgramForm> {
  TextEditingController _Titre = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _cours = TextEditingController();
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();

   
    if (widget.programToEdit != null) {
      _Titre.text = widget.programToEdit!.titre;
      _description.text = widget.programToEdit!.descriptionProgramme;
      _cours.text = widget.programToEdit!.cours.join(', ');
      _selectedImagePath = widget.programToEdit!.image;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter ou éditer un programme'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _Titre,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            TextFormField(
              controller: _description,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextFormField(
              controller: _cours,
              decoration: InputDecoration(
                  labelText: 'Cours (séparés par des virgules)'),
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Sélectionner une image'),
            ),
            _selectedImagePath != null
                ? Text('Image URL: $_selectedImagePath')
                : Container(),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String titre = _Titre.text;
                String description = _description.text;
                List<String> cours = _cours.text.split(',');

                if (_selectedImagePath != null) {
                  Program nouveauProgramme = Program(
                    id: widget.programToEdit?.id ??
                        '', 
                    titre: titre,
                    descriptionProgramme: description,
                    cours: cours,
                    image: _selectedImagePath!,
                  );

                  if (widget.programToEdit != null) {
                    widget.onUpdate(nouveauProgramme);
                  } else {
                    widget.onAdd(nouveauProgramme);
                  }

                  Navigator.pop(context); 
                } else {
                  print('Veuillez sélectionner une image.');
                }
              },
              child: Text(
                  widget.programToEdit != null ? 'Mettre à jour' : 'Ajouter'),
            ),
          ],
        ),
      ),
    );
  }
}
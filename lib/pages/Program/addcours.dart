
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../model/cours.dart';

class AddCours extends StatefulWidget {
  final Function(CoursProgramme) onAjouter;
  final CoursProgramme? cours;

  AddCours({required this.onAjouter, this.cours});

  @override
  _AddCoursState createState() => _AddCoursState();
}

class _AddCoursState extends State<AddCours> {
  TextEditingController _typeController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  String? _selectedImagePath;

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
  void initState() {
    super.initState();

    if (widget.cours != null) {
      _typeController.text = widget.cours!.Type;
      _descriptionController.text = widget.cours!.description;
      _selectedImagePath = widget.cours!.image;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cours == null
            ? 'Ajouter un nouveau cours'
            : 'Modifier le cours'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _typeController,
              decoration: InputDecoration(labelText: 'Type'),
            ),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Sélectionner une image'),
            ),
_selectedImagePath != null
  ? Image.network(
      _selectedImagePath!,
      width: 100,
      height: 100,
    )
  : Container(),

            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String type = _typeController.text;
                String description = _descriptionController.text;

                if (widget.cours == null) {
                  
                  CoursProgramme nouveauCoursProgramme = CoursProgramme(
                    id: '',
                    Type: type,
                    description: description,
                    image: _selectedImagePath ?? '',
                  );

                  widget.onAjouter(nouveauCoursProgramme);
                } else {
                 
                  CoursProgramme coursModifie = CoursProgramme(
                    id: widget
                        .cours!.id, 
                    Type: type,
                    description: description,
                    image: _selectedImagePath ?? '',
                  );

                  widget.onAjouter(coursModifie);
                }

                Navigator.pop(context);
              },
              child: Text(widget.cours == null ? 'Ajouter' : 'Modifier'),
            ),
          ],
        ),
      ),
    );
  }
}
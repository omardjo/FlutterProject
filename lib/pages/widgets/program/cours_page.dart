
import 'package:flutter/material.dart';
import 'package:safeguard/model/cours.dart';
import 'package:safeguard/pages/Program/addcours.dart';
import 'package:safeguard/pages/Program/cours_row.dart';
import 'package:safeguard/services/cours.dart';


class DashboardCours extends StatefulWidget {
  @override
  _DashboardCoursState createState() => _DashboardCoursState();
}

class _DashboardCoursState extends State<DashboardCours> {
  CoursService coursService = CoursService();
  List<CoursProgramme> cours = [];

  Future<void> fetchCours() async {
    try {
      List<CoursProgramme> fetchedCours = await coursService.getCours();

      setState(() {
        cours = fetchedCours;
      });
    } catch (error) {
      print('Erreur lors de la récupération des cours : $error');
    }
  }

  Future<void> supprimerCours(CoursProgramme coursProgramme) async {
    try {
      await coursService.deleteCours(coursProgramme.id!);
      fetchCours(); 
    } catch (error) {
      print('Erreur lors de la suppression de la cours: $error');
    }
  }

  void ajouterOuMettreAJourCours({CoursProgramme? cours}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddCours(
          onAjouter: (nouveauCoursProgramme) async {
            if (cours == null) {
              await coursService.addCours(
                nouveauCoursProgramme.Type,
                nouveauCoursProgramme.description,
                nouveauCoursProgramme.image,
              );
            } else {
              await coursService.updateCours(
                cours.id!,
                nouveauCoursProgramme.Type,
                nouveauCoursProgramme.description,
                nouveauCoursProgramme.image,
              );
            }
            fetchCours();
          },
          cours: cours,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchCours();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord des cours'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => ajouterOuMettreAJourCours(),
            child: Text('Ajouter un cours'),
          ),
          Expanded(
            child: CoursProgrammeTable(
              cours: cours,
              onDelete: supprimerCours,
              onEdit: (cours) => ajouterOuMettreAJourCours(cours: cours),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DashboardCours(),
  ));
}
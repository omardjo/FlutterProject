
import 'package:flutter/material.dart';
import 'package:safeguard/model/program.dart';
import 'package:safeguard/pages/Program/program_row.dart';
import 'package:safeguard/services/program.dart';
import '../../widgets/program/addOrgramForm.dart';
class DashboardProgram extends StatefulWidget {
  @override
  _DashboardProgramState createState() => _DashboardProgramState();
}

class _DashboardProgramState extends State<DashboardProgram> {
  ProgramService programService = ProgramService();
  List<Program> programs = [];

  void addProgram(Program newProgram) async {
    try {
      await programService.addProgram(
        newProgram.titre,
        newProgram.descriptionProgramme,
        newProgram.cours,
        newProgram.image,
      );

      fetchPrograms(); 
      print('Nouveau programme ajouté : ${newProgram.titre}');
    } catch (error) {
      print('Erreur lors de l\'ajout du programme : $error');
    }
  }

  void updateProgram(Program updatedProgram) async {
    try {
      await programService.updateProgram(
        updatedProgram.id,
        updatedProgram.titre,
        updatedProgram.descriptionProgramme,
        updatedProgram.cours,
        updatedProgram.image,
      );

      fetchPrograms(); 
      print('Programme mis à jour : ${updatedProgram.titre}');
    } catch (error) {
      print('Erreur lors de la mise à jour du programme : $error');
    }
  }

  void navigateToAddProgram() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProgramForm(
          onAdd: addProgram,
          onUpdate: updateProgram,
        ),
      ),
    );
    fetchPrograms();
  }

  Future<void> fetchPrograms() async {
    try {
      List<Program> fetchedPrograms = await programService.getPrograms();

      setState(() {
        programs = fetchedPrograms;
      });
    } catch (error) {
      print('Erreur lors de la récupération des programmes: $error');
    }
  }

  Future<void> deleteProgram(Program program) async {
    try {
      await programService.deleteProgram(program.titre);
      fetchPrograms(); 
    } catch (error) {
      print('Erreur lors de la suppression du programme: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPrograms(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord des programmes'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: navigateToAddProgram,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ProgramTable(
              programs: programs,
              onDelete: deleteProgram,
              onUpdate: updateProgram,
            ),
          ),
        ],
      ),
    );
  }
}
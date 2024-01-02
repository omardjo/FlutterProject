
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../pages/widgets/program/addOrgramForm.dart';
import '../../pages/widgets/program/cours_page.dart';
import '../../model/program.dart';

class ProgramTable extends StatelessWidget {
  final List<Program> programs;
  final Function(Program) onDelete;
  final Function(Program) onUpdate;

  ProgramTable(
      {required this.programs, required this.onDelete, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Le nombre total des programmes égale à ${programs.length}',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: DataTable(
                dataRowHeight: 70.0,
                columns: [
                  DataColumn(label: Text('Image')),
                  DataColumn(label: Text('Titre')),
                  DataColumn(label: Text('Bienvenue')),
                  DataColumn(label: Center(child: Text('Actions'))),
                  DataColumn(label: Center(child: Text(''))),
                ],
                rows: programs.map((program) {
                  return DataRow(cells: [
                    DataCell(
                      CachedNetworkImage(
                        imageUrl: program.image,
                        width: 100,
                        height: 100,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    DataCell(Text(program.titre)),
                    DataCell(Text(program.descriptionProgramme)),
                    DataCell(
                      Row(
                        children: [
                          InkWell(
                            onTap: () {
                              
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddProgramForm(
                                    onAdd: (nouveauProgramme) {},
                                    onUpdate: onUpdate,
                                    programToEdit: program,
                                  ),
                                ),
                              );
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.edit, color: Colors.blue),
                            ),
                          ),
                          Container(
                            height: 24,
                            width: 1,
                            color: Colors.black,
                          ),
                          InkWell(
                            onTap: () {
                              onDelete(program);
                            },
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              padding: EdgeInsets.all(8),
                              child: Icon(Icons.delete, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DashboardCours()),
                            );
                          },
                          child: Text('Cours'),
                        ),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
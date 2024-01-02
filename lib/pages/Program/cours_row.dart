import 'package:flutter/material.dart';
import '../../model/cours.dart';
import '../../model/comment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../services/cours.dart';
import '../Program/addcours.dart';
class CoursProgrammeTable extends StatefulWidget {
  final List<CoursProgramme> cours;
  final Function(CoursProgramme) onDelete;
  final Function(CoursProgramme) onEdit;

  CoursProgrammeTable(
      {required this.cours, required this.onDelete, required this.onEdit});

  @override
  _CoursProgrammeTableState createState() => _CoursProgrammeTableState();
}

class _CoursProgrammeTableState extends State<CoursProgrammeTable> {
  CoursProgramme? selectedCours;
  List<Commentaire> comments = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: EdgeInsets.all(16.0),
                child: DataTable(
                  dataRowHeight: 120.0,
                  columnSpacing: 20.0,
                  horizontalMargin: 20.0,
                  columns: [
                    DataColumn(label: Text('Image')),
                    DataColumn(label: Text('Chapitre')),
                    DataColumn(label: Text('Contenu')),
                    DataColumn(
                      label: Center(child: Text('Actions')),
                    ),
                  ],
                  rows: widget.cours.map((cour) {
                    return DataRow(cells: [
                      DataCell(
                        Image.network(
                          cour.image,
                          width: 100,
                          height: 100,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                      DataCell(Text(cour.Type)),
                      DataCell(
                        Container(
                          width: 700,
                          height: double.infinity,
                          child: Center(child: Text(cour.description)),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            InkWell(
                              onTap: () {
                                widget.onEdit(cour);
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
                                widget.onDelete(cour);
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                padding: EdgeInsets.all(8),
                                child: Icon(Icons.delete, color: Colors.red),
                              ),
                            ),
                            Container(
                              height: 24,
                              width: 1,
                              color: Colors.black,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectedCours = cour;
                                });
                                fetchComments(cour.id!);
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                padding: EdgeInsets.all(8),
                                child: Icon(Icons.comment, color: Colors.green),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
          if (selectedCours != null)
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Liste des commentaire pour ${selectedCours!.Type}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          setState(() {
                            selectedCours = null;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                 
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(comments[index].textComment),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void fetchComments(String idCoursProgramme) {
    CoursService()
        .getCommentairesByCoursId(idCoursProgramme)
        .then((List<Commentaire> response) {
      setState(() {
        comments = response;
      });
    }).catchError((error) {
      print('Erreur lors de la recup des commentaires : $error');
    });
  }
}
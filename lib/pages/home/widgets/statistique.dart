import 'package:flutter/material.dart';
import '../../../services/cours.dart';
import '../widgets/favorie.dart';
import '../widgets/commentairegraph.dart';

class StatistiquesPage extends StatefulWidget {
  @override
  _StatistiquesPageState createState() => _StatistiquesPageState();
}

class _StatistiquesPageState extends State<StatistiquesPage> {
  final CoursService coursService = CoursService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistiques '),
      ),
      body: FutureBuilder<Map<String, int>?>(
        future: coursService.getStatistiqueNombreFavorisParTypeCours(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur: ${snapshot.error}'),
            );
          } else {
            final statistiques = snapshot.data ?? {};
            return FutureBuilder<Map<String, int>?>(
              future: coursService.getStatistiqueNombreCommentairesParTypeCours(),
              builder: (context, commentaireSnapshot) {
                if (commentaireSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (commentaireSnapshot.hasError) {
                  return Center(
                    child: Text('Erreur: ${commentaireSnapshot.error}'),
                  );
                } else {
                  final commentairesStatistiques = commentaireSnapshot.data ?? {};
                  return _buildStatistiquesList(statistiques, commentairesStatistiques);
                }
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildStatistiquesList(Map<String, int> statistiques, Map<String, int> commentairesStatistiques) {
    return ListView.builder(
      itemCount: statistiques.length + 2, 
      itemBuilder: (context, index) {
        if (index == statistiques.length) {
         return BarStat();
        
        } else if (index == statistiques.length + 1) {
          
           return CommentairesBarGraphCard();
        }

        final typeCours = statistiques.keys.toList()[index];
        final nombreFavoris = statistiques[typeCours];
        final nombreCommentaires = commentairesStatistiques[typeCours] ?? 0;

        return Card(
          elevation: 2.0,
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: ListTile(
            contentPadding: EdgeInsets.all(16.0),
            title: Text(
              'Chapitre: $typeCours',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nombre de favoris: $nombreFavoris',
                  style: TextStyle(fontSize: 14.0),
                ),
                Text(
                  'Nombre de commentaires: $nombreCommentaires',
                  style: TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StatistiquesPage(),
  ));
}
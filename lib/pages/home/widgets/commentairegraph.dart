import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:safeguard/services/cours.dart';
import 'package:safeguard/widgets/custom_card.dart';

class CommentairesBarGraphCard extends StatefulWidget {
  CommentairesBarGraphCard({Key? key}) : super(key: key);

  @override
  _CommentairesBarGraphCardState createState() => _CommentairesBarGraphCardState();
}

class _CommentairesBarGraphCardState extends State<CommentairesBarGraphCard> {
  final CoursService coursService = CoursService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>?>(
      future: coursService.getStatistiqueNombreCommentairesParTypeCours(),
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
          final data = snapshot.data ?? {};
          return _buildGraph(data);
        }
      },
    );
  }

  Widget _buildGraph(Map<String, int> data) {
   final typesCours = data.keys.toList();
    final commentairesCounts = data.values.toList();

    return CustomCard(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Comment par Chapitre',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 200, // Ajustez la hauteur en fonction de vos besoins
            child: BarChart(
              BarChartData(
                barGroups: _chartGroups(
                  points:commentairesCounts ,
                  color: const Color.fromARGB(255, 88, 30, 233), 
                ),
                borderData: FlBorderData(border: const Border()),
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

 List<BarChartGroupData> _chartGroups({required List<int> points, required Color color}) {
    return points
        .map(
          (point) => BarChartGroupData(
            x: points.indexOf(point),
            barRods: [
              BarChartRodData(
                toY: point.toDouble(),
                width: 6,
                color: color.withOpacity(0.8), 
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(3.0),
                  topRight: Radius.circular(3.0),
                ),
              ),
            ],
          ),
        )
        .toList();
  }
}
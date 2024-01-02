import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:safeguard/services/cours.dart';

import 'package:safeguard/widgets/custom_card.dart';

class BarStat extends StatefulWidget {
  BarStat({Key? key}) : super(key: key);

  @override
  _BarStat createState() => _BarStat();
}

class _BarStat extends State<BarStat> {
  final CoursService coursService = CoursService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>?>(
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
          final data = snapshot.data ?? {};
          return _buildGraph(data);
        }
      },
    );
  }

  Widget _buildGraph(Map<String, int> data) {
    final typesCours = data.keys.toList();
    final favorisCounts = data.values.toList();

    return CustomCard(
      padding: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Les plus 3 chapitres préférés',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 200, 
            child: BarChart(
              BarChartData(
                barGroups: _chartGroups(
                  points: favorisCounts,
                  color: Colors.pink, 
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
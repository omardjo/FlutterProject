import 'package:flutter/material.dart';
import 'package:safeguard/model/Catastrophe.dart';
import 'package:safeguard/model/ZoneDeDanger.dart';
import 'package:safeguard/services/ApiZoneDeDanger.dart';

import '../services/ApiCatastrophe.dart';

class TableMap extends StatelessWidget {
  final List<ZoneDeDanger> zoneDeDangerList;
  final List<Catastrophe> catastropheList;
  final VoidCallback onZoneDeDangerDeleted;

  const TableMap({
    Key? key,
    required this.zoneDeDangerList,
    required this.catastropheList,
    required this.onZoneDeDangerDeleted,
  }) : super(key: key);

  void _handleDeleteZoneDeDanger(String id) async {
    try {
      await ApiZoneDeDanger.deleteZoneDeDangerwithId(id);
      onZoneDeDangerDeleted();
    } catch (e) {
      print('Error deleting ZoneDeDanger: $e');
    }
  }

  void _handleDeleteCatastrophe(String id) async {
    try {
      await ApiCatastrophe.deleteCatastropheWithId(id);
      onZoneDeDangerDeleted(); // Update this callback to refresh the UI
    } catch (e) {
      print('Error deleting Catastrophe: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextStyle headerStyle =
        TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800]);

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Zone De Danger Details',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          DataTable(
            headingRowColor: MaterialStateColor.resolveWith(
                (states) => Colors.blue[100] as Color),
            columns: [
              DataColumn(label: Text('Latitude', style: headerStyle)),
              DataColumn(label: Text('Longitude', style: headerStyle)),
              DataColumn(label: Text('User ID', style: headerStyle)),
              DataColumn(label: Text('Actions', style: headerStyle)),
            ],
            rows: zoneDeDangerList
                .map((zone) => DataRow(
                      cells: [
                        DataCell(Text('${zone.latitudeDeZoneDanger}')),
                        DataCell(Text('${zone.longitudeDeZoneDanger}')),
                        DataCell(Text(zone.idUser)),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () =>
                                _handleDeleteZoneDeDanger(zone.id!),
                          ),
                        ),
                      ],
                    ))
                .toList(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Catastrophes',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          DataTable(
            headingRowColor: MaterialStateColor.resolveWith(
                (states) => Colors.blue.shade200),
            columns: [
              DataColumn(label: Text('Title', style: headerStyle)),
              DataColumn(label: Text('Type', style: headerStyle)),
              DataColumn(label: Text('Description', style: headerStyle)),
              DataColumn(label: Text('Magnitude', style: headerStyle)),
              DataColumn(label: Text('Actions', style: headerStyle)),
            ],
            rows: catastropheList
                .map((cat) => DataRow(
                      cells: [
                        DataCell(Text(cat.titre)),
                        DataCell(Text(cat.type)),
                        DataCell(Text(cat.description)),
                        DataCell(Text('${cat.magnitude}')),
                        DataCell(
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: cat.id != null
                                ? () => _handleDeleteCatastrophe(cat.id!)
                                : null,
                          ),
                        ),
                      ],
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../const.dart';
import '../model/Catastrophee.dart';
import 'AddCatastropheScreen.dart';
import 'EditCatastropheScreen.dart';

class RecentFiles extends StatefulWidget {
  const RecentFiles({Key? key}) : super(key: key);

  @override
  _RecentFilesState createState() => _RecentFilesState();
}

class _RecentFilesState extends State<RecentFiles> {
  late List<Catastrophee> catastrophes;
  late int _rowsPerPage;
  late int _sortColumnIndex;
  late bool _sortAscending;

  @override
  void initState() {
    super.initState();
    catastrophes = [];
    _rowsPerPage = 10;
    _sortColumnIndex = 0;
    _sortAscending = true;
    fetchData();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('http://localhost:9090/catastrophe/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print(data); // Print the response body
      setState(() {
        catastrophes = data.map((json) => Catastrophee.fromJson(json)).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void updateData() {
    fetchData(); // Fetch updated data from the backend server
    setState(() {}); // Trigger a rebuild of the data table
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2A2D3E),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Liste des catastrophes",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          ElevatedButton(
            onPressed: () {
              // Navigate to the screen where the user can add a new catastrophe
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCatastropheScreen(
                    onAdd: _handleAddCatastrophe, // Pass callback for updating UI
                  ),
                ),
              );
            },
            child: Text('Ajouter Catastrophe'),
          ),
          SizedBox(
            width: double.infinity,
            child: PaginatedDataTable(
              header: const Text(''),
              rowsPerPage: _rowsPerPage,
              onRowsPerPageChanged: (newRowsPerPage) {
                setState(() {
                  _rowsPerPage = newRowsPerPage!;
                });
              },
              availableRowsPerPage: [10, 20, 30],
              sortAscending: _sortAscending,
              sortColumnIndex: _sortColumnIndex,
              columns: [
                DataColumn(
                  label: Text("Titre"),
                  onSort: (columnIndex, ascending) {
                    _sort<String>((c) => c.titre, columnIndex, ascending);
                  },
                ),
                DataColumn(
                  label: Text("Type"),
                  onSort: (columnIndex, ascending) {
                    _sort<String>((c) => c.type, columnIndex, ascending);
                  },
                ),
                DataColumn(
                  label: Text("Description"),
                  onSort: (columnIndex, ascending) {
                    _sort<String>((c) => c.description, columnIndex, ascending);
                  },
                ),
                DataColumn(
                  label: Text("Date"),
                  onSort: (columnIndex, ascending) {
                    _sort<DateTime>((c) => c.date, columnIndex, ascending);
                  },
                ),
                DataColumn(
                  label: Text("Magnitude"),
                  onSort: (columnIndex, ascending) {
                    _sort<double>((c) => c.magnitude, columnIndex, ascending);
                  },
                ),
                DataColumn(
                  label: Text("Supprimer"),
                ),
                DataColumn(
                  label: Text("Modifier"),
                ),
              ],
              source: _DataSource(
                context,
                catastrophes,
                _handleDelete,
                _handleEdit,
                updateData, // Pass the callback function to the data source
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleDelete(Catastrophee catastrophe) async {
    final response = await http.delete(
      Uri.parse('http://localhost:9090/catastrophe/${catastrophe.id}'),
    );

    if (response.statusCode == 204) {
      // Delete successful, update the UI or fetch data again
      setState(() {
        catastrophes.remove(catastrophe);
      });
      updateData(); // Call the callback function to update the data table
    } else {
      // Delete failed, handle the error
      print('Failed to delete the catastrophe.');
    }
  }

  void _handleEdit(Catastrophee catastrophe) {
    // Navigate to the edit screen/dialog and pass the selected catastrophe
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCatastropheScreen(
          catastrophe: catastrophe,
          onUpdate: updateData, // Pass the callback function to the edit screen
        ),
      ),
    );
  }

  void _sort<T extends Comparable>(
    T Function(Catastrophee d) getField,
    int columnIndex,
    bool ascending,
  ) {
    catastrophes.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
    });

    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  void _handleAddCatastrophe(Catastrophee newCatastrophe) {
    setState(() {
      catastrophes.add(newCatastrophe);
    });
  }
}

class _DataSource extends DataTableSource {
  final BuildContext context;
  final List<Catastrophee> catastrophes;
  final Function(Catastrophee) onDeletePressed;
  final Function(Catastrophee) onEditPressed;
  final Function() onUpdate; // Callback function to update the data table

  _DataSource(
    this.context,
    this.catastrophes,
    this.onDeletePressed,
    this.onEditPressed,
    this.onUpdate,
  );

  @override
  DataRow getRow(int index) {
    final catastrophe = catastrophes[index];
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(catastrophe.titre),
              ),
            ],
          ),
        ),
        DataCell(Text(catastrophe.type)),
        DataCell(Text(catastrophe.description)),
        DataCell(Text(catastrophe.date.toLocal().toString())),
        DataCell(Text(catastrophe.magnitude.toString())),
        DataCell(
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              onDeletePressed(catastrophe);
              onUpdate(); // Call the callback function to update the data table
            },
          ),
        ),
        DataCell(
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              onEditPressed(catastrophe);
            },
          ),
        ),
      ],
    );
  }

  @override
  int get rowCount => catastrophes.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
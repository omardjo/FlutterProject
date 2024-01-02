import 'dart:convert';
import 'package:safeguard/model/Catastrophe.dart';
import 'package:http/http.dart' as http;

class ApiCatastrophe {
  static Future<List<Catastrophe>> getCatastrophe() async {
    var url = Uri.parse('http://127.0.0.1:9090/catastrophe');
    var response = await http.get(url);
    List<Catastrophe> CatastropheList = [];

    if (response.statusCode == 200) {
      var notesJson = json.decode(response.body);
      for (var noteJson in notesJson) {
        CatastropheList.add(Catastrophe.fromJson(noteJson));
      }
    }

    return CatastropheList;
  }

  static Future<void> deleteCatastropheWithId(String id) async {
    var url = Uri.parse('http://127.0.0.1:9090/catastrophe/$id');
    var response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to delete catastrophe: ${response.statusCode}, ${response.body}');
    } else {
      print("catastrophe deleted");
    }
  }
}

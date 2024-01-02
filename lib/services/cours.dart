import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/cours.dart';
import '../model/comment.dart';
import 'package:http_parser/http_parser.dart';

class CoursService {
  Future<void> addCours(String type, String description, String image) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://localhost:9090/cours/'),
      );

      request.fields['Type'] = type;
      request.fields['description'] = description;

      var imageResponse = await http.get(Uri.parse(image));
      List<int> imageBytes = imageResponse.bodyBytes;

      request.files.add(http.MultipartFile.fromBytes(
        'source',
        imageBytes,
        filename: 'image.jpg',
        contentType: MediaType('image', 'jpg'),
      ));

      print('Request Fields: ${request.fields}');
      print('Request Files: ${request.files}');

      var response = await request.send();
      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Cours ajouté avec succès!');
      } else {
        print('Échec de l ajout du cours ${response.statusCode}');
        print('Response Body: ${await response.stream.bytesToString()}');
      }
    } catch (error) {
      print('Erreur lors de l ajout du cours: $error');
    }
  }

  Future<List<CoursProgramme>> getCours() async {
    final response = await http.get(Uri.parse('http://localhost:9090/cours/'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => CoursProgramme.fromJson(item)).toList();
    } else {
      throw Exception('Erreur lors de la récupération des cours');
    }
  }

  Future<void> deleteCours(String id) async {
    final response =
        await http.delete(Uri.parse('http://localhost:9090/cours/$id'));

    if (response.statusCode == 200) {
      print('Cours supprimé avec succès');
    } else {
      throw Exception('Erreur lors de la suppression du cours');
    }
  }

  Future<Map<String, int>> getStatistiqueNombreFavorisParTypeCours() async {
    final url = 'http://localhost:9090/favorie/stat';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        Map<String, int> statistiquesFinale =
            Map<String, int>.from(jsonResponse);
        return statistiquesFinale;
      } else {
        print('Erreur de requête : ${response.statusCode}');
        return Map<String, int>();
      }
    } catch (error) {
      print('Erreur lors de l\'envoi de la requête : $error');
      return Map<String, int>();
    }
  }

  Future<Map<String, int>?>
      getStatistiqueNombreCommentairesParTypeCours() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:9090/commentairesProgramme/stat'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final Map<String, int> statistiques = Map<String, int>.from(data);
        return statistiques;
      } else {
        throw Exception('Échec de la requête : ${response.reasonPhrase}');
      }
    } catch (error) {
      print(
          'Erreur lors de la récupération des statistiques des commentaires : $error');
      throw Exception('Erreur serveur');
    }
  }

  Future<List<Commentaire>> getCommentairesByCoursId(
      String idCoursProgramme) async {
    final response = await http.get(Uri.parse(
        'http://localhost:9090/commentairesProgramme/$idCoursProgramme'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
     
      if (data.isEmpty) {
        return [];
      }
      return data.map((item) => Commentaire.fromJson(item)).toList();
    } else {
      throw Exception('Erreur lors de la recup des commentaires');
    }
  }

  Future<void> updateCours(
      String id, String type, String description, String image) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(
            'http://localhost:9090/cours/$id'), 
      );

      request.fields['Type'] = type;
      request.fields['description'] = description;

      if (image.isNotEmpty) {
        var imageResponse = await http.get(Uri.parse(image));
        List<int> imageBytes = imageResponse.bodyBytes;

        request.files.add(http.MultipartFile.fromBytes(
          'source',
          imageBytes,
          filename: 'image.jpg',
          contentType: MediaType('image', 'jpg'),
        ));
      }

      print('Request Fields: ${request.fields}');
      print('Request Files: ${request.files}');

      var response = await request.send();
      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        print('Cours mis à jour avec succès!');
      } else {
        print('Échec de la mise à jour du cours ${response.statusCode}');
        print('Response Body: ${await response.stream.bytesToString()}');
      }
    } catch (error) {
      print('Erreur lors de la mise à jour du cours: $error');
    }
  }
}
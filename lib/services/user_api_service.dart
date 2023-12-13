import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safeguard/model/user_model.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:9090";

static Future<User> authenticateAdmin(String email, String password) async {
  final Uri requestUri = Uri.parse('$baseUrl/user/loginAdmin');
  final Map<String, String> requestBody = {
    'email': email,
    'password': password,
  };

  final http.Response response = await http.post(
    requestUri,
    body: requestBody,
  );

  // Print the raw response body
  print(response.body);

 if (response.statusCode == 200) {
  print(response.body); // Add this line
  final Map<String, dynamic> responseData = json.decode(response.body);
  return User.fromJson(responseData);
} else {
  throw Exception('Failed to authenticate admin');
}
}
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safeguard/model/user_model.dart';

class UserApiService {
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
    print('Server Response: ${response.body}');

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      print('Decoded Response: $responseData');

      return User.fromJson(responseData);
    } else {
      throw Exception('Failed to authenticate admin');
    }
  }

    static Future<User> fetchUserProfile(String userId) async {
  final Uri requestUri = Uri.parse('$baseUrl/user/profile/$userId'); // Add '/user' before '/profile'
  
  try {
    final http.Response response = await http.get(requestUri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      return User.fromJson(responseData);
    } else {
      throw Exception('Failed to fetch user profile');
    }
  } catch (error) {
    throw Exception('Error: $error'); // Add error handling for better insight
  }
}

  static Future<void> sendCredentialsByEmail(String adminEmail) async {
    final Uri requestUri = Uri.parse('$baseUrl/user/sendCredentialsByEmail');
    final Map<String, String> requestBody = {
      'email': adminEmail,
    };

    final http.Response response = await http.post(
      requestUri,
      body: requestBody,
    );

    // Print the raw response body
    print('Server Response: ${response.body}');

    if (response.statusCode == 200) {
      print('Credentials sent successfully');
    } else {
      throw Exception('Failed to send credentials by email');
    }
  }
 
  
}

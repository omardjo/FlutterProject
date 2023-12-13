import 'package:flutter/cupertino.dart';
import 'package:safeguard/model/user_model.dart';
import 'package:safeguard/services/user_api_service.dart';

class UserProvider with ChangeNotifier {
  User? _authenticatedUser;

  User? get authenticatedUser => _authenticatedUser;

  Future<void> authenticateAdmin(String email, String password) async {
    // Call the authenticateAdmin method from the ApiService
    final User user = await ApiService.authenticateAdmin(email, password);

    // Print the user data for debugging
    print('User data: $user');

    // Set the authenticated user
    _authenticatedUser = User(
      id: user.id,
      userName: user.userName,
      email: user.email,
      password: user.password,
      role: user.role, // Set default role if null
      latitudeUser: user.latitudeUser,
      longitudeUser: user.longitudeUser,
      numeroTel: user.numeroTel,
    );

    // Print the authenticated user data for debugging
    print('Authenticated user: $_authenticatedUser');

    // Notify listeners that the authentication was successful
    notifyListeners();
  }
}

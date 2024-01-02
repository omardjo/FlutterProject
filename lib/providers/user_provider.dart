import 'package:flutter/cupertino.dart';
import 'package:safeguard/model/user_model.dart';
import 'package:safeguard/services/user_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
class UserProvider with ChangeNotifier {
  List<User> _users = [];
  String _invitationStatus = '';

  List<User> get users => _users;

  String get invitationStatus => _invitationStatus; // Add this getter

  Future<User> authenticateAdmin(String email, String password) async {
    // Call the authenticateAdmin method from the ApiService
    final User user = await UserApiService.authenticateAdmin(email, password);

    // Add the user to the _users list
    _users.add(user);

    // Notify listeners that the data has changed
    notifyListeners();
        return user;

    
  }
Future<User> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('userId') ?? '';
    return UserApiService.fetchUserProfile(userId);
  }
  Future<void> sendCredentialsByEmail(String adminEmail) async {
    try {
      // Update invitation status to indicate that it's in progress
      _invitationStatus = 'Sending credentials...';
      notifyListeners();

      // Call the UserApiService method to send credentials
      await UserApiService.sendCredentialsByEmail(adminEmail);

      // Update invitation status to indicate success
      _invitationStatus = 'Credentials sent successfully';
      notifyListeners();
    } catch (e) {
      // Update invitation status to indicate failure
      _invitationStatus = 'Failed to send credentials';
      notifyListeners();
    }
  }

}






import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safeguard/model/user_model.dart';
import 'package:safeguard/providers/user_provider.dart';
import 'package:safeguard/pages/Dashboard/dashboard.dart';
import 'package:safeguard/pages/ForgotPassword/forgot_password.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key});

  static const String routeName = '/signin';

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: const OutlineInputBorder(),
                suffixIcon: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordPage()),
                    );
                  },
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final String email = _emailController.text;
                final String password = _passwordController.text;

                try {
                  // Authenticate user
                  User user = await Provider.of<UserProvider>(context, listen: false)
                      .authenticateAdmin(email, password);

                  // Save user details locally using shared_preferences
                  await saveUserDetailsLocally(user);

                  // Navigate to Dashboard
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashBoard()),
                  );
                } catch (error) {
                  print('Authentication failed: $error');
                }
              },
              child: const Text('Sign In'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to save user details locally
  Future<void> saveUserDetailsLocally(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save user details
    prefs.setString('userId', user.id ?? "");
    prefs.setString('userName', user.userName ?? "");
    prefs.setString('email', user.email ?? "");
    prefs.setString('numeroTel', user.numeroTel ?? "");
  }
}

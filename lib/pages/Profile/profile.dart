import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safeguard/model/user_model.dart';
import 'package:safeguard/providers/user_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<User>(
        future: Provider.of<UserProvider>(context).getUserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Text('No user data available.'),
            );
          }

          User user = snapshot.data!;
          print('User details loaded successfully: $user');

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/user.png'),
                ),
                SizedBox(height: 20),
                Text(
                  'User Name: ${user.userName}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Email: ${user.email}',
                  style: TextStyle(fontSize: 16),
                ),
             
                SizedBox(height: 20),
                Divider(),
                SizedBox(height: 20),
          
                SizedBox(height: 5),
                // Additional widgets for 'About' section can be added here
              ],
            ),
          );
        },
      ),
    );
  }
}

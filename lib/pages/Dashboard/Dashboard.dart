import 'package:flutter/material.dart';
import 'package:provider/provider.dart';  // Add this import
import 'package:safeguard/pages/home/home_page.dart';
import 'package:safeguard/pages/widgets/menu.dart';
import 'package:safeguard/Responsive.dart';
import 'package:safeguard/providers/user_provider.dart';  // Replace with the actual path to your UserProvider

class DashBoard extends StatelessWidget {
  DashBoard({Key? key});

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController(); // Controller for the email TextField

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: !Responsive.isDesktop(context)
          ? SizedBox(width: 250, child: Menu(scaffoldKey: _scaffoldKey))
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  if (Responsive.isDesktop(context))
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: Menu(scaffoldKey: _scaffoldKey),
                      ),
                    ),
                  Expanded(flex: 8, child: HomePage(scaffoldKey: _scaffoldKey)),
                ],
              ),
              // Add the button and text field here
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Enter Admin Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        String adminEmail = _emailController.text;
                        await Provider.of<UserProvider>(context, listen: false).sendCredentialsByEmail(adminEmail);
     String invitationStatus = Provider.of<UserProvider>(context, listen: false).invitationStatus;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invite Admins by Email: $adminEmail, Status: $invitationStatus'),
                          ),
                        );
                      },
                      child: Text('Invite Admins'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

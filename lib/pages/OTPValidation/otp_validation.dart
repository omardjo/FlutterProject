import 'package:flutter/material.dart';
import 'package:safeguard/pages/ChangePassword/change_password.dart';

class OtpValidationView extends StatefulWidget {
  const OtpValidationView({super.key});

  @override
  _OtpValidationViewState createState() => _OtpValidationViewState();
}

class _OtpValidationViewState extends State<OtpValidationView> {
  TextEditingController block1Controller = TextEditingController();
  TextEditingController block2Controller = TextEditingController();
  TextEditingController block3Controller = TextEditingController();
  TextEditingController block4Controller = TextEditingController();

  bool? isVerified;
  String storedOtpCode = "";
  String storedOtpResponse = "";
  bool navigateToChangePass = false;

  @override
  void initState() {
    // Use initState to retrieve values stored in AppStorage
    storedOtpCode = "1234";
    storedOtpResponse = "1234";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Enter OTP to Verify:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: block1Controller,
                      decoration: const InputDecoration(
                        labelText: 'Block',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: block2Controller,
                      decoration: const InputDecoration(
                        labelText: 'Block',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: block3Controller,
                      decoration: const InputDecoration(
                        labelText: 'Block',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: block4Controller,
                      decoration: const InputDecoration(
                        labelText: 'Block',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isVerified = block1Controller.text +
                      block2Controller.text +
                      block3Controller.text +
                      block4Controller.text ==
                      storedOtpCode ||
                      block1Controller.text +
                          block2Controller.text +
                          block3Controller.text +
                          block4Controller.text ==
                          storedOtpResponse;
                  navigateToChangePass = isVerified ?? false;
                });
              },
              child: const Text("Verify"),
            ),
            if (isVerified != null && isVerified!)
              Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    "OTP Verified!",
                    style: TextStyle(fontSize: 20),
                  ),
                  // Use Navigator to navigate to the ChangePasswordView
                  FutureBuilder<bool>(
                    future: Future.value(navigateToChangePass),
                    builder: (context, snapshot) {
                      if (snapshot.data == true) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChangePasswordView(),
                            ),
                          );
                        });
                      }
                      return Container();
                    },
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}



void main() {
  runApp(const MaterialApp(
    home: OtpValidationView(),
  ));
}


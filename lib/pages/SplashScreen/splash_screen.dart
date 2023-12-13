import 'package:flutter/material.dart';
import 'package:safeguard/pages/SignUp/sign_up.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Splash Screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash'; // Add this line

  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // You can add your initialization logic here, like loading data or fetching user data.
    // For demonstration purposes, let's assume the splash screen displays for 3 seconds before navigating to the next screen.
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignUpPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            color: Colors.white,
          ),
          Center(
            child: Image.asset(
              "assets/images/image.png",
              width: screenWidth,
              height: MediaQuery.of(context).size.height, // Set the height to full screen height
            ),
          ),
        ],
      ),
    );
  }
}


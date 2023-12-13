import 'package:flutter/material.dart';
import 'package:safeguard/pages/SignIn/sign_in.dart';
import 'package:safeguard/pages/SplashScreen/splash_screen.dart';

Map<String, Widget Function(BuildContext)> routes = {
  //1
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInPage.routeName: (p0) => const SignInPage()
};

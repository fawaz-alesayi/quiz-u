// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:quiz_u_client/api/token.dart';
import 'package:quiz_u_client/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A page that checks shared preferences for user info and redirects to the appropriate page.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> routeToPage() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var destination = Routes.navigation;
    if (prefs.getString('name') == null) {
      destination = Routes.name;
    }
    if (token == null) {
      destination = Routes.login;
    } else {
      var isValidToken = await validateToken(token: token);
      if (!isValidToken) {
        destination = Routes.login;
      }
    }
    Navigator.pushReplacementNamed(context, destination);
  }

  @override
  void initState() {
    super.initState();
    routeToPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('QuizU',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

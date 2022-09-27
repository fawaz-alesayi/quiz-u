import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u_client/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A page that checks shared preferences for user info and redirects to the appropriate page.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> RouteToPage() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var destination = Routes.home;
    if (prefs.getString('name') == null) {
      destination = Routes.name;
    }
    if (token == null) {
      destination = Routes.login;
    }
    Navigator.pushReplacementNamed(context, destination);
  }

  @override
  void initState() {
    super.initState();
    RouteToPage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('QuizU',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

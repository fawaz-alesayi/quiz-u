// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u_client/pages/home.dart';
import 'package:quiz_u_client/pages/leaderboards.dart';
import 'package:quiz_u_client/pages/login.dart';
import 'package:quiz_u_client/pages/name.dart';
import 'package:quiz_u_client/pages/otp.dart';
import 'package:quiz_u_client/pages/profile.dart';
import 'package:quiz_u_client/pages/quiz.dart';
import 'package:quiz_u_client/pages/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

final sharedPreferencesProvider = FutureProvider((ref) async {
  return await SharedPreferences.getInstance();
});

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var prefs = ref.watch(sharedPreferencesProvider).value;
    return MaterialApp(
      title: 'QuizU',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: {
        Routes.login: (context) => LoginPage(),
        Routes.home: (context) => HomePage(),
        Routes.otp: (context) => OtpPage(),
        Routes.leaderboard: (context) => LeaderboardPage(),
        Routes.profile: (context) => ProfilePage(),
        Routes.name: (context) => NamePage(),
        Routes.quiz: (context) => QuizPage(),
      },
    );
  }
}

abstract class Routes {
  static const String home = '/home';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String leaderboard = '/leaderboard';
  static const String profile = '/profile';
  static const String name = '/name';
  static const String quiz = '/quiz';
}

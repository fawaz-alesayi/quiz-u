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
  // ensure shared preferences is initialized
  WidgetsFlutterBinding.ensureInitialized();
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
        Routes.navigation: (context) => NavigationPage(),
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
  static const String login = '/login';
  static const String navigation = '/navigation';
  static const String home = '/home';
  static const String otp = '/otp';
  static const String leaderboard = '/leaderboard';
  static const String profile = '/profile';
  static const String name = '/name';
  static const String quiz = '/quiz';
}

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    LeaderboardPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Leaderboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }
}

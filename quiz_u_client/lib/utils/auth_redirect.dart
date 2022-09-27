import 'package:flutter/material.dart';
import 'package:quiz_u_client/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void redirectToHomeIfLoggedIn(BuildContext context, SharedPreferences? perf) {
  if (perf?.getString("token") != null) {
    Navigator.pushNamed(context, Routes.home);
  }
}

void redirectToLoginIfNotLoggedIn(BuildContext context, SharedPreferences? perf) {
  if (perf?.getString("token") == null) {
    Navigator.pushNamed(context, Routes.login);
  }
}
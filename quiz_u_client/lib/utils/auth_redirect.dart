import 'package:flutter/material.dart';
import 'package:quiz_u_client/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Redirects to the proper page is not logged in
String getInitialRoute(BuildContext context, SharedPreferences? prefs) {
  if (prefs?.getString("token") != null) {
    return Routes.home;
  } else {
    return Routes.login;
  }
}

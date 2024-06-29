import 'package:cartify/features/auth/screens/auth_screen.dart';
import 'package:flutter/material.dart';

/// Generates the appropriate route based on the given [routeSettings].
///
/// This function is responsible for mapping the route name to the corresponding
/// screen widget. If the route name matches, it returns the corresponding screen
Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const AuthScreen(),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (context) => const Scaffold(
          body: Center(
            child: Text("404 - Not Found"),
          ),
        ),
      );
  }
}

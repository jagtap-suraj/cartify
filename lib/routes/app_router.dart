import 'package:cartify/constants/app_strings.dart';
import 'package:cartify/features/auth/screens/auth_screen.dart';
import 'package:cartify/features/auth/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  homeScreen('/home', 'homeScreen'),
  authScreen('/', 'authScreen');

  final String path;
  final String name;

  const AppRoute(this.path, this.name);
}

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoute.authScreen.path,
      name: AppRoute.authScreen.name,
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: AppRoute.homeScreen.path,
      name: AppRoute.homeScreen.name,
      builder: (context, state) => const HomeScreen(),
    )
  ],
  errorBuilder: (context, state) => const Scaffold(
    body: Center(
      child: Text(AppStrings.notFound),
    ),
  ),
);

import 'package:cartify/features/auth/services/auth_service.dart';
import 'package:cartify/providers/user_provider.dart';
import 'package:cartify/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    initializeUserData();
  }

  void initializeUserData() async {
    try {
      const storage = FlutterSecureStorage();
      final String? token = await storage.read(key: 'x-auth-token');
      final getUserDataResult = await _authService.getUser(token: token);
      getUserDataResult.fold(
        (left) async => {
          await storage.write(key: 'x-auth-token', value: ''),
          _navigateToAuth(),
        },
        (right) => {
          Provider.of<UserProvider>(context, listen: false).setUser(right),
          _navigateBasedOnUserType(),
        },
      );
    } catch (e) {
      // If an error occurs while fetching user data, navigate to auth screen
      _navigateToAuth();
    }
  }

  void _navigateToAuth() {
    GoRouter.of(context).goNamed(AppRoute.authScreen.name);
  }

  void _navigateBasedOnUserType() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userProvider.user.type == 'admin') {
      GoRouter.of(context).goNamed(AppRoute.sellerScreen.name);
    } else {
      GoRouter.of(context).goNamed(AppRoute.customBottomNavigationBar.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

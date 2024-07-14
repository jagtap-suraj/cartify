import 'package:cartify/constants/app_strings.dart';
import 'package:cartify/constants/utils.dart';
import 'package:cartify/features/auth/services/auth_service.dart';
import 'package:cartify/features/seller/services/seller_services.dart';
import 'package:cartify/providers/user_provider.dart';
import 'package:cartify/repository/product_repository.dart';
import 'package:cartify/repository/user_repository.dart';
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
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final token = await _getToken();
    if (token == null) {
      _navigateToAuth();
      return;
    }
    await _initializeUserData(token);
  }

  Future<String?> _getToken() async {
    return await _storage.read(key: 'x-auth-token');
  }

  Future<void> _initializeUserData(String token) async {
    try {
      final getUserDataResult = await _authService.getUser(token: token);
      getUserDataResult.fold(
        (left) async => {
          await _storage.write(key: 'x-auth-token', value: ''),
          _navigateToAuth(),
        },
        (right) async {
          Provider.of<UserProvider>(context, listen: false).setUser(right);
          final userRepository = UserRepository();
          await userRepository.deleteAllUsers();
          await userRepository.createUser(right);
          await _navigateBasedOnUserType();
        },
      );
    } catch (e) {
      _navigateToAuth();
    }
  }

  Future<void> _navigateBasedOnUserType() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final userType = userProvider.user.type;
    if (userType == 'admin' || userType == 'seller') {
      await _refreshProducts();
      if (!mounted) return;
      GoRouter.of(context).goNamed(AppRoute.sellerScreen.name);
    } else {
      GoRouter.of(context).goNamed(AppRoute.customBottomNavigationBar.name);
    }
  }

  Future<void> _refreshProducts() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final productRepository = ProductRepository();
    final sellerServices = SellerServices();
    final token = await _getToken();
    if (token == null) return;
    try {
      final res = await sellerServices.fetchSellerProducts(token: token, sellerId: userProvider.user.id!);
      res.fold(
        (left) => showSnackBar(context, AppStrings.noProductsFound),
        (right) async {
          await productRepository.deleteAllProducts();
          await productRepository.createProducts(right);
        },
      );
    } catch (e) {
      _navigateToAuth();
    }
  }

  void _navigateToAuth() {
    GoRouter.of(context).goNamed(AppRoute.authScreen.name);
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

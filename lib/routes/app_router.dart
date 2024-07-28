import 'package:cartify/common/widgets/custom_bottom_navigation_bar.dart';
import 'package:cartify/constants/app_strings.dart';
import 'package:cartify/features/account/screens/account_screen.dart';
import 'package:cartify/features/address/screens/address_screen.dart';
import 'package:cartify/features/home/screens/category_deals_screen.dart';
import 'package:cartify/features/product_details/screens/product_details_screen.dart';
import 'package:cartify/features/search/screens/search_screen.dart';
import 'package:cartify/features/seller/screens/add_product_screen.dart';
import 'package:cartify/features/seller/screens/seller_screen.dart';
import 'package:cartify/features/seller/screens/product_screen.dart';
import 'package:cartify/features/auth/screens/auth_screen.dart';
import 'package:cartify/features/home/screens/home_screen.dart';
import 'package:cartify/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  // Initial Screens
  splashScreen('/', 'splashScreen'),
  customBottomNavigationBar('/bottom-navigation-bar', 'bottomNavigationBar'),
  homeScreen('home-screen', 'homeScreen'),
  accountScreen('account-screen', 'accountScreen'),
  authScreen('/auth-screen', 'authScreen'),

  // Admin Screens
  sellerScreen('/seller-screen', 'sellerScreen'),
  productScreen('product-screen', 'productScreen'),
  addProductScreen('add-product-screen', 'addProductScreen'),

  // Home Screens
  categoryDealsScreen('category-deals-screen', 'categoryDealsScreen'),
  searchScreen('search-screen', 'searchScreen'),
  productDetailsScreen('product-details-screen', 'productDetailsScreen'),

  addressScreen('address-screen', 'addressScreen');

  final String path;
  final String name;

  const AppRoute(this.path, this.name);
}

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  routes: [
    // Initial Routes
    GoRoute(
      path: AppRoute.splashScreen.path,
      name: AppRoute.splashScreen.name,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoute.authScreen.path,
      name: AppRoute.authScreen.name,
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(path: AppRoute.customBottomNavigationBar.path, name: AppRoute.customBottomNavigationBar.name, builder: (context, state) => const CustomBottomNavigationBar(), routes: [
      GoRoute(
        path: AppRoute.homeScreen.path,
        name: AppRoute.homeScreen.name,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '${AppRoute.categoryDealsScreen.path}/:category',
        name: AppRoute.categoryDealsScreen.name,
        builder: (context, state) {
          final category = state.pathParameters['category']!;
          return CategoryDealsScreen(category: category);
        },
      ),
      GoRoute(
        path: AppRoute.searchScreen.path,
        name: AppRoute.searchScreen.name,
        builder: (context, state) {
          final searchQuery = state.uri.queryParameters['searchQuery']!;
          return SearchScreen(searchQuery: searchQuery);
        },
      ),
      GoRoute(
        path: '${AppRoute.productDetailsScreen.path}/:productId',
        name: AppRoute.productDetailsScreen.name,
        builder: (context, state) {
          final productId = state.pathParameters['productId']!;
          return ProductDetailsScreen(productId: productId);
        },
      ),
      GoRoute(
        path: AppRoute.accountScreen.path,
        name: AppRoute.accountScreen.name,
        builder: (context, state) => const AccountScreen(),
      ),
      GoRoute(
        path: AppRoute.addressScreen.path,
        name: AppRoute.addressScreen.name,
        builder: (context, state) => const AddressScreen(),
      )
    ]),

    // Seller Routes
    GoRoute(
      path: AppRoute.sellerScreen.path,
      name: AppRoute.sellerScreen.name,
      builder: (context, state) => const SellerScreen(),
      routes: [
        GoRoute(
          path: AppRoute.productScreen.path,
          name: AppRoute.productScreen.name,
          builder: (context, state) => const ProductScreen(),
        ),
        GoRoute(
          path: AppRoute.addProductScreen.path,
          name: AppRoute.addProductScreen.name,
          builder: (context, state) => const AddProductScreen(),
        ),
      ],
    )
  ],
  errorBuilder: (context, state) => const Scaffold(
    body: Center(
      child: Text(AppStrings.notFound),
    ),
  ),
);

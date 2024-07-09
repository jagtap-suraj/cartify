import 'package:cartify/common/widgets/custom_bottom_navigation_bar.dart';
import 'package:cartify/constants/app_strings.dart';
import 'package:cartify/constants/global_variables.dart';
import 'package:cartify/features/auth/screens/auth_screen.dart';
import 'package:cartify/features/auth/screens/home_screen.dart';
import 'package:cartify/features/auth/services/auth_service.dart';
import 'package:cartify/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future main() async {
  // turn off the # in the URLs on the web
  usePathUrlStrategy();
  // This function is made async so that we can use the await keyword to load the .env file
  await dotenv.load(fileName: ".env");
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = AuthService();
  bool _isLoading = true; // A loader to show while fetching user data

  @override
  void initState() {
    super.initState();
    //clear the user token from storage
    initializeUserData();
  }

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  void initializeUserData() async {
    try {
      const storage = FlutterSecureStorage();
      final String? token = await storage.read(key: 'x-auth-token');
      final getUserDataResult = await _authService.getUser(token: token);
      getUserDataResult.fold(
        (left) async => {
          await storage.write(key: 'x-auth-token', value: ''),
        },
        (right) => {
          Provider.of<UserProvider>(context, listen: false).setUser(right),
        },
      );
    } catch (e) {
      // If an error occurs while fetching user data, log the error and do nothing
    }
    _toggleLoading();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      theme: ThemeData(
        colorScheme: const ColorScheme.light(primary: GlobalVariables.secondaryColor),
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        appBarTheme: const AppBarTheme(elevation: 0, iconTheme: IconThemeData(color: Colors.black)),
        useMaterial3: true,
        // disable the ripple effect on the buttons
        splashFactory: NoSplash.splashFactory,
      ),
      home: _isLoading // Check if loading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(), // Show progress indicator while loading
              ),
            )
          : Provider.of<UserProvider>(context).user.token.isNotEmpty
              ? const CustomBottomNavigationBar()
              : const AuthScreen(),
    );
  }
}

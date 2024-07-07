import 'package:cartify/constants/global_variables.dart';
import 'package:cartify/features/auth/screens/auth_screen.dart';
import 'package:cartify/features/auth/screens/home_screen.dart';
import 'package:cartify/features/auth/services/auth_service.dart';
import 'package:cartify/providers/user_provider.dart';
import 'package:cartify/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future main() async {
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
    initializeUserData();
  }

  void initializeUserData() async {
    // Make this method async
    try {
      await _authService.getUserData(
        // Await the getUserData call
        onUserDataReceived: (userData) {
          Provider.of<UserProvider>(context, listen: false).setUser(userData);
          setState(() {
            _isLoading = false; // Set loading to false once data is received
          });
        },
      );
    } catch (e) {
      // If an error occurs while fetching user data, log the error and do nothing
      setState(() {
        _isLoading = false; // Ensure loading is set to false even on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cartify',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(primary: GlobalVariables.secondaryColor),
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        appBarTheme: const AppBarTheme(elevation: 0, iconTheme: IconThemeData(color: Colors.black)),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: _isLoading // Check if loading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(), // Show progress indicator while loading
              ),
            )
          : Provider.of<UserProvider>(context).user.token.isNotEmpty
              ? const HomeScreen()
              : const AuthScreen(),
    );
  }
}

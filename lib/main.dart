import 'package:cartify/constants/global_variables.dart';
import 'package:cartify/features/auth/screens/auth_screen.dart';
import 'package:cartify/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
        onGenerateRoute: (settings) => generateRoute(settings), // This is the function that will be called when the app navigates to a new route
        home: const AuthScreen());
  }
}

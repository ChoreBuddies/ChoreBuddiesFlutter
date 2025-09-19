import 'package:chorebuddies_flutter/authentication/auth_manager.dart';
import 'package:chorebuddies_flutter/dependencies.dart';
import 'package:chorebuddies_flutter/layout/main_layout.dart';
import 'package:chorebuddies_flutter/pages/login_page.dart';
import 'package:chorebuddies_flutter/pages/page_not_found.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(buildDependencies(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChoreBuddies',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 78, 167, 222),
        ), // Picton Blue
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: Consumer<AuthManager>(
        builder: (context, auth, child) {
          if (auth.isLoggedIn) {
            return MainLayout();
          } else {
            return LoginPage();
          }
        },
      ),
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (context) => const PageNotFound()),
    );
  }
}

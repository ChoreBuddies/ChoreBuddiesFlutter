import 'package:chorebuddies_flutter/authentication/auth_manager.dart';
import 'package:chorebuddies_flutter/dependencies.dart';
import 'package:chorebuddies_flutter/households/household_service.dart';
import 'package:chorebuddies_flutter/layout/main_layout.dart';
import 'package:chorebuddies_flutter/pages/login_page.dart';
import 'package:chorebuddies_flutter/pages/no_household_page.dart';
import 'package:chorebuddies_flutter/pages/page_not_found.dart';
import 'package:chorebuddies_flutter/styles/colors.dart';
import 'package:chorebuddies_flutter/users/user_service.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
        ),
      ),
      home: _HomePage(),
      onUnknownRoute: (settings) =>
          MaterialPageRoute(builder: (context) => const PageNotFound()),
    );
  }
}

class _HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthManager>();
    if (!auth.isLoggedIn) {
      return LoginPage();
    }

    context.watch<HouseholdService>();
    final userService = context.read<UserService>();

    return FutureBuilder(
      future: userService.getMe(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final user = snapshot.data;
        if (user == null) {
          return const Scaffold(
            body: Center(child: Text('Couldn\'t load user data')),
          );
        }

        if (user.householdId != null) {
          return const MainLayout();
        } else {
          return const NoHouseholdPage();
        }
      },
    );
  }
}

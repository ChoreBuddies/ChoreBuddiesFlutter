import 'dart:async';

import 'package:chorebuddies_flutter/features/authentication/auth_manager.dart';
import 'package:chorebuddies_flutter/dependencies.dart';
import 'package:chorebuddies_flutter/firebase_options.dart';
import 'package:chorebuddies_flutter/features/households/household_service.dart';
import 'package:chorebuddies_flutter/UI/layout/main_layout.dart';
import 'package:chorebuddies_flutter/features/notifications/notification_service.dart';
import 'package:chorebuddies_flutter/features/authentication/login_page.dart';
import 'package:chorebuddies_flutter/features/households/no_household_page.dart';
import 'package:chorebuddies_flutter/UI/pages/page_not_found.dart';
import 'package:chorebuddies_flutter/UI/styles/colors.dart';
import 'package:chorebuddies_flutter/features/users/user_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Obsługa w tle: ${message.messageId}");
}

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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

class _HomePage extends StatefulWidget {
  const _HomePage();

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  StreamSubscription? _messageSubscription;
  NotificationService? _notificationService;

  AuthManager? _authManager;

  @override
  void initState() {
    super.initState();

    _setupNotificationListeners();

    _authManager = context.read<AuthManager>();
    _notificationService = context.read<NotificationService>();

    _authManager?.addListener(_onAuthChange);

    if (_authManager?.isLoggedIn ?? false) {
      _syncTokenWithBackend();
    }
  }

  @override
  void dispose() {
    _authManager?.removeListener(_onAuthChange);
    _messageSubscription?.cancel();
    super.dispose();
  }

  void _onAuthChange() {
    final auth = _authManager;
    if (auth != null && auth.isLoggedIn) {
      _syncTokenWithBackend();
    }
  }

  Future<void> _syncTokenWithBackend() async {
    final token = await _notificationService?.getFcmToken();

    if (token != null && mounted) {
      await context.read<UserService>().updateFcmToken(token);
    }
  }

  Future<void> _setupNotificationListeners() async {
    await _notificationService?.initialize();

    _messageSubscription = _notificationService?.onMessage.listen((
      RemoteMessage message,
    ) {
      if (message.notification != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message.notification!.title ?? 'New Notification'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    _notificationService?.onMessageOpenedApp.listen((message) {
      // TODO: Navigator.of(context).pushNamed(...)
    });
  }

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

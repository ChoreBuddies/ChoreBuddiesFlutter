import 'package:chorebuddies_flutter/features/authentication/auth_api_service.dart';
import 'package:chorebuddies_flutter/features/authentication/auth_client.dart';
import 'package:chorebuddies_flutter/features/authentication/auth_manager.dart';
import 'package:chorebuddies_flutter/features/chores/chore_service.dart';
import 'package:chorebuddies_flutter/features/households/household_service.dart';
import 'package:chorebuddies_flutter/features/notifications/notification_preferences_service.dart';
import 'package:chorebuddies_flutter/features/notifications/notification_service.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/models/scheduled_chore_dto.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/scheduled_chores_service.dart';
import 'package:chorebuddies_flutter/features/users/user_service.dart';
import 'package:chorebuddies_flutter/features/chat/chat_service.dart';
import 'package:chorebuddies_flutter/core/app_config.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<Widget> buildDependencies({required Widget child}) async {
  final baseUrl = await AppConfig.apiBaseUrl;
  debugPrint("App configured with Base URL: $baseUrl");

  return MultiProvider(
    providers: [
      Provider<AuthApiService>(
        create: (ctx) => AuthApiService(baseUrl: baseUrl),
      ),
      ChangeNotifierProvider<AuthManager>(
        create: (ctx) =>
            AuthManager(apiService: ctx.read<AuthApiService>())..init(),
      ),
      Provider<AuthClient>(
        create: (ctx) =>
            AuthClient(baseUrl: baseUrl, authManager: ctx.read<AuthManager>()),
      ),
      Provider(
        create: (ctx) => ChoreService(authClient: ctx.read<AuthClient>()),
      ),
      Provider(
        create: (ctx) => UserService(authClient: ctx.read<AuthClient>()),
      ),
      ChangeNotifierProvider<HouseholdService>(
        create: (ctx) => HouseholdService(authClient: ctx.read<AuthClient>()),
      ),
      Provider<NotificationPreferencesService>(
        create: (ctx) =>
            NotificationPreferencesService(authClient: ctx.read<AuthClient>()),
      ),
      Provider<NotificationService>(create: (ctx) => NotificationService()),
      Provider<ScheduledChoresService>(
        create: (ctx) =>
            ScheduledChoresService(authClient: ctx.read<AuthClient>()),
      ),
      ChangeNotifierProvider<ChatService>(
        create: (ctx) => ChatService(
          authClient: ctx.read<AuthClient>(),
          authManager: ctx.read<AuthManager>(),
        ),
      ),
    ],
    child: child,
  );
}

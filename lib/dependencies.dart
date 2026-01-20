import 'package:chorebuddies_flutter/features/authentication/auth_api_service.dart';
import 'package:chorebuddies_flutter/features/authentication/auth_client.dart';
import 'package:chorebuddies_flutter/features/authentication/auth_manager.dart';
import 'package:chorebuddies_flutter/features/chores/chore_service.dart';
import 'package:chorebuddies_flutter/features/households/household_service.dart';
import 'package:chorebuddies_flutter/features/notifications/notification_preferences_service.dart';
import 'package:chorebuddies_flutter/features/notifications/notification_service.dart';
import 'package:chorebuddies_flutter/features/redeemedrewards/models/redeemed_reward.dart';
import 'package:chorebuddies_flutter/features/redeemedrewards/redeemed_rewards_service.dart';
import 'package:chorebuddies_flutter/features/rewards/reward_service.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/scheduled_chores_service.dart';
import 'package:chorebuddies_flutter/features/users/user_service.dart';
import 'package:chorebuddies_flutter/features/chat/chat_service.dart';
import 'package:chorebuddies_flutter/core/app_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'features/exception_handler/api_exception_interceptor.dart';

Future<Widget> buildDependencies({required Widget child}) async {
  await AppConfig.init();
  final baseUrl = AppConfig.baseUrl;
  debugPrint("App configured with Base URL: $baseUrl");

  return MultiProvider(
    providers: [
      Provider<AuthApiService>(
        create: (ctx) => AuthApiService(
          baseUrl: baseUrl,
          httpClient: ApiExceptionInterceptor(inner: http.Client()),
        ), // Client with ApiExceptionInterceptor
      ),
      ChangeNotifierProvider<AuthManager>(
        create: (ctx) =>
            AuthManager(apiService: ctx.read<AuthApiService>())..init(),
      ),
      Provider<AuthClient>(
        create: (ctx) =>
            AuthClient(baseUrl: baseUrl, authManager: ctx.read<AuthManager>()),
      ),
      // Main client - ApiExceptionInterceptor + AuthClient
      Provider<http.Client>(
        create: (ctx) {
          final authClient = ctx.read<AuthClient>();
          return ApiExceptionInterceptor(
            inner: authClient,
          ); // baseClient -> AuthClient -> Interceptor
        },
      ),
      Provider(
        create: (ctx) => ChoreService(httpClient: ctx.read<http.Client>()),
      ),
      Provider(
        create: (ctx) => UserService(httpClient: ctx.read<http.Client>()),
      ),
      ChangeNotifierProvider<HouseholdService>(
        create: (ctx) => HouseholdService(
          httpClient: ctx.read<http.Client>(),
          authManager: ctx.read<AuthManager>(),
        ),
      ),
      Provider<NotificationPreferencesService>(
        create: (ctx) =>
            NotificationPreferencesService(httpClient: ctx.read<http.Client>()),
      ),
      Provider<NotificationService>(create: (ctx) => NotificationService()),
      Provider<ScheduledChoresService>(
        create: (ctx) =>
            ScheduledChoresService(httpClient: ctx.read<http.Client>()),
      ),
      Provider<RewardService>(
        create: (ctx) =>
            RewardService(httpClient: ctx.read<http.Client>()),
      ),
      Provider<RedeemedRewardService>(
        create: (ctx) =>
            RedeemedRewardService(httpClient: ctx.read<http.Client>()),
      ),
      ChangeNotifierProvider<ChatService>(
        create: (ctx) => ChatService(
          httpClient: ctx.read<http.Client>(),
          authManager: ctx.read<AuthManager>(),
        ),
      ),
    ],
    child: child,
  );
}

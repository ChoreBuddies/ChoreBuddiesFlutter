import 'package:chorebuddies_flutter/authentication/auth_api_service.dart';
import 'package:chorebuddies_flutter/authentication/auth_client.dart';
import 'package:chorebuddies_flutter/authentication/auth_manager.dart';
import 'package:chorebuddies_flutter/chores/chore_service.dart';
import 'package:chorebuddies_flutter/users/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

Widget buildDependencies({required Widget child}) {
  final baseUrl = dotenv.env['base_url'];
  if (baseUrl == null || baseUrl.isEmpty) {
    throw Exception('Missing required environment variable: base_url');
  }

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
    ],
    child: child,
  );
}

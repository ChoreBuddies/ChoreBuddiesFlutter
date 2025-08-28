import 'package:chorebuddies_flutter/api/http_util.dart';
import 'package:chorebuddies_flutter/chores/chore_service.dart';
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
      Provider<HttpUtil>(create: (_) => HttpUtil(baseUrl: baseUrl)),
      Provider(create: (ctx) => ChoreService(httpUtil: ctx.read<HttpUtil>())),
    ],
    child: child,
  );
}

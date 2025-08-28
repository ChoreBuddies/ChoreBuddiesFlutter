import 'package:chorebuddies_flutter/api/http_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget buildDependencies({required Widget child}) {
  return MultiProvider(
    providers: [
      Provider<HttpUtil>(
        create: (_) => HttpUtil(baseUrl: 'https://api.example.com'),
      ),
    ],
    child: child,
  );
}

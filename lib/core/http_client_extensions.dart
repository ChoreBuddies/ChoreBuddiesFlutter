
import 'package:http/http.dart' as http;

import 'app_config.dart';

extension HttpClientExtensions on http.Client {
  Uri uri(String path) {
    final cleanPath = path.startsWith('/') ? path : '/$path';
    return Uri.parse('${AppConfig.baseUrl}$cleanPath');
  }
}
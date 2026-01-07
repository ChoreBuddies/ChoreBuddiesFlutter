import 'dart:io';
import 'package:flutter/foundation.dart'; // Potrzebne do kIsWeb

class AppConfig {
  // ---------------------------------------------------------------------------
  // Optional: can be set manual ip
  static const String? _manualIp = null;
  // ---------------------------------------------------------------------------

  static const String _port = "5000";
  static const String _apiPath = "/api/v1";

  static String get _host {
    if (_manualIp != null) {
      return _manualIp!;
    }

    // Flutter Web
    if (kIsWeb) {
      return "localhost";
    }

    // Android Emulator
    if (Platform.isAndroid) {
      return "10.0.2.2";
    }

    // Default: iOS Simulator / Desktop
    return "localhost";
  }

  static String get apiBaseUrl {
    return "http://$_host:$_port$_apiPath";
  }
}
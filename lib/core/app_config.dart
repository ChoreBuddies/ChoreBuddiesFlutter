import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart'; // Potrzebne do kIsWeb

class AppConfig {
  // ---------------------------------------------------------------------------
  // Optional: can be set manual ip
  static const String? _manualIp = null;
  // ---------------------------------------------------------------------------

  static const String _port = "5000";
  static const String _apiPath = "/api/v1";

  static Future<String> get _host async {
    if (_manualIp != null) {
      return _manualIp!;
    }

    // Flutter Web
    if (kIsWeb) {
      return "localhost";
    }

    // Android Emulator
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      final isEmulator = androidInfo.isPhysicalDevice == false;

      if (isEmulator) {
        return "10.0.2.2"; // Android emulator
      } else {
        return "localhost"; // Physical device
      }
    }

    // Default: iOS Simulator / Desktop
    return "localhost";
  }

  static Future<String> get apiBaseUrl async {
    final host = await _host;
    return "http://$host:$_port$_apiPath";
  }
}

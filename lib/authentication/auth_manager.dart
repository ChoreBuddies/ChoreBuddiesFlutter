import 'package:chorebuddies_flutter/authentication/auth_api_service.dart';
import 'package:chorebuddies_flutter/authentication/authentication_result_dto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthManager extends ChangeNotifier {
  final AuthApiService _authApiService;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String? _token;
  String? _refreshToken;

  AuthManager({required AuthApiService apiService})
    : _authApiService = apiService;

  bool get isLoggedIn => _token != null;

  String? get token => _token;
  String? get refreshToken => _refreshToken;

  Future<void> init() async {
    _token = await _storage.read(key: 'auth_token');
    _refreshToken = await _storage.read(key: 'refresh_token');
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    try {
      final authenticationResultDto = await _authApiService.login(
        email,
        password,
      );
      await storeTokens(
        authenticationResultDto.accessToken,
        authenticationResultDto.refreshToken,
      );

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Login failed: $e');
    }
    return false;
  }

  Future<bool> register(String email, String password, String userName) async {
    try {
      final success = await _authApiService.register(email, password, userName);
      return success;
    } catch (e) {
      debugPrint('Register failed: $e');
      return false;
    }
  }

  Future<void> logout() async {
    _token = null;
    _refreshToken = null;
    await _storage.delete(key: 'auth_token');
    await _storage.delete(key: 'refresh_token');
    notifyListeners();
  }

  Future<void> storeTokens(String accessToken, String refreshToken) async {
    _token = accessToken;
    await _storage.write(key: 'auth_token', value: _token);
    _refreshToken = refreshToken;
    await _storage.write(key: 'refresh_token', value: _refreshToken);
  }

  Future<bool> refreshTokens() async {
    if (refreshToken != null) {
      try {
        final newTokens = await _authApiService.refreshTokens(refreshToken!);
        await storeTokens(newTokens.accessToken, newTokens.refreshToken);
        return true;
      } catch (Exception) {
        await logout();
        rethrow;
      }
    }
    return false;
  }
}

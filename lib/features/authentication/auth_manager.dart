import 'package:chorebuddies_flutter/features/authentication/auth_api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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

  Map<String, dynamic>? get _decodedToken {
    if (_token == null) return null;
    try {
      return JwtDecoder.decode(_token!);
    } catch (e) {
      debugPrint('Error occured while decoding token: $e');
      return null;
    }
  }

  String? get userId {
    return _decodedToken?['nameid'];
  }

  String? get householdId {
    return _decodedToken?['HouseholdId'];
  }

  bool get hasHousehold => householdId != null && householdId!.isNotEmpty;

  String? get role {
    return _decodedToken?['role'];
  }

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

      return true;
    } catch (e) {
      debugPrint('Login failed: $e');
    }
    return false;
  }

  Future<bool> register(
    String userName,
    String email,
    String password,
    String firstName,
    String lastName,
    DateTime dateOfBirth,
  ) async {
    try {
      final success = await _authApiService.register(
        email,
        password,
        userName,
        firstName,
        lastName,
        dateOfBirth,
      );
      await storeTokens(success.accessToken, success.refreshToken);
      return true;
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
    notifyListeners();
  }

  Future<bool> refreshTokens() async {
    if (refreshToken != null) {
      try {
        final newTokens = await _authApiService.refreshTokens(
          refreshToken!,
          _token!,
        );
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

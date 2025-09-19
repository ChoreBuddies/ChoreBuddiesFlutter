import 'dart:convert';

import 'package:chorebuddies_flutter/authentication/auth_client.dart';
import 'package:chorebuddies_flutter/users/models/user.dart';

class UserService {
  final AuthClient _authClient;
  final String endpoint = '/users';
  UserService({required AuthClient authClient}) : _authClient = authClient;

  Future<User> getMe() async {
    try {
      final response = await _authClient.get(_authClient.uri('$endpoint/me'));
      final Map<String, dynamic> meJson = jsonDecode(response.body);

      return User.fromJson(meJson);
    } catch (e) {
      throw Exception('Error fetching current user: $e');
    }
  }
}

import 'dart:convert';
import 'package:chorebuddies_flutter/core/http_client_extensions.dart';
import 'package:chorebuddies_flutter/features/predefined_rewards/predefined_rewards_constants.dart';
import 'package:http/http.dart' as http;

import 'models/predefined_reward_dto.dart';

class PredefinedRewardService {
  final http.Client _httpClient;

  PredefinedRewardService({required http.Client httpClient})
    : _httpClient = httpClient;

  Future<List<PredefinedRewardDto>> getAllPredefinedRewards() async {
    final response = await _httpClient.get(
      _httpClient.uri(PredefinedRewardsConstants.apiEndpointGetAll),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => PredefinedRewardDto.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load predefined rewards');
    }
  }
}

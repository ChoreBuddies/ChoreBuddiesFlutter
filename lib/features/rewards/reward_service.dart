import 'dart:convert';

import 'package:chorebuddies_flutter/core/http_client_extensions.dart';
import 'package:chorebuddies_flutter/features/predefined_rewards/models/predefined_reward_request.dart';
import 'package:chorebuddies_flutter/features/rewards/models/reward_dto.dart';
import 'package:chorebuddies_flutter/features/rewards/models/create_reward_dto.dart';
import 'package:http/http.dart' as http;

class RewardService {
  final http.Client _httpClient;
  final String endpoint = '/rewards';
  RewardService({required http.Client httpClient}) : _httpClient = httpClient;

  Future<Reward?> getReward(int id) async {
    try {
      final response = await _httpClient.get(_httpClient.uri('$endpoint/$id'));
      final Map<String, dynamic> jsonReward = jsonDecode(response.body);

      return Reward.fromJson(jsonReward);
    } catch (e) {
      throw Exception('error getting reward: $e');
    }
  }

  Future<Reward?> createReward(Reward reward) async {
    try {
      final response = await _httpClient.post(
        _httpClient.uri('$endpoint/add'),
        body: jsonEncode(
          CreateRewardDto(
            reward.name,
            reward.description,
            reward.householdId,
            reward.cost,
            reward.quantityAvailable,
          ).toJson(),
        ),
      );
      final Map<String, dynamic> jsonReward = jsonDecode(response.body);

      return Reward.fromJson(jsonReward);
    } catch (e) {
      throw Exception('error adding reward: $e');
    }
  }

  Future<void> addPredefinedRewards(PredefinedRewardRequest request) async {
    final response = await _httpClient.post(
      _httpClient.uri('$endpoint/add-predefined'),
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      return;
    }
  }

  Future<Reward?> updateReward(Reward reward) async {
    try {
      final response = await _httpClient.post(
        _httpClient.uri('$endpoint/update'),
        body: jsonEncode(reward.toJson()),
      );
      final Map<String, dynamic> jsonReward = jsonDecode(response.body);

      return Reward.fromJson(jsonReward);
    } catch (e) {
      throw Exception('error updating reward: $e');
    }
  }

  Future<List<Reward>> getHouseholdRewards() async {
    try {
      final response = await _httpClient.get(
        _httpClient.uri('$endpoint/householdRewards'),
      );
      final List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList
          .map((json) => Reward.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('error getting household rewards: $e');
    }
  }
}

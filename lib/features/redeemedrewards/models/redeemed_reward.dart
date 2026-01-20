import 'package:json_annotation/json_annotation.dart';

part 'redeemed_reward.g.dart';

@JsonSerializable()
class RedeemedReward {
  int id;
  int userId;
  String name;
  String description;
  int pointsSpent;
  bool isFulfilled;

  RedeemedReward(
    this.id,
    this.userId,
    this.name,
    this.description,
    this.pointsSpent,
    this.isFulfilled
  );

  factory RedeemedReward.fromJson(Map<String, dynamic> json) => _$RedeemedRewardFromJson(json);

  Map<String, dynamic> toJson() => _$RedeemedRewardToJson(this);
}
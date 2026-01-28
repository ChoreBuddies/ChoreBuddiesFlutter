import 'package:json_annotation/json_annotation.dart';

part 'create_redeemed_reward.g.dart';

@JsonSerializable()
class CreateRedeemedReward {
  int rewardId;
  bool isFulfilled;

  CreateRedeemedReward(
    this.rewardId,
    this.isFulfilled,
  );

  factory CreateRedeemedReward.fromJson(Map<String, dynamic> json) => _$CreateRedeemedRewardFromJson(json);

  Map<String, dynamic> toJson() => _$CreateRedeemedRewardToJson(this);
}
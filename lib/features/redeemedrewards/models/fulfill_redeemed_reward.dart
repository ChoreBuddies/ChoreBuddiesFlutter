import 'package:json_annotation/json_annotation.dart';

part 'fulfill_redeemed_reward.g.dart';

@JsonSerializable()
class FulfillRedeemedReward {
  int redeemedRewardId;

  FulfillRedeemedReward(
    this.redeemedRewardId,
  );

  factory FulfillRedeemedReward.fromJson(Map<String, dynamic> json) => _$FulfillRedeemedRewardFromJson(json);

  Map<String, dynamic> toJson() => _$FulfillRedeemedRewardToJson(this);
}
import 'package:json_annotation/json_annotation.dart';

part 'reward_dto.g.dart';

@JsonSerializable()
class Reward {
  int? id;
  String name;
  String description;
  int householdId;
  int cost;
  int quantityAvailable = 1;

  Reward(this.id, this.name, this.description, this.householdId, this.cost, this.quantityAvailable);
  factory Reward.fromJson(Map<String, dynamic> json) =>
      _$RewardFromJson(json);
  Map<String, dynamic> toJson() => _$RewardToJson(this);
}
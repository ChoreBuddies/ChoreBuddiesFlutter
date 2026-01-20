import 'package:json_annotation/json_annotation.dart';

part 'create_reward_dto.g.dart';

@JsonSerializable()
class CreateRewardDto {
  String name;
  String description;
  int householdId;
  int cost;
  int quantityAvailable = 1;

  CreateRewardDto(this.name, this.description, this.householdId, this.cost, this.quantityAvailable);
  factory CreateRewardDto.fromJson(Map<String, dynamic> json) =>
      _$CreateRewardDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CreateRewardDtoToJson(this);
}
import 'package:json_annotation/json_annotation.dart';

part 'predefined_reward_dto.g.dart';

@JsonSerializable()
class PredefinedRewardDto {
  final int id;
  final String name;
  final String description;
  final int cost;
  final int quantityAvailable;

  PredefinedRewardDto({
    required this.id,
    required this.name,
    required this.description,
    required this.cost,
    required this.quantityAvailable,
  });

  factory PredefinedRewardDto.fromJson(Map<String, dynamic> json) =>
      _$PredefinedRewardDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PredefinedRewardDtoToJson(this);
}
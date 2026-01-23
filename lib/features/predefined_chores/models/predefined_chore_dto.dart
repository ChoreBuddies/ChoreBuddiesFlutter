import 'package:chorebuddies_flutter/features/scheduled_chores/models/scheduled_chores_tile_view_dto.dart' show Frequency;
import 'package:json_annotation/json_annotation.dart';

part 'predefined_chore_dto.g.dart';

@JsonSerializable()
class PredefinedChoreDto {
  final int id;
  final String name;
  final String description;
  final String room;
  final int rewardPointsCount;
  final int choreDuration;
  final Frequency frequency;
  final int everyX;

  PredefinedChoreDto({
    required this.id,
    required this.name,
    required this.description,
    required this.room,
    required this.rewardPointsCount,
    required this.choreDuration,
    required this.frequency,
    required this.everyX,
  });

  factory PredefinedChoreDto.fromJson(Map<String, dynamic> json) =>
      _$PredefinedChoreDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PredefinedChoreDtoToJson(this);
}
import 'package:chorebuddies_flutter/features/scheduled_chores/models/scheduled_chores_tile_view_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_scheduled_chore_dto.g.dart';

@JsonSerializable()
class CreateScheduledChoreDto {
  String name;
  String description;
  int? userId;
  String room;
  int rewardPointsCount;
  Frequency frequency;
  int? minAge;
  int choreDuration;
  int everyX;

  CreateScheduledChoreDto({
    required this.name,
    required this.description,
    this.userId,
    required this.room,
    required this.rewardPointsCount,
    required this.frequency,
    this.minAge,
    required this.choreDuration,
    required this.everyX,
  });

  factory CreateScheduledChoreDto.fromJson(Map<String, dynamic> json) =>
      _$CreateScheduledChoreDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateScheduledChoreDtoToJson(this);
}

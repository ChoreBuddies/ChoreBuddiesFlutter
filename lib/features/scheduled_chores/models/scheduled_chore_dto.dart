import 'package:chorebuddies_flutter/features/scheduled_chores/models/scheduled_chores_tile_view_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'scheduled_chore_dto.g.dart';

@JsonSerializable()
class ScheduledChoreDto {
  int id;
  int minAge;
  String name;
  String description;
  int? userId;
  String room;
  int rewardPointsCount;
  int householdId;
  int choreDuration; // days
  Frequency frequency;
  DateTime? lastGenerated;
  int everyX;

  ScheduledChoreDto({
    required this.id,
    required this.minAge,
    required this.name,
    required this.description,
    this.userId,
    required this.room,
    required this.rewardPointsCount,
    required this.householdId,
    required this.choreDuration,
    required this.frequency,
    this.lastGenerated,
    required this.everyX,
  });

  factory ScheduledChoreDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduledChoreDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduledChoreDtoToJson(this);
}

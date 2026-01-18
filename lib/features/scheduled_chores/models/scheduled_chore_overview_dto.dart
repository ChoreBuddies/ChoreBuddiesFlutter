import 'package:json_annotation/json_annotation.dart';

part 'scheduled_chore_overview_dto.g.dart';

@JsonSerializable()
class ScheduledChoreOverviewDto {
  int id;
  String name;
  int? userId;
  String room;

  ScheduledChoreOverviewDto({
    required this.id,
    required this.name,
    this.userId,
    required this.room,
  });

  factory ScheduledChoreOverviewDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduledChoreOverviewDtoFromJson(json);
}

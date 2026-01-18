import 'package:json_annotation/json_annotation.dart';

part 'scheduled_chores_tile_view_dto.g.dart';

enum Frequency { daily, weekly, monthly, quarterly, yearly }

@JsonSerializable()
class ScheduledChoreTileViewDto {
  int id;
  String name;
  String? userName;
  String? description;
  Frequency frequency;

  ScheduledChoreTileViewDto({
    required this.id,
    required this.name,
    this.userName,
    this.description,
    required this.frequency,
  });
  factory ScheduledChoreTileViewDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduledChoreTileViewDtoFromJson(json);
}

import 'package:json_annotation/json_annotation.dart';

part 'scheduled_chores_tile_view_dto.g.dart';

enum Frequency {
  @JsonValue(0)
  daily,
  @JsonValue(1)
  weekly,
  @JsonValue(2)
  monthly,
  @JsonValue(3)
  quarterly,
  @JsonValue(4)
  yearly,
}

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

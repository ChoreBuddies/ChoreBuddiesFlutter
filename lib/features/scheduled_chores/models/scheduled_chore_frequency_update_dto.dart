import 'package:chorebuddies_flutter/features/scheduled_chores/models/scheduled_chores_tile_view_dto.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class ScheduledChoreFrequencyUpdateDto {
  int id;
  Frequency frequency;
  ScheduledChoreFrequencyUpdateDto(this.id, this.frequency);

  factory ScheduledChoreFrequencyUpdateDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ScheduledChoreFrequencyUpdateDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ScheduledChoreFrequencyUpdateDtoToJson(this);
}

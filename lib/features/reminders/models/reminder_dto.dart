import 'package:json_annotation/json_annotation.dart';

part 'reminder_dto.g.dart';

@JsonSerializable()
class ReminderDto {
  final DateTime remindAt;
  final int choreId;

  ReminderDto({required this.remindAt, required this.choreId});

  factory ReminderDto.fromJson(Map<String, dynamic> json) =>
      _$ReminderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ReminderDtoToJson(this);
}

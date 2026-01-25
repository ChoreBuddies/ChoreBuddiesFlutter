// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReminderDto _$ReminderDtoFromJson(Map<String, dynamic> json) => ReminderDto(
  remindAt: DateTime.parse(json['remindAt'] as String),
  choreId: (json['choreId'] as num).toInt(),
);

Map<String, dynamic> _$ReminderDtoToJson(ReminderDto instance) =>
    <String, dynamic>{
      'remindAt': instance.remindAt.toIso8601String(),
      'choreId': instance.choreId,
    };

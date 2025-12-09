// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_preferences_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationPreferencesDto _$NotificationPreferencesDtoFromJson(
  Map<String, dynamic> json,
) => NotificationPreferencesDto(
  $enumDecode(_$NotificationEventEnumMap, json['type']),
  $enumDecode(_$NotificationChannelEnumMap, json['channel']),
  json['isEnabled'] as bool,
);

Map<String, dynamic> _$NotificationPreferencesDtoToJson(
  NotificationPreferencesDto instance,
) => <String, dynamic>{
  'type': _$NotificationEventEnumMap[instance.type]!,
  'channel': _$NotificationChannelEnumMap[instance.channel]!,
  'isEnabled': instance.isEnabled,
};

const _$NotificationEventEnumMap = {
  NotificationEvent.newChore: 1,
  NotificationEvent.rewardRequest: 2,
  NotificationEvent.choreCompleted: 3,
};

const _$NotificationChannelEnumMap = {
  NotificationChannel.email: 1,
  NotificationChannel.push: 2,
};

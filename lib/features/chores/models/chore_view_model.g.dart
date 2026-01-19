// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chore_view_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChoreViewModel _$ChoreViewModelFromJson(Map<String, dynamic> json) =>
    ChoreViewModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String? ?? '',
      room: json['room'] as String? ?? '',
      description: json['description'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      rewardPointsCount: (json['rewardPointsCount'] as num?)?.toInt() ?? 0,
      dueDate: json['dueDate'] == null
          ? null
          : DateTime.parse(json['dueDate'] as String),
      householdId: (json['householdId'] as num?)?.toInt() ?? 0,
      isScheduled: json['isScheduled'] as bool? ?? false,
      choreDuration: (json['choreDuration'] as num?)?.toInt() ?? 1,
      everyX: (json['everyX'] as num?)?.toInt() ?? 1,
      frequency:
          $enumDecodeNullable(_$FrequencyEnumMap, json['frequency']) ??
          Frequency.daily,
      status:
          $enumDecodeNullable(_$StatusEnumMap, json['status']) ??
          Status.unassigned,
    );

Map<String, dynamic> _$ChoreViewModelToJson(ChoreViewModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'room': instance.room,
      'description': instance.description,
      'userId': instance.userId,
      'rewardPointsCount': instance.rewardPointsCount,
      'dueDate': instance.dueDate?.toIso8601String(),
      'householdId': instance.householdId,
      'isScheduled': instance.isScheduled,
      'choreDuration': instance.choreDuration,
      'everyX': instance.everyX,
      'frequency': _$FrequencyEnumMap[instance.frequency]!,
      'status': _$StatusEnumMap[instance.status]!,
    };

const _$FrequencyEnumMap = {
  Frequency.daily: 0,
  Frequency.weekly: 1,
  Frequency.monthly: 2,
  Frequency.quarterly: 3,
  Frequency.yearly: 4,
};

const _$StatusEnumMap = {
  Status.unassigned: 0,
  Status.assigned: 1,
  Status.completed: 2,
};

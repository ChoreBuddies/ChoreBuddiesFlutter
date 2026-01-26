// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chore_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChoreDto _$ChoreDtoFromJson(Map<String, dynamic> json) => ChoreDto(
  (json['id'] as num).toInt(),
  json['name'] as String,
  json['description'] as String?,
  (json['userId'] as num?)?.toInt(),
  $enumDecode(_$StatusEnumMap, json['status']),
  json['room'] as String?,
  (json['rewardPointsCount'] as num).toInt(),
  DateTime.parse(json['dueDate'] as String),
);

Map<String, dynamic> _$ChoreDtoToJson(ChoreDto instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'userId': instance.userId,
  'dueDate': instance.dueDate.toIso8601String(),
  'status': _$StatusEnumMap[instance.status]!,
  'room': instance.room,
  'rewardPointsCount': instance.rewardPointsCount,
};

const _$StatusEnumMap = {
  Status.unassigned: 0,
  Status.assigned: 1,
  Status.completed: 2,
  Status.unverifiedcompleted: 3,
};

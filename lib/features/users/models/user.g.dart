// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  (json['id'] as num).toInt(),
  json['firstName'] as String?,
  json['lastName'] as String?,
  DateTime.parse(json['dateOfBirth'] as String),
  json['userName'] as String,
  json['email'] as String?,
  (json['householdId'] as num?)?.toInt(),
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'dateOfBirth': instance.dateOfBirth.toIso8601String(),
  'userName': instance.userName,
  'email': instance.email,
  'householdId': instance.householdId,
};

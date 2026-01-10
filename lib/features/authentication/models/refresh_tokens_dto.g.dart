// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_tokens_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefreshTokensDto _$RefreshTokensDtoFromJson(Map<String, dynamic> json) =>
    RefreshTokensDto(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );

Map<String, dynamic> _$RefreshTokensDtoToJson(RefreshTokensDto instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
    };

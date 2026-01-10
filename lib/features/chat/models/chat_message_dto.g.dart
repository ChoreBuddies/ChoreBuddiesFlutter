// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageDto _$ChatMessageDtoFromJson(Map<String, dynamic> json) =>
    ChatMessageDto(
      id: (json['id'] as num).toInt(),
      senderName: json['senderName'] as String,
      content: json['content'] as String,
      sentAt: DateTime.parse(json['sentAt'] as String),
      isMine: json['isMine'] as bool,
      clientUniqueId: json['clientUniqueId'] as String?,
    );

Map<String, dynamic> _$ChatMessageDtoToJson(ChatMessageDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'senderName': instance.senderName,
      'content': instance.content,
      'sentAt': instance.sentAt.toIso8601String(),
      'isMine': instance.isMine,
      'clientUniqueId': instance.clientUniqueId,
    };

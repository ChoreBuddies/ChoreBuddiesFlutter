import 'package:json_annotation/json_annotation.dart';

part 'chat_message_dto.g.dart';

@JsonSerializable()
class ChatMessageDto {
  final int id;
  final String senderName;
  final String content;
  final DateTime sentAt;
  final bool isMine;
  final String? clientUniqueId; // String, bo UUID w Darcie to string

  ChatMessageDto({
    required this.id,
    required this.senderName,
    required this.content,
    required this.sentAt,
    required this.isMine,
    this.clientUniqueId,
  });

  factory ChatMessageDto.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ChatMessageDtoToJson(this);
}
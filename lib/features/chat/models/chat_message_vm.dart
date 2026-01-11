import 'chat_message_dto.dart';

enum MessageStatus { none, sending, sent }

class ChatMessageVm {
  int id;
  final String senderName;
  String content;
  DateTime sentAt;
  final bool isMine;
  final String? clientUniqueId;
  MessageStatus status;

  ChatMessageVm({
    required this.id,
    required this.senderName,
    required this.content,
    required this.sentAt,
    required this.isMine,
    this.clientUniqueId,
    this.status = MessageStatus.none,
  });

  factory ChatMessageVm.fromDto(ChatMessageDto dto) {
    return ChatMessageVm(
      id: dto.id,
      senderName: dto.senderName,
      content: dto.content,
      sentAt: dto.sentAt,
      isMine: dto.isMine,
      clientUniqueId: dto.clientUniqueId,
      status: MessageStatus.none,
    );
  }
}
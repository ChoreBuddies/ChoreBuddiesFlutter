import 'package:chorebuddies_flutter/chat/models/chat_message_vm.dart';
import 'package:chorebuddies_flutter/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessageVm message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine;
    final align = isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final color = isMine ? AppColors.primary : Colors.grey[300];
    final textColor = isMine ? Colors.white : Colors.black;

    return Column(
      crossAxisAlignment: align,
      children: [
        if (!isMine)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 4.0),
            child: Text(
              message.senderName,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),

        // Dymek
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: isMine ? const Radius.circular(12) : Radius.zero,
              bottomRight: isMine ? Radius.zero : const Radius.circular(12),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                message.content,
                style: TextStyle(color: textColor),
              ),
              const SizedBox(height: 2),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('HH:mm').format(message.sentAt.toLocal()),
                    style: TextStyle(fontSize: 10, color: textColor.withOpacity(0.7)),
                  ),
                  if (isMine && message.status != MessageStatus.none) ...[
                    const SizedBox(width: 4),
                    Icon(
                      message.status == MessageStatus.sent
                          ? Icons.check_circle
                          : Icons.access_time,
                      size: 10,
                      color: textColor.withOpacity(0.7),
                    ),
                  ],
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
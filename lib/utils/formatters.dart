import 'package:chorebuddies_flutter/notifications/models/notificaiton_event.dart';

String formatDate(DateTime? date) {
  if (date == null) return '';
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

String formatEventName(NotificationEvent event) {
  switch (event) {
    case NotificationEvent.newChore:
      return "New Chore";
    case NotificationEvent.choreCompleted:
      return "Chore Completed";
    case NotificationEvent.rewardRequest:
      return "Reward Request";
    case NotificationEvent.reminder:
      return "Reminder";
    case NotificationEvent.newMessage:
      return "New Message";
    default:
      return event.toString();
  }
}

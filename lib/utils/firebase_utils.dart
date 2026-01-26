import 'package:chorebuddies_flutter/UI/layout/main_layout.dart';
import 'package:chorebuddies_flutter/main.dart';

final Map<String, int> pushScreenIndexMap = {
  '/chore_details': 1,
  '/reward_details': 2,
  '/chat': 3,
};

void handlePushNotification(Map<String, dynamic> data) {
  final screen = data['screen'];
  if (screen == null) {
    // No screen in notification
    return;
  }

  if (mainLayoutKey.currentState != null) {
    mainLayoutKey.currentState!.handlePushScreen(data);
  } else {
    // MainLayout not ready, saving notification for later
    pendingNotificationData = data;
  }
}

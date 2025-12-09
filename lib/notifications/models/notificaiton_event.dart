import 'package:json_annotation/json_annotation.dart';

enum NotificationEvent {
  @JsonValue(1)
  newChore,
  @JsonValue(2)
  rewardRequest,
  @JsonValue(3)
  choreCompleted,
}

import 'package:json_annotation/json_annotation.dart';

enum NotificationChannel {
  @JsonValue(1)
  email,
  @JsonValue(2)
  push,
}

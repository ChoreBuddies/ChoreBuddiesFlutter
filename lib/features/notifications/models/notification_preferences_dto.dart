import 'package:chorebuddies_flutter/features/notifications/models/notificaiton_event.dart';
import 'package:chorebuddies_flutter/features/notifications/models/notification_channel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_preferences_dto.g.dart';

@JsonSerializable()
class NotificationPreferencesDto {
  NotificationEvent type;
  NotificationChannel channel;
  bool isEnabled;
  NotificationPreferencesDto(this.type, this.channel, this.isEnabled);

  factory NotificationPreferencesDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesDtoFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationPreferencesDtoToJson(this);
}

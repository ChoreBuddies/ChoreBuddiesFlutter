import 'package:chorebuddies_flutter/features/notifications/models/notificaiton_event.dart';
import 'package:chorebuddies_flutter/features/notifications/models/notification_preferences_dto.dart';
import 'package:chorebuddies_flutter/features/notifications/notification_preferences_service.dart';
import 'package:chorebuddies_flutter/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPreferencesWidget extends StatefulWidget {
  const NotificationPreferencesWidget({super.key});

  @override
  State<NotificationPreferencesWidget> createState() =>
      _NotificationPreferencesWidgetState();
}

class _NotificationPreferencesWidgetState
    extends State<NotificationPreferencesWidget> {
  bool loading = true;
  List<NotificationPreferencesDto> prefs = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final notificationPreferencesService = context
        .read<NotificationPreferencesService>();
    prefs = await notificationPreferencesService.getPreferences();

    setState(() => loading = false);
  }

  Future<void> changeValue(NotificationPreferencesDto pref, bool value) async {
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() => pref.isEnabled = value);
    final notificationPreferencesService = context
        .read<NotificationPreferencesService>();
    if (!await notificationPreferencesService.updatePreferences(pref)) {
      setState(() => pref.isEnabled = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final Map<NotificationEvent, List<NotificationPreferencesDto>> grouped = {};
    for (var p in prefs) {
      grouped.putIfAbsent(p.type, () => []).add(p);
    }

    return Column(
      children: grouped.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 8),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  formatEventName(entry.key),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Column(
                  children: entry.value.map((pref) {
                    return SwitchListTile(
                      title: Text(pref.channel.name.toUpperCase()),
                      value: pref.isEnabled,
                      onChanged: (value) => changeValue(pref, value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

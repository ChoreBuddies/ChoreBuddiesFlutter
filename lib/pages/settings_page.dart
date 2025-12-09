import 'package:chorebuddies_flutter/notifications/notification_preferences_widget.dart';
import 'package:chorebuddies_flutter/users/profile_widget.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool expandNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: ListView(
        children: [
          Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsetsGeometry.all(12),
              child: ProfileWidget(),
            ),
          ),
          Card(
            margin: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ExpansionTile(
              initiallyExpanded: expandNotifications,
              title: const Text(
                "Notification Preferences",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: const [
                Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: NotificationPreferencesWidget(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

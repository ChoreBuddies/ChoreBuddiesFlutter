import 'package:chorebuddies_flutter/features/chores/models/chore_overview.dart';
import 'package:chorebuddies_flutter/features/chores/models/status.dart';
import 'package:chorebuddies_flutter/features/reminders/reminders_service.dart';
import 'package:chorebuddies_flutter/features/reminders/set_reminder_dialog.dart';
import 'package:chorebuddies_flutter/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChoreView extends StatelessWidget {
  final ChoreOverview choreOverview;
  final ValueChanged<bool?> onCheckBoxChanged;
  final GestureTapCallback onTileTap;

  const ChoreView({
    super.key,
    required this.choreOverview,
    required this.onCheckBoxChanged,
    required this.onTileTap,
  });

  Future<void> showReminderDialog(BuildContext context) async {
    final service = context.read<RemindersService>();

    final DateTime? pickedDate = await showDialog<DateTime>(
      context: context,
      builder: (_) => SetReminderDialog(formatDate: formatDate),
    );

    if (pickedDate != null && context.mounted) {
      final bool success = await service.setReminder(
        choreOverview.id,
        pickedDate,
      );
      if (!context.mounted) return;

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reminder set'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error setting reminder'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        choreOverview.name,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(choreOverview.room),
      onTap: onTileTap,

      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => showReminderDialog(context),
          ),
          Checkbox(
            value: choreOverview.status == Status.completed,
            onChanged: onCheckBoxChanged,
          ),
        ],
      ),
    );
  }
}

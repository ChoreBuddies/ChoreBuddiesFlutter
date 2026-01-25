import 'package:flutter/material.dart';

class SetReminderDialog extends StatefulWidget {
  final String Function(DateTime?) formatDate;

  const SetReminderDialog({super.key, required this.formatDate});

  @override
  State<SetReminderDialog> createState() => _SetReminderDialogState();
}

class _SetReminderDialogState extends State<SetReminderDialog> {
  DateTime? selectedDateTime;

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDate: DateTime.now(),
    );

    if (date == null) return;
    if (!mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set reminder'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectedDateTime == null
                ? 'No date selected'
                : widget.formatDate(selectedDateTime),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _pickDateTime,
            child: const Text('Pick date & time'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: selectedDateTime == null
              ? null
              : () {
                  Navigator.pop(context, selectedDateTime);
                },
          child: const Text('Set reminder'),
        ),
      ],
    );
  }
}

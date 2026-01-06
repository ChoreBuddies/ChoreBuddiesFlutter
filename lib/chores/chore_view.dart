import 'package:chorebuddies_flutter/chores/models/chore_overview.dart';
import 'package:chorebuddies_flutter/chores/models/status.dart';
import 'package:flutter/material.dart';

class ChoreView extends StatelessWidget {
  final ChoreOverview choreOverview;
  final ValueChanged<bool?> onChanged;

  const ChoreView({super.key, required this.choreOverview, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(choreOverview.name,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
              ),),
      subtitle: Text(choreOverview.room),
      secondary: const Icon(Icons.check_box_outlined),
      controlAffinity: ListTileControlAffinity.trailing,
      value: choreOverview.status == Status.completed,
      onChanged: onChanged,
    );
  }
}

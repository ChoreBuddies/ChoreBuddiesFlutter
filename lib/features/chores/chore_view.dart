import 'package:chorebuddies_flutter/features/chores/models/chore_overview.dart';
import 'package:chorebuddies_flutter/features/chores/models/status.dart';
import 'package:flutter/material.dart';

class ChoreView extends StatelessWidget {
  final ChoreOverview choreOverview;
  final ValueChanged<bool?> onCheckBoxChanged;
  final GestureTapCallback onTileTap;

  const ChoreView({super.key, required this.choreOverview, required this.onCheckBoxChanged, required this.onTileTap});

@override
Widget build(BuildContext context) {
  return ListTile(
    title: Text(
      choreOverview.name,
      style: Theme.of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(fontWeight: FontWeight.bold),
    ),
    subtitle: Text(choreOverview.room),
    onTap: onTileTap,

    // checkbox po prawej
    trailing: Checkbox(
      value: choreOverview.status == Status.completed,
      onChanged: onCheckBoxChanged
    ),
  );
}

}

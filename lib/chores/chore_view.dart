import 'package:chorebuddies_flutter/chores/models/chore_overview.dart';
import 'package:chorebuddies_flutter/chores/models/status.dart';
import 'package:flutter/material.dart';

class ChoreView extends StatelessWidget {
  final ChoreOverview choreOverview;

  const ChoreView({super.key, required this.choreOverview});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(choreOverview.name),
      subtitle: Text(choreOverview.room),
      secondary: FlutterLogo(),
      controlAffinity: ListTileControlAffinity.trailing,
      value: choreOverview.status == Status.completed,
      onChanged: (value) => {},
    );
  }
}

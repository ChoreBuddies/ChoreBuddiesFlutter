import 'package:chorebuddies_flutter/chores/models/status.dart';
import 'package:chorebuddies_flutter/chores/models/chore.dart';
import 'package:flutter/material.dart';

class ChoreView extends StatelessWidget {
  final Chore chore;

  const ChoreView({super.key, required this.chore});

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(chore.name),
      subtitle: Text(chore.room),
      secondary: FlutterLogo(),
      controlAffinity: ListTileControlAffinity.trailing,
      value: chore.status == Status.completed,
      onChanged: (value) => {},
    );
  }
}

import 'package:chorebuddies_flutter/tasks/models/status.dart';
import 'package:chorebuddies_flutter/tasks/models/task.dart';

final mockTasks = [
  Task(
    '1',
    'Vacuum The Living',
    'Vacuum the entire living room thoroughly.',
    'Alice',
    DateTime.now().add(Duration(days: 1)),
    Status.assigned,
    'Living Room',
    rewardPointsCount: 10,
  ),
  Task(
    '2',
    'Wash Sins',
    'Clean all dishes after dinner.',
    'Bob',
    DateTime.now().add(Duration(days: 2)),
    Status.unassigned,
    'Kitchen',
    rewardPointsCount: 5,
  ),
  Task(
    '3',
    'Take Out Trash',
    'Take out the trash before 8 PM.',
    'Charlie',
    DateTime.now().add(Duration(days: 3)),
    Status.completed,
    'Outside',
    rewardPointsCount: 8,
  ),
];

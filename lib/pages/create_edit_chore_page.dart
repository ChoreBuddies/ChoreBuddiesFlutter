import 'package:chorebuddies_flutter/chores/create_chore_widget.dart';
import 'package:chorebuddies_flutter/chores/models/chore.dart';
import 'package:chorebuddies_flutter/chores/models/status.dart';
import 'package:chorebuddies_flutter/users/models/user.dart';
import 'package:flutter/material.dart';

class CreateChorePage extends StatefulWidget {
  final Chore? chore;

  const CreateChorePage({
    super.key,
    this.chore,
  });

  @override
  State<CreateChorePage> createState() => _CreateChorePageState();
}

class _CreateChorePageState extends State<CreateChorePage> {
  late ChorePageMode mode;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final roomController = TextEditingController();
  final rewardController = TextEditingController();
  final dueDateController = TextEditingController();

  DateTime? dueDate;
  Status status = Status.unassigned;
  int? assignedTo;

  bool isLoading = false;
  List<User> users = [];

  @override
  void initState() {
    super.initState();

    mode = widget.chore == null
        ? ChorePageMode.create
        : ChorePageMode.view;

    if (widget.chore != null) {
      final c = widget.chore!;
      nameController.text = c.name;
      descriptionController.text = c.description;
      roomController.text = c.room;
      rewardController.text = c.rewardPointsCount.toString();
      dueDate = c.dueDate;
      dueDateController.text = _formatDate(c.dueDate);
      status = c.status;
      assignedTo = c.assignedTo;
    }

    _loadUsers();
  }

  Future<void> _loadUsers() async {
    users = await userService.getUsersFromHousehold();
    setState(() {});
  }

}


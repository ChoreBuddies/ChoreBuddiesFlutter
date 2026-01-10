import 'package:chorebuddies_flutter/chores/create_chore_widget.dart';
import 'package:chorebuddies_flutter/chores/models/chore.dart';
import 'package:chorebuddies_flutter/chores/models/status.dart';
import 'package:chorebuddies_flutter/generic_widgets/g_form_field.dart';
import 'package:chorebuddies_flutter/users/models/user.dart';
import 'package:chorebuddies_flutter/users/user_service.dart';
import 'package:chorebuddies_flutter/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      dueDateController.text = formatDate(c.dueDate);
      status = c.status;
      assignedTo = c.assignedTo;
    }
  }

  Future<void> _loadUsers(UserService userService) async {
    users = await userService.getUsersFromHousehold();
    setState(() {});
  }

   @override
  Widget build(BuildContext context) {
    final userService = context.read<UserService>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          mode == ChorePageMode.create
              ? 'Create Chore'
              : 'Chore Details',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  GFormField(
                    labelText: 'Name',
                    controller: nameController,
                    readonly: mode == ChorePageMode.view,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),

                  GFormField(
                    labelText: 'Description',
                    controller: descriptionController,
                    readonly: mode == ChorePageMode.view,
                    maxLines: 3,
                  ),

                  GFormField(
                    labelText: 'Room',
                    controller: roomController,
                    readonly: mode == ChorePageMode.view,
                  ),

                  GFormField(
                    labelText: 'Reward points',
                    controller: rewardController,
                    keyboardType: TextInputType.number,
                    readonly: mode == ChorePageMode.view,
                  ),

                  GFormField(
                    labelText: 'Due date',
                    controller: dueDateController,
                    readonly: true,
                    onTap: mode != ChorePageMode.view
                        ? _pickDueDate
                        : null,
                  ),

                  const SizedBox(height: 12),

                  _assignedToDropdown(),
                  _statusDropdown(),

                  const SizedBox(height: 16),

                  _actionButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


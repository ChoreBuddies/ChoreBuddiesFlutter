import 'package:chorebuddies_flutter/chores/chore_service.dart';
import 'package:chorebuddies_flutter/chores/models/chore_create.dart';
import 'package:chorebuddies_flutter/chores/models/chore_dto.dart';
import 'package:chorebuddies_flutter/chores/models/status.dart';
import 'package:chorebuddies_flutter/generic_widgets/g_form_field.dart';
import 'package:chorebuddies_flutter/styles/button_styles.dart';
import 'package:chorebuddies_flutter/users/models/user.dart';
import 'package:chorebuddies_flutter/users/user_service.dart';
import 'package:chorebuddies_flutter/utils/formatters.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ChorePageMode { create, view, edit }

class CreateChorePage extends StatefulWidget {
  final int? id;

  const CreateChorePage({
    super.key,
    this.id,
  });

  @override
  State<CreateChorePage> createState() => _CreateChorePageState();
}

class _CreateChorePageState extends State<CreateChorePage> {
  late ChorePageMode mode;

  late ChoreService choreService;

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final roomController = TextEditingController();
  final rewardController = TextEditingController();
  final dueDateController = TextEditingController();

  DateTime dueDate = DateTime.now();
  Status status = Status.unassigned;
  int? assignedTo;

  bool isLoading = false;
  List<User> users = [];
  ChoreDto? chore;

  @override
  void initState() {
    super.initState();

    //mode = widget.chore == null
    mode = widget.id == null
        ? ChorePageMode.create
        : ChorePageMode.view;

    _loadUsers();
    _loadChore(widget.id);
  }

  Future<void> _loadUsers() async {
    final userService = context.read<UserService>();
    users = await userService.getUsersFromHousehold();
    setState(() {});
  }
  Future<void> _loadChore(int? id) async {
      choreService = context.read<ChoreService>();
      if(id != null) {
          chore = await choreService.getChore(id);
      }
      if (chore != null) {
        id = chore!.id;
        nameController.text = chore!.name;
        descriptionController.text = chore!.description;
        roomController.text = chore!.room;
        rewardController.text = chore!.rewardPointsCount.toString();
        dueDate = chore!.dueDate;
        dueDateController.text = formatDate(chore!.dueDate);
        status = chore!.status;
        assignedTo = chore!.assignedTo;
        }
  }

    Future<void> _pickDueDate() async {
    final DateTime initialDate = dueDate;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      helpText: 'Select chore deadline date',
      cancelText: 'Cancel',
      confirmText: 'Select',
    );

    if (pickedDate != null) {
      setState(() {
        dueDate = pickedDate;
        dueDateController.text = formatDate(pickedDate);
      });
    }
  }

    Future<void> _handleSaveChore() async {

    setState(() => isLoading = true);
    if(mode == ChorePageMode.edit) {
      try {
        final result = await choreService.updateChore(
          ChoreDto(chore!.id, nameController.text.trim(), descriptionController.text.trim(), assignedTo, status, 
                    roomController.text.trim(), rewardController.value as int, dueDate)
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result != null ? 'Chore updated successfully!' : 'Saving failed.',
            ),
          ),
        );
        setState(() => mode = ChorePageMode.view);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() => isLoading = false);
      }
    }
    else if(mode == ChorePageMode.create)    {
      try {
        final result = await choreService.createChore(
          ChoreCreate(nameController.text.trim(), descriptionController.text.trim(), assignedTo, status, 
                    roomController.text.trim(), rewardController.value as int, dueDate)
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result != null ? 'Chore created successfully!' : 'Saving failed.',
            ),
          ),
        );
        setState(() => mode = ChorePageMode.view);
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() => isLoading = false);
      }
    }
    mode = ChorePageMode.view;
  }

   @override
  Widget build(BuildContext context) {
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

                  //_assignedToDropdown(),
                  //_statusDropdown(),

                  const SizedBox(height: 16),

                  if (mode == ChorePageMode.view)
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => setState(() => mode = ChorePageMode.edit),
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                        onPressed: () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Confirm'),
                            content: const Text('Mark this chore as done?'),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                              ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('OK')),
                            ],
                          ),
                        );

                        if (ok == true) {
                          choreService.markChoreAsDone(chore!.id);
                          }
                        },
                        icon: const Icon(Icons.check),
                        label: const Text('Mark as done'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                             ),
                            ),
                          ),
                        ],
                      ),
                  if (mode == ChorePageMode.edit)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              setState(() => mode = ChorePageMode.view),
                          style: ElevatedButtonStyles.cancelStyle,
                          child: const Text('Cancel'),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _handleSaveChore(),
                          child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 10,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Save'),
                        ),
                  ],
                ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


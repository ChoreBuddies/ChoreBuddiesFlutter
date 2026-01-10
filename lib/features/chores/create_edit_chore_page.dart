import 'package:chorebuddies_flutter/features/chores/chore_service.dart';
import 'package:chorebuddies_flutter/features/chores/models/chore_create.dart';
import 'package:chorebuddies_flutter/features/chores/models/chore_dto.dart';
import 'package:chorebuddies_flutter/features/chores/models/status.dart';
import 'package:chorebuddies_flutter/UI/widgets/g_form_field.dart';
import 'package:chorebuddies_flutter/UI/styles/button_styles.dart';
import 'package:chorebuddies_flutter/features/users/models/user.dart';
import 'package:chorebuddies_flutter/features/users/user_service.dart';
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

  final _formKey = GlobalKey<FormState>();

  DateTime dueDate = DateTime.now();
  Status status = Status.unassigned;
  int? assignedTo;

  bool isLoading = true;
  List<User> users = [];
  ChoreDto? chore;

  @override
  void initState() {
    super.initState();

    _loadUsers();

    _loadChore(widget.id);
    mode = widget.id == null
        ? ChorePageMode.create
        : ChorePageMode.view;
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
      _loadChoreFields();
      setState(() {
        isLoading = false;
      });
  }
  void _loadChoreFields() {
    if (chore != null) {
        nameController.text = chore!.name;
        if(chore?.description != null) {
          descriptionController.text = chore?.description as String;
        }
        if(chore?.room != null) {
          roomController.text = chore?.room as String;
        }
        rewardController.text = chore!.rewardPointsCount.toString();
        dueDate = chore!.dueDate;
        dueDateController.text = formatDate(chore!.dueDate);
        status = chore!.status;
        assignedTo = chore?.userId;
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
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      if(mode == ChorePageMode.edit) {
        try {
          final result = await choreService.updateChore(
            ChoreDto(chore!.id, nameController.text.trim(), descriptionController.text.trim(), assignedTo, 
                      assignedTo == null ? Status.unassigned : Status.assigned, roomController.text.trim(), 
                      int.tryParse(rewardController.text) ?? 0, dueDate)
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
            ChoreCreate(nameController.text.trim(), descriptionController.text.trim(), assignedTo, 
                        assignedTo == null ? Status.unassigned : Status.assigned, roomController.text.trim(), 
                        int.tryParse(rewardController.text) ?? 0, dueDate)
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result != null ? 'Chore created successfully!' : 'Saving failed.',
              ),
            ),
          );
          if(result != null){
            chore = result;
          }
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
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          mode == ChorePageMode.create
              ? 'Create Chore'
              : 'Chore Details',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
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
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),

                    GFormField(
                      labelText: 'Description',
                      controller: descriptionController,
                      readonly: mode == ChorePageMode.view,
                      maxLines: null,
                    ),

                    GFormField(
                      labelText: 'Room',
                      controller: roomController,
                      readonly: mode == ChorePageMode.view,
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: DropdownButtonFormField<int>(
                        decoration: const InputDecoration(
                          labelText: 'Assigned To',
                          border: OutlineInputBorder(),
                        ),
                        initialValue: users.any((u) => u.id == assignedTo)
                                      ? assignedTo
                                      : null,
                        items: users.map((user) {
                          return DropdownMenuItem<int>(
                            value: user.id,
                            child: Text(user.userName),
                          );
                        }).toList(),
                        onChanged: mode == ChorePageMode.view
                            ? null
                            : (int? newValue) {
                                setState(() {
                                  assignedTo = newValue;
                                });
                              },
                      ),
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
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Required' : null,
                    ),

                    const SizedBox(height: 12),

                    const SizedBox(height: 16),

                    if (mode == ChorePageMode.view && chore!.status != Status.completed)
                      Row(
                        children: [
                          const SizedBox(height: 10),
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
                                    _loadChore(widget.id);
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
                    if (mode != ChorePageMode.view)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if(mode == ChorePageMode.edit)
                            ElevatedButton(
                              onPressed: () =>
                                  setState(() { 
                                    _loadChoreFields();
                                    mode = ChorePageMode.view;
                                    }),
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
      ),
    );
  }
}


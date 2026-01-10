import 'package:chorebuddies_flutter/generic_widgets/g_form_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ChorePageMode {
  view,
  edit,
  create,
}

class CreateChoreWidget extends StatefulWidget {
  const CreateChoreWidget({super.key});
  @override
  State<CreateChoreWidget> createState() => _CreateChorePageState();
}

class _CreateChorePageState extends State<CreateChoreWidget>{
  ChorePageMode mode = ChorePageMode.view;



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
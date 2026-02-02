import 'package:chorebuddies_flutter/UI/styles/button_styles.dart';
import 'package:chorebuddies_flutter/UI/widgets/g_form_field.dart';
import 'package:chorebuddies_flutter/features/chores/create_edit_page/create_edit_chore_page.dart';
import 'package:chorebuddies_flutter/features/chores/models/chore_view_model.dart';
import 'package:chorebuddies_flutter/features/chores/models/status.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/models/scheduled_chores_tile_view_dto.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/scheduled_chore_form_fields.dart';
import 'package:chorebuddies_flutter/features/users/models/user_minimal_dto.dart';
import 'package:chorebuddies_flutter/utils/validators.dart';
import 'package:flutter/material.dart';

import '../../predefined_chores/models/predefined_chore_dto.dart';
import '../../predefined_chores/predefined_chore_dialog.dart';

class CreateEditChoreForm extends StatefulWidget {
  final ChoreViewModel model;
  final List<UserMinimalDto> users;
  final PageMode pageMode;
  final ValueChanged<ChoreViewModel>? onValidSubmit;
  final ValueChanged<PageMode>? onPageModeChanged;
  final VoidCallback? onMarkAsDone;
  final bool isChild;
  final bool showCancel;

  const CreateEditChoreForm({
    super.key,
    required this.model,
    required this.users,
    required this.pageMode,
    this.onValidSubmit,
    this.onPageModeChanged,
    this.showCancel = true,
    this.isChild = true,
    this.onMarkAsDone,
  });

  @override
  State<CreateEditChoreForm> createState() => _CreateEditChoreFormState();
}

class _CreateEditChoreFormState extends State<CreateEditChoreForm> {
  bool _isLoading = false;

  late final TextEditingController nameController;
  late final TextEditingController descriptionController;
  late final TextEditingController roomController;
  late final TextEditingController rewardPointsController;
  late final TextEditingController choreDurationController;
  late final TextEditingController everyXController;

  late PageMode mode;
  late bool isScheduled;
  int? userId;
  DateTime? dueDate;
  Frequency? frequency;

  final _formKey = GlobalKey<FormState>();
  void _onSave() {
    _isLoading = true;
    if (_formKey.currentState?.validate() ?? false) {
      final model = widget.model;
      model.name = nameController.text;
      model.description = descriptionController.text;
      model.room = roomController.text;
      model.userId = userId;
      model.isScheduled = isScheduled;
      model.rewardPointsCount = int.tryParse(rewardPointsController.text) ?? 0;
      model.dueDate = dueDate;
      model.choreDuration = int.tryParse(choreDurationController.text) ?? 0;
      model.everyX = int.tryParse(everyXController.text) ?? 1;
      model.frequency = frequency!;

      widget.onValidSubmit?.call(model);
    }
    _isLoading = false;
  }

  Future<void> _switchToEdit() async {
    setState(() => mode = PageMode.edit);
    widget.onPageModeChanged?.call(mode);
  }

  @override
  void initState() {
    super.initState();

    mode = widget.pageMode;
    final model = widget.model;
    nameController = TextEditingController(text: model.name);
    descriptionController = TextEditingController(text: model.description);
    roomController = TextEditingController(text: model.room);
    choreDurationController = TextEditingController(
      text: model.choreDuration.toString(),
    );
    everyXController = TextEditingController(text: model.everyX.toString());
    rewardPointsController = TextEditingController(
      text: model.rewardPointsCount.toString(),
    );
    isScheduled = model.isScheduled;
    userId = model.userId;
    dueDate = model.dueDate;
    frequency = model.frequency;
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    roomController.dispose();
    choreDurationController.dispose();
    everyXController.dispose();
    super.dispose();
  }

  Future<void> _pickFromTemplate() async {
    final PredefinedChoreDto? template = await showDialog<PredefinedChoreDto>(
      context: context,
      builder: (context) => const PredefinedChoreSelectorDialog(),
    );

    if (template != null) {
      setState(() {
        nameController.text = template.name;
        descriptionController.text = template.description;
        roomController.text = template.room;
        rewardPointsController.text = template.rewardPointsCount.toString();
        choreDurationController.text = template.choreDuration.toString();
        everyXController.text = template.everyX.toString();

        isScheduled = true;

        frequency = template.frequency;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Data loaded from template. You can now edit it."),
            backgroundColor: Colors.blue,
          ),
        );
      }
    }
  }

  bool get _readOnly => mode == PageMode.view;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (mode == PageMode.create) ...[
            OutlinedButton.icon(
              onPressed: _pickFromTemplate,
              icon: const Icon(Icons.copy),
              label: const Text("Select From Predefined"),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(12),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            const SizedBox(height: 20),
          ],
          GFormField(
            labelText: 'Name',
            controller: nameController,
            readonly: mode == PageMode.view,
            validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
          ),

          GFormField(
            labelText: 'Description',
            controller: descriptionController,
            readonly: mode == PageMode.view,
            maxLines: null,
          ),

          GFormField(
            labelText: 'Room',
            controller: roomController,
            readonly: mode == PageMode.view,
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                labelText: 'Assigned To',
                border: OutlineInputBorder(),
              ),
              initialValue: widget.users.any((u) => u.id == userId)
                  ? userId
                  : null,
              items: widget.users.map((user) {
                return DropdownMenuItem<int>(
                  value: user.id,
                  child: Text(user.userName),
                );
              }).toList(),
              onChanged: mode == PageMode.view
                  ? null
                  : (int? newValue) {
                      setState(() {
                        userId = newValue;
                      });
                    },
            ),
          ),

          GFormField(
            labelText: 'Reward points',
            controller: rewardPointsController,
            keyboardType: TextInputType.number,
            readonly: mode == PageMode.view,
            validator: (value) {
              if (_readOnly) return null;
              if (value == null || value.isEmpty) return 'Required';
              return Validators.validate(
                value,
                ValidationType.nonNegativeInteger,
              );
            },
          ),

          Row(
            children: [
              Checkbox(
                value: isScheduled,
                onChanged: mode != PageMode.create
                    ? null
                    : (v) => setState(() => isScheduled = v ?? false),
              ),
              const Text('Is Scheduled'),
            ],
          ),
          const SizedBox(height: 12),

          if (!isScheduled)
            GFormField(
              labelText: 'Due date',
              controller: TextEditingController(
                text: dueDate != null
                    ? '${dueDate!.year}-${dueDate!.month}-${dueDate!.day}'
                    : '',
              ),
              readonly: true,
              onTap: _readOnly
                  ? null
                  : () async {
                      final picked = await showDatePicker(
                        helpText: 'Select chore deadline date',
                        cancelText: 'Cancel',
                        confirmText: 'Select',
                        context: context,
                        initialDate: dueDate ?? DateTime.now(),
                        firstDate: dueDate ?? DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                      );
                      if (picked != null) setState(() => dueDate = picked);
                    },
            ),

          ScheduledChoreFormFields(
            isScheduled: isScheduled,
            mode: mode,
            choreDurationController: choreDurationController,
            everyXController: everyXController,
            frequency: frequency,
            onFrequencyChanged: (f) {
              if (f != null) setState(() => frequency = f);
            },
          ),

          const SizedBox(height: 24),

          if (mode == PageMode.view && !widget.isChild && widget.model.status != Status.completed && widget.model.status != Status.unverifiedcompleted)
            Row(
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => setState(() async => await _switchToEdit()),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: 12),
                if (!isScheduled)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: widget.onMarkAsDone,
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
          if (mode != PageMode.view && !widget.isChild)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (mode == PageMode.edit)
                  ElevatedButton(
                    onPressed: () => setState(() {
                      mode = PageMode.view;
                    }),
                    style: ElevatedButtonStyles.cancelStyle,
                    child: const Text('Cancel'),
                  ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => _onSave(),
                  child: _isLoading
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
    );
  }
}

import 'package:chorebuddies_flutter/features/chores/create_edit_page/create_edit_chore_page.dart';
import 'package:chorebuddies_flutter/UI/widgets/g_form_field.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/models/scheduled_chores_tile_view_dto.dart';
import 'package:chorebuddies_flutter/utils/validators.dart';
import 'package:flutter/material.dart';

class ScheduledChoreFormFields extends StatelessWidget {
  final bool isScheduled;
  final PageMode mode;

  final TextEditingController choreDurationController;
  final TextEditingController everyXController;
  final Frequency? frequency;
  final ValueChanged<Frequency?> onFrequencyChanged;

  const ScheduledChoreFormFields({
    super.key,
    required this.isScheduled,
    required this.mode,
    required this.choreDurationController,
    required this.everyXController,
    required this.frequency,
    required this.onFrequencyChanged,
  });

  bool get _readOnly => mode == PageMode.view;

  @override
  Widget build(BuildContext context) {
    if (!isScheduled) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GFormField(
          labelText: 'Chore Duration (Days)',
          controller: choreDurationController,
          keyboardType: TextInputType.number,
          readonly: _readOnly,
          validator: (value) {
            if (_readOnly) return null;
            if (value == null || value.isEmpty) return 'Required';
            return Validators.validate(value, ValidationType.positiveInteger);
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButtonFormField<Frequency>(
            initialValue: frequency,
            items: Frequency.values
                .map((f) => DropdownMenuItem(value: f, child: Text(f.name)))
                .toList(),
            onChanged: _readOnly ? null : onFrequencyChanged,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Frequency',
              isDense: true,
            ),
          ),
        ),

        GFormField(
          labelText: 'Every X',
          controller: everyXController,
          keyboardType: TextInputType.number,
          readonly: _readOnly,
          validator: (value) {
            if (_readOnly) return null;
            if (value == null || value.isEmpty) return 'Required';
            return Validators.validate(value, ValidationType.positiveInteger);
          },
        ),
      ],
    );
  }
}

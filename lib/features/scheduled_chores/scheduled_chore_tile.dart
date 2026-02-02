import 'package:chorebuddies_flutter/UI/styles/colors.dart';
import 'package:chorebuddies_flutter/features/chores/create_edit_page/create_edit_chore_page.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/models/scheduled_chores_tile_view_dto.dart';
import 'package:flutter/material.dart';

class ScheduledChoreTile extends StatelessWidget {
  final ScheduledChoreTileViewDto chore;
  final Function(Frequency)? onFrequencyChanged;
  final VoidCallback onPressed;

  const ScheduledChoreTile({
    super.key,
    required this.chore,
    required this.onFrequencyChanged,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Expanded(
              child: Text(
                chore.name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            DropdownButton<Frequency>(
              value: chore.frequency,
              items: Frequency.values
                  .map((f) => DropdownMenuItem(value: f, child: Text(f.name)))
                  .toList(),
              onChanged: onFrequencyChanged != null
                  ? (value) {
                      if (value != null) onFrequencyChanged!(value);
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

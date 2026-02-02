import 'package:chorebuddies_flutter/features/chores/create_edit_page/create_edit_chore_page.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/models/scheduled_chores_tile_view_dto.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/scheduled_chore_tile.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/scheduled_chores_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScheduledChoreList extends StatefulWidget {
  final bool canEdit;
  const ScheduledChoreList({super.key, required this.canEdit});
  @override
  State<ScheduledChoreList> createState() => _ScheduledChoreListState();
}

class _ScheduledChoreListState extends State<ScheduledChoreList> {
  List<ScheduledChoreTileViewDto> _chores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final service = context.read<ScheduledChoresService>();

      final choresData = await service.getMyHouseholdChoresOverview();

      if (mounted) {
        setState(() {
          _chores = choresData;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error loading scheduled chores: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleRowPressed(int choreId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CreateEditChorePage(choreId: choreId, isScheduled: true),
      ),
    );
    if (mounted) {
      _loadData();
    }
  }

  void _handleFrequencyChanged(int choreId, Frequency frequency) async {
    final service = context.read<ScheduledChoresService>();

    try {
      final result = await service.updateChoreFrequency(choreId, frequency);

      if (!mounted) return;

      if (result != null) {
        setState(() {
          final index = _chores.indexWhere((c) => c.id == choreId);
          if (index != -1) {
            _chores[index] = result;
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error updating chore frequency'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An unexpected error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Scheduled Chores',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const Divider(),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_chores.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text("No chores scheduled."),
              )
            else
              SizedBox(
                height: 400,
                child: ListView.separated(
                  itemCount: _chores.length,
                  separatorBuilder: (ctx, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final chore = _chores[index];
                    return ScheduledChoreTile(
                      chore: chore,
                      onFrequencyChanged: widget.canEdit
                          ? (Frequency newFrequency) =>
                                _handleFrequencyChanged(chore.id, newFrequency)
                          : null,
                      onPressed: () async => await _handleRowPressed(chore.id),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

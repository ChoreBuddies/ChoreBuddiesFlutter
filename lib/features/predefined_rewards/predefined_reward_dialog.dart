import 'package:chorebuddies_flutter/features/predefined_rewards/predefined_reward_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/predefined_reward_dto.dart';

class PredefinedRewardSelectorDialog extends StatefulWidget {
  const PredefinedRewardSelectorDialog({super.key});

  @override
  State<PredefinedRewardSelectorDialog> createState() => _PredefinedRewardSelectorDialogState();
}

class _PredefinedRewardSelectorDialogState extends State<PredefinedRewardSelectorDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<PredefinedRewardDto> _allRewards = [];
  List<PredefinedRewardDto> _filteredRewards = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterRewards);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final service = context.read<PredefinedRewardService>();
      final result = await service.getAllPredefinedRewards();
      if (mounted) {
        setState(() {
          _allRewards = result..sort((a, b) => a.name.compareTo(b.name));
          _filteredRewards = _allRewards;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _filterRewards() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredRewards = _allRewards;
      } else {
        _filteredRewards = _allRewards.where((element) {
          return element.name.toLowerCase().contains(query) ||
              element.cost.toString().contains(query) ||
              element.quantityAvailable.toString().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 500),
        child: Column(
          children: [
            Text(
              "Choose predefined reward",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Search (name, cost, quantity)...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredRewards.isEmpty
                  ? const Center(child: Text("No rewards found"))
                  : ListView.separated(
                itemCount: _filteredRewards.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final reward = _filteredRewards[index];
                  return ListTile(
                    title: Text(reward.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${reward.cost} pts • ${reward.quantityAvailable}"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).pop(reward);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
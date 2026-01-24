import 'package:chorebuddies_flutter/UI/layout/main_layout.dart';
import 'package:chorebuddies_flutter/features/predefined_rewards/predefined_reward_service.dart';
import 'package:chorebuddies_flutter/features/rewards/reward_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/predefined_reward_dto.dart';
import 'models/predefined_reward_request.dart';

class SetupRewardsPage extends StatefulWidget {
  const SetupRewardsPage({super.key});

  @override
  State<SetupRewardsPage> createState() => _SetupRewardsPageState();
}

class _SetupRewardsPageState extends State<SetupRewardsPage> {
  bool _isLoading = true;
  List<PredefinedRewardDto> _allRewards = [];
  final Set<int> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final service = context.read<PredefinedRewardService>();
      _allRewards = await service.getAllPredefinedRewards();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error while downloading data: $e')),
        );
      }
    }
  }

  Color _getColorForReward(String rewardName) {
    if (rewardName.isEmpty) return const Color(0xFF424242);

    const customColors = [
      Color(0xFF5B6FE6), // Primary Blue
      Color(0xFF3F51B5), // Indigo Blue
      Color(0xFF3949AB), // Deep Indigo
      Color(0xFF303F9F), // Dark Indigo
      Color(0xFF512DA8), // Deep Purple
      Color(0xFF673AB7), // Purple
      Color(0xFF00695C), // Dark Teal
      Color(0xFF00796B), // Teal Green
    ];

    final index = rewardName.hashCode.abs() % customColors.length;
    return customColors[index];
  }

  Future<void> _onSave() async {
    if (_selectedIds.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final request = PredefinedRewardRequest(
        predefinedRewardIds: _selectedIds.toList(),
      );

      await context.read<RewardService>().addPredefinedRewards(request);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rewards have been added!')),
      );

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainLayout()),
            (route) => false,
      );

    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error while saving: $e')),
        );
      }
    }
  }

  void _onSkip() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainLayout()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Setup rewards")),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Choose your starting rewards",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Select the rewards you want to add to your new household.",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rewards",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 12),

                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: _allRewards.map((reward) {
                                final isSelected = _selectedIds.contains(reward.id);
                                final color = _getColorForReward(reward.name);
                                return RawChip(
                                  label: Text('${reward.name} (${reward.cost})'),
                                  selected: isSelected,
                                  showCheckmark: true,
                                  checkmarkColor: color,

                                  backgroundColor: Colors.white,
                                  selectedColor: color.withOpacity(0.15),

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                        color: color,
                                        width: 1.5
                                    ),
                                  ),

                                  labelStyle: TextStyle(
                                    color: color,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),

                                  onSelected: (val) {
                                    setState(() {
                                      if (val) {
                                        _selectedIds.add(reward.id);
                                      } else {
                                        _selectedIds.remove(reward.id);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _onSkip,
                  child: const Text("Skip"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _selectedIds.isNotEmpty ? _onSave : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text("Add selected (${_selectedIds.length})"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
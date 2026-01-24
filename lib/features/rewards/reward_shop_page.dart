import 'package:chorebuddies_flutter/features/redeemedrewards/models/redeemed_reward.dart';
import 'package:chorebuddies_flutter/features/redeemedrewards/redeemed_rewards_service.dart';
import 'package:chorebuddies_flutter/features/rewards/create_edit_page/create_edit_reward_page.dart';
import 'package:chorebuddies_flutter/features/rewards/models/reward_dto.dart';
import 'package:chorebuddies_flutter/features/rewards/reward_service.dart';
import 'package:chorebuddies_flutter/features/users/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RewardsCenterPage extends StatefulWidget {
  const RewardsCenterPage({super.key});

  @override
  State<RewardsCenterPage> createState() => _RewardsCenterPageState();
}

class _RewardsCenterPageState extends State<RewardsCenterPage> {
  int _userPoints = 0;

  List<Reward> _rewards = [];

  List<RedeemedReward> _history = [];

  bool _isLoading = true;
  String? _errorMessage;

  late RewardService rewardService;
  late RedeemedRewardService redeemedRewardService;
  late UserService userService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      rewardService = context.read<RewardService>();
      redeemedRewardService = context.read<RedeemedRewardService>();
      userService = context.read<UserService>();
      final results = await Future.wait([
        rewardService.getHouseholdRewards(),
        redeemedRewardService.getUsersRedeemedRewards(),
        userService.getMyPointsCount(),
      ]);
      if (!mounted) return;
      setState(() {
        _rewards = results[0] as List<Reward>;
        _history = results[1] as List<RedeemedReward>;
        _userPoints = results[2] as int;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Error occured: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _redeemReward(Reward reward) async {
    if (_userPoints < reward.cost) return;
    var result = await redeemedRewardService.redeemReward(reward);
    if (result != null) {
      setState(() {
        _userPoints -= reward.cost;
        _loadData();
      });
    }
  }

  void _showRedeemDialog(Reward reward) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Redeem "${reward.name}"'),
        content: Text('This will cost ${reward.cost} points.\n\nProceed?'),
        actions: [
          TextButton(
            onPressed: () => {Navigator.pop(context)},
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _userPoints >= reward.cost
                ? () {
                    Navigator.pop(context);
                    _redeemReward(reward);
                  }
                : null,
            child: const Text('Redeem'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rewards Center')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateEditRewardPage()),
          ).then((_) => setState(() {}));
        },
        label: const Text('Add new Reward'),
        icon: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _pointsCard(),
          const SizedBox(height: 24),
          _sectionTitle('Redeem'),
          const SizedBox(height: 12),
          ..._rewards.map(_rewardTile),
          const SizedBox(height: 32),
          _sectionTitle('History'),
          const SizedBox(height: 12),
          if (_history.isEmpty) const Text('No rewards redeemed yet'),
          ..._history.map(_historyTile),
        ],
      ),
    );
  }

  Widget _pointsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Text('Your Points'),
          const SizedBox(height: 8),
          Text(
            '$_userPoints',
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }

  Widget _rewardTile(Reward reward) {
    final canRedeem = _userPoints >= reward.cost;

    return Card(
      child: ListTile(
        title: Text(reward.name),
        subtitle: Text(reward.description),
        trailing: ElevatedButton(
          onPressed: canRedeem ? () => _showRedeemDialog(reward) : null,
          child: Text('${reward.cost} pts'),
        ),
      ),
    );
  }

  Widget _historyTile(RedeemedReward reward) {
    final statusText = reward.isFulfilled ? 'Fulfilled' : 'Pending';
    final statusColor = reward.isFulfilled ? Colors.green : Colors.orange;

    return Card(
      child: ListTile(
        title: Text(reward.name),
        subtitle: Text(reward.description),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('-${reward.pointsSpent} pts'),
            const SizedBox(height: 4),
            Text(statusText, style: TextStyle(color: statusColor)),
          ],
        ),
      ),
    );
  }
}

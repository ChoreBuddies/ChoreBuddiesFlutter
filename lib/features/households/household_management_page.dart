import 'package:chorebuddies_flutter/features/households/models/household.dart';
import 'package:chorebuddies_flutter/features/redeemedrewards/models/redeemedreward_username.dart';

import 'package:chorebuddies_flutter/features/users/models/user_role.dart';
import 'package:flutter/material.dart';

class HouseholdManagementPage extends StatefulWidget {
  final Household household;
  final List<UserRole> users;
  final List<RedeemedRewardUsername> redeemedRewards;

  const HouseholdManagementPage({
    super.key,
    required this.household,
    required this.users,
    required this.redeemedRewards,
  });

  @override
  State<HouseholdManagementPage> createState() =>
      _HouseholdManagementPageState();
}

class _HouseholdManagementPageState extends State<HouseholdManagementPage> {
  final List<String> availableRoles = ['Admin', 'Member', 'Child'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Household Management'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _householdDetailsCard(),
          const SizedBox(height: 16),
          _usersCard(),
          const SizedBox(height: 16),
          _rewardsCard(),
        ],
      ),
    );
  }

  // ------------------ Household Details ------------------

  Widget _householdDetailsCard() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.household.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.household.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Edit household',
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const Placeholder(), // TODO: EditHouseholdPage
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // ------------------ Users ------------------

  Widget _usersCard() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Members',
                style: Theme.of(context).textTheme.titleMedium),
            const Divider(),
            ...widget.users.map(_userTile),
          ],
        ),
      ),
    );
  }

  Widget _userTile(UserRole user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              user.userName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          DropdownButton<String>(
            value: user.roleName,
            items: availableRoles
                .map(
                  (role) => DropdownMenuItem(
                    value: role,
                    child: Text(role),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                user.roleName = value;
              });
            },
          ),
          IconButton(
            tooltip: 'Save role',
            icon: const Icon(Icons.check_circle_outline),
            onPressed: () {
              // TODO: save role to backend
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Role updated for ${user.userName}')),
              );
            },
          ),
        ],
      ),
    );
  }

  // ------------------ Rewards ------------------

  Widget _rewardsCard() {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pending Rewards',
                style: Theme.of(context).textTheme.titleMedium),
            const Divider(),
            if (widget.redeemedRewards.isEmpty)
              const Text('No rewards to approve'),
            ...widget.redeemedRewards.map(_rewardTile),
          ],
        ),
      ),
    );
  }

  Widget _rewardTile(RedeemedRewardUsername redeemedReward) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  redeemedReward.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  '${redeemedReward.userName} • ${redeemedReward.pointsSpent} pts',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.check),
            label: const Text('Approve'),
            onPressed: () {
              // TODO: approve reward logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Reward approved for ${redeemedReward.userName}'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

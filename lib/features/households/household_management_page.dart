import 'package:chorebuddies_flutter/features/households/household_service.dart';
import 'package:chorebuddies_flutter/features/households/invitation_code_display.dart';
import 'package:chorebuddies_flutter/features/households/models/household.dart';
import 'package:chorebuddies_flutter/features/redeemedrewards/models/redeemedreward_username.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/scheduled_chore_list.dart';

import 'package:chorebuddies_flutter/features/users/models/user_role.dart';
import 'package:chorebuddies_flutter/features/users/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HouseholdManagementPage extends StatefulWidget {
  const HouseholdManagementPage({super.key});

  @override
  State<HouseholdManagementPage> createState() =>
      _HouseholdManagementPageState();
}

class _HouseholdManagementPageState extends State<HouseholdManagementPage> {
  final List<String> availableRoles = ['Adult', 'Child'];
  Household? _household;
  List<UserRole> _users = [];
  List<RedeemedRewardUsername> _redeemedRewards = [];
  bool _isLoading = true;
  String? _errorMessage;

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
      final householdService = context.read<HouseholdService>();
      final userService = context.read<UserService>();

      final results = await Future.wait([
        householdService.getHousehold(null),
        userService.getUsersRolesFromHousehold(),
        // rewardsService.getPendingRewards(householdId),        // TODO: add getPedingRewards
        Future.value(<RedeemedRewardUsername>[]), // Placeholder for rewards
      ]);

      if (!mounted) return;
      setState(() {
        _household = results[0] as Household;
        _users = results[1] as List<UserRole>;
        _redeemedRewards = results[2] as List<RedeemedRewardUsername>;
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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Try again'),
            ),
          ],
        ),
      );
    }

    if (_household == null) {
      return const Center(child: Text('Household not found.'));
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Household Management'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InvitationCodeDisplay(
            householdName: _household!.name,
            invitationCode: _household!.invitationCode,
          ),
          const SizedBox(height: 16),
          _householdDetailsCard(_household!),
          const SizedBox(height: 16),
          _usersCard(_users),
          const SizedBox(height: 16),
          ScheduledChoreList(),
          const SizedBox(height: 16),
          _rewardsCard(_redeemedRewards),
        ],
      ),
    );
  }

  // ------------------ Household Details ------------------

  Widget _householdDetailsCard(Household household) {
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
                    household.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    household.description,
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
                    builder: (_) =>
                        const Placeholder(), // TODO: EditHouseholdPage
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

  Widget _usersCard(List<UserRole> users) {
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
                    'Members',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'Edit household',
                  icon: const Icon(
                    Icons.edit,
                  ), // TODO: when editing, change it to a save button
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const Placeholder(), // TODO: Edit Roles Logic
                      ),
                    );
                  },
                ),
              ],
            ),
            const Divider(),
            ...users.map(_userTile),
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
                .map((role) => DropdownMenuItem(value: role, child: Text(role)))
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() {
                user.roleName = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // ------------------ Rewards ------------------

  Widget _rewardsCard(List<RedeemedRewardUsername> redeemedRewards) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pending Rewards',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            if (redeemedRewards.isEmpty) const Text('No rewards to approve'),
            ...redeemedRewards.map(_rewardTile),
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
                  content: Text(
                    'Reward approved for ${redeemedReward.userName}',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

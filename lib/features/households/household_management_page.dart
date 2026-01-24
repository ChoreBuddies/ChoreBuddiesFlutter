import 'package:chorebuddies_flutter/UI/styles/button_styles.dart';
import 'package:chorebuddies_flutter/UI/styles/colors.dart';
import 'package:chorebuddies_flutter/features/authentication/auth_manager.dart';
import 'package:chorebuddies_flutter/features/households/create_edit_page/create_edit_household_page.dart';
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

  bool _isEditingRoles = false;
  bool _isSavingRoles = false;
  Map<int, String> _originalRoles = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  bool _isChild() {
    final service = context.read<AuthManager>();
    return service.role == "Child";
  }

  bool _canEditRole(int id) {
    final service = context.read<AuthManager>();
    return !_isChild() &&
        id.toString() != service.userId &&
        _isEditingRoles &&
        !_isSavingRoles;
  }

  Future<void> _saveRoles() async {
    setState(() {
      _isSavingRoles = true;
    });

    final service = context.read<UserService>();
    bool allSuccess = true;

    // Pętla po użytkownikach i wysłanie requestów tylko dla zmienionych ról
    for (var user in _users) {
      final originalRole = _originalRoles[user.id];

      // Jeśli rola się zmieniła, wywołujemy serwis
      if (originalRole != null && originalRole != user.roleName) {
        try {
          final result = await service.updateUserRole(user.id, user.roleName);
          if (!result) {
            allSuccess = false;
          }
        } catch (e) {
          allSuccess = false;
          debugPrint("Error updating user ${user.id}: $e");
        }
      }
    }

    if (!mounted) return;

    setState(() {
      _isSavingRoles = false;
      if (allSuccess) {
        _isEditingRoles = false;
        _originalRoles.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Roles updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Some roles failed to update'),
            backgroundColor: Colors.orange,
          ),
        );
        _isEditingRoles = false;
      }
    });
  }

  void _cancelEditingRoles() {
    setState(() {
      _isEditingRoles = false;
      for (var user in _users) {
        if (_originalRoles.containsKey(user.id)) {
          user.roleName = _originalRoles[user.id]!;
        }
      }
      _originalRoles.clear();
    });
  }

  void _startEditingRoles() {
    setState(() {
      _isEditingRoles = true;
      _originalRoles = {for (var user in _users) user.id: user.roleName};
    });
  }

  void _onRoleDropdownChanged(int userId, String? newRole) {
    if (newRole == null) return;
    setState(() {
      final index = _users.indexWhere((u) => u.id == userId);
      if (index != -1) {
        _users[index].roleName = newRole;
      }
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
                    household.description ?? '',
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
                        CreateEditHouseholdPage(householdId: household.id),
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
                if (!_isEditingRoles && !_isChild())
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Edit roles',
                    onPressed: _startEditingRoles,
                  ),
              ],
            ),
            const Divider(),
            ...users.map(_userTile),
            if (_isEditingRoles) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.cancel),
                      foregroundColor: AppColors.cancel,
                    ),
                    onPressed: _isSavingRoles ? null : _cancelEditingRoles,
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _isSavingRoles ? null : _saveRoles,
                    child: _isSavingRoles
                        ? const SizedBox(
                            width: 20,
                            height: 20,
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
          ],
        ),
      ),
    );
  }

  Widget _userTile(UserRole user) {
    final bool canEdit = _canEditRole(user.id);
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
          canEdit
              ? DropdownButton<String>(
                  value: user.roleName,
                  isDense: true,
                  underline: Container(height: 1, color: Colors.grey),
                  items: availableRoles
                      .map(
                        (role) =>
                            DropdownMenuItem(value: role, child: Text(role)),
                      )
                      .toList(),
                  onChanged: (value) => _onRoleDropdownChanged(user.id, value),
                )
              : Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Text(
                    user.roleName,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                  ),
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

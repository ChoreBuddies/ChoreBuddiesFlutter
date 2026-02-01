import 'package:chorebuddies_flutter/features/authentication/auth_manager.dart';
import 'package:chorebuddies_flutter/features/chores/chore_service.dart';
import 'package:chorebuddies_flutter/features/chores/chore_view.dart';
import 'package:chorebuddies_flutter/features/chores/create_edit_page/create_edit_chore_page.dart';
import 'package:chorebuddies_flutter/features/chores/models/status.dart';
import 'package:chorebuddies_flutter/features/users/models/user.dart';
import 'package:chorebuddies_flutter/features/users/models/user_minimal_dto.dart';
import 'package:chorebuddies_flutter/features/users/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chorebuddies_flutter/features/chores/models/chore_overview.dart';

class ChoresPage extends StatefulWidget {
  const ChoresPage({super.key});

  @override
  State<ChoresPage> createState() => _ChoresPageState();
}

class _ChoresPageState extends State<ChoresPage> {
  bool? val = false;
  int? selectedMemberId;

  @override
  Widget build(BuildContext context) {
    final choreService = context.read<ChoreService>();
    final userService = context.read<UserService>();
    final authManager = context.read<AuthManager>();

    return Scaffold(
      appBar: AppBar(title: const Text("Chores")),

      floatingActionButton: authManager.role == "Child" ? null : FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateEditChorePage()),
          ).then((_) => setState(() {}));
        },
        label: const Text('Add New Chore'),
        icon: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            choreService.getHouseholdChores(),
            userService.getMyHouseholdMembersAsync(),
            userService.getMe(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No chores found, add a new one to see it here!'),
              );
            }

            final List<ChoreOverview> allChores = snapshot.data![0];
            final List<UserMinimalDto> members = snapshot.data![1];
            final User currentUser = snapshot.data![2];
            final currentUserId = selectedMemberId ?? currentUser.id;

            final userChores = allChores
                .where((c) => c.userId == currentUserId)
                .toList();

            final assignedChores = userChores
                .where((c) => c.status == Status.assigned)
                .toList();

            final unassignedChores = allChores
                .where((c) => c.status == Status.unassigned)
                .toList();

            final unverifiedChores = userChores
                .where((c) => c.status == Status.unverifiedcompleted)
                .toList();

            final completedChores = userChores
                .where((c) => c.status == Status.completed)
                .toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: "User",
                        border: OutlineInputBorder(),
                      ),
                      key: ValueKey(currentUserId),
                      initialValue: currentUserId,
                      items: members.map((member) {
                        return DropdownMenuItem(
                          value: member.id,
                          child: Text(member.userName),
                        );
                      }).toList(),
                      onChanged: (newId) {
                        setState(() {
                          selectedMemberId = newId;
                        });
                      },
                    ),
                  ),
                  _getChoresListView(assignedChores, choreService),

                  if (unassignedChores.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildSectionHeader("Unassigned Chores"),
                    _getChoresListView(unassignedChores, choreService),
                  ],

                  if (unverifiedChores.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildSectionHeader("Unverified Chores"),
                    _getChoresListView(unverifiedChores, choreService),
                  ],

                  if (completedChores.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildSectionHeader("Completed Chores"),
                    _getChoresListView(completedChores, choreService),
                  ],
                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  ListView _getChoresListView(
    List<ChoreOverview> chores,
    ChoreService choreService,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: chores.length,
      separatorBuilder: (context, index) => const Divider(height: 1),
      itemBuilder: (context, index) {
        return ChoreView(
          choreOverview: chores[index],
          onCheckBoxChanged: (value) => setState(() {
            if (value != null && value) {
              choreService.markChoreAsDone(chores[index].id);
              chores[index].status = Status.unverifiedcompleted;
            }
          }),
          onTileTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CreateEditChorePage(choreId: chores[index].id),
            ),
          ).then((_) => setState(() {})),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      color: Colors.grey[300],
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      width: double.infinity,
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[700]),
      ),
    );
  }
}

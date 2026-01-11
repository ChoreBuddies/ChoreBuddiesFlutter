import 'dart:math' as math;

import 'package:chorebuddies_flutter/features/chores/chore_service.dart';
import 'package:chorebuddies_flutter/features/chores/chore_view.dart';
import 'package:chorebuddies_flutter/features/chores/models/status.dart';
import 'package:chorebuddies_flutter/features/chores/create_edit_chore_page.dart';
import 'package:chorebuddies_flutter/features/users/models/user.dart';
import 'package:chorebuddies_flutter/features/users/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chorebuddies_flutter/features/chores/models/chore_overview.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  bool? val = false;

  @override
  Widget build(BuildContext context) {
    final choreService = context.read<ChoreService>();
    final userService = context.read<UserService>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            choreService.getChores(),
            userService.getMe(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }  
            
            var chores = snapshot.data![0] as List<ChoreOverview>;
            if (chores.isEmpty) {
              return const Text('No chores found');
            }

            final user = snapshot.data![1] as User;

            chores.sort((a, b) => a.dueDate.compareTo(b.dueDate));
            
            final completedCount = chores.where((chore) => chore.status == Status.completed).length;

            final totalCount = chores.length;

            final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;

            chores = chores.where((c) => c.status == Status.assigned).toList();

            final childrenCount = math.max(1, chores.length * 2 - 1);

            final actualCount = chores.length;

            return Scaffold(
              appBar: AppBar(title: const Text("Home")),
              body: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(8),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Text(
                          'Hello, ${user.userName}',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 16),
                        Text('Chores completion: $completedCount / $totalCount'),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: progress),
                        const SizedBox(height: 16),
                      ]),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if(actualCount == 0 && index == 0)
                        {
                          return Text('Congratulations, You are done for today!',
                          style: Theme.of(context).textTheme.bodyLarge);
                        }
                        final int itemIndex = index ~/ 2;
                        if (index.isEven) {
                        return ChoreView(
                          choreOverview: chores[itemIndex],
                          onCheckBoxChanged: (value) => setState(() {
                            if(value != null && value)
                            {
                              choreService.markChoreAsDone(chores[itemIndex].id);
                            }}),
                            onTileTap: () => {Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => CreateChorePage(id: chores[itemIndex].id),
                                                ),
                                              )},
                        );
                        }
                        return Divider(height: 0, color: Colors.grey);
                      },
                      semanticIndexCallback: (Widget widget, int localIndex) {
                        if (localIndex.isEven) {
                          return localIndex ~/ 2;
                        }
                        return null;
                      },
                      childCount: childrenCount,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

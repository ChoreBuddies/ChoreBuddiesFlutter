import 'package:chorebuddies_flutter/chores/chore_service.dart';
import 'package:chorebuddies_flutter/chores/chore_view.dart';
import 'package:chorebuddies_flutter/chores/models/status.dart';
import 'package:chorebuddies_flutter/users/models/user.dart';
import 'package:chorebuddies_flutter/users/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chorebuddies_flutter/chores/models/chore_overview.dart';

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
            
            final chores = snapshot.data![0] as List<ChoreOverview>;
            if (chores.isEmpty) {
              return const Text('No chores found');
            }

            final user = snapshot.data![1] as User;

            chores.sort((a, b) => a.dueDate.compareTo(b.dueDate));
            
            final completedCount = chores.where((chore) => chore.status == Status.completed).length;

            final totalCount = chores.length;

            final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;

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
                        Text('Chores completion: $completedCount / ${chores.length}'),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: progress),
                        const SizedBox(height: 16),
                      ]),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return ChoreView(
                          choreOverview: chores[index],
                          onChanged: (value) => setState(() {
                            if(value != null && value)
                            {
                              choreService.markChoreAsDone(chores[index]);
                            }}),
                        );
                      },
                      childCount: chores.length,
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

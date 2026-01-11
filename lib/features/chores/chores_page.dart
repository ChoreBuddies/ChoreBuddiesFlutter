import 'package:chorebuddies_flutter/features/chores/chore_service.dart';
import 'package:chorebuddies_flutter/features/chores/chore_view.dart';
import 'package:chorebuddies_flutter/features/chores/create_edit_chore_page.dart';
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

  @override
  Widget build(BuildContext context) {
    final choreService = context.read<ChoreService>();

    return Scaffold(
      appBar: AppBar(title: const Text("My Chores")),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateChorePage()),
          ).then((_) => setState(() {}));
        },
        label: const Text('Add new Chore'),
        icon: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<ChoreOverview>>(
          future: choreService.getChores(),
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

            final chores = snapshot.data!;

            return ListView.separated(
              itemCount: chores.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                return ChoreView(
                  choreOverview: chores[index],
                  onCheckBoxChanged: (value) => setState(() {
                    if (value != null && value) {
                      choreService.markChoreAsDone(chores[index].id);
                    }
                  }),
                  onTileTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CreateChorePage(id: chores[index].id),
                    ),
                  ).then((_) => setState(() {})),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

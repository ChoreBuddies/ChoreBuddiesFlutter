import 'package:chorebuddies_flutter/chores/chore_service.dart';
import 'package:chorebuddies_flutter/chores/chore_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chorebuddies_flutter/chores/models/chore_overview.dart';

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

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Scaffold(
        appBar: AppBar(title: const Text("My Chores")),
        body:        FutureBuilder<List<ChoreOverview>>(
            future: choreService.getChores(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No chores found, add a new one to see it here!');
              }

              final chores = snapshot.data!;

              return ListView.separated(
                itemCount: chores.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  return ChoreView(
                    choreOverview: chores[index],
                    onCheckBoxChanged: (value) => setState(() {
                      if (value != null && value) {
                        choreService.markChoreAsDone(chores[index]);
                      }
                    }),
                    onTileTap: () => {}, //TODO: Change to navigate to chore page when done
                  );
                },
              );
            },
          ),
        )
      ),
    );
  }
}

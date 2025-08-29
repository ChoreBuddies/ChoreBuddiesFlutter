import 'package:chorebuddies_flutter/chores/chore_service.dart';
import 'package:chorebuddies_flutter/chores/chore_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chorebuddies_flutter/chores/models/chore_overview.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final choreService = context.read<ChoreService>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: FutureBuilder<List<ChoreOverview>>(
          future: choreService.getChores(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text('No chores found');
            }

            final items = snapshot.data!;

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ChoreView(choreOverview: items[index]);
              },
            );
          },
        ),
      ),
    );
  }
}

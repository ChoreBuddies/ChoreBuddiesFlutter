import 'package:chorebuddies_flutter/chores/chore_view.dart';
import 'package:flutter/material.dart';
import 'package:chorebuddies_flutter/chores/mock_chore_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Example data for the ListView
    final items = mockChores;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ChoreView(chore: items[index]);
          },
        ),
      ),
    );
  }
}

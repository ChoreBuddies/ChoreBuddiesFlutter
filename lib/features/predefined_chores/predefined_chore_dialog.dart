import 'package:chorebuddies_flutter/features/predefined_chores/models/predefined_chore_dto.dart';
import 'package:chorebuddies_flutter/features/predefined_chores/predefined_chore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PredefinedChoreSelectorDialog extends StatefulWidget {
  const PredefinedChoreSelectorDialog({super.key});

  @override
  State<PredefinedChoreSelectorDialog> createState() => _PredefinedChoreSelectorDialogState();
}

class _PredefinedChoreSelectorDialogState extends State<PredefinedChoreSelectorDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<PredefinedChoreDto> _allChores = [];
  List<PredefinedChoreDto> _filteredChores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _searchController.addListener(_filterChores);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      final service = context.read<PredefinedChoreService>();
      final result = await service.getAllPredefinedChores();
      if (mounted) {
        setState(() {
          // Sortowanie podobne do Blazora: Room + Name
          _allChores = result..sort((a, b) => '${a.room}${a.name}'.compareTo('${b.room}${b.name}'));
          _filteredChores = _allChores;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        // Opcjonalnie obsługa błędu
      }
    }
  }

  void _filterChores() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredChores = _allChores;
      } else {
        _filteredChores = _allChores.where((element) {
          return element.name.toLowerCase().contains(query) ||
              element.room.toLowerCase().contains(query) ||
              element.rewardPointsCount.toString().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(16),
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 500),
        child: Column(
          children: [
            Text(
              "Choose predefined chore",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Search (name, room, points)...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredChores.isEmpty
                  ? const Center(child: Text("No chores found"))
                  : ListView.separated(
                itemCount: _filteredChores.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final chore = _filteredChores[index];
                  return ListTile(
                    title: Text(chore.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("${chore.room} • ${chore.rewardPointsCount} pts"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).pop(chore);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
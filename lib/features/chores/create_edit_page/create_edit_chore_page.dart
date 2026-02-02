import 'package:chorebuddies_flutter/UI/styles/colors.dart';
import 'package:chorebuddies_flutter/features/authentication/auth_api_service.dart';
import 'package:chorebuddies_flutter/features/authentication/auth_manager.dart';
import 'package:chorebuddies_flutter/features/chores/chore_service.dart';
import 'package:chorebuddies_flutter/features/chores/create_edit_page/create_edit_chore_form.dart';
import 'package:chorebuddies_flutter/features/chores/mappers/chore_view_model_mapper.dart';
import 'package:chorebuddies_flutter/features/chores/models/chore_view_model.dart';
import 'package:chorebuddies_flutter/features/scheduled_chores/scheduled_chores_service.dart';
import 'package:chorebuddies_flutter/features/users/models/user_minimal_dto.dart';
import 'package:chorebuddies_flutter/features/users/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum PageMode { create, view, edit }

class CreateEditChorePage extends StatefulWidget {
  final int? choreId;
  final bool isScheduled;

  const CreateEditChorePage({
    super.key,
    this.choreId,
    this.isScheduled = false,
  });

  @override
  State<CreateEditChorePage> createState() => _CreateEditChorePageState();
}

class _CreateEditChorePageState extends State<CreateEditChorePage> {
  late ChoreViewModel model;
  late PageMode pageMode;
  List<UserMinimalDto> availableUsers = [];
  bool isLoading = true;
  bool isChild = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    var userService = context.read<UserService>();
    var scheduledChoresService = context.read<ScheduledChoresService>();
    var choresService = context.read<ChoreService>();
    var authManager = context.read<AuthManager>();
    availableUsers = await userService.getMyHouseholdMembersAsync();

    isChild = authManager.role == "Child";

    if (widget.choreId != null) {
      pageMode = PageMode.view;
      if (widget.isScheduled) {
        final dto = await scheduledChoresService.getChoreById(widget.choreId!);
        if (dto != null) model = ChoreViewModelMapper.fromScheduledDto(dto);
        model.isScheduled = true;
      } else {
        final dto = await choresService.getChore(widget.choreId!);
        if (dto != null) model = ChoreViewModelMapper.fromChoreDto(dto);
      }
    } else {
      pageMode = PageMode.create;
      model = ChoreViewModel(isScheduled: false);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _handleMarkAsDonePress() async {
    if (model.id != null && model.isScheduled == false) {
      final ok = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Confirm'),
          content: const Text('Mark this chore as done?'),
          actions: [
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.cancel),
                foregroundColor: AppColors.cancel,
              ),
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      if (ok != true) return;

      final choreService = context.read<ChoreService>();
      await choreService.markChoreAsDone(model.id!);

      final result = await choreService.getChore(model.id!);
      if (result != null) {
        setState(() {
          model = ChoreViewModelMapper.fromChoreDto(result);
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to refresh chore')),
        );
      }
    }
  }

  Future<void> _handleSave(ChoreViewModel updatedModel) async {
    var scheduledChoresService = context.read<ScheduledChoresService>();
    var choresService = context.read<ChoreService>();
    dynamic result;
    if (pageMode == PageMode.edit) {
      if (updatedModel.isScheduled) {
        result = await scheduledChoresService.updateChore(
          updatedModel.toScheduledDto(),
        );
      } else {
        result = await choresService.updateChore(updatedModel.toChoreDto());
      }
    } else {
      if (updatedModel.isScheduled) {
        result = await scheduledChoresService.createChore(
          updatedModel.toCreateScheduledDto(),
        );
      } else {
        result = await choresService.createChore(updatedModel.toCreateDto());
      }
    }

    if (result != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Saved successfully!')));

      setState(() {
        Navigator.maybePop(context);
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error occured')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Chore Details')),
      body: CreateEditChoreForm(
        model: model,
        users: availableUsers,
        pageMode: pageMode,
        onValidSubmit: _handleSave,
        onPageModeChanged: (newMode) => setState(() => pageMode = newMode),
        onMarkAsDone: _handleMarkAsDonePress,
        isChild: isChild,
      ),
    );
  }
}

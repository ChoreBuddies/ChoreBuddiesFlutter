import 'package:chorebuddies_flutter/features/rewards/create_edit_page/create_edit_reward_form.dart';
import 'package:chorebuddies_flutter/features/rewards/models/reward_dto.dart';
import 'package:chorebuddies_flutter/features/rewards/reward_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum PageMode { create, view, edit }

class CreateEditRewardPage extends StatefulWidget {
  final int? rewardId;

  const CreateEditRewardPage({super.key, this.rewardId});

  @override
  State<CreateEditRewardPage> createState() =>
      _CreateEditRewardPageState();
}

class _CreateEditRewardPageState extends State<CreateEditRewardPage> {
  late Reward model;
  late PageMode pageMode;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    var rewardService = context.read<RewardService>();
    if (widget.rewardId != null) {
      pageMode = PageMode.view;
      model = await rewardService.getReward(widget.rewardId!) ?? Reward(null, '', '', 0, 0, 0);
    } else {
      pageMode = PageMode.create;
      model = Reward(null, '', '', 0, 0, 0);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _handleSave(Reward updatedModel) async {
    var rewardService = context.read<RewardService>();
    Reward? result;
    if (pageMode == PageMode.edit) {
      result = await rewardService.updateReward(updatedModel);
    } else {
      result = await rewardService.createReward(updatedModel);
    }
    if(!mounted) return;
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
      appBar: AppBar(title: const Text('Reward Details')),
      body: CreateEditRewardForm(
        model: model,
        pageMode: pageMode,
        onValidSubmit: _handleSave,
        onPageModeChanged: (newMode) => setState(() => pageMode = newMode),
      ),
    );
  }
}

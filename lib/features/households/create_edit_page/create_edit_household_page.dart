import 'package:chorebuddies_flutter/UI/pages/home_page.dart';
import 'package:chorebuddies_flutter/features/households/create_edit_page/create_edit_household_form.dart';
import 'package:chorebuddies_flutter/features/households/household_service.dart';
import 'package:chorebuddies_flutter/features/households/models/household.dart';
import 'package:chorebuddies_flutter/features/users/models/user_minimal_dto.dart';
import 'package:chorebuddies_flutter/features/users/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum PageMode { create, view, edit }

class CreateEditHouseholdPage extends StatefulWidget {
  final int? householdId;

  const CreateEditHouseholdPage({super.key, this.householdId});

  @override
  State<CreateEditHouseholdPage> createState() =>
      _CreateEditHouseholdPageState();
}

class _CreateEditHouseholdPageState extends State<CreateEditHouseholdPage> {
  late Household model;
  late PageMode pageMode;
  List<UserMinimalDto> availableUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    var householdService = context.read<HouseholdService>();
    if (widget.householdId != null) {
      pageMode = PageMode.view;
      model = await householdService.getHousehold(widget.householdId!);
    } else {
      pageMode = PageMode.create;
      model = Household(null, '', '');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _handleSave(Household updatedModel) async {
    var householdService = context.read<HouseholdService>();
    var result;
    if (pageMode == PageMode.edit) {
      result = await householdService.updateHousehold(updatedModel);
    } else {
      result = await householdService.createHousehold(updatedModel);
    }

    if (result != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Saved successfully!')));
      if (pageMode == PageMode.create && mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) =>
                const HomePage(),
          ),
          (Route<dynamic> route) =>
              false,
        );
      }
      setState(() {
        pageMode = PageMode.view;
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
      appBar: AppBar(title: const Text('Household Details')),
      body: CreateEditHouseholdForm(
        model: model,
        pageMode: pageMode,
        onValidSubmit: _handleSave,
        onPageModeChanged: (newMode) => setState(() => pageMode = newMode),
      ),
    );
  }
}

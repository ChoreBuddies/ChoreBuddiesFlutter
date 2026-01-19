import 'package:chorebuddies_flutter/UI/widgets/g_form_field.dart';
import 'package:chorebuddies_flutter/UI/widgets/g_or_divider.dart';
import 'package:chorebuddies_flutter/features/households/create_edit_page/create_edit_household_page.dart';
import 'package:chorebuddies_flutter/features/households/household_service.dart';
import 'package:chorebuddies_flutter/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NoHouseholdPage extends StatefulWidget {
  const NoHouseholdPage({Key? key}) : super(key: key);

  @override
  State<NoHouseholdPage> createState() => _NoHouseholdPageState();
}

class _NoHouseholdPageState extends State<NoHouseholdPage> {
  final invitationCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _handleJoinHousehold() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final householdService = context.read<HouseholdService>();
      await householdService.joinHousehold(invitationCodeController.text);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to join: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    invitationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              Icon(
                Icons.house_rounded,
                size: 80,
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Join Household',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the code shared by your family or housemates.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),

              Form(
                key: _formKey,
                child: GFormField(
                  labelText: 'Invitation Code',
                  controller: invitationCodeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a code';
                    }

                    return Validators.validate(
                      value,
                      ValidationType.invitationCode,
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                height: 48,
                child: FilledButton.icon(
                  onPressed: _isLoading ? null : _handleJoinHousehold,
                  icon: const Icon(Icons.add_home_outlined),
                  label: _isLoading
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Join Household'),
                ),
              ),
              const SizedBox(height: 16),
              const GOrDivider(),
              const SizedBox(height: 16),

              Text(
                'Starting fresh?',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CreateEditHouseholdPage(),
                      ),
                    )
                  },
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Create New Household'),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.colorScheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

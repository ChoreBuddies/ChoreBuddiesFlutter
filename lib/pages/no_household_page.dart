import 'package:chorebuddies_flutter/generic_widgets/g_form_field.dart';
import 'package:chorebuddies_flutter/households/household_service.dart';
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

  Future<void> _handleJoinHousehold() async {
    if (_formKey.currentState!.validate()) {
      final householdService = context.read<HouseholdService>();
      await householdService.joinHousehold(invitationCodeController.text);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Provide correct invitation code')),
      );
    }
  }

  @override
  void dispose() {
    invitationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join household or create one')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Input invitation code provided by your Parent or Housemate.',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GFormField(
                    labelText: 'Invitation code',
                    controller: invitationCodeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a code';
                      }
                      if (value.length != 6) {
                        return 'Code must be 6 characters long';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _handleJoinHousehold,
                    child: const Text('Join household'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'No household invitation code? No problem! Let\s create one together.',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () => {},
              child: const Text('Create household'),
            ),
          ],
        ),
      ),
    );
  }
}

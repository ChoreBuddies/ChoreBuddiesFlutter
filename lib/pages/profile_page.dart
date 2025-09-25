import 'package:chorebuddies_flutter/authentication/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:chorebuddies_flutter/generic_widgets/g_form_field.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authManager = context.read<AuthManager>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey.shade300,
                  child: const Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                GFormField(
                  labelText: 'First Name',
                  controller: TextEditingController(text: "John"),
                ),
                GFormField(
                  labelText: 'Last Name',
                  controller: TextEditingController(text: "Doe"),
                ),
                GFormField(
                  labelText: 'Email',
                  controller: TextEditingController(text: "john.doe@email.com"),
                ),
                GFormField(
                  labelText: 'Date of birth',
                  controller: TextEditingController(text: "1990-01-01"),
                ),
                ElevatedButton(
                  onPressed: () {
                    authManager.logout();
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

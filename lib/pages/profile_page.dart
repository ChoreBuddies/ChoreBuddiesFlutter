import 'package:chorebuddies_flutter/authentication/auth_manager.dart';
import 'package:chorebuddies_flutter/styles/button_styles.dart';
import 'package:flutter/material.dart';
import 'package:chorebuddies_flutter/generic_widgets/g_form_field.dart';
import 'package:provider/provider.dart';

enum ProfilePageMode { view, edit }

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfilePageMode mode = ProfilePageMode.view;

  final firstNameController = TextEditingController(text: "John");
  final lastNameController = TextEditingController(text: "Doe");
  final emailController = TextEditingController(text: "john.doe@email.com");
  final dobController = TextEditingController(text: "1990-01-01");

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    dobController.dispose();
    super.dispose();
  }

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
                  controller: firstNameController,
                ),
                GFormField(
                  labelText: 'Last Name',
                  controller: lastNameController,
                ),
                GFormField(labelText: 'Email', controller: emailController),
                GFormField(
                  labelText: 'Date of birth',
                  controller: dobController,
                ),
                const SizedBox(height: 20),
                if (mode == ProfilePageMode.view)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        mode = ProfilePageMode.edit;
                      });
                    },
                    child: const Text('Edit'),
                  ),
                if (mode == ProfilePageMode.edit)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            mode = ProfilePageMode.view;
                          });
                        },
                        style: ElevatedButtonStyles.cancelStyle,
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            mode = ProfilePageMode.view;
                          });
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    authManager.logout();
                  },
                  style: ElevatedButtonStyles.cancelStyle,
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

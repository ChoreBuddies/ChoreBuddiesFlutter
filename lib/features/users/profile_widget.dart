import 'package:chorebuddies_flutter/features/authentication/auth_manager.dart';
import 'package:chorebuddies_flutter/UI/styles/button_styles.dart';
import 'package:chorebuddies_flutter/features/users/user_service.dart';
import 'package:chorebuddies_flutter/utils/formatters.dart';
import 'package:chorebuddies_flutter/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:chorebuddies_flutter/UI/widgets/g_form_field.dart';
import 'package:provider/provider.dart';

enum ProfilePageMode { view, edit }

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  ProfilePageMode mode = ProfilePageMode.view;

  int? id;
  final userNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  var dateOfBirth;

  bool isLoading = true;
  bool hasError = false;
  String error = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _handleSaveUser() async {
    final email = emailController.text.trim();
    final emailError = email.isEmpty
        ? 'Email is required'
        : Validators.validate(email, ValidationType.email);

    if (emailError != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(emailError)));
      return;
    }

    final userService = context.read<UserService>();

    setState(() => isLoading = true);
    try {
      final result = await userService.updateMe(
        id!,
        firstNameController.text.trim(),
        lastNameController.text.trim(),
        dateOfBirth,
        userNameController.text.trim(),
        email,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result ? 'Profile updated successfully!' : 'Saving failed.',
          ),
        ),
      );
      setState(() => mode = ProfilePageMode.view);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadUserData() async {
    final userService = context.read<UserService>();
    try {
      final user = await userService.getMe();

      setState(() {
        id = user.id;
        userNameController.text = user.userName;
        firstNameController.text = user.firstName ?? '';
        lastNameController.text = user.lastName ?? '';
        emailController.text = user.email ?? "";
        dateOfBirth = user.dateOfBirth;
        dateOfBirthController.text = formatDate(user.dateOfBirth);
        isLoading = false;
        hasError = false;
        error = '';
      });
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
        error = e.toString();
      });
    }
  }

  Future<void> handleBirthDateClick() async {
    final DateTime initialDate = dateOfBirth ?? DateTime(2000);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Select your date of birth',
      cancelText: 'Cancel',
      confirmText: 'Select',
    );

    if (pickedDate != null) {
      setState(() {
        dateOfBirth = pickedDate;
        dateOfBirthController.text = formatDate(pickedDate);
      });
    }
  }

  @override
  void dispose() {
    userNameController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authManager = context.read<AuthManager>();

    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Failed to load profile: $error'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadUserData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: GFormField(
                      labelText: 'First Name',
                      controller: firstNameController,
                      readonly: mode != ProfilePageMode.edit,
                    ),
                  ),
                  Expanded(
                    child: GFormField(
                      labelText: 'Last Name',
                      controller: lastNameController,
                      readonly: mode != ProfilePageMode.edit,
                    ),
                  ),
                ],
              ),
              GFormField(
                labelText: 'Email',
                controller: emailController,
                readonly: mode != ProfilePageMode.edit,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  return Validators.validate(value, ValidationType.email);
                },
              ),
              GFormField(
                labelText: 'Date of Birth',
                controller: dateOfBirthController,
                readonly: mode != ProfilePageMode.edit,
                onTap: mode == ProfilePageMode.edit
                    ? handleBirthDateClick
                    : null,
              ),

              const SizedBox(height: 10),

              if (mode == ProfilePageMode.view)
                ElevatedButton(
                  onPressed: () => setState(() => mode = ProfilePageMode.edit),
                  child: const Text('Edit'),
                ),

              if (mode == ProfilePageMode.edit)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          setState(() => mode = ProfilePageMode.view),
                      style: ElevatedButtonStyles.cancelStyle,
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _handleSaveUser(),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 10,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Save'),
                    ),
                  ],
                ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: authManager.logout,
                style: ElevatedButtonStyles.cancelStyle,
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:chorebuddies_flutter/UI/layout/main_layout.dart';
import 'package:chorebuddies_flutter/features/authentication/auth_manager.dart';
import 'package:chorebuddies_flutter/UI/widgets/g_form_field.dart';
import 'package:chorebuddies_flutter/features/authentication/login_page.dart';
import 'package:chorebuddies_flutter/utils/formatters.dart';
import 'package:chorebuddies_flutter/utils/validators.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();
  final _userNameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dateOfBirthController = TextEditingController();

  var dateOfBirth;
  bool _passwordVisible = false;

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
        _dateOfBirthController.text = formatDate(pickedDate);
      });

      _formKey.currentState?.validate();
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    _userNameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authManager = context.read<AuthManager>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
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
                  labelText: 'Username',
                  controller: _userNameController,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Required' : null,
                ),
                GFormField(
                  labelText: 'Email',
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return Validators.validate(value, ValidationType.email);
                  },
                ),

                Row(
                  children: [
                    Expanded(
                      child: GFormField(
                        labelText: 'First Name',
                        controller: _firstNameController,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Required' : null,
                      ),
                    ),
                    Expanded(
                      child: GFormField(
                        labelText: 'Last Name',
                        controller: _lastNameController,
                        validator: (value) =>
                            value == null || value.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ],
                ),

                GFormField(
                  labelText: 'Date of Birth',
                  controller: _dateOfBirthController,
                  onTap: handleBirthDateClick,
                  readonly: true,
                  validator: (value) {
                    if (value == null || value.isEmpty || dateOfBirth == null) {
                      return 'Please select your date of birth';
                    }
                    return null;
                  },
                ),

                Row(
                  children: [
                    Expanded(
                      child: GFormField(
                        labelText: 'Password',
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        enableSuggestion: false,
                        autocorrect: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          return Validators.validate(
                            value,
                            ValidationType.password,
                          );
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: GFormField(
                        labelText: 'Repeat Password',
                        controller: _repeatPasswordController,
                        obscureText: !_passwordVisible,
                        enableSuggestion: false,
                        autocorrect: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          if (value != _passwordController.text) {
                            return 'Passwords mismatch';
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          icon: Icon(
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _passwordVisible = !_passwordVisible;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      bool success = await authManager.register(
                        _userNameController.text.trim(),
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                        _firstNameController.text.trim(),
                        _lastNameController.text.trim(),
                        dateOfBirth,
                      );

                      if (success && mounted) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const MainLayout(),
                          ),
                          (route) => false,
                        );
                      }
                    }
                  },
                  child: const Text('Sign up'),
                ),

                const SizedBox(height: 16),

                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: const TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "Sign in",
                          style: const TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

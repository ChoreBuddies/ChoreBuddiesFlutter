import 'package:chorebuddies_flutter/features/authentication/auth_manager.dart';
import 'package:chorebuddies_flutter/UI/widgets/g_form_field.dart';
import 'package:chorebuddies_flutter/features/authentication/register_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authManager = context.read<AuthManager>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey.shade300,
                child: const Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 20),
              GFormField(labelText: 'Email', controller: _emailController),
              const SizedBox(height: 16),
              GFormField(
                labelText: 'Password',
                controller: _passwordController,
                obscureText: !_passwordVisible,
                enableSuggestion: false,
                autocorrect: false,
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  await authManager.login(
                    _emailController.text.trim(),
                    _passwordController.text.trim(),
                  );
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              Center(
                child: RichText(
                  text: TextSpan(
                    text: "Don't have an account yet? ",
                    style: const TextStyle(color: Colors.black),
                    children: [
                      TextSpan(
                        text: "Sign up",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(),
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
    );
  }
}

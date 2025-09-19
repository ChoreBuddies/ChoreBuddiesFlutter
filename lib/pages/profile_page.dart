import 'package:chorebuddies_flutter/users/user_service.dart';
import 'package:flutter/material.dart';
import 'package:chorebuddies_flutter/generic_widgets/g_form_field.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = context.read<UserService>();

    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: userService.getMe(), // <-- async call
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // loading state
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            final user = snapshot.data!; // whatever your User model is
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // wyśrodkowanie pionowe
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
                      controller: TextEditingController(text: user.firstName),
                    ),
                    GFormField(
                      labelText: 'Last Name',
                      controller: TextEditingController(text: user.lastName),
                    ),
                    GFormField(
                      labelText: 'Email',
                      controller: TextEditingController(text: user.email),
                    ),
                    GFormField(
                      labelText: 'Date of birth',
                      controller: TextEditingController(
                        text: user.dateOfBirth.toString(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

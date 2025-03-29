import 'package:flutter/material.dart';
import 'package:task_manager/registrationpage.dart';
import 'package:task_manager/homescreen.dart';

import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameOrEmailController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              style:  TextStyle(color: Colors.white),
              controller: usernameOrEmailController,
              decoration: InputDecoration(
                filled: true,
                fillColor:
                    Colors.blueGrey[300], // Darker background for input fields
                hintText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              style:  TextStyle(color: Colors.white),
              controller: passwordController,
              obscureText: true,
              decoration:  InputDecoration(
                filled: true,
                fillColor:
                 Colors.blueGrey[300],
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final usernameOrEmail = usernameOrEmailController.text.trim();
                final password = passwordController.text.trim();
                loginUser(usernameOrEmail, password);
              },
              child: const Text('Login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Navigate to the Registration Page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loginUser(String usernameOrEmail, String password) async {
    final user = ParseUser(usernameOrEmail, password, null);

    try {
      final response = await user.login();

      if (response.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
        // Navigate to the next screen or home page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.error?.message}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exception: $e')),
      );
    }
  }
}

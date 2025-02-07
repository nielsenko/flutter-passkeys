import 'package:corbado_auth_example/app_locator.dart';
import 'package:corbado_auth_example/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key}) {}

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final AuthService _authService = getIt<AuthService>();

  String? _error;

  @override
  void initState() {
    _error = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Corbado authentication')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 50),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: const Text(
                'Tired of passwords?',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: const Text(
                'Sign in using your biometrics like fingerprint or face.',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'email address',
                ),
              ),
            ),
            _error != null
                ? Text(
                    _error!,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  )
                : Container(),
            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _signUp,
                child: const Text('sign up'),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: BorderSide(
                        width: 2, color: Theme.of(context).primaryColor)),
                onPressed: _signIn,
                child: const Text('sign in'),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  _signIn() async {
    try {
      final email = _emailController.value.text;
      final maybeError = await _authService.signIn(email: email);
      if (maybeError != null) {
        setState(() {
          _error = maybeError;
        });
      }
    } catch (error) {
      debugPrint('error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).primaryColor,
          content: Text('$error'),
          duration: const Duration(seconds: 10),
        ),
      );
    }
  }

  _signUp() async {
    final email = _emailController.value.text;
    final maybeError = await _authService.register(email: email);
    if (maybeError != null) {
      setState(() {
        _error = maybeError;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}

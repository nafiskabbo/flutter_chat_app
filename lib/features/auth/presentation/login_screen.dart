import 'package:chat/config/routes/routes.dart';
import 'package:chat/features/auth/data/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSignUp = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isSignUp ? 'Sign Up' : 'Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
            ElevatedButton(
              onPressed: _isSignUp ? _signUp : _signIn,
              child: Text(_isSignUp ? 'Sign Up' : 'Login'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isSignUp = !_isSignUp;
                });
              },
              child: Text(
                  _isSignUp ? 'Already have an account? Login' : 'Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signIn() async {
    final errorMessage = await _authService.signIn(
      _emailController.text,
      _passwordController.text,
    );
    if (errorMessage == null) {
      context.goNamed(Routes.profiles.name);
    } else {
      setState(() {
        _errorMessage = errorMessage;
      });
    }
  }

  Future<void> _signUp() async {
    final errorMessage = await _authService.signUp(
      _emailController.text,
      _passwordController.text,
    );
    if (errorMessage == null) {
      setState(() {
        _isSignUp = false;
        _errorMessage = 'Account created! Please login.';
      });
    } else {
      setState(() {
        _errorMessage = errorMessage;
      });
    }
  }
}

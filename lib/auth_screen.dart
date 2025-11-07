import 'package:flutter/material.dart';

import 'auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  bool _isLogin = true;
  String _email = '';
  String _password = '';
  String _username = '';
  bool _isLoading = false;

  void _switchMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        await _authService.login(_email, _password);
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/input');
        }
      } else {
        await _authService.register(_username, _email, _password);
        if (mounted) {
          setState(() => _isLogin = true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! Please login'),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  InputDecoration _getInputDecoration({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
      ),
      filled: true,
      fillColor: Theme.of(
        context,
      ).colorScheme.surfaceContainerHighest.withValues(alpha: 77),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          _isLogin ? 'Welcome Back' : 'Create Account',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isLogin ? 'Sign in to continue' : 'Get started',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isLogin
                        ? 'Please sign in to access your account'
                        : 'Create an account to get started',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 180),
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (!_isLogin)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        decoration: _getInputDecoration(
                          label: 'Username',
                          hint: 'Enter your username',
                          icon: Icons.person,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a username';
                          }
                          return null;
                        },
                        onSaved: (value) => _username = value!,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      decoration: _getInputDecoration(
                        label: 'Email',
                        hint: 'Enter your email',
                        icon: Icons.email,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter an email';
                        }
                        if (!value.contains('@') || !value.contains('.')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                      onSaved: (value) => _email = value!,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      decoration: _getInputDecoration(
                        label: 'Password',
                        hint: 'Enter your password',
                        icon: Icons.lock,
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      onSaved: (value) => _password = value!,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isLoading)
                    Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )
                  else
                    FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _isLogin ? 'Login' : 'Register',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: _switchMode,
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    child: Text(
                      _isLogin ? 'Create an account' : 'I have an account',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'auth_screen.dart';
import 'auth_service.dart';
import 'input_screen.dart';
import 'result_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loan Prediction',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        useMaterial3: true,
      ),
      home: const AuthCheckScreen(),
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/input': (context) => const InputScreen(),
        '/result': (context) => const ResultScreen(),
        '/history': (context) => const ResultScreen(),
      },
    );
  }
}

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({Key? key}) : super(key: key);

  @override
  _AuthCheckScreenState createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    final isLoggedIn = await _authService.isLoggedIn();
    if (mounted) {
      if (isLoggedIn) {
        Navigator.of(context).pushReplacementNamed('/input');
      } else {
        Navigator.of(context).pushReplacementNamed('/auth');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

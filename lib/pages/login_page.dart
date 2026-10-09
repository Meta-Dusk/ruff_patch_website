import 'package:capstone_website/app.dart';
import 'package:capstone_website/core/app_assets.dart';
import 'package:capstone_website/core/app_fonts.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();

  void _handleLogin() {
    final username = _usernameController.text.trim();
    if (username.isNotEmpty) {
      userNotifier.value = username;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final cardContent = [
      Image.asset(AppAssets.logo),
      const SizedBox(height: 24),
      Text(
        'Welcome to Ruff Patch',
        textAlign: .center,
        style: TextStyle(
          fontSize: 28,
          fontFamily: AppFonts.born2B,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      const SizedBox(height: 32),
      TextField(
        controller: _usernameController,
        decoration: InputDecoration(
          labelText: "Enter a display name",
          border: OutlineInputBorder(borderRadius: .circular(12)),
          focusedBorder: OutlineInputBorder(
            borderRadius: .circular(12),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
        ),
        onSubmitted: (_) => _handleLogin(),
      ),
      const SizedBox(height: 32),
      SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: RoundedRectangleBorder(borderRadius: .circular(12)),
          ),
          onPressed: _handleLogin,
          child: const Text(
            'Enter the Patch',
            style: TextStyle(fontSize: 18, fontFamily: AppFonts.born2B),
          ),
        ),
      ),
    ];

    final card = Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: .circular(24)),
      child: Padding(
        padding: const .all(40.0),
        child: Column(mainAxisSize: .min, children: cardContent),
      ),
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: card,
        ),
      ),
    );
  }
}

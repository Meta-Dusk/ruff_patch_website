import 'package:flutter/material.dart';

import 'package:capstone_website/core/app_assets.dart';
import 'package:capstone_website/core/app_fonts.dart';
import 'package:capstone_website/services/auth_service.dart';
import 'package:capstone_website/widgets/global_appbar.dart';
import 'package:capstone_website/widgets/google_logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoadingGoogle = false;
  String? _errorMessage;

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoadingGoogle = true;
      _errorMessage = null;
    });

    try {
      await AuthService.signInWithGoogle();
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingGoogle = false;
        });
      }
    }
  }

  void _handleGuestLogin() {
    final username = _usernameController.text.trim();
    if (username.isEmpty) return;

    setState(() {
      _errorMessage = null;
    });

    AuthService.signInAsGuest(username);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainContent = [
      const _LoginHeader(),
      const SizedBox(height: 24),
      if (_errorMessage != null)
        _LoginErrorBanner(errorMessage: _errorMessage!),
      _GoogleSignInButton(
        isLoading: _isLoadingGoogle,
        onPressed: _isLoadingGoogle ? null : _handleGoogleSignIn,
      ),
      const SizedBox(height: 24),
      const _DividerWithText(text: 'or guest access'),
      const SizedBox(height: 20),
      _GuestAccessForm(
        controller: _usernameController,
        isLoading: _isLoadingGoogle,
        onSubmit: _handleGuestLogin,
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const GlobalAppBar(title: "Ruff Patch", showNavToggle: false),
      body: Center(
        child: SingleChildScrollView(
          padding: const .all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: .circular(24)),
              child: Padding(
                padding: const .symmetric(horizontal: 32.0, vertical: 36.0),
                child: Column(mainAxisSize: .min, children: mainContent),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Image.asset(AppAssets.pixelLogo, height: 150),
        const SizedBox(height: 20),
        Text(
          'Welcome to Ruff Patch',
          textAlign: .center,
          style: TextStyle(
            fontSize: 28,
            fontFamily: AppFonts.born2B,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'e-Learning platform for caring pet owners',
          textAlign: .center,
          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}

class _LoginErrorBanner extends StatelessWidget {
  final String errorMessage;

  const _LoginErrorBanner({required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const .all(12),
      margin: const .only(bottom: 16),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: .circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.onErrorContainer,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              errorMessage,
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoogleSignInButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;

  const _GoogleSignInButton({required this.isLoading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final loadingWidget = SizedBox(
      height: 22,
      width: 22,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: colorScheme.primary,
      ),
    );

    final googleSignIn = Row(
      mainAxisAlignment: .center,
      children: [
        const GoogleLogo(size: 20),
        const SizedBox(width: 12),
        Text(
          'Continue with Google',
          style: TextStyle(
            fontSize: 16,
            fontWeight: .w600,
            color: colorScheme.onSurface,
          ),
        ),
      ],
    );

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.onSurface,
        backgroundColor: colorScheme.surface,
        side: BorderSide(color: colorScheme.outlineVariant, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: .circular(12)),
        padding: const .symmetric(vertical: 14, horizontal: 16),
      ),
      onPressed: onPressed,
      child: isLoading ? loadingWidget : googleSignIn,
    );
  }
}

class _DividerWithText extends StatelessWidget {
  final String text;

  const _DividerWithText({required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(child: Divider(color: colorScheme.outlineVariant)),
        Padding(
          padding: const .symmetric(horizontal: 16),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              fontFamily: AppFonts.born2B,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Expanded(child: Divider(color: colorScheme.outlineVariant)),
      ],
    );
  }
}

class _GuestAccessForm extends StatelessWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSubmit;

  const _GuestAccessForm({
    required this.controller,
    required this.isLoading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: "Enter a display name",
            border: OutlineInputBorder(borderRadius: .circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: .circular(12),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
          ),
          onSubmitted: (_) => onSubmit(),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: .circular(12)),
            ),
            onPressed: isLoading ? null : onSubmit,
            child: const Text(
              'Enter as Guest',
              style: TextStyle(fontSize: 18, fontFamily: AppFonts.born2B),
            ),
          ),
        ),
      ],
    );
  }
}

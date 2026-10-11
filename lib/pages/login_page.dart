import 'package:flutter/material.dart';

import 'package:capstone_website/core/app_assets.dart';
import 'package:capstone_website/core/app_fonts.dart';
import 'package:capstone_website/services/auth_service.dart';
import 'package:capstone_website/widgets/google_logo.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoadingGoogle = false;
  bool _isLoadingGuest = false;
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

  Future<void> _handleGuestLogin() async {
    final username = _usernameController.text.trim();
    if (username.isEmpty) return;

    setState(() {
      _isLoadingGuest = true;
      _errorMessage = null;
    });

    try {
      await AuthService.signInAnonymously(displayName: username);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingGuest = false;
        });
      }
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

    final googleSignInButton = OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.onSurface,
        backgroundColor: colorScheme.surface,
        side: BorderSide(color: colorScheme.outlineVariant, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: .circular(12)),
        padding: const .symmetric(vertical: 14, horizontal: 16),
      ),
      onPressed: _isLoadingGoogle || _isLoadingGuest
          ? null
          : _handleGoogleSignIn,
      child: _isLoadingGoogle
          ? SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: colorScheme.primary,
              ),
            )
          : Row(
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
            ),
    );

    final dividerWithText = Row(
      children: [
        Expanded(child: Divider(color: colorScheme.outlineVariant)),
        Padding(
          padding: const .symmetric(horizontal: 16),
          child: Text(
            'or guest access',
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

    final guestContent = [
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
        onSubmitted: (_) => _handleGuestLogin(),
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
          onPressed: _isLoadingGoogle || _isLoadingGuest
              ? null
              : _handleGuestLogin,
          child: _isLoadingGuest
              ? SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: colorScheme.onPrimary,
                  ),
                )
              : const Text(
                  'Enter as Guest',
                  style: TextStyle(fontSize: 18, fontFamily: AppFonts.born2B),
                ),
        ),
      ),
    ];

    final cardContent = [
      Image.asset(AppAssets.pixelLogo, height: 150),
      const SizedBox(height: 20),
      Text(
        'Welcome to Ruff Patch',
        textAlign: TextAlign.center,
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
      const SizedBox(height: 24),
      if (_errorMessage != null) ...[
        Container(
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
                  _errorMessage!,
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      googleSignInButton,
      const SizedBox(height: 24),
      dividerWithText,
      const SizedBox(height: 20),
      ...guestContent,
    ];

    final card = Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: .circular(24)),
      child: Padding(
        padding: const .symmetric(horizontal: 32.0, vertical: 36.0),
        child: Column(mainAxisSize: .min, children: cardContent),
      ),
    );

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          padding: const .all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: card,
          ),
        ),
      ),
    );
  }
}

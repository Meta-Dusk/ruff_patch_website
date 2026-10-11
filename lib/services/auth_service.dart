import 'package:capstone_website/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  AuthService._();

  static FirebaseAuth get _auth => FirebaseAuth.instance;

  /// Holds the current Firebase [User], reactive for GoRouter and UI.
  static final ValueNotifier<User?> userNotifier = ValueNotifier<User?>(
    null,
  );

  /// Initializes the auth state listener after Firebase is initialized.
  static void initialize() {
    userNotifier.value = _auth.currentUser;
    _auth.authStateChanges().listen((user) {
      userNotifier.value = user;
    });
  }

  static User? get currentUser => userNotifier.value;

  /// Checks if Firebase has been configured with real credentials.
  static bool get isConfigured {
    return DefaultFirebaseOptions.web.apiKey != 'YOUR_API_KEY';
  }

  /// Sign in using Google OAuth popup (works seamlessly on Flutter Web).
  static Future<UserCredential> signInWithGoogle() async {
    if (!isConfigured) {
      throw Exception(
        'Firebase is not configured yet. Please update lib/firebase_options.dart with your Firebase web credentials.',
      );
    }
    final GoogleAuthProvider googleProvider = GoogleAuthProvider();
    googleProvider.addScope('email');
    googleProvider.setCustomParameters({'prompt': 'select_account'});
    return await _auth.signInWithPopup(googleProvider);
  }

  /// Sign in anonymously or with a custom display name.
  static Future<UserCredential> signInAnonymously({String? displayName}) async {
    if (!isConfigured) {
      throw Exception(
        'Firebase is not configured yet. Please update lib/firebase_options.dart with your Firebase web credentials.',
      );
    }
    final credential = await _auth.signInAnonymously();
    if (displayName != null && displayName.trim().isNotEmpty) {
      await credential.user?.updateDisplayName(displayName.trim());
      // Refresh userNotifier with updated display name
      userNotifier.value = _auth.currentUser;
    }
    return credential;
  }

  /// Sign out the current user.
  static Future<void> signOut() async {
    if (!isConfigured) {
      userNotifier.value = null;
      return;
    }
    await _auth.signOut();
  }
}


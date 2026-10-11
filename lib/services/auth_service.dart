import 'package:capstone_website/firebase_options.dart';
import 'package:capstone_website/models/app_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  AuthService._();

  static FirebaseAuth get _auth => FirebaseAuth.instance;

  /// Holds the current [AppUser], reactive for GoRouter and UI.
  static final ValueNotifier<AppUser?> userNotifier =
      ValueNotifier<AppUser?>(null);

  /// Initializes the auth state listener after Firebase is initialized.
  static void initialize() {
    if (_auth.currentUser != null) {
      userNotifier.value = AppUser.fromFirebase(_auth.currentUser!);
    }

    _auth.authStateChanges().listen((user) {
      if (user != null) {
        userNotifier.value = AppUser.fromFirebase(user);
      } else if (userNotifier.value?.isGuest != true) {
        userNotifier.value = null;
      }
    });
  }

  static AppUser? get currentUser => userNotifier.value;

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

  /// Guest bypass: completely local, no Firebase restrictions.
  static void signInAsGuest(String displayName) {
    userNotifier.value = AppUser.guest(displayName);
  }

  /// Sign out the current user (both guest and Firebase).
  static Future<void> signOut() async {
    userNotifier.value = null;
    if (isConfigured && _auth.currentUser != null) {
      await _auth.signOut();
    }
  }
}

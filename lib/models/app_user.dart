import 'package:firebase_auth/firebase_auth.dart';

class AppUser {
  final String? uid;
  final String displayName;
  final String? email;
  final String? photoUrl;
  final bool isGuest;

  const AppUser({
    this.uid,
    required this.displayName,
    this.email,
    this.photoUrl,
    this.isGuest = false,
  });

  factory AppUser.fromFirebase(User user) => AppUser(
    uid: user.uid,
    displayName: user.displayName ?? user.email ?? "User",
    email: user.email,
    photoUrl: user.photoURL,
    isGuest: false,
  );

  factory AppUser.guest(String name) => AppUser(
    displayName: name.trim().isEmpty ? "Guest" : name.trim(),
    isGuest: true,
  );
}


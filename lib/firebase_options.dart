import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyAkr4svEXexLox-LK0YjaP8YkKjC8C2o-c",
    authDomain: "ruff-patch-capstone.firebaseapp.com",
    projectId: "ruff-patch-capstone",
    storageBucket: "ruff-patch-capstone.firebasestorage.app",
    messagingSenderId: "1097487597436",
    appId: "1:1097487597436:web:424ed7316f3a1ca4ca6ef9",
    measurementId: "G-QN2LC19KT3",
  );
}

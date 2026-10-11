import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:capstone_website/app.dart';
import 'package:capstone_website/firebase_options.dart';
import 'package:capstone_website/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    if (AuthService.isConfigured) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      AuthService.initialize();
    } else {
      debugPrint(
        'Firebase: Web API key is not configured yet in lib/firebase_options.dart',
      );
    }
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  runApp(const MainApp());
}

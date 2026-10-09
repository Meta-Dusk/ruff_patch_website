import 'package:capstone_website/core/app_router.dart';
import 'package:flutter/material.dart';

final themeNotifier = ValueNotifier(ThemeMode.light);
final userNotifier = ValueNotifier<String?>(null);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, currentMode, _) {
        return MaterialApp.router(
          title: "Capstone Website",
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF403474),
              brightness: .light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF403474),
              brightness: .dark,
            ),
            useMaterial3: true,
          ),
          themeMode: currentMode,
          routerConfig: goRouter,
        );
      },
    );
  }
}

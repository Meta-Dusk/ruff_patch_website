import 'package:flutter/material.dart';

import 'package:capstone_website/core/app_fonts.dart';
import 'package:capstone_website/widgets/global_appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = MediaQuery.sizeOf(context).width < 800;

    final announcementPlaceholder = Container(
      width: double.infinity,
      padding: const .all(24),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: .circular(16),
        border: .all(color: colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: colorScheme.primary),
              const SizedBox(width: 8),
              const Text(
                "Quiz Available!",
                style: TextStyle(fontSize: 24, fontFamily: AppFonts.born2B),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Check out \"Introduction to Dog Care\" in the Modules section.",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const GlobalAppBar(title: "Home"),
      body: SingleChildScrollView(
        padding: const .all(24.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              "Welcome back to Ruff Patch!",
              style: TextStyle(
                fontSize: isMobile ? 32 : 48,
                fontFamily: AppFonts.born2B,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Pick up where you left off or explore new modules.",
              style: TextStyle(fontSize: 18, color: colorScheme.onSurface),
            ),
            const SizedBox(height: 32),
            announcementPlaceholder,
          ],
        ),
      ),
    );
  }
}

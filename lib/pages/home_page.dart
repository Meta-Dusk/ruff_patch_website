import 'package:capstone_website/widgets/global_appbar.dart';
import 'package:flutter/material.dart';
import 'package:capstone_website/core/app_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final announcementPlaceholder = Container(
      width: double.infinity,
      padding: const .all(32),
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
              SizedBox(width: 8),
              Text(
                "Quiz Available!",
                style: TextStyle(fontSize: 24, fontFamily: AppFonts.born2B),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            "Check out \"Introduction to Dog Care\" in the Modules section.",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );

    return Scaffold(
      // Keep background transparent so the MainLayout color shows through
      backgroundColor: Colors.transparent,
      appBar: GlobalAppBar(title: "Home"),
      body: Padding(
        padding: const .all(24.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              "Welcome back to Ruff Patch!",
              style: TextStyle(
                fontSize: 48,
                fontFamily: AppFonts.born2B,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Pick up where you left off or explore new modules.",
              style: TextStyle(fontSize: 18, color: colorScheme.onSurface),
            ),
            const SizedBox(height: 40),
            announcementPlaceholder,
          ],
        ),
      ),
    );
  }
}

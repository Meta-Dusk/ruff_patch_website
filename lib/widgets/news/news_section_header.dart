import 'package:flutter/material.dart';

import 'package:capstone_website/core/app_fonts.dart';

class NewsSectionHeader extends StatelessWidget {
  final bool isMobile;

  const NewsSectionHeader({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Icon(Icons.campaign, color: colorScheme.primary, size: 28),
            const SizedBox(width: 10),
            Text(
              "News & Announcements",
              style: TextStyle(
                fontSize: isMobile ? 22 : 28,
                fontFamily: AppFonts.born2B,
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          "Stay informed about local stray welfare missions, "
          "chapter updates, and advisories.",
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'package:capstone_website/core/app_fonts.dart';

class AnnouncementPinnedBadge extends StatelessWidget {
  const AnnouncementPinnedBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const .symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: .circular(12),
        border: .all(color: colorScheme.primary.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Icon(Icons.push_pin, size: 14, color: colorScheme.primary),
          const SizedBox(width: 4),
          Text(
            "Pinned",
            style: TextStyle(
              fontSize: 12,
              fontFamily: AppFonts.born2B,
              fontWeight: .bold,
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

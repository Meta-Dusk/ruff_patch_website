import 'package:flutter/material.dart';

import 'package:capstone_website/core/app_fonts.dart';
import 'package:capstone_website/models/announcement.dart';

class AnnouncementTypeBadge extends StatelessWidget {
  final AnnouncementType type;

  const AnnouncementTypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final badgeColor = type.color;

    return Container(
      padding: const .symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.12),
        borderRadius: .circular(12),
        border: .all(color: badgeColor.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: .min,
        children: [
          Icon(type.icon, size: 14, color: badgeColor.shade700),
          const SizedBox(width: 4),
          Text(
            type.label,
            style: TextStyle(
              fontSize: 12,
              fontFamily: AppFonts.born2B,
              fontWeight: .bold,
              color: badgeColor.shade700,
            ),
          ),
        ],
      ),
    );
  }
}

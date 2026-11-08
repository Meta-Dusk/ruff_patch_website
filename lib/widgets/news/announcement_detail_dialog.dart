import 'package:capstone_website/widgets/news/announcement_pinned_badge.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:capstone_website/core/app_fonts.dart';
import 'package:capstone_website/models/announcement.dart';
import 'package:capstone_website/widgets/news/announcement_type_badge.dart';

class AnnouncementDetailDialog extends StatelessWidget {
  final Announcement announcement;

  const AnnouncementDetailDialog({super.key, required this.announcement});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final actionRoute = announcement.actionRoute;
    final actionLabel = announcement.actionLabel;

    final mainContent = [
      Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Row(
            children: [
              AnnouncementTypeBadge(type: announcement.type),
              if (announcement.isPinned) ...[
                const SizedBox(width: 8),
                const AnnouncementPinnedBadge(),
              ],
            ],
          ),
          IconButton(
            icon: const Icon(Icons.close),
            tooltip: "Close",
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      const SizedBox(height: 16),
      Text(
        announcement.title,
        style: TextStyle(
          fontSize: 24,
          fontFamily: AppFonts.born2B,
          fontWeight: .bold,
          color: colorScheme.onSurface,
        ),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 14,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            announcement.date,
            style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
      const Divider(height: 28),
      Text(
        announcement.content,
        style: TextStyle(
          fontSize: 15,
          height: 1.6,
          color: colorScheme.onSurface,
        ),
      ),
      const SizedBox(height: 24),
      Row(
        mainAxisAlignment: .end,
        children: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              "Close",
              style: TextStyle(fontFamily: AppFonts.born2B),
            ),
          ),
          if (actionLabel != null && actionRoute != null) ...[
            const SizedBox(width: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                shape: RoundedRectangleBorder(borderRadius: .circular(10)),
              ),
              icon: const Icon(Icons.arrow_forward, size: 16),
              label: Text(
                actionLabel,
                style: const TextStyle(fontFamily: AppFonts.born2B),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                context.go(actionRoute);
              },
            ),
          ],
        ],
      ),
    ];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: .circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Padding(
          padding: const .all(24.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: .min,
              crossAxisAlignment: .start,
              children: mainContent,
            ),
          ),
        ),
      ),
    );
  }
}

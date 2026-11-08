import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:capstone_website/core/app_fonts.dart';
import 'package:capstone_website/models/announcement.dart';

import 'announcement_detail_dialog.dart';
import 'announcement_pinned_badge.dart';
import 'announcement_type_badge.dart';
import 'news_section_header.dart';

class NewsAndAnnouncementsSection extends StatefulWidget {
  final bool isMobile;

  const NewsAndAnnouncementsSection({super.key, required this.isMobile});

  @override
  State<NewsAndAnnouncementsSection> createState() =>
      _NewsAndAnnouncementsSectionState();
}

class _NewsAndAnnouncementsSectionState
    extends State<NewsAndAnnouncementsSection> {
  AnnouncementType? _selectedType;

  @override
  Widget build(BuildContext context) {
    final allAnnouncements = Announcement.sampleAnnouncements;
    final filteredAnnouncements = _selectedType == null
        ? allAnnouncements
        : allAnnouncements.where((a) => a.type == _selectedType).toList();

    return Column(
      crossAxisAlignment: .start,
      children: [
        NewsSectionHeader(isMobile: widget.isMobile),
        const SizedBox(height: 16),
        _NewsFilterBar(
          selectedType: _selectedType,
          onTypeSelected: (type) => setState(() => _selectedType = type),
        ),
        const SizedBox(height: 20),
        if (filteredAnnouncements.isEmpty)
          const _EmptyAnnouncementsState()
        else
          for (final announcement in filteredAnnouncements) ...[
            _AnnouncementCard(
              announcement: announcement,
              isMobile: widget.isMobile,
            ),
            const SizedBox(height: 16),
          ],
      ],
    );
  }
}

class _NewsFilterBar extends StatelessWidget {
  final AnnouncementType? selectedType;
  final ValueChanged<AnnouncementType?> onTypeSelected;

  const _NewsFilterBar({
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: .horizontal,
    child: Row(
      children: [
        _FilterChipButton(
          label: "All",
          icon: Icons.all_inclusive,
          isSelected: selectedType == null,
          onTap: () => onTypeSelected(null),
        ),
        const SizedBox(width: 8),
        for (final type in AnnouncementType.values) ...[
          _FilterChipButton(
            label: type.label,
            icon: type.icon,
            isSelected: selectedType == type,
            activeColor: type.color,
            onTap: () => onTypeSelected(type),
          ),
          const SizedBox(width: 8),
        ],
      ],
    ),
  );
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final MaterialColor? activeColor;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    this.activeColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final primaryColor = activeColor ?? colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: .circular(20),
      child: Container(
        padding: const .symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? primaryColor.withValues(alpha: 0.15)
              : colorScheme.surface,
          borderRadius: .circular(20),
          border: .all(
            color: isSelected ? primaryColor : colorScheme.outlineVariant,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? primaryColor : colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontFamily: AppFonts.born2B,
                color: isSelected ? primaryColor : colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? .bold : .normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final bool isMobile;

  const _AnnouncementCard({required this.announcement, required this.isMobile});

  void _showDetailDialog(BuildContext context) => showDialog<void>(
    context: context,
    builder: (_) => AnnouncementDetailDialog(announcement: announcement),
  );

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2,
      clipBehavior: .antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: .circular(16),
        side: BorderSide(
          color: announcement.isPinned
              ? colorScheme.primary.withValues(alpha: 0.5)
              : colorScheme.outlineVariant,
          width: announcement.isPinned ? 1.5 : 1.0,
        ),
      ),
      child: InkWell(
        onTap: () => _showDetailDialog(context),
        child: Padding(
          padding: const .all(20.0),
          child: Column(
            crossAxisAlignment: .start,
            children: [
              _AnnouncementCardHeader(
                announcement: announcement,
                isMobile: isMobile,
              ),
              const SizedBox(height: 12),
              Text(
                announcement.title,
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontFamily: AppFonts.born2B,
                  fontWeight: .bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                announcement.summary,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              _AnnouncementCardFooter(
                announcement: announcement,
                onReadMore: () => _showDetailDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnnouncementCardHeader extends StatelessWidget {
  final Announcement announcement;
  final bool isMobile;

  const _AnnouncementCardHeader({
    required this.announcement,
    required this.isMobile,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        AnnouncementTypeBadge(type: announcement.type),
        if (announcement.isPinned) ...[
          const SizedBox(width: 8),
          const AnnouncementPinnedBadge(),
        ],
        const Spacer(),
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
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AnnouncementCardFooter extends StatelessWidget {
  final Announcement announcement;
  final VoidCallback onReadMore;

  const _AnnouncementCardFooter({
    required this.announcement,
    required this.onReadMore,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final actionRoute = announcement.actionRoute;
    final actionLabel = announcement.actionLabel;

    return Wrap(
      alignment: .spaceBetween,
      crossAxisAlignment: .center,
      spacing: 12,
      runSpacing: 8,
      children: [
        TextButton.icon(
          style: TextButton.styleFrom(
            padding: .zero,
            foregroundColor: colorScheme.primary,
            textStyle: const TextStyle(
              fontFamily: AppFonts.born2B,
              fontSize: 15,
            ),
          ),
          icon: const Icon(Icons.arrow_forward, size: 16),
          label: const Text("Read Details"),
          onPressed: onReadMore,
        ),
        if (actionLabel != null && actionRoute != null)
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const .symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: .circular(8)),
              side: BorderSide(
                color: colorScheme.primary.withValues(alpha: 0.5),
              ),
            ),
            icon: const Icon(Icons.open_in_new, size: 14),
            label: Text(
              actionLabel,
              style: const TextStyle(fontFamily: AppFonts.born2B, fontSize: 13),
            ),
            onPressed: () => context.go(actionRoute),
          ),
      ],
    );
  }
}

class _EmptyAnnouncementsState extends StatelessWidget {
  const _EmptyAnnouncementsState();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const .all(32.0),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: .circular(16),
        border: .all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 12),
          Text(
            "No announcements in this category yet.",
            style: TextStyle(fontSize: 16, color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

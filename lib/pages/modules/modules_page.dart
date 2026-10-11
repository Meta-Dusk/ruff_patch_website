import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:capstone_website/core/app_fonts.dart';
import 'package:capstone_website/core/app_routes.dart';
import 'package:capstone_website/models/chapter.dart';
import 'package:capstone_website/models/chapter_progress.dart';
import 'package:capstone_website/services/progress_service.dart';
import 'package:capstone_website/widgets/global_appbar.dart';

class ModulesPage extends StatelessWidget {
  const ModulesPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.transparent,
    appBar: const GlobalAppBar(title: "Modules"),
    body: Padding(
      padding: const .all(24.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 380,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 0.9,
        ),
        itemCount: Chapter.allChapters.length,
        itemBuilder: (_, index) {
          return ChapterCard(chapter: Chapter.allChapters[index]);
        },
      ),
    ),
  );
}

class ChapterCard extends StatelessWidget {
  final Chapter chapter;

  const ChapterCard({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) => Card(
    elevation: 6,
    clipBehavior: .antiAlias,
    shape: RoundedRectangleBorder(borderRadius: .circular(16)),
    child: InkWell(
      onTap: () => context.go(AppRoutes.chapterPath(chapter.id)),
      child: ValueListenableBuilder<Map<String, ChapterProgress>>(
        valueListenable: ProgressService.progressNotifier,
        builder: (context, progressMap, _) {
          final progress =
              progressMap[chapter.id] ??
              ChapterProgress(chapterId: chapter.id);
          return _chapterCardContent(context, chapter, progress);
        },
      ),
    ),
  );

  Widget _chapterCardContent(
    BuildContext context,
    Chapter chapter,
    ChapterProgress progress,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget? statusBadge;
    if (progress.isCompleted) {
      statusBadge = Container(
        padding: const .symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green.shade600,
          borderRadius: .circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: .min,
          children: [
            const Icon(Icons.check_circle, size: 14, color: Colors.white),
            const SizedBox(width: 4),
            Text(
              progress.quizScore != null
                  ? 'Completed (${progress.quizScore}/${progress.quizTotal})'
                  : 'Completed',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: AppFonts.born2B,
              ),
            ),
          ],
        ),
      );
    } else if (progress.hasViewed) {
      statusBadge = Container(
        padding: const .symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.amber.shade800,
          borderRadius: .circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: .min,
          children: [
            Icon(Icons.play_circle_outline, size: 14, color: Colors.white),
            SizedBox(width: 4),
            Text(
              'In Progress',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontFamily: AppFonts.born2B,
              ),
            ),
          ],
        ),
      );
    }

    final topBanner = Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: .topLeft,
            end: .bottomRight,
            colors: [
              colorScheme.primary.withValues(alpha: 0.7),
              colorScheme.primary,
            ],
          ),
        ),
        child: Stack(
          alignment: .center,
          children: [
            // Background watermark icon
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                chapter.icon,
                size: 120,
                color: colorScheme.onPrimary.withValues(alpha: 0.15),
              ),
            ),
            // Main focused icon
            Icon(chapter.icon, size: 64, color: colorScheme.onPrimary),
            // Progress Status Badge
            if (statusBadge != null)
              Positioned(
                top: 12,
                left: 12,
                child: statusBadge,
              ),
          ],
        ),
      ),
    );

    final footerDetails = Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        _Badge(icon: Icons.schedule, label: chapter.duration),
        if (progress.isCompleted)
          _Badge(
            icon: Icons.check_circle_outline,
            label: 'Done',
            color: Colors.green.shade600,
          )
        else if (chapter.quiz != null)
          const _Badge(icon: Icons.quiz_outlined, label: 'Includes Quiz'),
      ],
    );

    final bottomContent = Expanded(
      flex: 4,
      child: Padding(
        padding: const .all(20.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              chapter.title,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: AppFonts.born2B,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: .ellipsis,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                chapter.description,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: AppFonts.born2B,
                  color: colorScheme.secondary,
                ),
                maxLines: 2,
                overflow: .ellipsis,
              ),
            ),
            const Divider(height: 24),
            footerDetails,
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        topBanner,
        bottomContent,
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _Badge({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final badgeColor = color ?? Theme.of(context).colorScheme.primary;
    return Row(
      children: [
        Icon(icon, size: 16, color: badgeColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontFamily: AppFonts.born2B,
            color: badgeColor,
          ),
        ),
      ],
    );
  }
}

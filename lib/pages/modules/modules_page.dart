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
        builder: (_, progressMap, _) {
          final progress =
              progressMap[chapter.id] ?? ChapterProgress(chapterId: chapter.id);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ChapterCardTopBanner(chapter: chapter, progress: progress),
              _ChapterCardBottomContent(chapter: chapter, progress: progress),
            ],
          );
        },
      ),
    ),
  );
}

class _ChapterCardTopBanner extends StatelessWidget {
  final Chapter chapter;
  final ChapterProgress progress;

  const _ChapterCardTopBanner({required this.chapter, required this.progress});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Expanded(
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
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                chapter.icon,
                size: 120,
                color: colorScheme.onPrimary.withValues(alpha: 0.15),
              ),
            ),
            Icon(chapter.icon, size: 64, color: colorScheme.onPrimary),
            if (progress.isCompleted || progress.hasViewed)
              Positioned(
                top: 12,
                left: 12,
                child: _ChapterStatusBadge(progress: progress),
              ),
          ],
        ),
      ),
    );
  }
}

class _ChapterStatusBadge extends StatelessWidget {
  final ChapterProgress progress;

  const _ChapterStatusBadge({required this.progress});

  @override
  Widget build(BuildContext context) {
    if (progress.isCompleted) {
      return Container(
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
    }

    return Container(
      padding: const .symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.amber.shade800,
        borderRadius: .circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 4),
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
}

class _ChapterCardBottomContent extends StatelessWidget {
  final Chapter chapter;
  final ChapterProgress progress;

  const _ChapterCardBottomContent({
    required this.chapter,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final footer = Row(
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

    final chapterTitle = Text(
      chapter.title,
      style: const TextStyle(
        fontSize: 20,
        fontFamily: AppFonts.born2B,
        height: 1.2,
      ),
      maxLines: 2,
      overflow: .ellipsis,
    );

    final chapterDescription = Expanded(
      child: Text(
        chapter.description,
        style: TextStyle(
          fontSize: 16,
          fontFamily: AppFonts.born2B,
          color: Theme.of(context).colorScheme.secondary,
        ),
        maxLines: 2,
        overflow: .ellipsis,
      ),
    );

    return Expanded(
      flex: 4,
      child: Padding(
        padding: const .all(20.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            chapterTitle,
            const SizedBox(height: 8),
            chapterDescription,
            const Divider(height: 24),
            footer,
          ],
        ),
      ),
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

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:capstone_website/core/app_fonts.dart';
import 'package:capstone_website/core/app_routes.dart';
import 'package:capstone_website/models/chapter_progress.dart';
import 'package:capstone_website/services/progress_service.dart';
import 'package:capstone_website/widgets/global_appbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = MediaQuery.sizeOf(context).width < 800;

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
            ValueListenableBuilder<Map<String, ChapterProgress>>(
              valueListenable: ProgressService.progressNotifier,
              builder: (context, _, _) {
                final next = ProgressService.nextChapter;
                final percentage =
                    (ProgressService.overallProgress * 100).toInt();

                return Container(
                  width: double.infinity,
                  padding: const .all(24),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: .circular(20),
                    border: .all(
                      color: colorScheme.primary.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Row(
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                percentage == 100
                                    ? Icons.check_circle
                                    : Icons.bolt,
                                color: percentage == 100
                                    ? Colors.green.shade600
                                    : colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                percentage == 100
                                    ? "All Modules Completed!"
                                    : "Your Learning Progress",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontFamily: AppFonts.born2B,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "$percentage%",
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: AppFonts.born2B,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: .circular(6),
                        child: LinearProgressIndicator(
                          value: ProgressService.overallProgress,
                          minHeight: 10,
                          backgroundColor:
                              colorScheme.primary.withValues(alpha: 0.15),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            percentage == 100
                                ? Colors.green.shade600
                                : colorScheme.primary,
                          ),
                        ),
                      ),
                      if (next != null) ...[
                        const SizedBox(height: 20),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          alignment: WrapAlignment.spaceBetween,
                          spacing: 16,
                          runSpacing: 12,
                          children: [
                            Text(
                              "Next up: ${next.title}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: .circular(10),
                                ),
                                padding: const .symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                              ),
                              icon: const Icon(
                                Icons.play_arrow,
                                size: 20,
                              ),
                              label: const Text(
                                "Continue Module",
                                style: TextStyle(
                                  fontFamily: AppFonts.born2B,
                                  fontSize: 16,
                                ),
                              ),
                              onPressed: () =>
                                  context.go(AppRoutes.chapterPath(next.id)),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

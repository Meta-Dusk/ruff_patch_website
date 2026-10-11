import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:capstone_website/core/app_fonts.dart';
import 'package:capstone_website/core/app_routes.dart';
import 'package:capstone_website/models/chapter.dart';
import 'package:capstone_website/models/chapter_progress.dart';
import 'package:capstone_website/services/auth_service.dart';
import 'package:capstone_website/services/progress_service.dart';
import 'package:capstone_website/widgets/global_appbar.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = MediaQuery.sizeOf(context).width < 800;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const GlobalAppBar(title: "Dashboard"),
      body: ValueListenableBuilder<Map<String, ChapterProgress>>(
        valueListenable: ProgressService.progressNotifier,
        builder: (context, progressMap, _) {
          final total = ProgressService.totalChapters;
          final completed = ProgressService.completedChapters;
          final percentage = (ProgressService.overallProgress * 100).toInt();

          final userName = AuthService.currentUser?.displayName ?? "Learner";

          final headerCard = Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: .circular(20)),
            child: Padding(
              padding: .all(isMobile ? 20 : 28),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: isMobile ? 24 : 32,
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        backgroundImage:
                            AuthService.currentUser?.photoUrl != null
                            ? NetworkImage(AuthService.currentUser!.photoUrl!)
                            : null,
                        child: AuthService.currentUser?.photoUrl == null
                            ? Text(
                                userName.isNotEmpty
                                    ? userName[0].toUpperCase()
                                    : "U",
                                style: TextStyle(
                                  fontSize: isMobile ? 24 : 32,
                                  fontFamily: AppFonts.born2B,
                                ),
                              )
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              "Welcome back, $userName!",
                              style: TextStyle(
                                fontSize: isMobile ? 24 : 32,
                                fontFamily: AppFonts.born2B,
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Here is your e-learning journey summary so far.",
                              style: TextStyle(
                                fontSize: isMobile ? 14 : 16,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        "Overall Completion: $percentage%",
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 18,
                          fontFamily: AppFonts.born2B,
                          color: colorScheme.primary,
                        ),
                      ),
                      Text(
                        "$completed of $total Modules",
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          fontFamily: AppFonts.born2B,
                          color: colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: .circular(8),
                    child: LinearProgressIndicator(
                      value: ProgressService.overallProgress,
                      minHeight: 12,
                      backgroundColor: colorScheme.primary.withValues(
                        alpha: 0.15,
                      ),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        percentage == 100
                            ? Colors.green.shade600
                            : colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

          final modulesList = Chapter.allChapters.map((chapter) {
            final progress =
                progressMap[chapter.id] ??
                ChapterProgress(chapterId: chapter.id);

            Widget statusWidget;
            if (progress.isCompleted) {
              statusWidget = Container(
                padding: const .symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.12),
                  borderRadius: .circular(12),
                  border: .all(color: Colors.green.shade600),
                ),
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 14,
                      color: Colors.green.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      progress.quizScore != null
                          ? "Quiz Passed (${progress.quizScore}/${progress.quizTotal})"
                          : "Completed",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: AppFonts.born2B,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              );
            } else if (progress.hasViewed) {
              statusWidget = Container(
                padding: const .symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  borderRadius: .circular(12),
                  border: .all(color: Colors.amber.shade700),
                ),
                child: Row(
                  mainAxisSize: .min,
                  children: [
                    Icon(
                      Icons.play_circle_outline,
                      size: 14,
                      color: Colors.amber.shade800,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "In Progress",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: AppFonts.born2B,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              statusWidget = Container(
                padding: const .symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: .circular(12),
                  border: .all(color: colorScheme.outlineVariant),
                ),
                child: Text(
                  "Not Started",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: AppFonts.born2B,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }

            return Card(
              margin: const .only(bottom: 12),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: .circular(16)),
              child: ListTile(
                contentPadding: const .symmetric(horizontal: 20, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                  child: Icon(chapter.icon, color: colorScheme.primary),
                ),
                title: Text(
                  chapter.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: AppFonts.born2B,
                  ),
                ),
                subtitle: Padding(
                  padding: const .only(top: 4.0),
                  child: Row(
                    children: [
                      statusWidget,
                      const SizedBox(width: 12),
                      Text(
                        chapter.duration,
                        style: TextStyle(
                          fontSize: 13,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: .circular(10)),
                    padding: const .symmetric(horizontal: 16, vertical: 10),
                  ),
                  onPressed: () =>
                      context.go(AppRoutes.chapterPath(chapter.id)),
                  child: Text(
                    progress.isCompleted ? "Review" : "Continue",
                    style: const TextStyle(
                      fontFamily: AppFonts.born2B,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            );
          }).toList();

          return ListView(
            padding: const .all(24.0),
            children: [
              headerCard,
              const SizedBox(height: 32),
              Text(
                "Module Progress Breakdown",
                style: TextStyle(
                  fontSize: isMobile ? 22 : 28,
                  fontFamily: AppFonts.born2B,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 16),
              ...modulesList,
            ],
          );
        },
      ),
    );
  }
}

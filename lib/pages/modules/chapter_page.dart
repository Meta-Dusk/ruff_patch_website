import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'package:capstone_website/core/app_fonts.dart';
import 'package:capstone_website/core/app_routes.dart';
import 'package:capstone_website/models/chapter.dart';
import 'package:capstone_website/models/chapter_progress.dart';
import 'package:capstone_website/services/progress_service.dart';

class ChapterPage extends StatefulWidget {
  final String chapterId;

  const ChapterPage({super.key, required this.chapterId});

  @override
  State<ChapterPage> createState() => _ChapterPageState();
}

class _ChapterPageState extends State<ChapterPage> {
  late YoutubePlayerController _controller;
  Chapter? _currentChapter;

  @override
  void initState() {
    super.initState();

    _currentChapter = Chapter.getChapterById(widget.chapterId);
    final String fullYoutubeUrl = _currentChapter?.videoUrl ?? "";
    final String extractedId =
        YoutubePlayerController.convertUrlToId(fullYoutubeUrl) ?? "";

    _controller = YoutubePlayerController.fromVideoId(
      videoId: extractedId,
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
      ),
    );

    // Auto-mark chapter as viewed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ProgressService.markChapterViewed(widget.chapterId);
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_currentChapter == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Chapter Not Found")),
        body: const Center(child: Text("Sorry, this chapter does not exist.")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go(AppRoutes.modules),
        ),
        title: Text(
          _currentChapter!.title,
          style: const TextStyle(fontFamily: AppFonts.born2B),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [_ChapterCompletedChip(chapterId: widget.chapterId)],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ValueListenableBuilder<Map<String, ChapterProgress>>(
            valueListenable: ProgressService.progressNotifier,
            builder: (_, progressMap, _) {
              final progress =
                  progressMap[widget.chapterId] ??
                  ChapterProgress(chapterId: widget.chapterId);

              return ListView(
                padding: const .all(24.0),
                children: [
                  _VideoPlayerCard(controller: _controller),
                  const SizedBox(height: 32),
                  if (_currentChapter!.quiz != null)
                    _QuizBanner(
                      chapterId: widget.chapterId,
                      progress: progress,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ChapterCompletedChip extends StatelessWidget {
  final String chapterId;

  const _ChapterCompletedChip({required this.chapterId});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String, ChapterProgress>>(
      valueListenable: ProgressService.progressNotifier,
      builder: (_, progressMap, _) {
        final progress =
            progressMap[chapterId] ?? ChapterProgress(chapterId: chapterId);

        if (!progress.isCompleted) return const SizedBox.shrink();

        return Padding(
          padding: const .only(right: 24.0),
          child: Chip(
            avatar: const Icon(
              Icons.check_circle,
              color: Colors.white,
              size: 16,
            ),
            label: const Text(
              'Completed',
              style: TextStyle(
                color: Colors.white,
                fontFamily: AppFonts.born2B,
              ),
            ),
            backgroundColor: Colors.green.shade600,
          ),
        );
      },
    );
  }
}

class _VideoPlayerCard extends StatelessWidget {
  final YoutubePlayerController controller;

  const _VideoPlayerCard({required this.controller});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.onSurface,
        borderRadius: .circular(16),
        boxShadow: [
          BoxShadow(
            color: colorScheme.onSurface.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: .circular(16),
        child: YoutubePlayer(controller: controller, aspectRatio: 16 / 9),
      ),
    );
  }
}

class _QuizBanner extends StatelessWidget {
  final String chapterId;
  final ChapterProgress progress;

  const _QuizBanner({required this.chapterId, required this.progress});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasCompletedQuiz = progress.quizScore != null;

    final quizStatus = Row(
      mainAxisAlignment: .center,
      children: [
        Icon(
          hasCompletedQuiz ? Icons.check_circle : Icons.quiz_outlined,
          color: hasCompletedQuiz ? Colors.green.shade600 : colorScheme.primary,
          size: 28,
        ),
        const SizedBox(width: 10),
        Text(
          hasCompletedQuiz
              ? 'Quiz Passed! (${progress.quizScore}/${progress.quizTotal})'
              : 'Ready to test your knowledge?',
          style: TextStyle(
            fontSize: 24,
            fontFamily: AppFonts.born2B,
            fontWeight: .bold,
            color: hasCompletedQuiz
                ? Colors.green.shade700
                : colorScheme.onSurface,
          ),
        ),
      ],
    );

    final quizContextButton = ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: hasCompletedQuiz
            ? Colors.green.shade700
            : colorScheme.primary,
        foregroundColor: Colors.white,
        padding: const .symmetric(horizontal: 32, vertical: 18),
        textStyle: const TextStyle(fontSize: 18, fontFamily: AppFonts.born2B),
      ),
      icon: Icon(hasCompletedQuiz ? Icons.replay : Icons.quiz),
      label: Text(hasCompletedQuiz ? 'Retake Quiz' : 'Start Quiz'),
      onPressed: () => context.go(AppRoutes.quizPath(chapterId)),
    );

    return Container(
      padding: const .all(32),
      decoration: BoxDecoration(
        color: hasCompletedQuiz
            ? Colors.green.withValues(alpha: 0.08)
            : colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: .circular(16),
        border: .all(
          color: hasCompletedQuiz ? Colors.green.shade600 : colorScheme.primary,
        ),
      ),
      child: Column(
        children: [quizStatus, const SizedBox(height: 16), quizContextButton],
      ),
    );
  }
}

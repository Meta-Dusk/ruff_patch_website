import 'package:capstone_website/core/app_routes.dart';
import 'package:capstone_website/models/chapter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:capstone_website/core/app_fonts.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

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

    final youtubeVideoWidget = Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: YoutubePlayer(controller: _controller, aspectRatio: 16 / 9),
      ),
    );

    final quizSection = Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
      child: Column(
        children: [
          const Text(
            'Ready to test your knowledge?',
            style: TextStyle(
              fontSize: 24,
              fontFamily: AppFonts.born2B,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.surfaceContainer,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              textStyle: const TextStyle(
                fontSize: 18,
                fontFamily: AppFonts.born2B,
              ),
            ),
            icon: const Icon(Icons.quiz),
            label: const Text('Start Quiz'),
            onPressed: () {
              context.go(AppRoutes.quizPath(widget.chapterId));
            },
          ),
        ],
      ),
    );

    final constrainedBox = ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 900,
      ), // Keep content from stretching too wide on a desktop monitor
      child: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          youtubeVideoWidget,
          const SizedBox(height: 40),
          if (_currentChapter!.quiz != null) quizSection,
        ],
      ),
    );

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
      ),
      body: Center(child: constrainedBox),
    );
  }
}

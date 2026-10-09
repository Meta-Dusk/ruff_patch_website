import 'package:capstone_website/core/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:capstone_website/core/app_fonts.dart';
import 'package:capstone_website/models/chapter.dart';
import 'package:capstone_website/models/quiz.dart';

class QuizPage extends StatefulWidget {
  final String chapterId;

  const QuizPage({super.key, required this.chapterId});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late Chapter? _chapter;
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedOptionIndex;
  bool _isFinished = false;

  @override
  void initState() {
    super.initState();
    _chapter = Chapter.getChapterById(widget.chapterId);
  }

  void _submitAnswer() {
    // Don't allow submission without an answer
    if (_selectedOptionIndex == null) return;

    final currentQuestion = _chapter!.quiz!.questions[_currentQuestionIndex];

    if (_selectedOptionIndex == currentQuestion.correctAnswerIndex) {
      _score++;
    }

    if (_currentQuestionIndex < _chapter!.quiz!.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null; // Reset selection for the next question
      });
    } else {
      setState(() {
        _isFinished = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_chapter == null || _chapter!.quiz == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz Error')),
        body: const Center(child: Text('Quiz not found for this chapter.')),
      );
    }

    final quiz = _chapter!.quiz!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go(AppRoutes.chapterPath(widget.chapterId)),
        ),
        title: Text(
          'Quiz: ${_chapter!.title}',
          style: const TextStyle(fontFamily: AppFonts.born2B),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const .all(32.0),
            child: _isFinished ? _buildResultsView() : _buildQuizView(quiz),
          ),
        ),
      ),
    );
  }

  Widget _buildQuizView(Quiz quiz) {
    final colorScheme = Theme.of(context).colorScheme;
    final question = quiz.questions[_currentQuestionIndex];

    final optionsList = List.generate(question.options.length, (index) {
      final isSelected = _selectedOptionIndex == index;
      final container = Container(
        padding: const .all(20),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withValues(alpha: 0.1)
              : colorScheme.surfaceContainer,
          border: .all(
            color: isSelected
                ? colorScheme.primary
                : colorScheme.outlineVariant,
            width: 2,
          ),
          borderRadius: .circular(12),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                question.options[index],
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      );

      return Padding(
        padding: const .only(bottom: 12.0),
        child: InkWell(
          onTap: () => setState(() => _selectedOptionIndex = index),
          child: container,
        ),
      );
    });

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          'Question ${_currentQuestionIndex + 1} of ${quiz.questions.length}',
          style: const TextStyle(fontSize: 18, color: Colors.black54),
        ),
        const SizedBox(height: 16),
        Text(
          question.text,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: .bold,
            fontFamily: AppFonts.liberationSans,
          ),
        ),
        const SizedBox(height: 32),
        ...optionsList,
        const Spacer(),
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: .circular(12)),
            ),
            onPressed: _selectedOptionIndex == null ? null : _submitAnswer,
            child: Text(
              _currentQuestionIndex == quiz.questions.length - 1
                  ? 'Finish Quiz'
                  : 'Next Question',
              style: const TextStyle(fontSize: 20, fontFamily: AppFonts.born2B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsView() {
    final children = [
      const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
      const SizedBox(height: 24),
      const Text(
        'Quiz Completed!',
        style: TextStyle(
          fontSize: 36,
          fontFamily: AppFonts.born2B,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 16),
      Text(
        'You scored $_score out of ${_chapter!.quiz!.questions.length}',
        style: const TextStyle(
          fontSize: 24,
          fontFamily: AppFonts.liberationSans,
        ),
      ),
      const SizedBox(height: 40),
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          padding: const .symmetric(horizontal: 40, vertical: 20),
        ),
        onPressed: () => context.go(AppRoutes.chapterPath(widget.chapterId)),
        child: const Text(
          'Back to Chapter',
          style: TextStyle(fontSize: 18, fontFamily: AppFonts.born2B),
        ),
      ),
    ];

    return Center(
      child: Column(mainAxisAlignment: .center, children: children),
    );
  }
}

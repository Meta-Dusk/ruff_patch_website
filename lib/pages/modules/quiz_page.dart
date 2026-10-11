import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:capstone_website/core/app_fonts.dart';
import 'package:capstone_website/core/app_routes.dart';
import 'package:capstone_website/models/chapter.dart';
import 'package:capstone_website/models/quiz.dart';
import 'package:capstone_website/services/progress_service.dart';

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
    if (_selectedOptionIndex == null) return;

    final currentQuestion = _chapter!.quiz!.questions[_currentQuestionIndex];

    if (_selectedOptionIndex == currentQuestion.correctAnswerIndex) {
      _score++;
    }

    if (_currentQuestionIndex < _chapter!.quiz!.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOptionIndex = null;
      });
    } else {
      setState(() {
        _isFinished = true;
      });

      // Automatically persist quiz results
      ProgressService.saveQuizResult(
        widget.chapterId,
        _score,
        _chapter!.quiz!.questions.length,
      );
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

    final quizResultsView = _isFinished
        ? _QuizResultsView(
            score: _score,
            totalQuestions: quiz.questions.length,
            chapterId: widget.chapterId,
          )
        : _QuizQuestionView(
            quiz: quiz,
            currentQuestionIndex: _currentQuestionIndex,
            selectedOptionIndex: _selectedOptionIndex,
            onOptionSelected: (idx) =>
                setState(() => _selectedOptionIndex = idx),
            onSubmit: _selectedOptionIndex == null ? null : _submitAnswer,
          );

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
          child: Padding(padding: const .all(32.0), child: quizResultsView),
        ),
      ),
    );
  }
}

class _QuizQuestionView extends StatelessWidget {
  final Quiz quiz;
  final int currentQuestionIndex;
  final int? selectedOptionIndex;
  final ValueChanged<int> onOptionSelected;
  final VoidCallback? onSubmit;

  const _QuizQuestionView({
    required this.quiz,
    required this.currentQuestionIndex,
    required this.selectedOptionIndex,
    required this.onOptionSelected,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final question = quiz.questions[currentQuestionIndex];
    final isLastQuestion = currentQuestionIndex == quiz.questions.length - 1;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Text(
          'Question ${currentQuestionIndex + 1} of ${quiz.questions.length}',
          style: TextStyle(
            fontSize: 18,
            color: colorScheme.onSurfaceVariant,
            fontFamily: AppFonts.born2B,
          ),
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
        for (int i = 0; i < question.options.length; i++)
          _QuizOptionTile(
            optionText: question.options[i],
            isSelected: selectedOptionIndex == i,
            onTap: () => onOptionSelected(i),
          ),
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
            onPressed: onSubmit,
            child: Text(
              isLastQuestion ? 'Finish Quiz' : 'Next Question',
              style: const TextStyle(fontSize: 20, fontFamily: AppFonts.born2B),
            ),
          ),
        ),
      ],
    );
  }
}

class _QuizOptionTile extends StatelessWidget {
  final String optionText;
  final bool isSelected;
  final VoidCallback onTap;

  const _QuizOptionTile({
    required this.optionText,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const .only(bottom: 12.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(12),
        child: Container(
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
                child: Text(optionText, style: const TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizResultsView extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final String chapterId;

  const _QuizResultsView({
    required this.score,
    required this.totalQuestions,
    required this.chapterId,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: .center,
        children: [
          const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
          const SizedBox(height: 24),
          const Text(
            'Quiz Completed!',
            style: TextStyle(
              fontSize: 36,
              fontFamily: AppFonts.born2B,
              fontWeight: .bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'You scored $score out of $totalQuestions',
            style: const TextStyle(
              fontSize: 24,
              fontFamily: AppFonts.liberationSans,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const .symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: .circular(20),
              border: .all(color: Colors.green.shade600),
            ),
            child: Row(
              mainAxisSize: .min,
              children: [
                Icon(Icons.cloud_done, size: 18, color: Colors.green.shade600),
                const SizedBox(width: 8),
                Text(
                  'Progress Auto-Saved',
                  style: TextStyle(
                    fontFamily: AppFonts.born2B,
                    fontSize: 16,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: const .symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(borderRadius: .circular(12)),
            ),
            onPressed: () => context.go(AppRoutes.chapterPath(chapterId)),
            child: const Text(
              'Back to Chapter',
              style: TextStyle(fontSize: 18, fontFamily: AppFonts.born2B),
            ),
          ),
        ],
      ),
    );
  }
}

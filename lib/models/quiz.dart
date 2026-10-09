class Question {
  final String text;
  final List<String> options;
  final int correctAnswerIndex;

  const Question({
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
  });
}

class Quiz {
  final List<Question> questions;

  const Quiz({required this.questions});
}

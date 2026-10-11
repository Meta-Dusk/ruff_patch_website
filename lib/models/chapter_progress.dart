class ChapterProgress {
  final String chapterId;
  final bool hasViewed;
  final bool isCompleted;
  final int? quizScore;
  final int? quizTotal;
  final DateTime? lastUpdated;

  const ChapterProgress({
    required this.chapterId,
    this.hasViewed = false,
    this.isCompleted = false,
    this.quizScore,
    this.quizTotal,
    this.lastUpdated,
  });

  ChapterProgress copyWith({
    bool? hasViewed,
    bool? isCompleted,
    int? quizScore,
    int? quizTotal,
    DateTime? lastUpdated,
  }) => ChapterProgress(
    chapterId: chapterId,
    hasViewed: hasViewed ?? this.hasViewed,
    isCompleted: isCompleted ?? this.isCompleted,
    quizScore: quizScore ?? this.quizScore,
    quizTotal: quizTotal ?? this.quizTotal,
    lastUpdated: lastUpdated ?? this.lastUpdated,
  );

  Map<String, dynamic> toMap() => {
    'chapterId': chapterId,
    'hasViewed': hasViewed,
    'isCompleted': isCompleted,
    'quizScore': quizScore,
    'quizTotal': quizTotal,
    'lastUpdated': lastUpdated?.toIso8601String(),
  };

  factory ChapterProgress.fromMap(Map<String, dynamic> map) => ChapterProgress(
    chapterId: map['chapterId'] as String? ?? '',
    hasViewed: map['hasViewed'] as bool? ?? false,
    isCompleted: map['isCompleted'] as bool? ?? false,
    quizScore: map['quizScore'] as int?,
    quizTotal: map['quizTotal'] as int?,
    lastUpdated: map['lastUpdated'] != null
        ? DateTime.tryParse(map['lastUpdated'] as String)
        : null,
  );
}


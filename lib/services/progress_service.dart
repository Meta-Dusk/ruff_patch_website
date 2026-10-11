import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:capstone_website/models/chapter.dart';
import 'package:capstone_website/models/chapter_progress.dart';
import 'package:capstone_website/services/auth_service.dart';

class ProgressService {
  ProgressService._();

  static final ValueNotifier<Map<String, ChapterProgress>> progressNotifier =
      ValueNotifier<Map<String, ChapterProgress>>({});

  static StreamSubscription<DocumentSnapshot>? _firestoreSubscription;
  static bool _isInitialized = false;

  /// Initializes the service and connects to user auth state changes.
  static void initialize() {
    if (_isInitialized) return;
    _isInitialized = true;

    AuthService.userNotifier.addListener(_onUserChanged);
    _onUserChanged();
  }

  static void _onUserChanged() {
    final user = AuthService.currentUser;
    _firestoreSubscription?.cancel();
    _firestoreSubscription = null;

    if (user == null) {
      progressNotifier.value = {};
      return;
    }

    if (user.isGuest || !AuthService.isConfigured || user.uid == null) {
      _loadFromLocalStorage();
    } else {
      _listenToFirestore(user.uid!);
    }
  }

  /// Listens to real-time progress updates from Cloud Firestore.
  static void _listenToFirestore(String uid) {
    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      _firestoreSubscription = docRef.snapshots().listen(
        (snapshot) {
          if (!snapshot.exists || snapshot.data() == null) {
            progressNotifier.value = {};
            return;
          }

          final data = snapshot.data()!;
          final rawProgress = data['progress'] as Map<String, dynamic>? ?? {};

          final Map<String, ChapterProgress> mapped = {};
          rawProgress.forEach((key, val) {
            if (val is Map<String, dynamic>) {
              mapped[key] = ChapterProgress.fromMap(val);
            }
          });

          progressNotifier.value = mapped;
        },
        onError: (error) {
          debugPrint('Firestore progress sync error: $error');
          _loadFromLocalStorage();
        },
      );
    } catch (e) {
      debugPrint('Firestore initialization failed: $e');
      _loadFromLocalStorage();
    }
  }

  /// Loads cached progress from browser localStorage via SharedPreferences.
  static Future<void> _loadFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final user = AuthService.currentUser;
      final key = user?.uid != null
          ? 'progress_${user!.uid}'
          : 'guest_progress';
      final rawJson = prefs.getString(key);

      if (rawJson != null) {
        final decoded = jsonDecode(rawJson) as Map<String, dynamic>;
        final Map<String, ChapterProgress> mapped = {};
        decoded.forEach((k, v) {
          if (v is Map<String, dynamic>) {
            mapped[k] = ChapterProgress.fromMap(v);
          }
        });
        progressNotifier.value = mapped;
      } else {
        progressNotifier.value = {};
      }
    } catch (e) {
      debugPrint('Local storage read error: $e');
      progressNotifier.value = {};
    }
  }

  /// Automatically marks a chapter as viewed and saves progress.
  static Future<void> markChapterViewed(String chapterId) async {
    final currentMap = Map<String, ChapterProgress>.from(
      progressNotifier.value,
    );
    final existing =
        currentMap[chapterId] ?? ChapterProgress(chapterId: chapterId);

    // If chapter has no quiz, viewing it marks it completed
    final chapter = Chapter.getChapterById(chapterId);
    final hasNoQuiz = chapter != null && chapter.quiz == null;

    final updated = existing.copyWith(
      hasViewed: true,
      isCompleted: existing.isCompleted || hasNoQuiz,
      lastUpdated: DateTime.now(),
    );

    currentMap[chapterId] = updated;
    progressNotifier.value = currentMap;

    await _saveProgress(currentMap);
  }

  /// Saves the quiz result and marks the chapter completed.
  static Future<void> saveQuizResult(
    String chapterId,
    int score,
    int total,
  ) async {
    final currentMap = Map<String, ChapterProgress>.from(
      progressNotifier.value,
    );
    final existing =
        currentMap[chapterId] ?? ChapterProgress(chapterId: chapterId);

    final updated = existing.copyWith(
      hasViewed: true,
      isCompleted: true,
      quizScore: score,
      quizTotal: total,
      lastUpdated: DateTime.now(),
    );

    currentMap[chapterId] = updated;
    progressNotifier.value = currentMap;

    await _saveProgress(currentMap);
  }

  /// Persists progress to Firestore (if logged in with Firebase) and local storage.
  static Future<void> _saveProgress(
    Map<String, ChapterProgress> progress,
  ) async {
    final user = AuthService.currentUser;

    //? Always save to local storage (instant cache & guest support)
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = user?.uid != null
          ? 'progress_${user!.uid}'
          : 'guest_progress';
      final serialized = progress.map((k, v) => MapEntry(k, v.toMap()));
      await prefs.setString(key, jsonEncode(serialized));
    } catch (e) {
      debugPrint('Local storage save error: $e');
    }

    //? If logged in with Firebase, sync to Cloud Firestore
    if (user != null &&
        !user.isGuest &&
        AuthService.isConfigured &&
        user.uid != null) {
      try {
        final docRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);
        final serialized = progress.map((k, v) => MapEntry(k, v.toMap()));

        await docRef.set({
          'displayName': user.displayName,
          'email': user.email,
          'lastActive': FieldValue.serverTimestamp(),
          'progress': serialized,
        }, SetOptions(merge: true));
      } catch (e) {
        debugPrint('Firestore auto-save error: $e');
      }
    }
  }

  /// Returns progress for a specific chapter.
  static ChapterProgress getProgress(String chapterId) {
    return progressNotifier.value[chapterId] ??
        ChapterProgress(chapterId: chapterId);
  }

  /// Total number of chapters.
  static int get totalChapters => Chapter.allChapters.length;

  /// Number of completed chapters.
  static int get completedChapters {
    return progressNotifier.value.values.where((p) => p.isCompleted).length;
  }

  /// Percentage of overall completion (0.0 to 1.0).
  static double get overallProgress {
    if (totalChapters == 0) return 0.0;
    return (completedChapters / totalChapters).clamp(0.0, 1.0);
  }

  /// Next unfinished chapter for quick continuing.
  static Chapter? get nextChapter {
    for (final chapter in Chapter.allChapters) {
      final prog = getProgress(chapter.id);
      if (!prog.isCompleted) {
        return chapter;
      }
    }
    return Chapter.allChapters.isNotEmpty ? Chapter.allChapters.first : null;
  }
}

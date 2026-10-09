import 'package:capstone_website/models/quiz.dart';
import 'package:flutter/material.dart';

class Chapter {
  final String id;
  final String title;
  final String description;
  final String videoUrl;
  final IconData icon;
  final String duration;
  final Quiz? quiz;

  const Chapter({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.icon,
    required this.duration,
    this.quiz,
  });

  static const List<Chapter> allChapters = [
    Chapter(
      id: "chapter-1",
      title: "Introduction to Dog Care",
      description: "Basics of keeping your furbaby happy.",
      videoUrl: "https://youtu.be/6eUKxWxj2vI?si=bSQpVF32fsLA5CO2",
      icon: Icons.pets,
      duration: "15 mins.",
      quiz: Quiz(
        questions: [
          Question(
            text: "What does 'TNR' stand for?",
            options: [
              "Trap, Neuter, Release",
              "Treat, Nullify, Rebound",
              "Try Nothing Rectifying",
              "Treduse, Neruse, Recycle",
            ],
            correctAnswerIndex: 0,
          ),
          Question(
            text: "What is the purpose of TNR?",
            options: [
              "To sterilize stray dogs",
              "To neutralize stray dogs",
              "To capture stray dogs",
              "To protect stray dogs",
            ],
            correctAnswerIndex: 0,
          ),
          Question(
            text: "Why is the purpose of TNR important?",
            options: [
              "It helps increase stray population",
              "It helps control stray population",
              "It helps decrease stray population",
              "It helps capture the stray population",
            ],
            correctAnswerIndex: 1,
          ),
          Question(
            text:
                "Why should pet owners sterilize "
                "and prohibit free-roaming for their dogs?",
            options: [
              "It increases the chances of reproducing with stray dogs",
              "It maintains the chances of reproducing with stray dogs",
              "It reduces the chances of reproducing with stray dogs",
              "It ensures the chances of reproducing with stray dogs",
            ],
            correctAnswerIndex: 2,
          ),
        ],
      ),
    ),
    Chapter(
      id: "chapter-2",
      title: "Nutrition & Diet",
      description: "What to feed and what to avoid.",
      videoUrl: "https://youtu.be/8ulA5-cb2po?si=_-NyQG8ZFexjDo8W",
      icon: Icons.restaurant,
      duration: "20 mins.",
    ),
    Chapter(
      id: "chapter-3",
      title: "Basic Training",
      description: "Sit, stay, and heel commands.",
      videoUrl: "https://youtu.be/IKDrqkFBNmo?si=p8ioYEVQVlPcHGPe",
      icon: Icons.sports_score,
      duration: "25 mins.",
    ),
  ];

  static Chapter? getChapterById(String id) {
    try {
      return allChapters.firstWhere((chapter) => chapter.id == id);
    } catch (e) {
      return null;
    }
  }
}

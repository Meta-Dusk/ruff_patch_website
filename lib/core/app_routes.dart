class AppRoutes {
  AppRoutes._();

  static const String home = '/home';
  static const String modules = '/modules';
  static const String resources = '/resources';
  static const String dashboard = '/dashboard';
  static const String login = '/login';

  static String chapterPath(String chapterId) => "$modules/$chapterId";
  static String quizPath(String chapterId) => "$modules/$chapterId/quiz";
}

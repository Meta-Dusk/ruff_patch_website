import 'package:capstone_website/app.dart';
import 'package:capstone_website/core/app_routes.dart';
import 'package:capstone_website/pages/dashboard_page.dart';
import 'package:capstone_website/pages/home_page.dart';
import 'package:capstone_website/pages/login_page.dart';
import 'package:capstone_website/pages/modules/chapter_page.dart';
import 'package:capstone_website/pages/modules/modules_page.dart';
import 'package:capstone_website/pages/modules/quiz_page.dart';
import 'package:capstone_website/pages/resources_page.dart';
import 'package:capstone_website/widgets/main_layout.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final branches = [
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
  ),
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.modules,
        builder: (context, state) => const ModulesPage(),
        routes: [
          // Nested route for individual chapters (e.g., /modules/chapter-1)
          GoRoute(
            path: ':chapterId',
            builder: (context, state) {
              final chapterId = state.pathParameters['chapterId']!;
              return ChapterPage(chapterId: chapterId);
            },
            routes: [
              GoRoute(
                path: "quiz",
                builder: (context, state) {
                  final chapterId = state.pathParameters["chapterId"]!;
                  return QuizPage(chapterId: chapterId);
                },
              ),
            ],
          ),
        ],
      ),
    ],
  ),
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.resources,
        builder: (context, state) => const ResourcesPage(),
      ),
    ],
  ),
  StatefulShellBranch(
    routes: [
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardPage(),
      ),
    ],
  ),
];

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.login,
  refreshListenable: userNotifier,
  redirect: (context, state) {
    final isLoggedIn = userNotifier.value != null;
    final isGoingToLogin = state.matchedLocation == AppRoutes.login;

    if (!isLoggedIn && !isGoingToLogin) return AppRoutes.login;
    if (isLoggedIn && isGoingToLogin) return AppRoutes.home;

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    // The ShellRoute keeps the Sidebar persistent
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainLayout(navigationShell: navigationShell);
      },
      branches: branches,
    ),
  ],
);

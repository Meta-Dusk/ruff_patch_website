import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:capstone_website/core/app_fonts.dart';
import 'package:capstone_website/services/auth_service.dart';
import 'blackboard_sidebar.dart';

class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final userProfile = ValueListenableBuilder<User?>(
      valueListenable: AuthService.userNotifier,
      builder: (_, user, _) {
        final name = user?.displayName ?? user?.email ?? "Guest";
        final photoUrl = user?.photoURL;
        final colorScheme = Theme.of(context).colorScheme;

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 8,
          ),
          leading: CircleAvatar(
            backgroundColor: colorScheme.onPrimary,
            foregroundColor: colorScheme.primary,
            backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
            child: photoUrl == null
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : "?",
                    style: const TextStyle(
                      fontFamily: AppFonts.born2B,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  )
                : null,
          ),
          title: Text(
            name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: colorScheme.onPrimary,
              fontFamily: AppFonts.born2B,
              fontSize: 16,
            ),
          ),
          trailing: IconButton(
            onPressed: () => AuthService.signOut(),
            icon: Icon(
              Icons.logout,
              color: Theme.of(
                context,
              ).colorScheme.onPrimary.withValues(alpha: 0.7),
            ),
            tooltip: "Logout",
          ),
        );
      },
    );

    final leftPanel = Container(
      width: 260,
      color: colorScheme.primary,
      child: Column(
        children: [
          Expanded(
            child: BlackboardSidebar(
              selectedIndex: navigationShell.currentIndex,
              onItemSelected: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
            ),
          ),

          Divider(
            height: 1,
            color: Theme.of(
              context,
            ).colorScheme.onPrimary.withValues(alpha: 0.24),
          ),
          userProfile,
          const SizedBox(height: 16),
        ],
      ),
    );

    final rightPanel = Expanded(
      child: Container(
        color: colorScheme.surfaceContainer,
        child: navigationShell,
      ),
    );

    return Scaffold(body: Row(children: [leftPanel, rightPanel]));
  }
}

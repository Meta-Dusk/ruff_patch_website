import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:capstone_website/core/app_fonts.dart';
import 'package:capstone_website/services/auth_service.dart';
import 'sidebar.dart';

class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Row(
      children: [
        _LeftPanel(
          navigationShell: navigationShell,
          userProfile: _UserProfile(),
        ),
        _RightPanel(navigationShell: navigationShell),
      ],
    ),
  );
}

class _UserProfile extends StatelessWidget {
  const _UserProfile();

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<User?>(
    valueListenable: AuthService.userNotifier,
    builder: (_, user, _) {
      final name = user?.displayName ?? user?.email ?? "Guest";
      final photoUrl = user?.photoURL;
      final colorScheme = Theme.of(context).colorScheme;

      final avatarText = Text(
        name.isNotEmpty ? name[0].toUpperCase() : "?",
        style: const TextStyle(fontFamily: AppFonts.born2B, fontSize: 24),
        textAlign: .center,
      );

      return ListTile(
        contentPadding: const .symmetric(horizontal: 24, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: colorScheme.onPrimary,
          foregroundColor: colorScheme.primary,
          backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
          child: photoUrl == null ? avatarText : null,
        ),
        title: Text(
          name,
          maxLines: 1,
          overflow: .ellipsis,
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
            color: colorScheme.onPrimary.withValues(alpha: 0.7),
          ),
          tooltip: "Logout",
        ),
      );
    },
  );
}

class _RightPanel extends StatelessWidget {
  const _RightPanel({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Container(
        color: colorScheme.surfaceContainer,
        child: navigationShell,
      ),
    );
  }
}

class _LeftPanel extends StatelessWidget {
  const _LeftPanel({required this.navigationShell, required this.userProfile});

  final StatefulNavigationShell navigationShell;
  final _UserProfile userProfile;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 260,
      color: colorScheme.primary,
      child: Column(
        children: [
          Expanded(
            child: Sidebar(
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
            color: colorScheme.onPrimary.withValues(alpha: 0.24),
          ),
          userProfile,
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:capstone_website/core/app_fonts.dart';
import 'package:capstone_website/services/auth_service.dart';
import 'sidebar.dart';

class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({super.key, required this.navigationShell});

  static final scaffoldKey = GlobalKey<ScaffoldState>();
  static final sidebarCollapsedNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = MediaQuery.sizeOf(context).width < 800;

    return ValueListenableBuilder<bool>(
      valueListenable: sidebarCollapsedNotifier,
      builder: (context, isCollapsed, _) {
        final leftPanel = _LeftPanel(
          navigationShell: navigationShell,
          userProfile: _UserProfile(isCollapsed: isCollapsed),
          isCollapsed: isCollapsed,
          isDrawer: false,
          onToggleCollapse: () => sidebarCollapsedNotifier.value = !isCollapsed,
        );

        final drawer = Drawer(
          backgroundColor: colorScheme.primary,
          child: SafeArea(
            child: _LeftPanel(
              navigationShell: navigationShell,
              userProfile: const _UserProfile(isCollapsed: false),
              isCollapsed: false,
              isDrawer: true,
              onToggleCollapse: null,
            ),
          ),
        );

        return Scaffold(
          key: scaffoldKey,
          drawer: isMobile ? drawer : null,
          body: Row(
            children: [
              if (!isMobile) leftPanel,
              _RightPanel(navigationShell: navigationShell),
            ],
          ),
        );
      },
    );
  }
}

class _UserProfile extends StatelessWidget {
  final bool isCollapsed;

  const _UserProfile({this.isCollapsed = false});

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

      final avatar = CircleAvatar(
        backgroundColor: colorScheme.onPrimary,
        foregroundColor: colorScheme.primary,
        backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
        child: photoUrl == null ? avatarText : null,
      );

      if (isCollapsed) {
        return Padding(
          padding: const .symmetric(vertical: 8),
          child: Column(
            mainAxisSize: .min,
            children: [
              Tooltip(message: name, child: avatar),
              const SizedBox(height: 8),
              IconButton(
                onPressed: () => AuthService.signOut(),
                icon: Icon(
                  Icons.logout,
                  color: colorScheme.onPrimary.withValues(alpha: 0.7),
                ),
                tooltip: "Logout",
              ),
            ],
          ),
        );
      }

      return ListTile(
        contentPadding: const .symmetric(horizontal: 24, vertical: 8),
        leading: avatar,
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
  const _LeftPanel({
    required this.navigationShell,
    required this.userProfile,
    this.isCollapsed = false,
    this.isDrawer = false,
    this.onToggleCollapse,
  });

  final StatefulNavigationShell navigationShell;
  final _UserProfile userProfile;
  final bool isCollapsed;
  final bool isDrawer;
  final VoidCallback? onToggleCollapse;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final panelWidth = isDrawer ? 280.0 : (isCollapsed ? 72.0 : 260.0);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      width: panelWidth,
      color: colorScheme.primary,
      child: Column(
        children: [
          Expanded(
            child: Sidebar(
              selectedIndex: navigationShell.currentIndex,
              isCollapsed: isCollapsed,
              isDrawer: isDrawer,
              onToggleCollapse: onToggleCollapse,
              onItemSelected: (index) {
                if (isDrawer) {
                  Navigator.of(context).pop();
                }
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

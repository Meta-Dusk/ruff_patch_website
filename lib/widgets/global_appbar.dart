import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:capstone_website/app.dart';
import 'package:capstone_website/core/app_fonts.dart';
import 'package:capstone_website/widgets/custom_instagram_icon.dart';
import 'package:capstone_website/widgets/main_layout.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final bool showNavToggle;

  const GlobalAppBar({
    super.key,
    required this.title,
    this.leading,
    this.showNavToggle = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  /// Helper method to safely launch URLs
  Future<void> _openLink(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    final colorScheme = Theme.of(context).colorScheme;

    // Check if the browser/device supports opening this link
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        // ? Optional: on Web, this usually forces it to open in a new tab
        // ? rather than replacing your app's current tab.
        webOnlyWindowName: '_blank',
      );
    } else {
      debugPrint('Could not launch $url');
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not open link: $urlString',
            style: TextStyle(
              fontFamily: AppFonts.born2B,
              fontSize: 16,
              color: colorScheme.onErrorContainer,
            ),
          ),
          backgroundColor: colorScheme.errorContainer,
          behavior: .floating,
          shape: RoundedRectangleBorder(borderRadius: .circular(8)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;
    if (!showNavToggle) return null;

    final isMobile = MediaQuery.sizeOf(context).width < 800;
    final colorScheme = Theme.of(context).colorScheme;

    if (isMobile) {
      return IconButton(
        icon: Icon(Icons.menu, color: colorScheme.primary),
        tooltip: "Open menu",
        onPressed: () => MainLayout.scaffoldKey.currentState?.openDrawer(),
      );
    }

    return ValueListenableBuilder<bool>(
      valueListenable: MainLayout.sidebarCollapsedNotifier,
      builder: (_, isCollapsed, _) => IconButton(
        icon: Icon(
          isCollapsed ? Icons.menu : Icons.menu_open,
          color: colorScheme.primary,
        ),
        tooltip: isCollapsed ? "Expand sidebar" : "Collapse sidebar",
        onPressed: () =>
            MainLayout.sidebarCollapsedNotifier.value = !isCollapsed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 800;
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      leading: _buildLeading(context),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: AppFonts.born2B,
          fontSize: isMobile ? 26 : 32,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        // Dark Mode Toggle
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, currentMode, _) => IconButton(
            icon: Icon(
              currentMode == .light ? Icons.dark_mode : Icons.light_mode,
              color: colorScheme.primary,
              size: isMobile ? 24 : 28,
            ),
            tooltip: currentMode == .light
                ? "Switch to dark mode"
                : "Switch to light mode",
            onPressed: () {
              themeNotifier.value = currentMode == .light ? .dark : .light;
            },
          ),
        ),
        SizedBox(width: isMobile ? 4 : 8),
        IconButton(
          icon: CustomInstagramIcon(size: isMobile ? 22 : 24),
          tooltip: "Instagram",
          onPressed: () => _openLink(
            context,
            "https://www.instagram.com/ruff.patch.project/?hl=en",
          ),
        ),
        SizedBox(width: isMobile ? 4 : 8),
        IconButton(
          icon: Icon(
            Icons.facebook,
            size: isMobile ? 22 : 24,
            color: colorScheme.primary,
          ),
          tooltip: "Facebook",
          onPressed: () => _openLink(
            context,
            "https://www.facebook.com/profile.php?id=61593757455606",
          ),
        ),
        SizedBox(width: isMobile ? 12 : 24),
      ],
    );
  }
}

import 'package:capstone_website/app.dart';
import 'package:capstone_website/core/app_fonts.dart';
import 'package:capstone_website/widgets/custom_instagram_icon.dart';
import 'package:capstone_website/widgets/custom_youtube_icon.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GlobalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;

  const GlobalAppBar({super.key, required this.title, this.leading});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  /// Helper method to safely launch URLs
  Future<void> _openLink(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);

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
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          behavior: .floating,
          shape: RoundedRectangleBorder(borderRadius: .circular(8)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: Text(
        title,
        style: const TextStyle(fontFamily: AppFonts.born2B, fontSize: 32),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        // Dark Mode Toggle
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeNotifier,
          builder: (context, currentMode, child) {
            return IconButton(
              icon: Icon(
                currentMode == .light ? Icons.dark_mode : Icons.light_mode,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              ),
              onPressed: () {
                themeNotifier.value = currentMode == .light ? .dark : .light;
              },
            );
          },
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: Text(
            "𝕏",
            style: TextStyle(
              fontSize: 24,
              fontWeight: .bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          onPressed: () => _openLink(context, "https://x.com/JhonAndreDC"),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const CustomInstagramIcon(size: 24),
          onPressed: () =>
              _openLink(context, "https://www.instagram.com/rgielsmam/"),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const CustomYoutubeIcon(size: 28),
          onPressed: () => _openLink(
            context,
            "https://www.youtube.com/@Anarky_The_Mercenary",
          ),
        ),
        const SizedBox(width: 24),
      ],
    );
  }
}

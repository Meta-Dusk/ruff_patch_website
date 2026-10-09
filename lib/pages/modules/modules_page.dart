import 'package:capstone_website/widgets/global_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:capstone_website/core/app_fonts.dart';
import 'package:capstone_website/core/app_routes.dart';
import 'package:capstone_website/models/chapter.dart';

class ModulesPage extends StatelessWidget {
  const ModulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: GlobalAppBar(title: "Modules"),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 380,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 0.9,
          ),
          itemCount: Chapter.allChapters.length,
          itemBuilder: (context, index) {
            return _buildChapterCard(context, Chapter.allChapters[index]);
          },
        ),
      ),
    );
  }

  Widget _buildChapterCard(BuildContext context, Chapter chapter) {
    return Card(
      elevation: 6,
      clipBehavior: .antiAlias,
      shape: RoundedRectangleBorder(borderRadius: .circular(16)),
      child: InkWell(
        onTap: () => context.go(AppRoutes.chapterPath(chapter.id)),
        child: _chapterCardContent(context, chapter),
      ),
    );
  }

  Widget _chapterCardContent(BuildContext context, Chapter chapter) {
    final topBanner = Expanded(
      flex: 3,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: .topLeft,
            end: .bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
              Theme.of(context).colorScheme.primary,
            ],
          ),
        ),
        child: Stack(
          alignment: .center,
          children: [
            // Background watermark icon
            Positioned(
              right: -20,
              bottom: -20,
              child: Icon(
                chapter.icon,
                size: 120,
                color: Theme.of(
                  context,
                ).colorScheme.onPrimary.withValues(alpha: 0.15),
              ),
            ),
            // Main focused icon
            Icon(
              chapter.icon,
              size: 64,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ],
        ),
      ),
    );

    final footerDetails = Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        _buildBadge(context, icon: Icons.schedule, label: chapter.duration),
        if (chapter.quiz != null)
          _buildBadge(
            context,
            icon: Icons.quiz_outlined,
            label: 'Includes Quiz',
          ),
      ],
    );

    final bottomContent = Expanded(
      flex: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              chapter.title,
              style: const TextStyle(
                fontSize: 20,
                fontFamily: AppFonts.born2B,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: .ellipsis,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                chapter.description,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: AppFonts.born2B,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                maxLines: 2,
                overflow: .ellipsis,
              ),
            ),
            const Divider(height: 24),
            footerDetails,
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        topBanner, // Colored Header
        bottomContent, // Text and Data
      ],
    );
  }

  /// Helper widget for the info chips
  Widget _buildBadge(
    BuildContext context, {
    required IconData icon,
    required String label,
  }) {
    final badgeColor = Theme.of(context).colorScheme.primary;
    return Row(
      children: [
        Icon(icon, size: 16, color: badgeColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontFamily: AppFonts.born2B,
            color: badgeColor,
          ),
        ),
      ],
    );
  }
}

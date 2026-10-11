import 'package:flutter/material.dart';

import 'package:capstone_website/core/app_assets.dart';
import 'package:capstone_website/core/app_fonts.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final bool isCollapsed;
  final bool isDrawer;
  final VoidCallback? onToggleCollapse;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    this.isCollapsed = false,
    this.isDrawer = false,
    this.onToggleCollapse,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final navItems = [
      _buildNavItem(icon: Icons.house, title: "Home", index: 0),
      _buildNavItem(icon: Icons.library_books, title: "Modules", index: 1),
      _buildNavItem(icon: Icons.book, title: "Resources", index: 2),
      _buildNavItem(icon: Icons.dashboard, title: "Dashboard", index: 3),
    ];

    Widget header;
    if (isCollapsed) {
      header = Padding(
        padding: const .symmetric(vertical: 20),
        child: Column(
          children: [
            Image.asset(AppAssets.pixelLogo, height: 32, fit: .contain),
            if (onToggleCollapse != null) ...[
              const SizedBox(height: 12),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                color: colorScheme.onPrimary,
                tooltip: "Expand sidebar",
                onPressed: onToggleCollapse,
              ),
            ],
          ],
        ),
      );
    } else if (isDrawer) {
      header = Padding(
        padding: const .fromLTRB(24, 24, 16, 24),
        child: Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Expanded(child: Image.asset(AppAssets.pixelLogo, fit: .contain)),
            IconButton(
              icon: const Icon(Icons.close),
              color: colorScheme.onPrimary,
              tooltip: "Close menu",
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } else {
      header = Padding(
        padding: const .fromLTRB(24, 32, 16, 32),
        child: Row(
          children: [
            Expanded(child: Image.asset(AppAssets.pixelLogo, fit: .contain)),
            if (onToggleCollapse != null)
              IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: colorScheme.onPrimary.withValues(alpha: 0.8),
                ),
                tooltip: "Collapse sidebar",
                onPressed: onToggleCollapse,
              ),
          ],
        ),
      );
    }

    return Container(
      color: colorScheme.primary,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          header,
          Expanded(
            child: ListView(padding: .zero, children: navItems),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required int index,
  }) => _NavItem(
    icon: icon,
    title: title,
    index: index,
    selectedIndex: selectedIndex,
    onItemSelected: onItemSelected,
    isCollapsed: isCollapsed,
  );
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final bool isCollapsed;

  const _NavItem({
    required this.icon,
    required this.title,
    required this.index,
    required this.selectedIndex,
    required this.onItemSelected,
    this.isCollapsed = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = selectedIndex == index;
    final unselectedColor = colorScheme.onPrimary.withValues(alpha: 0.6);
    final selectedColor = colorScheme.onPrimary;

    final border = Border(
      left: BorderSide(
        color: isSelected ? selectedColor : Colors.transparent,
        width: 4.0,
      ),
    );

    if (isCollapsed) {
      return Tooltip(
        message: title,
        preferBelow: false,
        child: InkWell(
          onTap: () => onItemSelected(index),
          child: Container(
            decoration: BoxDecoration(border: border),
            padding: const .symmetric(vertical: 16.0),
            child: Center(
              child: Icon(
                icon,
                color: isSelected ? selectedColor : unselectedColor,
                size: 24,
              ),
            ),
          ),
        ),
      );
    }

    return InkWell(
      onTap: () => onItemSelected(index),
      child: Container(
        decoration: BoxDecoration(border: border),
        padding: const .symmetric(vertical: 16.0, horizontal: 20.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? selectedColor : unselectedColor,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? selectedColor : unselectedColor,
                fontSize: 24,
                fontWeight: .normal,
                fontFamily: AppFonts.born2B,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

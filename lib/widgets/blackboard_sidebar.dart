import 'package:capstone_website/core/app_assets.dart';
import 'package:capstone_website/core/app_fonts.dart';
import 'package:flutter/material.dart';

class BlackboardSidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const BlackboardSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final navItems = [
      _buildNavItem(icon: Icons.house, title: "Home", index: 0),
      _buildNavItem(icon: Icons.library_books, title: "Modules", index: 1),
      _buildNavItem(icon: Icons.book, title: "Resources", index: 2),
      _buildNavItem(icon: Icons.dashboard, title: "Dashboard", index: 3),
    ];

    return Container(
      width: 260,
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        crossAxisAlignment: .start,
        children: [
          // Header / Logo Area
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 40, 24, 40),
            child: Image.asset(AppAssets.logo),
          ),

          // Navigation Items
          Expanded(
            child: ListView(padding: EdgeInsets.zero, children: navItems),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required int index,
  }) => NavItem(
    icon: icon,
    title: title,
    index: index,
    selectedIndex: selectedIndex,
    onItemSelected: onItemSelected,
  );
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const NavItem({
    super.key,
    required this.icon,
    required this.title,
    required this.index,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = selectedIndex == index;
    final unselectedColor = colorScheme.onPrimary.withValues(alpha: 0.6);
    final selectedColor = colorScheme.onPrimary;

    return InkWell(
      onTap: () => onItemSelected(index),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isSelected ? selectedColor : Colors.transparent,
              width: 4.0,
            ),
          ),
        ),
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

import 'package:flutter/material.dart';

import 'package:capstone_website/core/app_fonts.dart';
import 'package:capstone_website/models/city_resource.dart';
import 'package:capstone_website/pages/modules/resource_category.dart';
import 'package:capstone_website/widgets/global_appbar.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  ResourceCategory? _selectedCategory;
  CityResource? _selectedCity;

  @override
  Widget build(BuildContext context) {
    final selectedCategory = _selectedCategory;

    final content = selectedCategory == null
        ? _CategoryGrid(
            onCategorySelected: (cat) {
              setState(() => _selectedCategory = cat);
            },
          )
        : _CategoryDetailView(
            category: selectedCategory,
            selectedCity: _selectedCity,
            onCityChanged: (city) => setState(() => _selectedCity = city),
            onBack: () => setState(() {
              _selectedCategory = null;
              _selectedCity = null;
            }),
          );

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const GlobalAppBar(title: "Resources"),
      body: Center(child: content),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final ValueChanged<ResourceCategory> onCategorySelected;

  const _CategoryGrid({required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    final categories = ResourceCategory.values;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1000),
      child: Padding(
        padding: const .all(24.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.2,
          ),
          itemCount: categories.length,
          itemBuilder: (_, index) {
            final category = categories[index];
            return _CategoryGridCard(
              category: category,
              onTap: () => onCategorySelected(category),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryGridCard extends StatelessWidget {
  final ResourceCategory category;
  final VoidCallback onTap;

  const _CategoryGridCard({required this.category, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: .circular(16)),
      child: InkWell(
        borderRadius: .circular(16),
        onTap: onTap,
        child: Padding(
          padding: const .all(24.0),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              Icon(category.icon, size: 48, color: colorScheme.primary),
              const SizedBox(height: 16),
              Text(
                category.title,
                textAlign: .center,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: AppFonts.born2B,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryDetailView extends StatelessWidget {
  final ResourceCategory category;
  final CityResource? selectedCity;
  final ValueChanged<CityResource?> onCityChanged;
  final VoidCallback onBack;

  const _CategoryDetailView({
    required this.category,
    required this.selectedCity,
    required this.onCityChanged,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900),
      child: ListView(
        padding: const .all(24.0),
        children: [
          Align(
            alignment: .centerLeft,
            child: TextButton.icon(
              icon: Icon(Icons.arrow_back, color: colorScheme.primary),
              label: Text(
                'Back to Categories',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontSize: 16,
                  fontFamily: AppFonts.born2B,
                ),
              ),
              onPressed: onBack,
            ),
          ),
          const SizedBox(height: 24),
          if (category == .localNeutering)
            _NeuteringDetailsView(
              selectedCity: selectedCity,
              onCityChanged: onCityChanged,
            )
          else
            _ComingSoonPlaceholder(categoryTitle: category.title),
        ],
      ),
    );
  }
}

class _NeuteringDetailsView extends StatelessWidget {
  final CityResource? selectedCity;
  final ValueChanged<CityResource?> onCityChanged;

  const _NeuteringDetailsView({
    required this.selectedCity,
    required this.onCityChanged,
  });

  static const String descriptionText =
      "Some city governments in the nation offer free neutering at certain "
      "government offices. This is in hopes to incentivize pet owners to "
      "participate in wider pet neutering to cut down the stray populations in "
      "their areas. Listed below are official websites of LGUs that have "
      "free neutering and ways to apply.";

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: .start,
      children: [
        const Text(
          'Free Neutering',
          style: TextStyle(fontSize: 36, fontFamily: AppFonts.born2B),
        ),
        const SizedBox(height: 16),
        Text(
          descriptionText,
          style: TextStyle(
            fontSize: 18,
            height: 1.5,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 40),
        Text(
          'Select a City/LGU:',
          style: TextStyle(
            fontSize: 20,
            fontFamily: AppFonts.born2B,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const .symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: .all(color: colorScheme.primary, width: 4),
            borderRadius: .circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CityResource>(
              value: selectedCity,
              hint: const Text(
                "Choose a city...",
                style: TextStyle(fontSize: 16),
              ),
              isExpanded: true,
              icon: Icon(
                Icons.arrow_drop_down,
                color: colorScheme.primary,
                size: 32,
              ),
              items: CityResource.neuteringResources.map((resource) {
                return DropdownMenuItem<CityResource>(
                  value: resource,
                  child: Text(
                    resource.cityName,
                    style: const TextStyle(fontSize: 18),
                  ),
                );
              }).toList(),
              onChanged: onCityChanged,
            ),
          ),
        ),
        const SizedBox(height: 32),
        if (selectedCity != null) _SelectedCityCard(resource: selectedCity!),
      ],
    );
  }
}

class _SelectedCityCard extends StatelessWidget {
  final CityResource resource;

  const _SelectedCityCard({required this.resource});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: .circular(16)),
      child: Padding(
        padding: const .all(32.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              resource.cityName,
              style: TextStyle(
                fontSize: 28,
                fontFamily: AppFonts.born2B,
                color: colorScheme.primary,
              ),
            ),
            Divider(height: 32, color: colorScheme.onSurfaceVariant),
            Text(
              resource.details,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            _ResourceDetailRow(
              icon: Icons.language,
              label: 'Website:',
              value: resource.website,
            ),
            const SizedBox(height: 12),
            _ResourceDetailRow(
              icon: Icons.phone,
              label: 'Contact:',
              value: resource.contact,
            ),
            const SizedBox(height: 24),
            Text(
              'Requirements:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: .bold,
                fontFamily: AppFonts.liberationSans,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            for (final req in resource.requirements)
              Padding(
                padding: const .only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(req, style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ResourceDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ResourceDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, color: colorScheme.primary, size: 20),
        const SizedBox(width: 12),
        Text(
          "$label ",
          style: const TextStyle(
            fontWeight: .bold,
            fontSize: 16,
            fontFamily: AppFonts.liberationSans,
          ),
        ),
        SelectableText(
          value,
          style: TextStyle(
            fontSize: 16,
            color: colorScheme.primary,
            decoration: .underline,
          ),
        ),
      ],
    );
  }
}

class _ComingSoonPlaceholder extends StatelessWidget {
  final String categoryTitle;

  const _ComingSoonPlaceholder({required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const .symmetric(vertical: 80.0),
        child: Column(
          children: [
            Icon(
              Icons.construction,
              size: 80,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 24),
            Text(
              'Content for $categoryTitle is coming soon!',
              style: TextStyle(
                fontSize: 24,
                color: colorScheme.onSurfaceVariant,
                fontFamily: AppFonts.born2B,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

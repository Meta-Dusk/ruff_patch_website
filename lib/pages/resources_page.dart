import 'package:capstone_website/pages/modules/resource_category.dart';
import 'package:capstone_website/widgets/global_appbar.dart';
import 'package:flutter/material.dart';
import 'package:capstone_website/core/app_fonts.dart';
import 'package:capstone_website/models/city_resource.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  ResourceCategory? _selectedCategory;
  CityResource? _selectedCity;

  static const String descriptionText =
      "Some city governments in the nation offer free neutering at certain "
      "government offices. This is in hopes to incentivize pet owners to "
      "participate in wider pet neutering to cut down the stray populations in "
      "their areas. Listed below are official websites of LGUs that have "
      "free neutering and ways to apply.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: const GlobalAppBar(title: "Resources"),
      // Swap between the Grid View and the Detail View based on state
      body: Center(
        child: _selectedCategory == null
            ? _buildCategoryGrid()
            : _buildCategoryContent(),
      ),
    );
  }

  /// Builds the grid of category cards
  Widget _buildCategoryGrid() {
    final categories = ResourceCategory.values;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1000),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 1.2,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: .circular(16)),
              child: InkWell(
                borderRadius: .circular(16),
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: .center,
                    children: [
                      Icon(
                        category.icon,
                        size: 48,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        category.title,
                        textAlign: .center,
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: AppFonts.born2B,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  /// Builds the content area based on the selected category
  Widget _buildCategoryContent() {
    final localNeuteringWidgets = [
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
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      const SizedBox(height: 40),
      Text(
        'Select a City/LGU:',
        style: TextStyle(
          fontSize: 20,
          fontFamily: AppFonts.born2B,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: .all(color: Theme.of(context).colorScheme.primary, width: 4),
          borderRadius: .circular(12),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<CityResource>(
            value: _selectedCity,
            hint: const Text(
              "Choose a city...",
              style: TextStyle(fontSize: 16),
            ),
            isExpanded: true,
            icon: Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.primary,
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
            onChanged: (newValue) {
              setState(() {
                _selectedCity = newValue;
              });
            },
          ),
        ),
      ),
      const SizedBox(height: 32),
      if (_selectedCity != null) _buildSelectedCityCard(_selectedCity!),
    ];

    final placeHolderWidgets = [
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80.0),
          child: Column(
            children: [
              Icon(
                Icons.construction,
                size: 80,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(height: 24),
              Text(
                'Content for ${_selectedCategory?.title} is coming soon!',
                style: TextStyle(
                  fontSize: 24,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontFamily: AppFonts.born2B,
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900),
      child: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          // Back Button
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.primary,
              ),
              label: Text(
                'Back to Categories',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                  fontFamily: AppFonts.born2B,
                ),
              ),
              onPressed: () {
                setState(() {
                  // Clear the selection, showing the grid again
                  _selectedCategory = null;
                  _selectedCity = null;
                });
              },
            ),
          ),
          const SizedBox(height: 24),
          if (_selectedCategory == .localNeutering)
            ...localNeuteringWidgets
          else
            ...placeHolderWidgets,
        ],
      ),
    );
  }

  Widget _buildSelectedCityCard(CityResource resource) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: .circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              resource.cityName,
              style: TextStyle(
                fontSize: 28,
                fontFamily: AppFonts.born2B,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Divider(
              height: 32,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            Text(
              resource.details,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailRow(Icons.language, 'Website:', resource.website),
            const SizedBox(height: 12),
            _buildDetailRow(Icons.phone, 'Contact:', resource.contact),
            const SizedBox(height: 24),
            Text(
              'Requirements:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: .bold,
                fontFamily: AppFonts.liberationSans,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            ...resource.requirements.map(
              (req) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(req, style: const TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
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
            color: Theme.of(context).colorScheme.primary,
            decoration: .underline,
          ),
        ),
      ],
    );
  }
}

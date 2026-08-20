
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/search/controllers/search_controller.dart'
    as search_controller;

class SearchFilter extends StatelessWidget {
  const SearchFilter({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<search_controller.SearchController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Obx(() {
      final hasCategory = controller.selectedCategory.value != null;
      final hasArea = controller.selectedArea.value != null;
      final hasFilters = hasCategory || hasArea;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // =========================================================
              // CATEGORY DROPDOWN
              // =========================================================
              Expanded(
                child: _FilterDropdown(
                  icon: Icons.restaurant_menu_rounded,
                  label: 'Category',
                  value: controller.selectedCategory.value,
                  items: controller.categories,
                  onChanged: controller.setCategory,
                ),
              ),

              const SizedBox(width: 10),

              // =========================================================
              // COUNTRY / CUISINE DROPDOWN
              // =========================================================
              Expanded(
                child: _FilterDropdown(
                  icon: Icons.public_rounded,
                  label: 'Country',
                  value: controller.selectedArea.value,
                  items: controller.areas,
                  onChanged: controller.setArea,
                ),
              ),
            ],
          ),

          // =========================================================
          // CLEAR FILTERS BUTTON & ACTIVE BADGES
          // =========================================================
          if (hasFilters) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        if (hasCategory) ...[
                          _FilterBadge(
                            label: controller.selectedCategory.value!,
                            onClear: () => controller.setCategory(null),
                          ),
                          const SizedBox(width: 6),
                        ],
                        if (hasArea) ...[
                          _FilterBadge(
                            label: controller.selectedArea.value!,
                            onClear: () => controller.setArea(null),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    controller.setCategory(null);
                    controller.setArea(null);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    foregroundColor: AppColors.primary,
                  ),
                  icon: const Icon(
                    Icons.refresh_rounded,
                    size: 16,
                  ),
                  label: const Text(
                    'Clear filters',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      );
    });
  }
}

// =============================================================
// THEME-AWARE FILTER DROPDOWN
// =============================================================

class _FilterDropdown extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.icon,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surfaceColor = isDark
        ? theme.colorScheme.surfaceContainerHighest
        : theme.colorScheme.surface;

    final textColor = theme.colorScheme.onSurface;
    final secondaryColor = theme.colorScheme.onSurfaceVariant;

    final borderColor = isDark
        ? Colors.white10
        : theme.dividerColor.withValues(alpha: 0.15);

    final validValue = items.contains(value) ? value : null;

    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: validValue,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: secondaryColor,
          ),
          dropdownColor: surfaceColor,

          // ==============================
          // HINT
          // ==============================
          hint: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          // ==============================
          // DROPDOWN ITEMS
          // ==============================
          items: [
            DropdownMenuItem<String>(
              value: null,
              child: Text(
                'All $label\s',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ...items.toSet().map((item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// =============================================================
// ACTIVE FILTER BADGE CHIP
// =============================================================

class _FilterBadge extends StatelessWidget {
  final String label;
  final VoidCallback onClear;

  const _FilterBadge({
    required this.label,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onClear,
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
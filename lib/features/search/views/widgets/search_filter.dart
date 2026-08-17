
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/search_controller.dart'
    as search_controller;

class SearchFilter extends StatelessWidget {
  const SearchFilter({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final search_controller.SearchController controller =
        Get.find<search_controller.SearchController>();

    return Obx(() {
      final hasFilters = controller.hasActiveFilters;

      return LayoutBuilder(
        builder: (context, constraints) {
          // =========================================================
          // WIDE SCREEN
          // =========================================================

          if (constraints.maxWidth >= 600) {
            return Row(
              children: [
                Expanded(
                  child: _FilterDropdown(
                    icon: Icons.category_outlined,
                    label: 'Category',
                    value: controller.selectedCategory.value,
                    items: controller.categories,
                    onChanged: controller.setCategory,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _FilterDropdown(
                    icon: Icons.public_rounded,
                    label: 'Cuisine',
                    value: controller.selectedArea.value,
                    items: controller.areas,
                    onChanged: controller.setArea,
                  ),
                ),

                if (hasFilters) ...[
                  const SizedBox(width: 6),
                  _ClearFilterButton(
                    onPressed: controller.clearFilters,
                  ),
                ],
              ],
            );
          }

          // =========================================================
          // SMALL SCREEN
          // =========================================================

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: _FilterDropdown(
                      icon: Icons.category_outlined,
                      label: 'Category',
                      value: controller.selectedCategory.value,
                      items: controller.categories,
                      onChanged: controller.setCategory,
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: _FilterDropdown(
                      icon: Icons.public_rounded,
                      label: 'Cuisine',
                      value: controller.selectedArea.value,
                      items: controller.areas,
                      onChanged: controller.setArea,
                    ),
                  ),
                ],
              ),

              if (hasFilters) ...[
                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: controller.clearFilters,
                    icon: const Icon(
                      Icons.filter_alt_off_rounded,
                      size: 18,
                    ),
                    label: const Text(
                      'Clear Filters',
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      );
    });
  }
}

// =============================================================
// FILTER DROPDOWN
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

    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.dividerColor.withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: value,
          isExpanded: true,
          isDense: true,
          menuMaxHeight: 320,

          // =======================================================
          // DROPDOWN ICON
          // =======================================================

          icon: Padding(
            padding: const EdgeInsets.only(
              right: 8,
            ),
            child: Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 21,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),

          // =======================================================
          // HINT
          // =======================================================

          hint: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 18,
                  color: theme.colorScheme.primary,
                ),

                const SizedBox(width: 7),

                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // =======================================================
          // MENU ITEMS
          // =======================================================

          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 17,
                    color: theme.colorScheme.primary,
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      'All $label',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ...items.map(
              (item) {
                return DropdownMenuItem<String?>(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                    ),
                    child: Text(
                      item,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],

          // =======================================================
          // SELECTED ITEM
          // =======================================================

          selectedItemBuilder: (context) {
            return [
              _SelectedFilterItem(
                icon: icon,
                text: label,
              ),

              ...items.map(
                (item) {
                  return _SelectedFilterItem(
                    icon: icon,
                    text: item,
                  );
                },
              ),
            ];
          },

          // =======================================================
          // CHANGE
          // =======================================================

          onChanged: onChanged,
        ),
      ),
    );
  }
}

// =============================================================
// SELECTED FILTER ITEM
// =============================================================

class _SelectedFilterItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _SelectedFilterItem({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: theme.colorScheme.primary,
          ),

          const SizedBox(width: 7),

          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// CLEAR FILTER BUTTON
// =============================================================

class _ClearFilterButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _ClearFilterButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Clear filters',
      onPressed: onPressed,
      icon: const Icon(
        Icons.filter_alt_off_rounded,
      ),
    );
  }
}

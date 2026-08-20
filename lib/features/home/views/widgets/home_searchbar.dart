import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSearchTap;

  const HomeSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final fillColor = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final hintColor = isDark
        ? AppColors.darkTextSecondary
        : AppColors.textHint;

    final borderColor = isDark
        ? AppColors.darkBorder
        : AppColors.border;

    return GestureDetector(
      onTap: onSearchTap,

      child: AbsorbPointer(
        absorbing: true,

        child: TextField(
          controller: controller,
          onChanged: onChanged,

          decoration: InputDecoration(
            // ==================================================
            // HINT
            // ==================================================

            hintText: 'Search recipes...',

            hintStyle: TextStyle(
              color: hintColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),

            // ==================================================
            // SEARCH ICON
            // ==================================================

            prefixIcon: const Icon(
              Icons.search_rounded,
              color: AppColors.primary,
              size: 23,
            ),

            // ==================================================
            // FILTER ICON
            // ==================================================

            suffixIcon: Icon(
              Icons.tune_rounded,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.textSecondary,
              size: 20,
            ),

            // ==================================================
            // BACKGROUND
            // ==================================================

            filled: true,
            fillColor: fillColor,

            // ==================================================
            // PADDING
            // ==================================================

            contentPadding:
                const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),

            // ==================================================
            // BORDER
            // ==================================================

            border: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(16),

              borderSide: BorderSide(
                color: borderColor,
                width: 1,
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(16),

              borderSide: BorderSide(
                color: borderColor,
                width: 1,
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius:
                  BorderRadius.circular(16),

              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
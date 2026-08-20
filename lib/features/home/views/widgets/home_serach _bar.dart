import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import '../../../../core/routes/app_routes.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.search,
      ),

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 13,
        ),

        decoration: BoxDecoration(
          // ==================================================
          // BACKGROUND
          // ==================================================

          color: isDark
              ? AppColors.darkSurface
              : AppColors.inputBackground,

          borderRadius:
              BorderRadius.circular(14),

          // ==================================================
          // BORDER
          // ==================================================

          border: Border.all(
            color: isDark
                ? AppColors.darkBorder
                : AppColors.border,
          ),

          // ==================================================
          // SHADOW
          // ==================================================

          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          children: [
            // ==================================================
            // SEARCH ICON
            // ==================================================

            Icon(
              Icons.search_rounded,
              color: AppColors.primary,
              size: 24,
            ),

            const SizedBox(width: 12),

            // ==================================================
            // PLACEHOLDER
            // ==================================================

            Expanded(
              child: Text(
                'Search any recipe or category...',

                overflow:
                    TextOverflow.ellipsis,

                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textHint,

                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
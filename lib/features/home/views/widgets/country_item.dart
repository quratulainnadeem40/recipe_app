import 'package:flutter/material.dart';
import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/home/models/country_model.dart';

class CountryItem extends StatelessWidget {
  final CountryModel country;
  final VoidCallback onTap;

  const CountryItem({
    super.key,
    required this.country,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark
        ? AppColors.darkSurface
        : AppColors.lightSurface;

    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    final borderColor = isDark
        ? AppColors.darkDivider
        : AppColors.divider;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),

      child: Container(
        width: 110,
        padding: const EdgeInsets.all(10),

        decoration: BoxDecoration(
          color: cardColor,

          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: borderColor,
            width: 1,
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: isDark ? 0.25 : 0.06,
              ),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // =================================================
            // COUNTRY FLAG
            // =================================================

            Text(
              country.flag,
              style: const TextStyle(
                fontSize: 36,
              ),
            ),

            const SizedBox(height: 8),

            // =================================================
            // COUNTRY NAME
            // =================================================

            Text(
              country.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,

              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
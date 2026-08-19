import 'package:flutter/material.dart';
import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/home/models/country_model.dart';

class CountryItem extends StatelessWidget {
  final CountryModel country;
  final bool isSelected;
  final VoidCallback onTap;

  const CountryItem({
    super.key,
    required this.country,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Circular Flag Container with Selected Ring
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? AppColors.tagGreenBg
                  : theme.colorScheme.surface,
              border: Border.all(
                color: isSelected
                    ? AppColors.tagGreen
                    : theme.colorScheme.outline.withValues(alpha: 0.2),
                width: isSelected ? 2.5 : 1.0,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: AppColors.tagGreen.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                else
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
              ],
            ),
            alignment: Alignment.center,
            child: Text(
              country.flag,
              style: const TextStyle(
                fontSize: 26,
              ),
            ),
          ),

          const SizedBox(height: 6),

          // Country Name Label
          SizedBox(
            width: 64,
            child: Text(
              country.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected
                    ? AppColors.tagGreen
                    : theme.colorScheme.onSurface,
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
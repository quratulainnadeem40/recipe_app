// import 'package:flutter/material.dart';

// import 'package:recipe_app/core/theme/app_colors.dart';

// class CountryItem extends StatelessWidget {
//   final dynamic country;
//   final bool isSelected;
//   final VoidCallback? onTap;

//   const CountryItem({
//     super.key,
//     required this.country,
//     this.isSelected = false,
//     this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final isDark = theme.brightness == Brightness.dark;

//     final surface = isDark
//         ? AppColors.darkSurface
//         : AppColors.surface;

//     final textPrimary = isDark
//         ? AppColors.darkTextPrimary
//         : AppColors.textPrimary;

//     return GestureDetector(
//       onTap: onTap,
//       child: SizedBox(
//         width: 82,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             AnimatedContainer(
//               duration: const Duration(
//                 milliseconds: 180,
//               ),
//               width: 58,
//               height: 58,
//               decoration: BoxDecoration(
//                 color: surface,
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: isSelected
//                       ? AppColors.primary
//                       : Colors.transparent,
//                   width: isSelected ? 2 : 0,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.06),
//                     blurRadius: 8,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               child: Center(
//                 child: Text(
//                   country.flag,
//                   style: const TextStyle(
//                     fontSize: 30,
//                   ),
//                 ),
//               ),
//             ),

//             const SizedBox(height: 7),

//             Text(
//               country.name,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: textPrimary,
//                 fontSize: 11,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:recipe_app/core/theme/app_colors.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final surface = isDark
        ? AppColors.darkSurface
        : AppColors.surface;

    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 108,
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary.withValues(
                alpha: 0.10,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textPrimary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
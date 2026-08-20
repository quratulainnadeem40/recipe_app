// import 'package:flutter/material.dart';

// import 'package:recipe_app/core/theme/app_colors.dart';
// import 'package:recipe_app/core/theme/app_text_styles.dart';

// class SectionHeader extends StatelessWidget {
//   final String title;
//   final VoidCallback onSeeAllTap;

//   const SectionHeader({
//     super.key,
//     required this.title,
//     required this.onSeeAllTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final isDark =
//         Theme.of(context).brightness == Brightness.dark;

//     final titleColor = isDark
//         ? AppColors.darkTextPrimary
//         : AppColors.textPrimary;

//     return Row(
//       mainAxisAlignment:
//           MainAxisAlignment.spaceBetween,

//       children: [
//         // ==================================================
//         // SECTION TITLE
//         // ==================================================

//         Expanded(
//           child: Text(
//             title,
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,

//             style: AppTextStyles.headingSmall.copyWith(
//               color: titleColor,
//               fontSize: 17,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),

//         const SizedBox(width: 10),

//         // ==================================================
//         // SEE ALL
//         // ==================================================

//         TextButton(
//           onPressed: onSeeAllTap,

//           style: TextButton.styleFrom(
//             foregroundColor: AppColors.primary,

//             padding: const EdgeInsets.symmetric(
//               horizontal: 8,
//               vertical: 4,
//             ),

//             minimumSize: Size.zero,

//             tapTargetSize:
//                 MaterialTapTargetSize.shrinkWrap,
//           ),

//           child: const Text(
//             'See all',
//             style: TextStyle(
//               color: AppColors.primary,
//               fontSize: 12,
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';

import 'package:recipe_app/core/theme/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onSeeAllTap;

  const SectionHeader({
    super.key,
    required this.title,
    required this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        // ==================================================
        // SECTION TITLE
        // ==================================================

        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.textPrimary,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        const SizedBox(width: 8),

        // ==================================================
        // SEE ALL
        // ==================================================

        TextButton(
          onPressed: onSeeAllTap,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            minimumSize: Size.zero,
            tapTargetSize:
                MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'See all',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
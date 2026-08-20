import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final String? imagePath;
  final IconData? icon;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.title,
    this.imagePath,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 68,
        height: 78,
        decoration: BoxDecoration(
          color: AppColors.categoryCard,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Category Icon or Image Asset
            SizedBox(
              height: 34,
              width: 34,
              child: imagePath != null
                  ? Image.asset(
                      imagePath!,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        icon ?? Icons.fastfood_rounded,
                        color: AppColors.textWhite,
                        size: 26,
                      ),
                    )
                  : Icon(
                      icon ?? Icons.fastfood_rounded,
                      color: AppColors.textWhite,
                      size: 26,
                    ),
            ),
            const SizedBox(height: 6),

            // Category Label Text
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
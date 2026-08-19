import 'package:flutter/material.dart';
import 'package:recipe_app/core/theme/app_colors.dart';

class HomeSearchBar extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onSearchTap;
  final String hintText;

  const HomeSearchBar({
    super.key,
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onSearchTap,
    this.hintText = 'Search recipes, ingredients...',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surfaceContainerHighest : AppColors.inputBackground,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.only(left: 18, right: 6),
      child: Row(
        children: [
          // Search Icon Prefix
          Icon(
            Icons.search_rounded,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.40),
            size: 22,
          ),
          const SizedBox(width: 10),

          // Text Field Input
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onSubmitted: onSubmitted,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: AppColors.textHint,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          // Primary Red/Burgundy Action Circle Button
          Material(
            color: AppColors.primary,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onSearchTap ?? () {
                if (controller != null && controller!.text.isNotEmpty) {
                  onSubmitted?.call(controller!.text);
                }
              },
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
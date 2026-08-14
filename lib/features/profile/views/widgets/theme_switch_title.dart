import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ThemeSwitchTile extends StatelessWidget {
  const ThemeSwitchTile({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 2,
      ),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.dark_mode_outlined,
          color: AppColors.primary,
          size: 22,
        ),
      ),
      title: Text(
        'Dark Mode',
        style: AppTextStyles.bodyLarge.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.orange,
      ),
    );
  }
}
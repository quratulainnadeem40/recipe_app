import 'package:flutter/material.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/on_boarding/models/onboarding_model.dart';

class Onboarding1 extends StatelessWidget {
  final OnboardingModel model;

  const Onboarding1({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark
        ? AppColors.darkBackground
        : AppColors.background;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: backgroundColor,

      child: Center(
        child: Image.asset(
          model.image,

          // Shows the complete image
          // without cutting the top/bottom.
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
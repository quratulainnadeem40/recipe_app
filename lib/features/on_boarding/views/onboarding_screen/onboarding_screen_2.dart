import 'package:flutter/material.dart';

import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/features/on_boarding/models/onboarding_model.dart';

class Onboarding2 extends StatelessWidget {
  final OnboardingModel model;

  const Onboarding2({
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

          width: double.infinity,
          height: double.infinity,

          // Shows the complete onboarding image
          // without cropping it.
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
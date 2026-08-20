import 'package:flutter/material.dart';
import 'package:recipe_app/features/on_boarding/models/onboarding_model.dart';

class Onboarding1 extends StatelessWidget {
  final OnboardingModel model;

  const Onboarding1({
    super.key,
    required this.model,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      model.image,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }
}

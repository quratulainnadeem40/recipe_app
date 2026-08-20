import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CustomLoader extends StatelessWidget {
  final double size;
  final double strokeWidth;
  final Color? color;

  const CustomLoader({
    super.key,
    this.size = 24,
    this.strokeWidth = 2.5,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.textWhite,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'custom_loader.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final double width;
  final double height;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double borderRadius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 52,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,

        style: ElevatedButton.styleFrom(
          backgroundColor:
              backgroundColor ?? AppColors.primary,

          foregroundColor:
              textColor ?? AppColors.textWhite,

          disabledBackgroundColor:
              backgroundColor ?? AppColors.primary,

          disabledForegroundColor:
              textColor ?? AppColors.textWhite,

          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(borderRadius),
          ),
        ),

        child: isLoading
            ? const CustomLoader(
                size: 22,
                strokeWidth: 2,
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
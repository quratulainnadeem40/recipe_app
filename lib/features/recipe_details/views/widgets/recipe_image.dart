import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget {
  final String imageUrl;

  const RecipeImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(24),
      ),
      child: Image.network(
        imageUrl,
        width: double.infinity,
        height: 280,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 280,
            color: Colors.grey.shade200,
            child: const Center(
              child: Icon(
                Icons.image_not_supported,
                size: 60,
                color: Colors.grey,
              ),
            ),
          );
        },
      ),
    );
  }
}
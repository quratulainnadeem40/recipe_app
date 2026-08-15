import 'package:flutter/material.dart';

class IngredientsSection extends StatelessWidget {
  final List<String> ingredients;

  const IngredientsSection({
    super.key,
    required this.ingredients,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ingredients',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          if (ingredients.isEmpty)
            const Text(
              'No ingredients available',
              style: TextStyle(
                color: Colors.grey,
              ),
            )
          else
            ...ingredients.map(
              (ingredient) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 20,
                        color: Theme.of(context)
                            .colorScheme
                            .primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          ingredient,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
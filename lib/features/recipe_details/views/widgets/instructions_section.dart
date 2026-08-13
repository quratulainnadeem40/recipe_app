import 'package:flutter/material.dart';

class InstructionsSection extends StatelessWidget {
  final String instructions;

  const InstructionsSection({
    super.key,
    required this.instructions,
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
            'Instructions',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          if (instructions.trim().isEmpty)
            const Text(
              'No instructions available',
              style: TextStyle(
                color: Colors.grey,
              ),
            )
          else
            Text(
              instructions,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
              ),
            ),
        ],
      ),
    );
  }
}
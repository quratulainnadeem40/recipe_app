import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback? onProfileTap;

  const HomeHeader({
    super.key,
    this.userName = 'User',
    this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, $userName 👋',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'What would you like to cook today?',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: onProfileTap,
          child: CircleAvatar(
            radius: 24,
            backgroundColor:
                Theme.of(context).colorScheme.primary,
            child: const Icon(
              Icons.person,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/routes/app_routes.dart';
import 'package:recipe_app/core/theme/app_colors.dart';
import 'package:recipe_app/core/theme/app_text_styles.dart';
import 'package:recipe_app/features/notifications/controllers/notifications_controller.dart';

class HomeHeader extends StatelessWidget {
  final String? userName;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onMenuTap;

  const HomeHeader({
    super.key,
    this.userName,
    this.onNotificationTap,
    this.onMenuTap,
  });

  Future<String> _getUserName() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return 'User';
    }

    // Use passed name first.
    if (userName != null &&
        userName!.trim().isNotEmpty &&
        userName!.trim() != 'User') {
      return userName!.trim();
    }

    // Get name from Firestore.
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        final data = snapshot.data();
        final String? name = data?['name']?.toString().trim();

        if (name != null && name.isNotEmpty) {
          return name;
        }
      }
    } catch (e) {
      debugPrint('Failed to get user name: $e');
    }

    // Firebase display name.
    final String? displayName = user.displayName?.trim();

    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notificationController = Get.find<NotificationController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================================================
        // TOP BAR: MENU ICON | COOKMATE LOGO | NOTIFICATION
        // =====================================================
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Drawer / Menu Button
            IconButton(
              icon: Icon(
                Icons.menu_rounded,
                color: theme.colorScheme.onSurface,
                size: 26,
              ),
              onPressed: onMenuTap ?? () => Scaffold.of(context).openDrawer(),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),

            // COOKmate Branding Logo
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'COOK',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const TextSpan(
                    text: 'mate',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

            // Notification Button
            Obx(() {
              final int unreadCount = notificationController.unreadCount;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.notifications_none_rounded,
                      color: theme.colorScheme.onSurface,
                      size: 26,
                    ),
                    onPressed:
                        onNotificationTap ??
                        () {
                          Get.toNamed(AppRoutes.notifications);
                        },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),

                  if (unreadCount > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          unreadCount > 9 ? '9+' : unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            }),
          ],
        ),

        const SizedBox(height: 20),

        // =====================================================
        // GREETING & HEADLINE (FIREBASE ASYNC NAME)
        // =====================================================
        FutureBuilder<String>(
          future: _getUserName(),
          builder: (context, snapshot) {
            final String name = snapshot.data ?? 'User';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome Back, $name!',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Discover, Cook,\nEnjoy!',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

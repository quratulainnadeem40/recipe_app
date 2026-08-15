import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:recipe_app/core/routes/app_routes.dart';
import 'package:recipe_app/features/notifications/controllers/notifications_controller.dart';

class HomeHeader extends StatelessWidget {
  final String? userName;
  final VoidCallback? onNotificationTap;

  const HomeHeader({
    super.key,
    this.userName,
    this.onNotificationTap,
  });

  Future<String> _getUserName() async {
    // =====================================================
    // 1. GET CURRENT FIREBASE USER
    // =====================================================

    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return 'User';
    }

    // =====================================================
    // 2. CHECK PASSED USER NAME FIRST
    // =====================================================

    if (userName != null &&
        userName!.trim().isNotEmpty &&
        userName!.trim() != 'User') {
      return userName!.trim();
    }

    // =====================================================
    // 3. GET NAME FROM FIRESTORE
    // =====================================================

    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (snapshot.exists) {
        final data = snapshot.data();

        final String? name =
            data?['name']?.toString().trim();

        if (name != null && name.isNotEmpty) {
          return name;
        }
      }
    } catch (e) {
      debugPrint(
        'Failed to get user name from Firestore: $e',
      );
    }

    // =====================================================
    // 4. FIREBASE DISPLAY NAME FALLBACK
    // =====================================================

    final String? displayName =
        user.displayName?.trim();

    if (displayName != null && displayName.isNotEmpty) {
      return displayName;
    }

    // =====================================================
    // 5. FINAL FALLBACK
    // =====================================================

    return 'User';
  }

  @override
  Widget build(BuildContext context) {
    final NotificationController notificationController =
        Get.find<NotificationController>();

    return FutureBuilder<String>(
      future: _getUserName(),
      builder: (
        context,
        snapshot,
      ) {
        final String name =
            snapshot.data ?? 'User';

        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $name 👋',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'What would you like to cook today?',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // =====================================================
            // NOTIFICATION ICON + UNREAD BADGE
            // =====================================================

            Obx(
              () {
                final int unreadCount =
                    notificationController.unreadCount;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onTap: onNotificationTap ??
                          () {
                            Get.toNamed(
                              AppRoutes.notifications,
                            );
                          },
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor:
                            Theme.of(context)
                                .colorScheme
                                .primary,
                        child: const Icon(
                          Icons.notifications_none_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ),

                    // =================================================
                    // UNREAD COUNT
                    // =================================================

                    if (unreadCount > 0)
                      Positioned(
                        right: -2,
                        top: -4,
                        child: Container(
                          padding:
                              const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          constraints:
                              const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          decoration:
                              const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            unreadCount > 9
                                ? '9+'
                                : unreadCount.toString(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
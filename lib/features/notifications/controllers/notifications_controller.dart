import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recipe_app/features/notifications/controllers/notifications_controller.dart';
import 'package:recipe_app/features/notifications/views/notifications_screen.dart';

import '../models/notification_model.dart';

class NotificationController extends GetxController {
  final GetStorage _storage = GetStorage();

  final notifications = <NotificationModel>[].obs;

  int get unreadCount =>
      notifications.where((notification) => !notification.isRead).length;

  @override
  void onInit() {
    super.onInit();

    loadNotifications();
  }

  void loadNotifications() {
    final savedData = _storage.read<List>('notifications');

    if (savedData != null && savedData.isNotEmpty) {
      final savedNotifications = savedData.map((item) {
        final data = Map<String, dynamic>.from(item);

        return NotificationModel(
          id: data['id'] as String,
          title: data['title'] as String,
          message: data['message'] as String,
          createdAt: DateTime.parse(data['createdAt'] as String),
          isRead: data['isRead'] as bool? ?? false,
        );
      }).toList();

      notifications.assignAll(savedNotifications);
      return;
    }

    // First time only: show the welcome notification.
    notifications.assignAll([
      NotificationModel(
        id: '1',
        title: 'Welcome to COOKmate!',
        message: 'Start discovering delicious recipes today.',
        createdAt: DateTime.now(),
      ),
    ]);

    _saveNotifications();
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere(
      (notification) => notification.id == id,
    );

    if (index == -1) {
      return;
    }

    notifications[index] = notifications[index].copyWith(isRead: true);

    _saveNotifications();
  }

  void _saveNotifications() {
    final data = notifications.map((notification) {
      return {
        'id': notification.id,
        'title': notification.title,
        'message': notification.message,
        'createdAt': notification.createdAt.toIso8601String(),
        'isRead': notification.isRead,
      };
    }).toList();

    _storage.write('notifications', data);
  }

  void addNotification({required String title, required String message}) {
    final notification = NotificationModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      createdAt: DateTime.now(),
    );

    notifications.insert(0, notification);

    _saveNotifications();
  }

  void markAllAsRead() {
    notifications.value = notifications
        .map((notification) => notification.copyWith(isRead: true))
        .toList();
  }

  void clearNotifications() {
    notifications.clear();
  }

}

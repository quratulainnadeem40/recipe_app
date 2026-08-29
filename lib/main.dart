import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recipe_app/core/services/api_service.dart';
import 'package:recipe_app/core/theme/app_themes.dart';
import 'package:recipe_app/features/navigation/bindings/navigation_binding.dart';
import 'package:recipe_app/features/notifications/controllers/notifications_controller.dart';

import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  // Global ApiService (Fixes "ApiService not found" error)
  Get.put<ApiService>(
    ApiService(),
    permanent: true,
  );

  // Global Notification Controller
  Get.put<NotificationController>(
    NotificationController(),
    permanent: true,
  );

  runApp(const CookmateApp());
}

class CookmateApp extends StatelessWidget {
  const CookmateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cookmate',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: AppRoutes.splash,
      unknownRoute: AppPages.pages.first,
      // Global binding to instantiate tab dependencies on app startup
      initialBinding: NavigationsBinding(),
      getPages: AppPages.pages,
    );
  }
}
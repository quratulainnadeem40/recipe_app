// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:recipe_app/core/theme/app_themes.dart';

// import 'core/routes/app_pages.dart';
// import 'core/routes/app_routes.dart';
// import 'firebase_options.dart';

// Future<void> main() async {
//   // Flutter bindings initialize
//   WidgetsFlutterBinding.ensureInitialized();

//   // Firebase initialize
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );

//   runApp(
//     const CookmateApp(),
//   );
// }

// class CookmateApp extends StatelessWidget {
//   const CookmateApp({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,

//       title: 'Cookmate',

//       // Theme
//       theme: AppTheme.lightTheme,
//       darkTheme: AppTheme.darkTheme,
//       themeMode: ThemeMode.light,

//       // Routes
//       initialRoute: AppRoutes.splash,
//       getPages: AppPages.pages,
//     );
//   }
// }
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:recipe_app/core/theme/app_themes.dart';
import 'package:recipe_app/features/notifications/controllers/notifications_controller.dart';

import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GetStorage.init();

  Get.put<NotificationController>(
    NotificationController(),
    permanent: true,
  );

  runApp(
    const CookmateApp(),
  );
}

class CookmateApp extends StatelessWidget {
  const CookmateApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Cookmate',

      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,

      initialRoute: AppRoutes.splash,

      getPages: AppPages.pages,
    );
  }
}
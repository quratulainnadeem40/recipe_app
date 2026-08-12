import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipe_app/core/theme/app_themes.dart';

import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';

void main() {

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

      initialRoute:
          AppRoutes.splash,

      getPages:
          AppPages.pages,
    );
  }
}